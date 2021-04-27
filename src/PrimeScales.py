from PySide2.QtCore import  QAbstractTableModel, QAbstractItemModel, QModelIndex, Qt, Slot, Signal, QObject, Slot
from PySide2.QtQml import qmlRegisterType
from PySide2.QtGui import QColor, QBrush

from Primes import Primes
from Rational import Rational

def registerQMLTypes():
    qmlRegisterType(PrimeScales, 'Athenum', 1,0, 'PrimeScales')
def getQMLTypes():
    theTypes = ['PrimeScales']
    return theTypes


class PrimeScales(QAbstractTableModel):
    def __init__(self,parent=None):
        QAbstractTableModel.__init__(self,parent)
        self._primesList = []
        self._rationalList = []
        self._scalesPeriods = []
        self._tableWidth = 100

    @Slot(int, result='int')
    def getPrime(self, position):
        return self._primesList[position]

    @Slot(int, int, int)
    def calculate(self, startPrime=1, endPrime=11, cellsAmount=100):
        self._tableWidth = cellsAmount
        p = Primes()
        self._primes = p
        self._primesList = p.getPrimesList(startPrime, endPrime)
        self._rationalList = []
        for localPrime in self._primesList:
            r = Rational()
            r.calc(1,localPrime)
            self._rationalList.append(r)
        self._scalesPeriods = [ r.scalesPeriod() for r in self._rationalList ]
        self.dataChanged.emit(self.index(0,0) , self.index(self.rowCount()-1, self.columnCount()-1) ,[])

    def rowCount(self, parent = QModelIndex()):
        return len(self._primesList) + 2 

    def columnCount(self, parent = QModelIndex()):
        return self._tableWidth

    def data(self, index, role = Qt.DisplayRole):

        displayClass = 0

        if not index.isValid():
            return ["",displayClass] #None
        elif role != Qt.DisplayRole:
            return ["",displayClass] #None

        row = index.row()
        column = index.column()

        if row == 0:
            if column == 0:
                return ['P', displayClass]
            elif column >= 2:
                return [column,displayClass]
        elif row == 1:
            return ['   ',displayClass]
        else:
            if column == 0:
                return [self._primesList[row-2], displayClass]
            elif column == 1:
                return ['   ', displayClass]
            else:
                localScalePeriod = self._scalesPeriods[row-2]
                primeNum = self._primesList[row-2]
                subIndex = (column-2) % len(localScalePeriod) #TODO review to make universal (any level)
                if localScalePeriod[subIndex] == primeNum - 1 :
                    displayClass = 1
                elif localScalePeriod[subIndex] == (primeNum- 1) / 2:
                    displayClass = 2
                elif localScalePeriod[subIndex] == (primeNum - 1) / 3:
                    displayClass = 3
                return [localScalePeriod[subIndex],displayClass]

        return ['   ',displayClass]
