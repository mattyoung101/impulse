% Impulse Internal Workings
% Matt Young
% October 2022

TODO setup pandoc

TODO make the date the real date

TODO maybe use overleaf instead of pandoc? (probably)

## About this document
This document aims to provide an in-depth overview of the internal workings of the Impulse design. If you are
a musician looking to quickly get started using the Impulse, you should read the User Manual instead. On the
other hand, if you're looking for a technical deep-dive into the inner-workings of the Impulse chip, this is
the right place for you. Technically-minded musicians may also find this document helpful to improve their
sound, as it documents each oscillator in excruciating detail.

## System overview
TODO block diagram

## Oscillators
### Noise oscillator
Impulse's noise oscillator is based on a 16-bit maximum-period linear feedback shift register (LFSR). This generates
pseudorandom numbers good enough for audio, although it would probably fail most statistical tests that modern
PRNGs like PCG and Xoroshiro go through. That being said, it sounds just fine and the repeating pattern is not
audible even for very long durations.

The noise oscillator has a period counter, which can be used to make a more "bitcrushed" sound. It controls how 
many samples there are between updating the LFSR. For example, if the period is set to 10, then the LFSR is only updated every 10 ticks. In between updates, the oscillator always outputs its last value.

The LFSR used in the oscillator the initial seed 0xACE1. In the SystemVerilog RTL, the LFSR is expressed in the
Galois format, and uses the maximal-period taps: 16, 15, 13, 4 (or 0xD008 in hex).

This method for generating noise is also very commonly used in the video-game consoles this synthesizer is
inspired by, in particular the NES and Genesis sound chips. LFSRs were also used to generate random numbers
in-game on these consoles, because of their "good enough" randomness and ease of computation on low power CPUs.

### Square oscillators
Impulse has two independent square-wave oscillators.

### Sawtooth oscillators

## Mixer

## DAC