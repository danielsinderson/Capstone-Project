#4.2
from typing import Optional
import math

def safe_reciprocal(a: Optional[float]) -> Optional[float]:
    if a is None:
        return None
    if a == 0:
        return None
    else:
        return 1 / a

assert safe_reciprocal(4) == 0.25
assert safe_reciprocal(0) == None


#4.3
def safe_root(a: Optional[float]) -> Optional[float]:
    if a is None:
        return None
    if a < 0:
        return None
    else:
        return math.sqrt(a)

assert safe_root(1) == 1
assert safe_root(-1) == None

def compose(f: callable, g: callable) -> callable:
    return lambda x: g(f(x))

safe_root_reciprocal = compose(safe_reciprocal, safe_root)
assert safe_root_reciprocal(0.25) == 2
assert safe_root_reciprocal(0) == None
assert safe_root_reciprocal(-4) == None