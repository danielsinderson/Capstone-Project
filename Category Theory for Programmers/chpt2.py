#2.1
def memoize(f: callable) -> callable:
    memory = {}
    def memoized_function(*args):
        if args not in memory:
            memory[args] = f(*args)
        return memory[args]
    return memoized_function

@memoize
def collatz(n: int) -> int:
 while n != 1:
    if n % 2 == 0:
        n = n / 2
    else:
        n = (n * 3) + 1