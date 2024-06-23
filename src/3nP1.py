a = 101241

from math import log10

mult = 3
addition = 1
divisor = 2
steps = 0

while a != 1:
    if a % divisor == 0:
        a /= divisor
    else:
        a = mult * a + addition
    steps += 1

print("Total steps", steps)
print(a)
