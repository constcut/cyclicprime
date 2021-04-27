from fractions import gcd
import math
from Rational import Rational

import Athenum as Athenum
import gmpy2

from PySide2.QtCore import Qt, Slot, Signal, QObject
from PySide2.QtQml import qmlRegisterType


def registerQMLTypes():
    qmlRegisterType(NumericSystem, 'Athenum', 1,0, 'NumericSystem')
def getQMLTypes():
    theTypes = ['NumericSystem']
    return theTypes


def reduceFraction(num, den):
    common_divisor = gcd(num, den)
    (rNum, rDen) = (num / common_divisor, den / common_divisor)
    return int(rNum), int(rDen)


class NumericSystem(QObject): 
    def __init__(self,parent=None):
        QObject.__init__(self,parent)

    @Slot('QVariant','int','int',result='QVariant')
    def translate(self, origin, originBase=10, destBase=2):
        origin = origin.upper()
        n = gmpy2.mpz(origin,originBase)
        result = n.digits(destBase)
        return result

    @Slot('QVariant','int','int',result='QVariant')
    def translateSepparated(self, strList, originBase=10, destBase=2):
        digits = strList.split()
        origin = 0
        for d in digits:
            origin *= originBase
            origin += int(d)
        n = gmpy2.mpz(origin,originBase)
        result = n.digits(destBase)
        return result

    @Slot('QVariant','int','int',result='QVariant')
    def translateRational(self, rStr, originBase=10, destBase=2):
        divisor = rStr.find('/')
        numStr = rStr[0:divisor]
        denStr = rStr[divisor+1:] 
        num = gmpy2.mpz(numStr, originBase)
        den = gmpy2.mpz(denStr, originBase)
        n, d = reduceFraction(num,den)
        print('Debug trans rat ',num,den, n, d)
        r = Rational()
        r.calc(n,d,destBase)
        return str(r)

    @Slot('QVariant','int','int',result='QVariant')
    def translateFraction(self, fStr, originBase=10, destBase=2):
        r = transFract(fStr, originBase, destBase)
        print('Debug translate fraction ',repr(r),r)
        return str(r)
