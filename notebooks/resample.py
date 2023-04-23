import sys

FREQ = 12500

start = 0
end = -1

if len(sys.argv) > 3:
    start = int(sys.argv[3])
    end = int(sys.argv[4])

def read():
    vals = []
    idx = 0
    vallast = 0

    with open(sys.argv[1], "r") as f:
        lines = iter(f)
        next(lines)
        for line in lines:
            parts = line.strip().split(",")
            tnext = float(parts[0])
            val = int(parts[1])

            while (idx / FREQ) < tnext:
                idx += 1
                if (idx / FREQ) > start:
                    vals.append(vallast)
                if end > -1 and (idx / FREQ) > end:
                    return vals

            vallast = val

    return vals

vals = read()

with open(sys.argv[2], "w") as f:
    for v in vals:
        f.write(f"{v}\n")
