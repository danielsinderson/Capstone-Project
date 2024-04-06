from Lenses import *




clock = Lens(lambda x, y: (x % 12) + 1, lambda x: x)
meridian = Lens(lambda m: (m[0] if m[1] < 12 else not m[0]), lambda m: m[0])
mc = monoidal_product(meridian, clock)

def test_clock_1(mer: Lens, clk: Lens) -> list:
    h = 0
    m = 0
    meridian_dict = {0: "am", 1: "pm"}
    t = []
    for i in range(24):
        h = clk.update(h, 1)
        m = mer.update((m, h))
        t.append(f"{h}{meridian_dict[m]}")
    return t

def main():
    print(test_clock_1(meridian, clock))


if __name__ == "__main__":
    main()