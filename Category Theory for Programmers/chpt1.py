import time



# 1.1
def id(x: object) -> object:
    return x

#1.2
def compose(f: callable, g: callable) -> callable:
    return lambda x: g(f(x))

#1.3
precompose_identity: callable = compose(id, lambda x: x + 2)
postcompose_identity: callable = compose(lambda x: x + 2, id)
assert precompose_identity(5) == postcompose_identity(5) == 7