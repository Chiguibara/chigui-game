"""Synthesizes Chigüi's sound effects as small 8-bit-style WAV files.

Pure standard library, so it runs anywhere (`make sounds` runs it in the
Flutter container). Every sound here is made from tones and noise; the
eating bites (assets/sounds/bite_*.flac) are the exception, cut from a real
recording. Tweak a recipe and re-run.
"""

import math
import random
import struct
import wave
from pathlib import Path

RATE = 22050
OUT = Path(__file__).resolve().parent.parent / "assets" / "sounds"


# --- Building blocks: each returns a list of float samples in [-1, 1]. ---


def _osc(phase, shape):
    if shape == "sine":
        return math.sin(2 * math.pi * phase)
    if shape == "square":
        return 1.0 if (phase % 1) < 0.5 else -1.0
    if shape == "triangle":
        p = phase % 1
        return 4 * p - 1 if p < 0.5 else 3 - 4 * p
    raise ValueError(shape)


def tone(freq, dur, shape="square", vol=0.5, attack=0.005, release=0.05,
         freq_end=None, vibrato=0.0):
    """A note, optionally sliding to freq_end, with a short envelope."""
    n = int(dur * RATE)
    out, phase = [], 0.0
    for i in range(n):
        t = i / RATE
        f = freq if freq_end is None else freq + (freq_end - freq) * i / n
        f *= 1 + vibrato * math.sin(2 * math.pi * 6 * t)
        phase += f / RATE
        env = min(1.0, t / attack) if attack else 1.0
        env *= min(1.0, (dur - t) / release) if release else 1.0
        out.append(vol * env * _osc(phase, shape))
    return out


def noise(dur, vol=0.5, smooth=0.0, attack=0.002, release=0.05, seed=1,
          smooth_end=None):
    """White noise; `smooth` (0–0.99) low-passes it for softer textures."""
    rng = random.Random(seed)
    n = int(dur * RATE)
    out, last = [], 0.0
    for i in range(n):
        t = i / RATE
        s = smooth if smooth_end is None else smooth + (smooth_end - smooth) * i / n
        last = last * s + rng.uniform(-1, 1) * (1 - s)
        env = min(1.0, t / attack) * min(1.0, (dur - t) / release)
        out.append(vol * env * last * (1 / (1 - s) ** 0.5 if s < 0.99 else 10))
    return out


def silence(dur):
    return [0.0] * int(dur * RATE)


def seq(*parts):
    return [s for part in parts for s in part]


def mix(*parts):
    length = max(len(p) for p in parts)
    return [sum(p[i] for p in parts if i < len(p)) for i in range(length)]


def notes(names, dur, gap=0.0, **kw):
    """A little melody from note names like 'C5', 'E5', 'G5'."""
    return seq(*(seq(tone(_hz(n), dur, **kw), silence(gap)) for n in names))


def _hz(name):
    steps = {"C": -9, "D": -7, "E": -5, "F": -4, "G": -2, "A": 0, "B": 2}
    note, octave = name[:-1], int(name[-1])
    semis = steps[note[0]] + (1 if "#" in note else 0) + 12 * (octave - 4)
    return 440 * 2 ** (semis / 12)


# --- The sounds. ---

SOUNDS = {
    # A soft, happy chirp for cuddles.
    "pet": seq(
        tone(600, 0.05, "sine", 0.4, release=0.02, freq_end=900),
        tone(900, 0.12, "sine", 0.45, freq_end=1300, vibrato=0.02),
    ),
    # "Nuh-uh": two soft falling blips.
    "refuse": seq(
        tone(520, 0.09, "triangle", 0.4),
        silence(0.04),
        tone(390, 0.14, "triangle", 0.4, freq_end=330),
    ),
    # Classic coin: two quick rising notes.
    "coin": seq(
        tone(_hz("B5"), 0.06, "square", 0.25, release=0.01),
        tone(_hz("E6"), 0.22, "square", 0.25, release=0.15),
    ),
    # Ka-ching for buying: coin plus a sparkle.
    "buy": seq(
        tone(_hz("B5"), 0.05, "square", 0.25, release=0.01),
        tone(_hz("E6"), 0.08, "square", 0.25, release=0.02),
        notes(["G6", "B6", "D7"], 0.05, shape="triangle", vol=0.25),
    ),
    # Soft "bonk" for the out-of-season and Error 402 jokes.
    "bonk": seq(
        tone(300, 0.08, "triangle", 0.5, freq_end=180),
        tone(160, 0.12, "sine", 0.3, freq_end=120),
    ),
    # Ta-da for a completed walk or a finished round.
    "reward": seq(
        notes(["C5", "E5", "G5"], 0.08, gap=0.01, shape="square", vol=0.22),
        tone(_hz("C6"), 0.3, "square", 0.22, release=0.2, vibrato=0.01),
    ),
    # A little "ready, go!" before the minigame.
    "start": seq(
        tone(_hz("G4"), 0.1, "square", 0.2), silence(0.08),
        tone(_hz("G4"), 0.1, "square", 0.2), silence(0.08),
        tone(_hz("G5"), 0.25, "square", 0.22, release=0.15),
    ),
    # Footsteps: soft taps, alternating pitch.
    "step_left": mix(noise(0.05, 0.4, smooth=0.75, seed=5),
                     tone(140, 0.05, "sine", 0.3, freq_end=90)),
    "step_right": mix(noise(0.05, 0.4, smooth=0.75, seed=6),
                      tone(170, 0.05, "sine", 0.3, freq_end=110)),
    # Toilet flush: a whooshing sweep with a gurgle.
    "flush": seq(
        tone(900, 0.06, "triangle", 0.25),
        mix(noise(0.7, 0.5, smooth=0.2, smooth_end=0.95, release=0.3, seed=7),
            tone(500, 0.7, "sine", 0.15, freq_end=120, vibrato=0.08)),
    ),
    # An accident: a funny little "plop".
    "plop": seq(
        tone(700, 0.08, "sine", 0.5, freq_end=200),
        tone(250, 0.06, "sine", 0.3, freq_end=150),
    ),
    # Chigüi needs the toilet: "uh-oh".
    "uh_oh": seq(
        tone(_hz("E5"), 0.12, "triangle", 0.35),
        silence(0.05),
        tone(_hz("B4"), 0.2, "triangle", 0.35, freq_end=_hz("A4")),
    ),
    # Sparkly clean.
    "sparkle": notes(["C6", "E6", "G6", "C7", "E7"], 0.04,
                     shape="triangle", vol=0.22),
    # The vet: a tiny "boop", then feeling better.
    "vet": seq(
        tone(1200, 0.05, "sine", 0.35, freq_end=800),
        silence(0.08),
        notes(["C5", "E5", "G5", "C6"], 0.07, shape="triangle", vol=0.3),
    ),
    # Lullaby for bedtime.
    "lullaby": notes(["G5", "E5", "C5"], 0.22, gap=0.03, shape="sine",
                     vol=0.35, release=0.12),
    # Wearing or taking off an accessory.
    "pop": tone(400, 0.08, "sine", 0.4, freq_end=800),
}


def write(name, samples):
    peak = max(1e-9, max(abs(s) for s in samples))
    gain = min(1.0, 0.9 / peak)
    frames = b"".join(
        struct.pack("<h", int(max(-1, min(1, s * gain)) * 32767))
        for s in samples
    )
    with wave.open(str(OUT / f"{name}.wav"), "wb") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(RATE)
        f.writeframes(frames)


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    for name, samples in SOUNDS.items():
        write(name, samples)
        print(f"{name:12} {len(samples) / RATE:.2f}s")
