
from factordb.factordb import FactorDB
from fractions import gcd

from PySide2.QtCore import Qt, Slot, Signal, QObject
from PySide2.QtQml import qmlRegisterType

def registerQMLTypes():
    qmlRegisterType(Primes, 'Athenum', 1,0, 'Primes')
def getQMLTypes():
    theTypes = ['Primes']
    return theTypes

class Primes(QObject):
    def __init__(self,parent=None):
        QObject.__init__(self,parent)

    @Slot('QVariant','int',result='QVariant')
    def decompose(self, number, baseCheck=10):
        l = makePrimeStringList(int(number)) #makbe make list of strings that matter more like 7**2
        return l

    @Slot('QVariant',result='QVariant')
    def findPrimeSeqGroups(self, border):
        isPrimeTime = False 
        rList = []
        curList = []
        stepsBetween = 0
        for i in range(2,border):
            needSwitch = False
            import gmpy2
            if gmpy2.is_prime(i):
                if isPrimeTime == False:
                    needSwitch = True
            else:
                if isPrimeTime:
                    needSwitch = True
            if needSwitch:
                if len(curList) > 1:
                    rList.append(curList)
                    print("prev steps btw ",stepsBetween)
                    stepsBetween = 0
                else:
                    stepsBetween += 1
                curList = []
                isPrimeTime = not isPrimeTime
            curList.append(i)
        return rList


    @Slot('QVariant','QVariant','int',result='QVariant')
    def decWithSpec(self, number, spectrum, base=10):
        spectrum = spectrum.toVariant()
        for i in range(len(spectrum)):
            spectrum[i] = int(spectrum[i])
        totalFound = []
        f = FactorDB(number)
        connection = f.connect()
        l = f.get_factor_list()
        for p in l:
            spec = pseudoSpectrum(p, base)
            if spec == spectrum:
                totalFound.append(shortVersion(str(p)))
        return totalFound

    @Slot('int','int',result='QVariant')
    def getPrimesList(self, start=2, end=50):
        import gmpy2
        result = []
        for i in range(start, end+1):
            if gmpy2.is_prime(i):
                result.append(i)
        return result

    @Slot('int',result='QVariant')
    def isPrime(self, number=1):
        import gmpy2 
        return gmpy2.is_prime(number)

    @Slot('int',result='QVariant')
    def isReversePrime(self, number=1):
        import gmpy2
        if gmpy2.is_prime(number) == False:
            return False
        string = str(number)
        rStr = string[::-1]
        return gmpy2.is_prime(gmpy2.mpz(rStr))

    @Slot('int','int',result='QVariant')
    def getReversePrimeInRange(self, start=2, end=10):
        result = []
        for i in range(start, end+1):
            if self.isReversePrime(i):
                result.append(i)
        return result


def pseudoSpectrum(intNum, base):
    theNum = intNum
    spec = [0]*base
    import gmpy2
    n = gmpy2.mpz(str(intNum), 10) 
    print("Use gmpy for pseudo spectrum")
    s = n.digits(base) 
    for char in s:
        spec[int(char,base)] = 1
    return spec

def shortVersion(strValue):
    l = len(strValue)
    result = strValue[0] + '..' + strValue[-1] + '; ' + str(l) + ' digits; ' + str(int(l/6))  + ' cycles; '  + str(l - int(l/6)*6) + ' out of cycle: ' + strValue
    return result

def numberToBase(n, b):
    if n == 0:
        return [0]
    digits = []
    while n:
        digits.append(int(n % b))
        n //= b
    return digits[::-1]

def makePrimeList(number):
    from sympy.ntheory import factorint
    return expendPrimeDict(factorint(number))

def expendPrimeDict(dict):
    numberList = []
    for prime in dict:
        pow = dict.get(prime)
        number = prime ** pow
        numberList.append(number)
    return numberList


def makePrimeStringList(number): 
    strList = []
    import importlib
    sympyLib = importlib.find_loader('sympy')
    if sympyLib is not None: 
        if len(str(number)) > 30:           
            f = FactorDB(number)
            connection = f.connect()
            l = f.get_factor_list()
            for el in l:
                strList.append(str(el))
        else:
            from sympy.ntheory import primefactors                              
            primes = primefactors(number)
            for el in primes:
                strList.append(str(el))
    else:
        f = FactorDB(number)
        connection = f.connect()
        l = f.get_factor_list()
        for el in l:
            strList.append(str(el))
    return strList


def expendPrimeStringDict(dict):
    numberList = []
    for prime in dict:
        pow = dict.get(prime)
        if pow > 1:
            number = str(prime) + '^' + str(pow) 
        else:
            number = str(prime)
        numberList.append(number)
    return numberList

def primeDecomposition(num, den):
    return makePrimeList(num), makePrimeList(den)



def primesPatternInList(primesList):
    flags = []
    for number in primesList:
        from sympy.ntheory import isprime
        if isprime(number):
            flags.append(1)
        else:
            flags.append(0)
    return flags

def primesPatternString(primesList):
    result = ''
    for number in primesList:
        from sympy.ntheory import isprime
        if isprime(number): 
            result += 'x'
        else:
            result += 'o'
    return result

def sexyPrimeResearch():
    from Rational import Rational
    import gmpy2
    for repType in range(0,10):
        repTypeName = "(P-1)"
        if repType:
            repTypeName += "/" + str(repType+1)
        print("\nReptyp: ", repTypeName, "\n")
        for P in range(2,138):
            mP = gmpy2.mpz(P)
            if not gmpy2.is_prime(mP):
                continue
            localBorderP = (P-1)/(repType + 1)
            r = Rational()
            r.calc(1, P, 10)
            s = r.scalesPeriod()
            twinPresent = False
            cousinPresent = False
            sexyPresent = False
            octaPresent = False
            for i in range(2, 10002):
                currentDigit = s[ (i-2) % len(s)]
                if currentDigit == localBorderP:
                    primeCheck = gmpy2.mpz(i)
                    if gmpy2.is_prime(primeCheck):
                        nextPrime = gmpy2.next_prime(primeCheck)
                        nextDigit = s[ (nextPrime-2) % len(s)]
                        if nextDigit != localBorderP:
                            continue
                        diff = nextPrime - primeCheck
                        if diff == 2:
                            #mid = int((primeCheck + nextPrime)/2)
                            #isSexRelated = mid % 6
                            #print("Twin primes: ", primeCheck, nextPrime, " mid: ", isSexRelated == 0)
                            twinPresent = True
                        if diff == 4:
                            #print("Cousin primes: ", primeCheck, nextPrime)
                            cousinPresent = True
                        if diff == 6:
                            #mid = int((primeCheck + nextPrime)/2)
                            #isDRelated = mid % 2
                            sexyPresent = True
                            #print("m ",mid, isQRelated)
                            #print("Sexy primes: ", primeCheck, nextPrime, " mid: ", isDRelated == 0)
                        if diff == 8:
                            #print("Octa primes: ", primeCheck, nextPrime)
                            octaPresent = True

            tP = "" 
            if twinPresent:
                tP = "twin "
            cP =  ""
            if cousinPresent:
                cP = "cousin "
            sP = "" 
            if sexyPresent:
                sP = "sexy "
            oP = "" 
            if octaPresent:
                oP = "octa "
            fullReportLine = tP + cP + sP + oP
            print("For P ", P, " : ", fullReportLine)


def primesInOtherScales():
    from Primes import Primes
    import gmpy2
    p = Primes()
    primeList = p.getPrimesList(2,500)
    for prime in primeList:
        b = gmpy2.mpz(prime)
        print("For prime ", prime, " in 3rd numeral system is ", b.digits(2))

def allPrimesDevergesSum():
    from Primes import Primes
    p = Primes()
    primeList = p.getPrimesList(2,10000000)
    import gmpy2
    pInv = gmpy2.mpq(0,1)
    for prime in primeList:
        pInv += gmpy2.mpq(1, prime)
        m = gmpy2.mpfr(pInv)
        print("On prime ", prime, " summ is ", str(m))
        if m > 3:
            break

def primeGapResearch():
    from Primes import Primes
    p = Primes()
    primeList = p.getPrimesList(2,499)
    d = dict()
    for p1 in primeList:
        for p2 in primeList:
            if p1 < p2:
                diff = int(p2 - p1)
                dictValue = d.get(diff)
                if dictValue == None:
                    d.update({diff:1})
                else:
                    d.update({diff:dictValue+1})    
    a = sorted(d.items(), key=lambda x: x[1], reverse=True)
    for record in a:
        if record[1] > 3:
            print(record[0], " has got ", record[1])

