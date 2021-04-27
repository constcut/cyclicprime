import math

from fractions import gcd
import gmpy2

from PySide2.QtCore import Qt, Slot, Signal, QObject
from PySide2.QtQml import qmlRegisterType


def lcm(x, y):
    return x * y // gcd(x, y) 

def reduceFraction(num, den):
    common_divisor = gcd(num, den)
    (rNum, rDen) = (num / common_divisor, den / common_divisor)
    return int(rNum), int(rDen)


class Rational(QObject):
    def __init__(self,parent=None):
        QObject.__init__(self,parent)
        self._den = 1
        self._num = 1
        self._scaleOfNotation = 10

    @Slot('int','int','int')
    def calc(self, num = 1, den = 1, base = 10):
        self._flush()
        #self._Rnew(num,den,base) #I tried to make it nicer, but it had issues on geometic progression
        self._Rold(num,den,base)

    @Slot()
    def reduce(self):
        common_divisor = gcd(self._num, self._den)
        (rNum, rDen) = (self._num / common_divisor, self._den / common_divisor)
        self._num = int(rNum)
        self._den = int(rDen)

    def _flush(self):
        self._dotPosition = -1
        self._startOfPeriod = 0 
        self._intDigitsCount = 1 
        self._period = -1
        self._isCyclic = False 

    def _Rold(self, num, den, base): 
        self._num = num
        self._den = den
        self._scaleOfNotation = base
        if (den % base) == 0: 
            self._digitsLimit = len(str(gmpy2.mpz(den)))
            self._digits, self._remains = self.calculateDigits(num,den,base)
            self._period = 0
        else:
            self._num, self._den =  reduceFraction(num,den)
            self._digitsLimit = den * 11 
            self._digits, self._remains = self.calculateDigits(num,den,base)
            self._period = self.establishPeriod(self._digits)
            if self._period != 0:
                self._startOfPeriod = self.findPeriodStart(self._digits,self._period)
                slicer = slice(0,self._startOfPeriod+self._period)
                self._digits = self._digits[slicer]
                slicerMods = slice(0,self._period + self._startOfPeriod - self._intDigitsCount)
                self._remains = self._remains[slicerMods]

    def _Rnew(self, num, den, base):
        self._num = num
        self._den = den
        self._scaleOfNotation = base
        if num > den:
            print("Rational class not used for calculation num > den")
            return
        for period in range(1, self._den):
            if (gmpy2.mpz(base) ** gmpy2.mpz(period)) % gmpy2.mpz(den) == 1:
                self._period = period
                break
        self._digitsLimit = self._period + 1
        self._digits, self._remains = self.calculateDigits(num,den,base)
        self._startOfPeriod = 1
           

    @Slot('QVariant','QVariant',result='QVariant')
    def findPeriodStart(self, digits, period):
        rangeBegin = self._intDigitsCount
        if rangeBegin == 0: rangeBegin = 1
        for startingPoint in range(rangeBegin,self._digitsLimit-1):
            slicerFirst = slice(startingPoint,startingPoint + period)
            slicerNext = slice(startingPoint + period, startingPoint + period*2)
            checkListFirst = digits[slicerFirst]
            checkListNext = digits[slicerNext]
            if checkListFirst == checkListNext:
                return startingPoint
        return None

    @Slot('QVariant','QVariant','QVariant')
    def fillDigitsByInteger(self, number, base, digitsList): 
        self._intDigitsCount = 0
        if number < base:
            digitsList.insert(0,number)
            self._intDigitsCount += 1
        while number >= base:
            d,m = gmpy2.f_divmod(number,base)
            digitsList.insert(0,m)
            self._intDigitsCount += 1
            number = d
            if number < base:
                digitsList.insert(0,d)
                self._intDigitsCount += 1
                break

    @Slot('QVariant','QVariant','QVariant',result='QVariant')
    def calculateDigits(self, num, den, base):
        num = gmpy2.mpz(num)
        den = gmpy2.mpz(den)
        baseScale = base
        digits = []
        mods = []
        if num == den:
            digits.append(1)
            self._period = 0
            return digits, mods
        if den == 0:
            self._period = 0
            return digits, mods

        for i in range(0, self._digitsLimit):
            d,m = gmpy2.f_divmod(num,den)
            num = m * baseScale
            if i==0 and d > 0:
                self.fillDigitsByInteger(d, base, digits)
                mods.append(m)
            else:
                digits.append(d)
                mods.append(m)
                if i != 0 and self._dotPosition == -1:
                    self._dotPosition = len(digits)-1
            if num == 0:
                break
            if len(digits) % 1000 == 0: 
                checkPeriod = self.establishPeriod(digits)
                if checkPeriod > 0: 
                    return digits, mods
        return digits, mods


    @Slot('QVariant',result='QVariant')
    def establishPeriod(self, digits):
        digitsLen = len(digits)
        for period in range(1,self._den): 
            firstSlice = slice(digitsLen - 1 - period, digitsLen-1)
            firstPeriod = digits[firstSlice]
            fineRepeatedPeriods = 0
            insureAmount = 10 
            for insureRepeats in range(1,insureAmount): 
                anotherSlice = slice(digitsLen -1 -period * insureRepeats -period, digitsLen - 1 - period * insureRepeats)
                anotherPeriod = digits[anotherSlice]
                if firstPeriod == anotherPeriod:
                    fineRepeatedPeriods += 1
                    if fineRepeatedPeriods >= insureAmount-1:
                        if period == 1 and anotherPeriod[0] == 0:
                            period = 0
                        return period
                else:
                    break
        return 0

    def __str__(self):
        fullString = ''
        sepparator = ' '  if self._scaleOfNotation > 10 else ''
        for digitIndex, digit in enumerate(self._digits):
            if self._dotPosition == digitIndex:  fullString += '.'
            if self._startOfPeriod != 0 and self._startOfPeriod == digitIndex:  fullString += '('
            fullString += str(digit) + sepparator
        if self._startOfPeriod != 0:
            fullString += ')'
        return fullString

    def __repr__(self):
        result = 'Rational(' + str(self._num) + '/' + str(self._den) + ','+ str(self._scaleOfNotation)  + ',p:' + str(self._period) + ')'
        return result

    def __format__(self, type):
        if type == "digits":
            return self.__str__()
        else:
            fullString = ''
            for digitIndex, digit in enumerate(self._digits):
                if self._dotPosition == digitIndex:
                    fullString += '.'
                if self._startOfPeriod != 0 and self._startOfPeriod == digitIndex:  fullString += '('
                if digit <= 9:
                    fullString += str(digit)
                else:
                    fullString += chr(digit-10 + 65) 
            if self._startOfPeriod != 0:
                fullString += ')'
            return fullString


    @Slot(result='QVariant')
    def getFullString(self):
        fullStr = self.__str__() + ' ' + repr(self)
        return fullStr

    @Slot('QVariant','int',result='QVariant')
    def digits(self, part='all', extendByPeriod=0):
        beginRange = 0; endRange = len( self._digits ) #default part='all'
        if part == 'period': beginRange = self._startOfPeriod
        elif part == 'int': endRange = self._intDigitsCount
        elif part == 'fract': beginRange = self._intDigitsCount
        slicer = slice(beginRange,endRange)
        resultList = self._digits[slicer] 
        if self._period == 0:
            return resultList
        if extendByPeriod != 0:
            for i in range(extendByPeriod):
                periodDigit = self._digits[self._startOfPeriod + i % self._period]
                resultList.append(periodDigit)
        return resultList

    @Slot('QVariant',result='QVariant')
    def intDigits(self, part='all'):
        x = self.digits(part)
        newList = []
        for any in x:
            newList.append(int(any))
        return newList

    @Slot('QVariant',result='QVariant')
    def intFromFract(self, n):
        if n > self._period:
            diff = n - self._period
            d = self.digits(part='fract',extendByPeriod=diff)
        else:
            d = self.digits(part='fract')
            d = d[0:n]
        sumInt = 0
        for digit in d:
            sumInt *= self._scaleOfNotation
            sumInt += digit
        return sumInt

    @Slot('int',result='QVariant')
    def intFromFractQML(self,n=0):
        return str(self.intFromFract(n))

    @Slot(result='QVariant')
    def getPeriod(self):
        return self._period

    @Slot(result='QVariant')
    def getPeriodStart(self):
        return self._startOfPeriod

    @Slot(result='QVariant')
    def getIntPartLen(self):
        return self._intDigitsCount

    @Slot(result='QVariant')
    def getFractPartLen(self):
        return len(self._digits) - self._intDigitsCount

    @Slot('int',result='QVariant')
    def changeScaleOfNotation(self,base=10): 
        r = Rational()
        r.calc(self._num, self._den, base)
        return r

    @Slot('QVariant',result='QVariant')
    def digitSpectrum(self, part='fract'): 
        spectrum = [0]*self._scaleOfNotation
        digits = self.digits(part)
        for digit in digits:
            spectrum[ digit ] += 1
        return spectrum

    @Slot('QVariant',result='QVariant')
    def spectrumString(self, part='fract'):
        spec = self.digitSpectrum(part)
        resultString = ''
        for dig in spec:
            resultString += str(dig) + ' '
        return resultString

    @Slot('QVariant',result='QVariant')
    def regularity(self, part='all'): 
        regs = []
        extension = 1 
        if self._period == 0 or part == 'int':
            extesion = 0
        digits = self.digits(part,extension)
        for digInd in range(0, len(digits)-1):
            diff = digits[ digInd+1 ] - digits[digInd]
            regs.append(diff)
        intRegs = []
        for reg in regs:
            intRegs.append(int(reg))
        return intRegs

    @Slot(result='QVariant')
    def remains(self): 
        intRemains = []
        for rem in self._remains:
            intRemains.append(int(rem))
        return intRemains

    @Slot('QVariant',result='QVariant')
    def numReduction(self, part='all'):
        digits = self.digits(part)
        while 'the earth spins round':
            result = 0
            for digit in digits:
                result += digit
            if result >= self._scaleOfNotation:
                newDigits = []
                self.fillDigitsByInteger(result, self._scaleOfNotation, newDigits)
                digits = newDigits
            else:
                return result

    @Slot(result='QVariant')
    def isCyclic(self):
        import importlib
        sympyLib = importlib.find_loader('sympy')
        if sympyLib is not None: 
            from sympy.ntheory import primefactors
            primesList = primefactors(self._den)
        else:
            from factordb.factordb import FactorDB
            f = FactorDB(self._den)
            connection = f.connect()
            primesList = f.get_factor_list()
        isDenPrime = len(primesList) == 1
        self._isCyclic = False
        if isDenPrime and self._num < self._den and self._period != 0: 
            self._isCyclic = True
            cycleList = []
            spectrumsSet = set()
            for n in range(1,self._den):
                number = Rational()
                number.calc(n,self._den, self._scaleOfNotation)
                cycleList.append(number)
                spectrumsSet.add(number.spectrumString())
            if len(spectrumsSet) == (self._den-1)/self._period:
                self._amountOfCycles = len(spectrumsSet)
            self._vertTables = []
            for i in range(self._period):
                singleVerTab = []
                for j in range(1, self._den):
                    singleVerTab.append(int(cycleList[j-1].digits()[i+1]))
                self._vertTables.append(singleVerTab)
            self._multiplyShiftList = [0]
            protoPeriod = cycleList[0].digits(part='period')
            for i in range(2,self._den): 
                firstPeriodDigit = cycleList[i-1].digits(part='period')[0]
                for index, digit  in enumerate(protoPeriod):
                    if digit == firstPeriodDigit:
                        self._multiplyShiftList.append(index)
            cyclicNumber = int( (self._scaleOfNotation ** self._period) * (1.0 / self._den) )
        return self._isCyclic

    @Slot(result='QVariant')
    def getAmountOfCycles(self):
        return self._amountOfCycles

    @Slot(result='QVariant')
    def multiplyShift(self):
        return self._multiplyShiftList

    @Slot(result='QVariant')
    def verticalTables(self):
        return self._vertTables

    @Slot(result='QVariant')
    def scalesPeriod(self):
        periodList = []
        for i in range(2, self._den + 2):
            num = Rational()
            num.calc(self._num, self._den, i)
            periodList.append(num.getPeriod())
        return periodList

    @Slot(result='QVariant')
    def cyclicPairNumber(self):
        if self._isCyclic:
            repunitString = '9'*self._period 
            periodBorder = gmpy2.mpz(repunitString)
            import importlib
            sympyLib = importlib.find_loader('sympy')
            if sympyLib is not None: 
                from sympy.ntheory import primefactors
                primes = primefactors(periodBorder)
            else:
                from factordb.factordb import FactorDB
                f = FactorDB(periodBorder)
                connection = f.connect()
                primes = f.get_factor_list()
            primesSet = set(primes)
            equalPeriods = []
            for primeNumber in primesSet:
                pass
                rational = Rational() #slow.. TODO
                rational.calc(1,primeNumber,self._scaleOfNotation)
                if rational.getPeriod() == self._period:
                    equalPeriods.append(primeNumber)
            return equalPeriods


    def __eq__(self,other):
        if self._num == other._num and self._den == other._den: return True
        return False

    def __add__(self, other):
        baseLcm = lcm(self._den,other._den)
        newDen = baseLcm
        newNum = int(self._num * baseLcm / self._den + other._num * baseLcm / other._den)
        r = Rational()
        r.calc(newNum,newDen, self._scaleOfNotation)
        return r

    @Slot('int','QVariant',result='QVariant')
    def findGeomProgress(self, decreaseCoef=100, epsCoef=0.000001):
        if self._isCyclic:  
            origin = Rational()
            origin.calc(1, self._den, self._scaleOfNotation)
            l = round(math.log(decreaseCoef,self._scaleOfNotation)) 
            multiplyBy = origin.remains()[l % len(self._remains)]
            f = origin.intFromFract(l) 
            while f == 0:
                l += 1
                f = origin.intFromFract(l)
                decreaseCoef *= self._scaleOfNotation
            from GeometricProgression import GeometricProgression
            g = GeometricProgression()
            g.set(f*self._num, multiplyBy,decreaseCoef)
            return g
        epsCoef = 1.0 / (self._scaleOfNotation ** self._period) 
        firstStepLength = math.log(decreaseCoef, self._scaleOfNotation)
        firstStep = int( (self._scaleOfNotation ** firstStepLength) * (1.0 / self._den) )
        equalent = self._num / self._den
        for checkMult in self.remains():
            gpCheck = GeometricProgression(firstStep,checkMult,decreaseCoef)
            sum = gpCheck.fullSum()
            if abs(sum-equalent) < epsCoef:
                return gpCheck
        return None

    @Slot(result='QVariant')
    def getGeomProgCoef(self):
        decreasor = 0
        for i in range(1,21):
            decreasor = self._scaleOfNotation ** i
            if decreasor > self._den:
                break
        geo = self.findGeomProgress(decreasor)
        result = (decreasor, geo.getInc())
        return result

