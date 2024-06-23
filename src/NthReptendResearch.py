from Rational import Rational


def findPattern(prime):
    P = prime
    print("prime =", P)

    reptends = []

    for ns in range(2, P):
        r = Rational()
        r.calc(1, P, ns)
        d = r.digits("fract", 0)
        if len(d) == (P-1)/2:
            reptends.append(ns)

    for mult in range(0, 1):
        for ns in reptends:
            r0 = Rational()
            r0.calc(1, P, ns + P * mult)
            ds0 = r0.digitSpectrum()
            sequence = []
            for num in range(1, P):
                r = Rational()
                r.calc(num, P, ns + P * mult)
                ds = r.digitSpectrum()
                #print(r.getFullString())
                if ds == ds0:
                    sequence.append(1)
                else:
                    sequence.append(2)
            print(sequence, "for ns=", ns + P * mult)
            return sequence #escape all the fun :)


def findPattern3rd(prime): #TODO построить dict [n] -> digitalSpectrum - где n номер цикла
    P = prime
    print("prime =", P)

    reptends = []

    for ns in range(2, P):
        r = Rational()
        r.calc(1, P, ns)
        d = r.digits("fract", 0)
        if len(d) == (P-1)/3:
            reptends.append(ns)

    for mult in range(0, 1):
        for ns in reptends:
            r0 = Rational()
            r0.calc(1, P, ns + P * mult)
            ds0 = r0.digitSpectrum()
            ds1 = None
            sequence = []
            for num in range(1, P):
                r = Rational()
                r.calc(num, P, ns + P * mult)
                ds = r.digitSpectrum()
                #print(r.getFullString())
                if ds == ds0:
                    sequence.append(1)
                else:
                    if ds1 == None:
                        ds1 = ds

                    if ds == ds1:
                        sequence.append(2)
                    else:
                        sequence.append(3)
            print(sequence, "for ns=", ns + P * mult)
            #return sequence #escape all the fun :)


findPattern(13)
# findPattern3rd(37)
