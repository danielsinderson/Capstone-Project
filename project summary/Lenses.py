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
    expose: callable


#lens composition
def compose(A: Lens, B: Lens) -> Lens:
    up = lambda a: A.update(a[0], B.update(A.expose(a[0]), a[1]))
    out = lambda a: B.expose(A.expose(a))
    return Lens(up, out)


#lens monoidal product
def monoidal_product(A: Lens, B: Lens) -> Lens:
    up = lambda ac, bd: (A.update(ac[0], bd[0]), B.update(ac[1], bd[1]))
    out = lambda ac: (A.expose(ac[0]), B.expose(ac[1]))
    return Lens(up, out)



def main() -> None:
    return


if __name__ == "__main__":
    main()