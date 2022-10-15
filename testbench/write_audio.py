import sys
import soundfile as sf
import numpy as np

if __name__ == "__main__":
    filename = sys.argv[1]
    with open(filename, "r") as f:
        data = np.array([int(x.strip()) for x in f.readlines()], dtype=np.int16)
        sf.write("audio.flac", data, 44100)