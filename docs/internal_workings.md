# Impulse Internal Workings Document
by Matt Young.

(TODO fix this up so we can process it with pandoc)

## Synthesizer overview

## Oscillators
## Noise oscillator
Impulse's noise oscillator is based on a 16-bit maximum-period linear feedback shift register (LFSR). This generates
pseudorandom numbers good enough for audio, and has the advantage of being easy to produce in hardware.

The noise oscillator has a "crush" factor, which is sort of like bandwidth. It controls how many ticks there
are between updating the LFSR. For example, if crush is set to 10, then the LFSR is only updated every 10
ticks. In between updates, the oscillator always outputs its last value.

The noise oscillator starts with the initial seed 0xACE1, uses a Fibonacci LFSR, and the taps are: 16, 15, 13, 4.

This method for generating noise is also very commonly used in the video-game consoles this synthesizer is
inspired by, in particular the NES and Genesis sound chips. LFSRs were also used to generate random numbers
in-game on these consoles, because of their "good enough" randomness and ease of computation on low power CPUs.

## Square oscillators
Impulse has two independent square-wave oscillators.