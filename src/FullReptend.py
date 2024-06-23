# primes_list requred : 1
# for each prime - prime scale
# for each full reptend generate C
# check is C in set, if not - add it
# if C in set - then print about it

# Run for this C and factor into P each : 4
# Calculate Growth for every C : 5

# For each C generate Digital spectrum
# For each spectrum calculate entropy : 8

# So we would have 2d: P, and bases, but bases only full reptend


# Run for fibbonach, check any other base gives 1/P : 11

# Run for single exp formula same way : 12


# For each base now we can calculate 1/P summ


# So we need:

# bases = {}
# primes = {}
# Cyclic number as a class, that holds all the properties
from Primes import Primes

primes = Primes


def check_series_possibility(s, base, primes=None):
    possible_p = round(1.0 / s, 9)
    if possible_p == round(1.0 / s, 3):
        PP = int(possible_p)
        factors = []
        if primes is not None:
            factors = primes.decompose(0, PP)
        print(PP, "for base", base, factors)


def calculate_fibbonachi_bases(start_base, end_base, primes=None, iterations=100):
    print("Searing for fibbonachy sums", start_base, end_base)
    for base in range(start_base, end_base + 1):
        s = 0.0
        fib_prev = 0
        fib_now = 1
        for i in range(iterations):
            s += fib_now / (base ** (i + 2))
            tmp = fib_prev
            fib_prev = fib_now
            fib_now += tmp
        check_series_possibility(s, base, primes)


def calculate_exp_bases(start_base, end_base, primes=None, iterations=100):
    print("Searing exp sums", start_base, end_base)
    for base in range(start_base, end_base + 1):
        s = 0
        for i in range(iterations):
            x = int(i / 2) + 2 * (i % 2)
            s += (2**x) / (base ** (1 * (i + 1)))
        check_series_possibility(s, base, primes)


calculate_fibbonachi_bases(1, 92, primes)  # TODO other famous numers series checks?
calculate_exp_bases(2, 256, primes)
