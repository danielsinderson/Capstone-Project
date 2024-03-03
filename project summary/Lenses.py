'''
Code to support wiring lenses together.
- Lens dataclass
- Composition of lenses
- Monoidal product of lenses
'''

from dataclasses import dataclass


@dataclass
class Lens:
    update: callable
    output: callable


def compose(A: Lens, B: Lens) -> Lens:
    up_new: callable = lambda a, b: A.update(a, B.update(A.output(a), b))
    out_new: callable = lambda a: B.output(A.output(a))
    return Lens(up_new, out_new)

def monoidal_product(A: Lens, B: Lens) -> Lens:
    up_new: callable = lambda ac, bd: (A.update(ac[0], bd[0]), B.update(ac[1], bd[1]))
    out_new: callable = lambda ac: (A.output(ac[0]), B.output(ac[1]))
    return Lens(up_new, out_new)


def main() -> None:
    return

if __name__ == "__main__":
    main()