
from Rational import Rational
from Primes import Primes

primes = Primes()
r = Rational()

for P in primes.getPrimesList(2, 12): # get primitive roots for X в нашем случае P

    print("P", P)
    p_count = 0

    all_same = set() ## Добавлять не то что есть, а то чего нет, и искать пересечение, а потом вычитать обратно

    for base in range(P + 1, P*3 + 1): #TODO function to jump on prime roots + N*P: speedup

        r.calc(1, P, base)
        period = r.getPeriod()

        if (period == P - 1):

            d = r.digitSpectrum()
            pos = 0

            p_count += 1

            print("period", period)
            print("Base ", base)

            Ls = []

            for L in range(0, P):
                count = 0

                for i in range(pos, len(d)):

                    pos = i
                    if d[i] == 0:
                        count += 1

                    elif d[i] > 1:

                        for j in range(0, d[i]):
                            print("L", L, " = ", 0)
                            L += 1
                            Ls.append(0)
                    else:
                        break
                
                pos += 1

                print("L", L, " = ", count)
                Ls.append(count)

                       
            L_calc = int(base / P)
            print("L calc", L_calc)

            L_same = []

            for L in range(1, P):
                if Ls[L] == L_calc:
                    L_same.append(L)

            print("L same", L_same)


print ("Done")