
from Rational import Rational
from Primes import Primes
import math

primes = Primes()
r = Rational()


def prepare_x(L, end):

    X = []

    X.append(L[0])

    for i in range(1, math.ceil(end) - 1):

        Xi = 0
        for j in range(0, i + 1):

            if L[j] == 0:
                Xi += 1
            else:        
                Xi += L[j] + 1

        X.append(Xi - L[0])

    return X



def make_x(L):
    
    return prepare_x(L, len(L))


def make_half_x(L):

    print("Xh ", L)
    return prepare_x(L, len(L) / 2)


def make_a(X, Pos): # ++ half

    A = []

    for i in range(1, int(len(X) / 2) + 1):

        Ai = X[Pos[i] - 1] - X[Pos[i - 1] - 1]
        A.append(Ai)

    return A


def prepare_offset(P, base, size):

    Pos = []

    for i in range(0, math.ceil(size)):
        Pos.append(pow(base, i) % P)

    return Pos


def make_offset(P, base):

    return prepare_offset(P, base, P - 1)


def make_half_offset(P, base):

    return prepare_offset(P, base, (P - 1) / 2)


# TODO make L



for P in primes.getPrimesList(2, 10): # get primitive roots for X в нашем случае P

    print("\nP", P)
    p_count = 0

    all_same = set() ## Добавлять не то что есть, а то чего нет, и искать пересечение, а потом вычитать обратно

    for base in range(P + 1, P * 5 + 1): #TODO function to jump on prime roots + N*P: speedup

        

        fract_len = math.log10((base ** (P-1) - 1) / P)

        if (fract_len == P - 1):  #period == P - 1

            r.calc(1, P, base)
            period = r.getPeriod() # более разумный метод поиска, как минимум при помощи математического рассчета числа цифр

            d = r.digitSpectrum()
            pos = 0

            p_count += 1

            print("period", period)
            print("Base ", base)

            Ls = []

            print("d", d)

            for L in range(0, P):
                count = 0

                for i in range(pos, len(d)):

                    pos = i
                    if d[i] == 0:
                        count += 1

                    elif d[i] > 1:

                        for j in range(0, d[i]):
                            #print("L", L, " = ", 0)
                            L += 1
                            Ls.append(0)
                    else:
                        break
                
                pos += 1

                #print("L", L, " = ", count)
                Ls.append(count)

            print("L = ", Ls)   

            X = make_x(Ls)
            O = make_offset(P, base)
            A = make_a(X, O)

            print('X', X, sum(X))
            print('A', A, sum(A))
            print('O', O, sum(O))

            L_calc = int(base / P)
            print("L calc", L_calc)

            L_same = []

            for L in range(1, P):
                if Ls[L] == L_calc:
                    L_same.append(L)
                else:
                    pass
                    #print("L diff ", L_calc - Ls[L], " on ", L)

            print("L same", L_same)

#TODO 1 Собрать перечень L same (и одновременно для проверки словарь разниц, удостовериться, что там всегда 1)

#Вывести их череду, для каждого простого числа

#Вывести формулу, для пропуска элементов, в зависимости от P и в любой форме записанной системы счисления

#Вывод, формулы можно записать чередующимися, от каждого примитивного корня, у них всегда одинаково будут распределяться отставания
#В таком случае по всем простым числам надо вывести только каждый цикл, и на каждом цикле нужно вывести свой паттерн LL-L-LL


print ("Done")

# Сформулировать полностью Xi, Ai/2, Lj, sum(X), sum(A), sum(L) == base, POSi, MIDI theorem X1 + x4 = base{10} - 1

#TODO make_l (P, base)
#TODO make_half_l(P, base)


