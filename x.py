
s = 0

for i in range(100):
    x = int(i / 2) + 2 * (i % 2)
    s += (2**x) / (10 ** (1 * (i + 1)))

print(s, 1.0 / s)


import gmpy2

x = gmpy2.mpz(1)  # ,originBase)
y = gmpy2.mpz(1)

for i in range(1, 255):
    if i % 3 != 0:
        x *= i
    y += 255 - i
    y *= 255 - i

"""
print(x.digits())
print()
print(y.digits())


print(len(gmpy2.to_binary(x)))
"""
