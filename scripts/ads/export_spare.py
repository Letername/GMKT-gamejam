"""Reproducible MP4/audio packaging for the locally rendered Spare ad."""
from pathlib import Path
import argparse
import json
import math
import struct
import subprocess
import wave

ROOT = Path(__file__).resolve().parents[2]
FFMPEG = Path(r"C:\Program Files\ShareX\ffmpeg.exe")
MEDIA = ROOT / "Build/media"
AUDIO = ROOT / "assets/ads/spare/audio"
WORK = ROOT / ".tools/ad-ingest/spare-20261005/production"


def make_chime():
    AUDIO.mkdir(parents=True, exist_ok=True)
    sample_rate = 48000
    samples = []
    for n in range(int(sample_rate * 0.45)):
        t = n / sample_rate
        envelope = min(1.0, t / 0.008) * math.exp(-t * 12)
        note = math.sin(2 * math.pi * 1174.66 * t)
        if t > 0.08:
            note += 0.6 * math.sin(2 * math.pi * 1567.98 * (t - 0.08))
        samples.append(struct.pack("<h", int(1800 * envelope * note)))
    with wave.open(str(AUDIO / "transfer-chime.wav"), "wb") as out:
        out.setnchannels(1)
        out.setsampwidth(2)
        out.setframerate(sample_rate)
        out.writeframes(b"".join(samples))


def mix_audio():
    timeline = json.loads((ROOT / "assets/ads/spare/timeline.json").read_text(encoding="utf-8"))
    duration = float(timeline["duration"])
    chime_indices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11]
    filters = [
        f"[0:a]aformat=sample_rates=48000:channel_layouts=stereo[voice]",
        f"[1:a]atrim=duration={duration},afade=t=in:st=0:d=0.5,"
        f"afade=t=out:st={duration-2}:d=2[music]",
        f"[2:a]asplit={len(chime_indices)}" + "".join(f"[c{i}]" for i in range(len(chime_indices))),
    ]
    for i, index in enumerate(chime_indices):
        beat = timeline["beats"][index]
        threshold = 0.5 if index == 11 else 0.24
        millis = round((float(beat["start"]) + threshold * float(beat["duration"])) * 1000)
        filters.append(f"[c{i}]adelay={millis}:all=1[ding{i}]")
    labels = "[voice][music]" + "".join(f"[ding{i}]" for i in range(len(chime_indices)))
    filters.append(
        f"{labels}amix=inputs={2+len(chime_indices)}:duration=first:normalize=0,"
        f"alimiter=limit=0.794:level=0:latency=1,atrim=duration={duration}[mix]"
    )
    command = [str(FFMPEG), "-hide_banner", "-loglevel", "warning", "-y",
               "-i", str(WORK / "voice-master.wav"),
               "-i", str(ROOT / "assets/ads/spare/music/screen-saver.ogg"),
               "-i", str(AUDIO / "transfer-chime.wav"),
               "-filter_complex", ";".join(filters), "-map", "[mix]",
               "-c:a", "pcm_s16le", str(WORK / "spare-final-mix.wav")]
    subprocess.run(command, check=True)


def package_movie(avi: Path, output: Path | None = None):
    MEDIA.mkdir(parents=True, exist_ok=True)
    output = output or MEDIA / "Spare-Letername-Ad.mp4"
    credit = ("Music: Screen Saver by Kevin MacLeod, "
              "https://incompetech.com/music/royalty-free/index.html?isrc=USUAN1900046; "
              "CC BY 4.0 https://creativecommons.org/licenses/by/4.0/; trimmed, faded and mixed.")
    subprocess.run([
        str(FFMPEG), "-hide_banner", "-loglevel", "warning", "-y",
        "-i", str(avi), "-i", str(WORK / "spare-final-mix.wav"),
        "-map", "0:v:0", "-map", "1:a:0", "-t", "60",
        "-c:v", "libx264", "-preset", "medium", "-crf", "18",
        "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", "192k",
        "-movflags", "+faststart", "-metadata", "title=Spare — Letername Technologies",
        "-metadata", "comment=" + credit, str(output)
    ], check=True)
    print(f"SPARE_MP4_READY {output}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--prepare-audio", action="store_true")
    parser.add_argument("--avi", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.prepare_audio:
        make_chime()
        mix_audio()
    if args.avi:
        package_movie(args.avi, args.output)
