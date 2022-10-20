# This file is part of Impulse, the retro music FPGA synthesizer.
# Copyright (c) 2022 Matt Young. All rights reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0
import sys
import soundfile as sf
import numpy as np

if __name__ == "__main__":
    filename = sys.argv[1]
    with open(filename, "r") as f:
        data = np.array([int(x.strip()) for x in f.readlines()], dtype=np.int16)
        sf.write("audio.flac", data, 44100)