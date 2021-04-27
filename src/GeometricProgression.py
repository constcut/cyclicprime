from Rational import Rational
from PySide2.QtCore import Qt, Slot, Signal, QObject
from PySide2.QtQml import qmlRegisterType
def registerQMLTypes():
    qmlRegisterType(GeometricProgression, 'Athenum', 1,0, 'GeometricProgression')
def getQMLTypes():
    theTypes = ['GeometricProgression']
    return theTypes


class GeometricProgression(QObject):
    def __init__(self,parent=None):
        QObject.__init__(self,parent)

    @Slot('int','int','int')
    def set(self, first=14, inc=2, dec=100):
        self._firstStep = first
        self._increseCoef = inc
        self._decreaseCoef = dec

    @Slot(result='QVariant')
    def getInc(self):
        return self._increseCoef

    @Slot(result='QVariant')    
    def getDec(self):
        return self._decreaseCoef

    @Slot(result='QVariant')    
    def getFirst(self):
        return self._firstStep

    @Slot(result='QVariant')
    def getQ(self):
        return self._increseCoef / self._decreaseCoef

    @Slot(result='QVariant')
    def firstElement(self):
        return self._firstStep / self._decreaseCoef

    @Slot(result='QVariant')
    def converges(self):
        if self.getQ() < 1.0: return True
        return False

    @Slot('int',result='QVariant')
    def countAt(self, n=0):
       nom = self._firstStep * (self._increseCoef ** n)
       den = self._decreaseCoef ** (n+1)
       result = Rational()
       result.calc(nom,den)
       return result

    @Slot('QVariant',result='QVariant')
    def sumAt(self,n):
        n += 1
        sum = self.countAt(0)
        for i in range(1,n):
            newSum = sum + self.countAt(i)
            sum = newSum
        return sum

    @Slot(result='QVariant')
    def fullSum(self):
       sum = (self._firstStep / self._decreaseCoef) / (1.0 - self._increseCoef/self._decreaseCoef)
       return sum

    @Slot(result='QVariant')
    def rationalSum(self):
       den = Rational()
       den.calc(self._firstStep, self._decreaseCoef)
       num = Rational()
       num.calc(self._decreaseCoef-self._increseCoef, self._decreaseCoef)
       sum = den/num
       return sum

    @Slot(result='QVariant')
    def rSumQML(self):
       r = self.rationalSum()
       result = [str(r._num),str(r._den),str(r._scaleOfNotation), r.__str__()]
       return result

    @Slot('int',result='QVariant')
    def rElementQML(self,n=0):
        r = self.countAt(n)
        result = [str(r._num),str(r._den),str(r._scaleOfNotation), r.__str__()]
        return result

    @Slot('int',result='QVariant')
    def reducedElementQML(self,n=0):
        r = self.countAt(n)
        r.reduce()
        result = [str(r._num),str(r._den),str(r._scaleOfNotation), r.__str__()]
        return result
