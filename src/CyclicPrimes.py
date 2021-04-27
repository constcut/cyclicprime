from Rational import Rational
from Primes import Primes
from PySide2.QtCore import Qt, Slot, Signal, QObject
from PySide2.QtQml import qmlRegisterType
def registerQMLTypes():
    qmlRegisterType(CyclicPrimes, 'Athenum', 1,0, 'CyclicPrimes')
def getQMLTypes():
    theTypes = ['CyclicPrimes']
    return theTypes

class CyclicPrimes(QObject):
    def __init__(self, parent=None):
        QObject.__init__(self,parent)
        self._digitsToCheck = 50

 
    @Slot('int')
    def setDigitsToCheck(self, newAmount):
        self._digitsToCheck = newAmount


    @Slot('int','int','int','QVariant',result='QVariant')
    def findInRange(self, prime=7, baseNumberStart=0, baseNumberEnd=2, type='sub'):
        fullReptendPositions = self._getFullReptendPositions(prime)
        totalPrimes = []
        if len(fullReptendPositions) == 0:
            return totalPrimes
        for i in range(baseNumberStart, baseNumberEnd+1):
            scale = self._rangeIterationBasement(prime, i, fullReptendPositions)
            foundPrimes = self.find(prime, scale, type)
            totalPrimes.append(foundPrimes)
        return totalPrimes

    def _getFullReptendPositions(self, prime):
        r = Rational()
        r.calc(1,prime,10)
        scalesPeriod = r.scalesPeriod()
        fullReptendPositions = []
        for i in range(len(scalesPeriod)):
            if scalesPeriod[i] == prime - 1:
                fullReptendPositions.append(i+2)
        return fullReptendPositions

    def _rangeIterationBasement(self, prime, currentNumber, fullReptendPositions):
        if currentNumber < len(fullReptendPositions):
            researchBasement = fullReptendPositions[currentNumber]
        else:
            totalCycles = int(currentNumber / len(fullReptendPositions))
            localCycle = currentNumber % len(fullReptendPositions)
            researchBasement = fullReptendPositions[localCycle]
            researchBasement += prime * totalCycles
        return researchBasement

    @Slot('int','int','int',result='QVariant')
    def getRangeScales(self, prime=7, baseNumberStart=0, baseNumberEnd=2):
        fullReptendPositions = self._getFullReptendPositions(prime)
        totalScales = []
        if len(fullReptendPositions) == 0:
            return totalScales
        for i in range(baseNumberStart, baseNumberEnd+1):
            scale = self._rangeIterationBasement(prime, i, fullReptendPositions)
            totalScales.append(scale)
        return totalScales


    @Slot('int','int','QVariant',result='QVariant')
    def find(self, prime=7, base=10, type='sub'):
        if type == 'sub':
            return self._findSubPrimes(prime,base)
        if type == 'full':
            return self._findFullPrimes(prime,base) 
        if type == 'combined':
            return self._findCombinedPrimes(prime, base) 
        print('Unknown Cyclic Prime type ',type)
        return []


    def _findFullPrimes(self, prime, base):
        fullCyclePrimes = set()
        primes = Primes()
        rList = [] 
        for n in range(1,prime-1): 
            r = Rational()
            r.calc(n, prime, base)
            rList.append(r)
            for i in range(prime, self._digitsToCheck):
                if i > 500 and i % 50 == 0:
                    print("Calculating cyclic prime numbers on digit# ", i, " got ", len(fullCyclePrimes))
                number = rList[n-1].intFromFract(i)
                if primes.isPrime(number):
                    fullCyclePrimes.add(int(number))
        intList = sorted(fullCyclePrimes)
        strList = [str(num) for num in intList]
        return strList


    @Slot('QVariant','QVariant','QVariant',result='QVariant') 
    def descriptionForFullCycle(self, prime, primeList, base):
        rational = Rational() 
        rational.calc(1, prime, base)
        rDigits = rational.digits('period')
        for i in range(len(primeList[0])):
            amountOfCycles = int( len(primeList[0][i]) / len(rDigits) )
            print('For number ', primeList[0][i], 'amount of cycles is',amountOfCycles)
        return 'some text to describe full cycle prime number'


    def _findSubPrimes(self, prime, base):
        subPrimes = set()
        primes = Primes()
        rList = []
        for n in range(1,prime-1):
            r = Rational()
            r.calc(n, prime, base)
            rList.append(r)
            for i in range(1, prime-1):
                number = rList[n-1].intFromFract(i)
                primesFromNumber = primes.decompose(number)
                for checkPrime in primesFromNumber:
                    if int(checkPrime) in subPrimes:
                        continue
                    if self._checkPrimeIsSub(checkPrime, base, rList[n-1]) == True:
                        subPrimes.add(int(checkPrime))
        return sorted(subPrimes)


    def _checkPrimeIsSub(self, prime, base, rational):
        primePart = int(prime)
        firstDigit = primePart % base
        rDigits = rational.digits('period')
        possibleStartIndex = []
        for i in range(len(rDigits)):
            if rDigits[i] == firstDigit:
                possibleStartIndex.append(i)
        if len(possibleStartIndex) == 1:
            return self._traceSub(primePart, base, possibleStartIndex[0], rDigits)
        elif len(possibleStartIndex) == 0:
            return False
        else:
            for checkStart in possibleStartIndex:
                if self._traceSub(primePart, base, checkStart, rDigits):
                    return True
            return False


    def _traceSub(self, prime, base, startIndex, rDigits): 
        primePart = prime
        currentIndex = startIndex
        while primePart > 0:
            currentDigit = primePart % base
            primePart = int(primePart / base)
            rationalDigit = rDigits[currentIndex]
            if rationalDigit != currentDigit:
                return False
            currentIndex -= 1
            if currentIndex < 0:
                currentIndex = len(rDigits) - 1
        return True



def LCSubStr(X, Y, m, n): 
    LCSuff = [[0 for k in range(n+1)] for l in range(m+1)] 
    result = 0 
    for i in range(m + 1): 
        for j in range(n + 1): 
            if (i == 0 or j == 0): 
                LCSuff[i][j] = 0
            elif (X[i-1] == Y[j-1]): 
                LCSuff[i][j] = LCSuff[i-1][j-1] + 1
                result = max(result, LCSuff[i][j]) 
            else: 
                LCSuff[i][j] = 0
    return result 


def compareSeq(origin, compare):
    if len(origin) != len(compare):
        print("Origin and compare sizes not equal")
    x2O = origin * 2
    x2C = compare * 2
    maxShared = LCSubStr(x2O, x2C, len(x2O), len(x2C))
    isMatching = maxShared > len(origin)
    matchingDigits = len(origin)
    if isMatching == False:
        for testingValue in range(0, maxShared + 1):
            lenX = (maxShared - testingValue)
            matchPart = compare[-lenX:]
            if x2O.find(matchPart) != -1:
                matchingDigits = lenX
                break
    lastPosition = -1
    if matchingDigits > 0:
        lastCompareDigit = compare[len(compare)-1]
        lastPosition = origin.find(lastCompareDigit)
    return isMatching, matchingDigits, lastPosition


def strFromList(l):
    strOut = ''
    for el in l:
        i = int(el)
        if i < 10:
            s = str(i)
        else:
            s = chr(i-10 + 97) 
        strOut += s
    return strOut

def checkCyclicPrimes(P):
    from CyclicPrimes import CyclicPrimes
    from Rational import Rational
    c = CyclicPrimes()
    prime = P
    c.setDigitsToCheck(300) 
    scales = c.getRangeScales(prime=prime, baseNumberStart=0, baseNumberEnd=100) #can try to scales 500 or more
    x = c.findInRange(prime=prime, baseNumberStart=0, baseNumberEnd=100, type="full")
    scalesForSearch = scales[:25]   
    print("Scales from list: ", scalesForSearch)
    import gmpy2
    for currentScale in scalesForSearch:
        searchScale = currentScale
        if searchScale > 62: #GMPY2 max
            continue
        nsSet = set()
        for numer in range(1,prime):
            intVal = int(searchScale ** (prime-1) * numer / prime)
            searchString = gmpy2.mpz(intVal).digits(searchScale)
            while len(searchString) < prime-1:
                searchString = "0" + searchString
            print("For prime ", P, " in numeric system ", currentScale, " searching sequence ", searchString, "=", numer,"/",prime)
            for ns in range(0,len(scales)):
                for d in x[ns]:
                    z = gmpy2.mpz(d)
                    digits = z.digits(searchScale)
                    pos = digits.find(searchString)
                    if pos != -1:
                        isCycle = False
                        cycles = 0
                        if pos != 0:
                            while (pos + len(searchString)) < len(digits):
                                cycles += 1
                                pos = digits.find(searchString, pos + 1)
                                if pos == -1: 
                                    passed = (pos + len(searchString))
                                    rD = digits[-passed:]
                                    specialStr = searchString * 2
                                    if specialStr.find(rD) != -1:
                                        isCycle = True
                                        #review :)
                                    break
                        else:
                            cycles = len(digits) / len(searchString) 

                        isNotFull = cycles * len(searchString) / len(digits) < .4 #kind of hotfix
                        if isCycle == True:
                            if isNotFull:
                                if cycles > 1:
                                    nsSet.add(scales[ns])
                            else:
                                nsSet.add(scales[ns])
               
        foundNS = sorted(nsSet)
        print("Found NS ", foundNS, " in base ", searchScale)
        topDiff = dict()
        for i in range(0, len(foundNS) - 1):
            delta = foundNS[i+1] - foundNS[i]
            if delta in topDiff:
                topDiff[delta] = topDiff[delta] + 1
            else:
                topDiff[delta] = 1
        print("Top difference: ", topDiff)
