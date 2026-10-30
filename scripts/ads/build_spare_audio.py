"""Build Spare's levelled narration and sample-accurate edit timeline.

Original recordings remain untouched. Only outer silence is removed; speech
and internal pauses are preserved. Subtitles use the approved recording script,
not an unverified claim of an automated transcription.
"""

from __future__ import annotations

import argparse
import json
import math
import re
import subprocess
import sys
import textwrap
import wave
from pathlib import Path

import numpy as np

RATE = 48_000
LINES = [
    ("spare_01", "Spare 1.m4a", "Meet Spare. The budgeting app that takes your money, and the responsibility of having it."),
    ("spare_02", "Spare 2.m4a", "Select ‘Make my money work.’ We’ll put it straight to work."),
    ("customer_01", "Customer 1.m4a", "Working where?"),
    ("spare_03", "Spare 3.m4a", "In our account. Look at that growth. You’re doing wonderfully."),
    ("spare_04", "Spare 4.m4a", "Spending Protection moves your money before you can waste on unnecessary purchases."),
    ("customer_02", "Customer 2.m4a", "I was buying lunch."),
    ("spare_05", "Spare 5.m4a", "And now you’re not. Purchase prevented."),
    ("spare_06", "Spare 6.m4a", "Smart Budget handles the rest. Rent. Groceries. Savings. All automatically allocated to Letername."),
    ("customer_03", "Customer 3.m4a", "So… what’s left for me?"),
    ("spare_07", "Spare 7.m4a", "A simpler dashboard. Fewer decisions. And absolutely nothing to overspend."),
    ("spare_08", "Spare  08.m4a", "Spare. Financial freedom achieved. For us."),
    ("spare_09", "Spare 9.m4a", "Letername Technologies. We don’t want just some of your money. We want all of it."),
]


def run(ffmpeg: Path, args: list[str]) -> str:
    result = subprocess.run([str(ffmpeg), "-nostdin", "-hide_banner", "-y", *args],
                            capture_output=True, text=True, encoding="utf-8", errors="replace")
    if result.returncode:
        raise RuntimeError(result.stderr)
    return result.stderr


def read_pcm(path: Path) -> np.ndarray:
    with wave.open(str(path), "rb") as audio:
        assert (audio.getframerate(), audio.getnchannels(), audio.getsampwidth()) == (RATE, 1, 2)
        return np.frombuffer(audio.readframes(audio.getnframes()), dtype="<i2").copy()


def write_pcm(path: Path, samples: np.ndarray) -> None:
    with wave.open(str(path), "wb") as audio:
        audio.setnchannels(1)
        audio.setsampwidth(2)
        audio.setframerate(RATE)
        audio.writeframes(samples.astype("<i2").tobytes())


def outer_trim(samples: np.ndarray) -> tuple[int, int]:
    """Conservative 10 ms RMS gate with 120 ms handles; never cut internally."""
    block = RATE // 100
    padded = np.pad(samples.astype(np.float64) / 32768, (0, (-len(samples)) % block))
    rms = np.sqrt(np.mean(padded.reshape(-1, block) ** 2, axis=1))
    active = np.flatnonzero(rms > 10 ** (-45 / 20))
    if not len(active):
        raise RuntimeError("Recording contains no detected non-silent samples")
    margin = round(RATE * .12)
    return max(0, int(active[0]) * block - margin), min(len(samples), (int(active[-1]) + 1) * block + margin)


def loudness(ffmpeg: Path, path: Path) -> dict:
    log = run(ffmpeg, ["-i", str(path), "-af", "loudnorm=I=-18:TP=-2:LRA=11:print_format=json", "-f", "null", "NUL"])
    return json.loads(re.findall(r'\{\s*"input_i"[\s\S]*?\}', log)[-1])


def stamp(seconds: float) -> str:
    milliseconds = round(seconds * 1000)
    hours, remainder = divmod(milliseconds, 3_600_000)
    minutes, remainder = divmod(remainder, 60_000)
    seconds, milliseconds = divmod(remainder, 1000)
    return f"{hours:02}:{minutes:02}:{seconds:02},{milliseconds:03}"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--ffmpeg", type=Path, default=Path(r"C:\Program Files\ShareX\ffmpeg.exe"))
    parser.add_argument("--verify-asr", action="store_true", help="Run isolated CPU speech recognition; no audio upload.")
    parser.add_argument("--asr-model", default="tiny.en", help="Local Whisper model size for verification.")
    args = parser.parse_args()
    project = args.project.resolve()
    ingest = project / ".tools/ad-ingest/spare-20261005"
    production = ingest / "production"
    output = project / "assets/ads/spare/audio"
    media = project / "Build/media"
    for folder in (production, output, media):
        folder.mkdir(parents=True, exist_ok=True)

    if args.verify_asr:
        sys.path.insert(0, str(project / ".tools/spare-asr"))
        from faster_whisper import WhisperModel
        model = WhisperModel(args.asr_model, device="cpu", compute_type="int8", cpu_threads=2,
                             download_root=str(project / ".tools/spare-asr/models"))
        transcripts = []
        for line_id, filename, approved in LINES:
            raw = subprocess.run([str(args.ffmpeg), "-nostdin", "-hide_banner", "-loglevel", "error",
                                  "-i", str(ingest / filename), "-ac", "1", "-ar", "16000",
                                  "-f", "f32le", "pipe:1"], capture_output=True, check=True).stdout
            asr_audio = np.frombuffer(raw, dtype="<f4").copy()
            segments, info = model.transcribe(asr_audio, beam_size=5, language="en",
                                             condition_on_previous_text=False, word_timestamps=True)
            segments = list(segments)
            entry = {"id": line_id, "source": filename, "approved": approved,
                     "transcript": " ".join(segment.text.strip() for segment in segments),
                     "segments": [{"start": segment.start, "end": segment.end, "text": segment.text,
                                   "words": [{"word": word.word, "start": word.start, "end": word.end,
                                              "probability": word.probability} for word in segment.words]}
                                  for segment in segments]}
            transcripts.append(entry)
            print(line_id + ": " + entry["transcript"], flush=True)
        (production / f"local-asr-{args.asr_model}.json").write_text(json.dumps(transcripts, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        return

    beats, report, master, subtitles = [], [], [], []
    cursor = 0
    for index, (line_id, filename, text) in enumerate(LINES, 1):
        decoded = production / f"{line_id}-original.wav"
        trimmed = production / f"{line_id}-trimmed.wav"
        compressed = production / f"{line_id}-compressed.wav"
        destination = output / f"{line_id}.wav"
        run(args.ffmpeg, ["-i", str(ingest / filename), "-vn", "-ac", "1", "-ar", str(RATE), "-c:a", "pcm_s16le", str(decoded)])
        original = read_pcm(decoded)
        trim_start, trim_end = outer_trim(original)
        write_pcm(trimmed, original[trim_start:trim_end])
        # Gentle speech compression gives the soft syllables consistent weight
        # without pushing the louder phone-mic transients beyond the peak cap.
        run(args.ffmpeg, ["-i", str(trimmed), "-af",
                         "acompressor=threshold=0.08:ratio=3:attack=5:release=90:makeup=1",
                         "-ar", str(RATE), "-ac", "1", "-c:a", "pcm_s16le", str(compressed)])
        measured = loudness(args.ffmpeg, compressed)
        normalizer = (
            "loudnorm=I=-18:TP=-2:LRA=11:"
            f"measured_I={measured['input_i']}:measured_TP={measured['input_tp']}:"
            f"measured_LRA={measured['input_lra']}:measured_thresh={measured['input_thresh']}:"
            f"offset={measured['target_offset']}:linear=false"
        )
        run(args.ffmpeg, ["-i", str(compressed), "-af", normalizer, "-ar", str(RATE), "-ac", "1", "-c:a", "pcm_s16le", str(destination)])
        quality = loudness(args.ffmpeg, destination)
        # Short utterances need a measured correction after loudnorm's temporal
        # integration. Oversampled peak limiting preserves a consistent speech
        # level instead of making an entire line quieter for one loud transient.
        for correction_index in range(3):
            gain = -18 - float(quality["input_i"])
            if not math.isfinite(gain):
                raise RuntimeError("Cannot measure speech loudness for " + line_id)
            if abs(gain) < .1 and float(quality["input_tp"]) <= -2:
                break
            correction = production / f"{line_id}-corrected-{correction_index}.wav"
            limiter = (f"volume={gain:.6f}dB,aresample=192000,"
                       "alimiter=limit=0.785:attack=5:release=60:level=false:latency=true,aresample=48000")
            run(args.ffmpeg, ["-i", str(destination), "-af", limiter, "-ar", str(RATE), "-ac", "1", "-c:a", "pcm_s16le", str(correction)])
            destination.write_bytes(correction.read_bytes())
            quality = loudness(args.ffmpeg, destination)
        samples = read_pcm(destination)
        voice_length = len(samples)
        pause = .75 if line_id.startswith("customer") else (.4 if line_id == "spare_09" else .15)
        pause_length = round(pause * RATE)
        duration = voice_length + pause_length
        beats.append({"id": line_id, "start": cursor / RATE, "duration": duration / RATE,
                      "voice_duration": voice_length / RATE,
                      "audio": f"res://assets/ads/spare/audio/{line_id}.wav", "text": text})
        subtitles.append(f"{index}\n{stamp(cursor / RATE)} --> {stamp((cursor + voice_length) / RATE)}\n"
                         + "\n".join(textwrap.wrap(text, width=48)) + "\n")
        report.append({"id": line_id, "source": filename, "source_duration": len(original) / RATE,
                       "trim_start": trim_start / RATE, "trim_end": trim_end / RATE,
                       "voice_duration": voice_length / RATE, "integrated_lufs": float(quality["input_i"]),
                       "true_peak_dbfs": float(quality["input_tp"])})
        master.extend((samples, np.zeros(pause_length, dtype=np.int16)))
        cursor += duration
        print(f"{line_id}: start={beats[-1]['start']:.3f}s voice={voice_length / RATE:.3f}s "
              f"I={quality['input_i']} LUFS TP={quality['input_tp']} dBFS", flush=True)

    # Give charts and transfers room to read. Narration stays at its original
    # speed, and customer replies retain their deliberate 750 ms awkward gap.
    endcard_frames = round(1.8 * RATE)
    extra_frames = max(0, 60 * RATE - cursor - endcard_frames)
    weights = {"spare_01": .35, "spare_02": 1.25, "spare_03": .35,
               "spare_04": 1.4, "spare_05": .35, "spare_06": 2,
               "spare_07": .75, "spare_08": .6, "spare_09": 1.1}
    weight_total = sum(weights.values())
    remaining_extra = extra_frames
    master, subtitles, cursor = [], [], 0
    for index, beat in enumerate(beats, 1):
        line_id = beat["id"]
        added = round(extra_frames * weights.get(line_id, 0) / weight_total)
        if line_id == "spare_09":
            added = remaining_extra
        remaining_extra -= added
        samples = read_pcm(output / f"{line_id}.wav")
        voice_length = len(samples)
        duration = round(beat["duration"] * RATE) + added
        beat["start"], beat["duration"] = cursor / RATE, duration / RATE
        master.extend((samples, np.zeros(duration - voice_length, dtype=np.int16)))
        subtitles.append(f"{index}\n{stamp(cursor / RATE)} --> {stamp((cursor + voice_length) / RATE)}\n"
                         + "\n".join(textwrap.wrap(beat["text"], width=48)) + "\n")
        cursor += duration

    endcard_start = cursor / RATE
    master.append(np.zeros(endcard_frames, dtype=np.int16))
    cursor += endcard_frames
    write_pcm(production / "voice-master.wav", np.concatenate(master))
    timeline = {"beats": beats, "duration": cursor / RATE, "endcard_start": endcard_start,
                "subtitle_basis": "Approved script cross-checked against local tiny.en/base.en ASR. Spare04 omits 'it' in both transcripts; accented words and brand spelling follow approved script."}
    (output.parent / "timeline.json").write_text(json.dumps(timeline, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (production / "audio-quality.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    (media / "Spare.srt").write_text("\n".join(subtitles), encoding="utf-8")
    print(f"SPARE_AUDIO_BUILD_PASS duration={cursor / RATE:.3f}s endcard={endcard_start:.3f}s")


if __name__ == "__main__":
    main()
