"""Track the filmed monitor and corner-pin Spare over its tracking markers.

OpenCV runs locally from the project's isolated production dependencies. The
original footage is never modified; output is muted Theora for Godot playback.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--app-image", type=Path)
    parser.add_argument("--beat-index", type=int, choices=(1, 3, 7))
    parser.add_argument("--beat-offset", type=float, default=0)
    args = parser.parse_args()
    project = args.project.resolve()
    sys.path.insert(0, str(project / ".tools/spare-asr"))
    import cv2
    import numpy as np
    from PIL import Image, ImageDraw, ImageFont

    ffmpeg = Path(r"C:\Program Files\ShareX\ffmpeg.exe")
    source = project / "assets/ads/spare/footage/screen.ogv"
    suffixes = {1: "start", 3: "growth", 7: "budget"}
    suffix = suffixes.get(args.beat_index, "composited")
    destination = source.with_name(f"screen-{suffix}.ogv")
    qa = project / ".tools/test-outputs/spare" / f"screen-{suffix}"
    qa.mkdir(parents=True, exist_ok=True)
    app_path = args.app_image or project / ".tools/test-outputs/spare/app-reference.png"
    app = cv2.imread(str(app_path))
    if app is None:
        raise RuntimeError("Missing Spare interface image: " + str(app_path))
    # Defensive removal of old in-game skip UI: screen replacement is a banking
    # app view, so the fictional customer's monitor must not contain an ad button.
    # Current Godot captures hide this control; the sampled strip is a fallback.
    app_height, app_width = app.shape[:2]
    if np.mean(app[int(app_height * .92):, int(app_width * .86):]) < 220:
        app[int(app_height * .91):, int(app_width * .85):] = app[int(app_height * .90), int(app_width * .82)]

    source_corners = np.float32([[0, 0], [app_width - 1, 0],
                                [app_width - 1, app_height - 1], [0, app_height - 1]])
    timeline = json.loads((project / "assets/ads/spare/timeline.json").read_text(encoding="utf-8"))
    amount_ranges = {1: (67.69, 61), 3: (59, 57), 7: (45, 44)}
    font = ImageFont.truetype(r"C:\Windows\Fonts\segoeuib.ttf", 74)

    def animate_amounts(frame_index: int):
        if args.beat_index is None:
            return app, None
        duration = timeline["beats"][args.beat_index]["duration"]
        progress = (args.beat_offset + frame_index / 30) / duration
        t = min(1, max(0, (progress - .24) / (.90 - .24)))
        eased = t * t * (3 - 2 * t)
        initial, final = amount_ranges[args.beat_index]
        customer_balance = initial + (final - initial) * eased
        company_balance = 67.69 - customer_balance
        rendered = Image.fromarray(cv2.cvtColor(app, cv2.COLOR_BGR2RGB))
        draw = ImageDraw.Draw(rendered)
        # Clear all former digits, including antialiased fringes. The surrounding
        # original banking screenshot is unchanged.
        draw.rectangle((95, 314, 95 + 430, 314 + 94), fill="#ffffff")
        draw.rectangle((735, 314, 735 + 430, 314 + 94), fill="#102e54")
        draw.text((95, 323), f"€{customer_balance:.2f}", font=font, fill="#102e54", anchor="lt")
        draw.text((735, 323), f"€{company_balance:.2f}", font=font, fill="#53d5b1", anchor="lt")
        return cv2.cvtColor(np.asarray(rendered), cv2.COLOR_RGB2BGR), customer_balance
    width, height = 1280, 720
    decoder = subprocess.Popen([str(ffmpeg), "-nostdin", "-hide_banner", "-loglevel", "error",
                                "-i", str(source), "-an", "-f", "rawvideo", "-pix_fmt", "bgr24", "pipe:1"],
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    encode_log = (qa / "encode.log").open("wb")
    encoder = subprocess.Popen([str(ffmpeg), "-nostdin", "-hide_banner", "-y", "-f", "rawvideo",
                                "-pix_fmt", "bgr24", "-s", f"{width}x{height}", "-r", "30", "-i", "pipe:0",
                                "-an", "-c:v", "libtheora", "-q:v", "9", "-pix_fmt", "yuv420p", str(destination)],
                               stdin=subprocess.PIPE, stdout=subprocess.DEVNULL, stderr=encode_log)
    tracks = []
    previous_quad = None
    previous_gray = None
    frame_number = 0
    fallback_frames = 0
    last_result = None
    try:
        while True:
            data = decoder.stdout.read(width * height * 3)
            if not data:
                break
            if len(data) != width * height * 3:
                raise RuntimeError("Incomplete decoded frame")
            frame = np.frombuffer(data, dtype=np.uint8).reshape(height, width, 3).copy()
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            roi = np.zeros_like(gray)
            roi[60:530, 270:940] = gray[60:530, 270:940]
            _, threshold = cv2.threshold(roi, 160, 255, cv2.THRESH_BINARY)
            threshold = cv2.morphologyEx(threshold, cv2.MORPH_CLOSE, np.ones((5, 5), dtype=np.uint8))
            contours, _ = cv2.findContours(threshold, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
            quad = None
            for contour in sorted(contours, key=cv2.contourArea, reverse=True):
                area = cv2.contourArea(contour)
                if not 60_000 < area < 250_000:
                    continue
                hull = cv2.convexHull(contour)
                perimeter = cv2.arcLength(hull, True)
                polygon = cv2.approxPolyDP(hull, .012 * perimeter, True)
                if len(polygon) != 4 or not cv2.isContourConvex(polygon):
                    continue
                points = polygon.reshape(4, 2).astype(np.float32)
                sums = points.sum(axis=1)
                differences = points[:, 1] - points[:, 0]
                ordered = np.float32([points[np.argmin(sums)], points[np.argmin(differences)],
                                      points[np.argmax(sums)], points[np.argmax(differences)]])
                if previous_quad is not None and np.max(np.linalg.norm(ordered - previous_quad, axis=1)) > 80:
                    continue
                quad = ordered
                break

            method = "bright-plane contour"
            if quad is None and previous_quad is not None:
                points, status, error = cv2.calcOpticalFlowPyrLK(previous_gray, gray,
                                                               previous_quad.reshape(-1, 1, 2), None,
                                                               winSize=(31, 31), maxLevel=3)
                if np.all(status):
                    quad = points.reshape(4, 2)
                    method = "corner optical flow"
                    fallback_frames += 1
            if quad is None:
                raise RuntimeError(f"Could not track monitor in frame {frame_number}; no guessed overlay was rendered")

            # Expand less than a pixel to hide bright threshold-edge fringes;
            # the black bezel remains visibly outside the replacement.
            center = quad.mean(axis=0)
            expanded = center + (quad - center) * 1.004
            transform = cv2.getPerspectiveTransform(source_corners, expanded)
            current_app, customer_balance = animate_amounts(frame_number)
            warped = cv2.warpPerspective(current_app, transform, (width, height), flags=cv2.INTER_LINEAR)
            mask = cv2.warpPerspective(np.ones((app_height, app_width), dtype=np.uint8) * 255,
                                       transform, (width, height), flags=cv2.INTER_LINEAR)
            alpha = mask.astype(np.float32)[..., None] / 255
            result = np.clip(frame * (1 - alpha) + warped * alpha, 0, 255).astype(np.uint8)
            encoder.stdin.write(result.tobytes())
            tracks.append({"frame": frame_number, "method": method, "corners": quad.tolist(),
                           "customer_balance": customer_balance})
            if frame_number in (0, 87):
                cv2.imwrite(str(qa / f"frame-{frame_number:03}.png"), result)
                diagnostic = frame.copy()
                cv2.polylines(diagnostic, [quad.astype(np.int32)], True, (40, 255, 40), 2)
                cv2.imwrite(str(qa / f"tracking-{frame_number:03}.png"), diagnostic)
            previous_quad, previous_gray = quad, gray
            last_result = result
            frame_number += 1
        if last_result is not None:
            cv2.imwrite(str(qa / f"frame-{frame_number - 1:03}.png"), last_result)
    finally:
        encoder.stdin.close()
        decoder.stdout.close()
        decoder_code = decoder.wait()
        encoder_code = encoder.wait()
        encode_log.close()
    if decoder_code or encoder_code:
        raise RuntimeError(f"FFmpeg failed: decode={decoder_code}, encode={encoder_code}")
    (qa / "tracking.json").write_text(json.dumps(tracks, indent=2) + "\n", encoding="utf-8")
    print(f"SPARE_SCREEN_COMPOSITE_PASS frames={frame_number} optical_flow_fallbacks={fallback_frames}")


if __name__ == "__main__":
    main()
