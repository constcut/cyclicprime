from PySide2 import QtGui, QtQml, QtCore
from PySide2.QtCore import  QAbstractTableModel, QAbstractItemModel, QModelIndex, Qt, Slot, Signal, QObject, Slot
from PySide2.QtQml import qmlRegisterType
from PySide2.QtGui import QColor, QBrush

def registerQMLTypes():
    qmlRegisterType(IntervalScalesModel, 'Athenum', 1,0, 'IntervalScalesModel')
    qmlRegisterType(LogOctaves, 'Athenum', 1,0, 'LogOctaves')
def getQMLTypes():
    theTypes = ['IntervalScalesModel']
    return theTypes

class LogOctaves(QObject):
    def __init__(self,parent=None):
        QObject.__init__(self,parent)
        self._l1 = IntervalScalesModel()
        self._l1.setType(1)
        self._l2 = IntervalScalesModel()
        self._l2.setType(2)
        self._l3 = IntervalScalesModel()
        self._l4 = IntervalScalesModel()
        

    @Slot('QVariant')
    def setScaleRatio(self, ratio):
        self._l1.setScaleRatio(ratio)
        self._l2.setScaleRatio(ratio)
        self._l3.setScaleRatio(ratio)
        self._l4.setScaleRatio(ratio)
        print("Chaning scales ratio to ", ratio)
        self.calc(1000)

        
    @Slot(int)
    def calc(self, elements):
        from Octaves import calculateOctaveScales, findSequences
        scales = calculateOctaveScales(14, elements)
        intervals = [interval for scale in scales for interval in scale]
        self._l1.setData(intervals)
        scalesNums = calculateOctaveScales(14, elements, type='numbers')
        self._l2.setData(scalesNums)
        sequences, seqNames = findSequences(scalesNums)
        self._seqNames = seqNames
        seqMap = {}
        for seq, seqNum in seqNames.items():
            totalSum = 0
            for s in seq:
                if s.isdigit():
                    if int(s) == 5:
                        totalSum += 11
                    else:
                        totalSum += 12
            seqMap[seqNum] = totalSum 
        self._l3.setWidthMap(seqMap)
        self._l3.setData(sequences)
        self._l3.setType(3)
        self._l1.setWidthMap([0,1,2])
        self._l2.setWidthMap([12,12,12,12,12,11,12,12])



    @Slot(int, result='QVariant')
    def getLine(self, line):
        if line == 1:
            return self._l1
        if line == 2:
            return self._l2
        if line == 3:
            return self._l3
        if line == 4:
            return self._l4
        return None
         

class IntervalScalesModel(QAbstractTableModel):
    def __init__(self,parent=None):
        QAbstractTableModel.__init__(self,parent)
        self._data = []
        self._type = 0
        self._l = [] 
        self._elCoef = 20

    def setWidthMap(self, widthMap):
        self._widthMap = widthMap

    def setScaleRatio(self, ratio):
        self._elCoef = ratio 

    def setData(self, data):
        self._data = data

    def setType(self, type):
        self._type = type

    @Slot()
    def calc(self):
        self.dataChanged.emit(self.index(0,0) , self.index(self.rowCount()-1, self.columnCount()-1) ,[])

    @Slot(int, result='QVariant')
    def getColumnWidth(self, column):  
        if self._type >= 1 and self._type <=3:
            return self._widthMap[self._data[column]] * self._elCoef
        return 0

    def changeColumns(self,newList):
        self._l = newList
    
    def rowCount(self, parent = QModelIndex()):
        return 1

    def columnCount(self, parent = QModelIndex()):
        return len(self._data)

    def findNoteAt(self, column):
        sum = 0
        if self._type == 1:
            for i in range(0, column):
               sum += self._data[i]
        if self._type == 2:
            for i in range(0, column):
                element = self._data[i]
                if element == 5: 
                    sum += 11
                else:
                    sum += 12
        if self._type == 3:
            for i in range(0, column):
                sum += self._widthMap[self._data[i]]  
        return sum % 12
    
    def makeNoteName(self, num):
        if num == 0: 
            return "C"
        if num == 1: 
            return "C#"
        if num == 2: 
            return "D"
        if num == 3: 
            return "D#"
        if num == 4:
            return "E"
        if num == 5: 
            return "F"
        if num == 6: 
            return "F#"
        if num == 7: 
            return "G"
        if num == 8: 
            return "G#"
        if num == 9: 
            return "A"
        if num == 10: 
            return "A#"
        if num == 11:
            return "B"
        return "W!"

    def mapColor(self, value):
        if value == 0:
            return QColor(255, 0, 0)
        if value == 1:
            return QColor(255, 128, 0)
        if value == 2:
            return QColor(255, 255, 0)
        if value == 3:
            return QColor(0, 255, 0)
        if value == 4:
            return QColor(0, 255, 128)
        if value == 5:
            return QColor(0, 0, 255)
        if value == 6:
            return QColor(0, 255, 255)
        if value == 7:
            return QColor(255, 255, 255)

    def data(self, index, role = Qt.DisplayRole):
        if not index.isValid():
            return None
        elif role != Qt.DisplayRole:
            return None
        row = index.row()
        column = index.column()
        realIndex = column + row
        mainValue = 0
        if len(self._data) > 0:
            mainValue = self._data[realIndex] 
        noteName = ''
        if self._type == 1 or self._type == 2 or self._type == 3:
            noteId = self.findNoteAt(realIndex)
            noteName = self.makeNoteName(noteId)
        sectionName = ''
        if self._type == 2:
            from Octaves import getScaleNameByNumber
            sectionName = getScaleNameByNumber(mainValue)
        color = self.mapColor(mainValue)
        return ['name', mainValue, noteName, sectionName, color]



