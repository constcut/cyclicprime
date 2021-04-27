text_type = str

from PySide2.QtQuick import QQuickPaintedItem
from PySide2.QtGui import QPen, QPainter, QColor, QBrush
from PySide2.QtCore import Property, Signal, Slot, QTimer, Qt, QObject, SIGNAL, SLOT
from PySide2.QtQml import qmlRegisterType
from math import sin, cos

from PySide2.QtQml import QJSValue


def registerQMLTypes():
    qmlRegisterType(DigitalCircle,'Athenum',1,0,'DigitalCircle')
    qmlRegisterType(DigitalCircleList,'Athenum',1,0,'DigitalCircleList')


def getQMLTypes():
    theTypes = ['DigitalCircle','DigitalCircleList']
    return theTypes

class DigitalCircleList(QQuickPaintedItem):
    def __init__(self,parent=None):
        QQuickPaintedItem.__init__(self,parent)
        self._circles = []
        self._timer = QTimer()
        QObject.connect(self._timer, SIGNAL('timeout()'), self, SLOT('requestSpecialUpdate()'))
        self._speedRatio = 1.0
        self._timerInterval = 25 * self._speedRatio
        self._label = ''

    @Slot('QString')
    def setLabel(self, newLabel):
        self._label = newLabel

    @Slot(result='QString')
    def exportJson(self):
        jsonString = '{"circles": ['
        totalCount = 0
        for c in self._circles:
            expStr = c.exportJson()
            totalCount += 1
            if totalCount < len(self._circles):
                jsonString += expStr + ","
            else:
                jsonString += expStr
        jsonString += "]}"
        return jsonString

    @Slot('QString')
    def importJson(self, jsonString):
        self._circles.clear()
        import json
        j = json.loads(jsonString.replace("'","\""))
        if "label" in j:
            self._label = str(j["label"])
        if "circles" in j:
            circles = j["circles"] 
            for c in circles:
                print(str(c).replace("'","\""), " - circle import")
                newC = DigitalCircle()
                newC.importJson(str(c).replace("'","\""))
                self._circles.append(newC)
        else:
            c = DigitalCircle()
            c.importJson(jsonString)
            self._circles.append(c)

        self.update()

    @Slot()
    def reset(self):
        self._circles = []
        self.update()

    @Slot('QVariant',int, bool, bool, 'QColor')
    def add(self, digitsList, scale, cycleFlag, oroborusFlag, dotColor):
       c = DigitalCircle()
       c.set(digitsList, scale, cycleFlag, oroborusFlag)
       c.setDotColor(dotColor)
       self._circles.append(c)
       self.update()

    @Slot(result='int')
    def size(self):
        return len(self._circles)

    @Slot(int)
    def remove(self, index):
        c = self._circles.pop(index)
        self.update()

    def paint(self, painter):
        painter.drawText(10, 210, self._label)
        if len(self._circles) == 0:
            return
        for c in self._circles:
            c.paintWithoutNotation(painter)
        self._circles[0].drawNotation(painter)

    @Slot(float)
    def setSpeedRatio(self, newRate):
        self._speedRatio = newRate
        self._timerInterval = 25 * self._speedRatio
        self._timer.setInterval(self._timerInterval)

    @Slot()
    def startAnimation(self):

        if len(self._circles) == 0:
            return

        for c in self._circles:
            if len(c._digitsList) == 0:
                continue
            c.prepareAnimation()
        self._timer.setInterval(self._timerInterval)
        self._timer.start()

    @Slot()
    def requestSpecialUpdate(self):
        for c in self._circles:
            c.requestSpecialUpdateSafe()
        self.update()


class DigitalCircle(QQuickPaintedItem):
    def __init__(self,parent=None):
        QQuickPaintedItem.__init__(self,parent)
        self._oroborusFlag = True 
        self._cycleFlag = True
        self._radius = 100
        self._borderOffset = 15
        self._digitsList = []
        self._scale = 0 
        self._posX = 0
        self._posY = 0
        self._speedRatio = 1.0
        self._timerInterval = 25 * self._speedRatio
        self._animationIndex = 0
        self._timer = QTimer() 
        QObject.connect(self._timer, SIGNAL('timeout()'), self, SLOT('requestSpecialUpdate()'))
        self._dotColor = QColor(Qt.green)
        self._lineWidth = 1
        self._lineColor = QColor(Qt.black)

    @Slot(result='QString')
    def exportJson(self):
        from PySide2.QtCore import QJsonDocument, QByteArray, QJsonArray
        jDoc = QJsonDocument()
        jObj = dict()
        if self._oroborusFlag == False:
            jObj["oroborusFlag"] = self._oroborusFlag
        if self._cycleFlag == False:
            jObj["cycleFlag"] = self._cycleFlag
        if self._radius != 100:
            jObj["radius"] = self._radius
        if self._speedRatio != 1.0:
            jObj["speedRatio"] = self._speedRatio
        if self._lineWidth != 1:
            jObj["lineWidth"] = self._lineWidth
        digitsArray = QJsonArray()
        for d in self._digitsList:
            digitsArray.append(int(d))
        jObj["digits"] = digitsArray
        jObj["scale"] = self._scale

        if self._dotColor !=  QColor(Qt.green):
            jObj["dotColor"] = self._dotColor.name()
        if self._lineColor !=  QColor(Qt.black):
            jObj["lineColor"] = self._lineColor.name()
        jDoc.setObject(jObj)
        jsonString = jDoc.toJson(QJsonDocument.Compact).data().decode()
        return jsonString


    @Slot('QString')
    def importJson(self, jsonString):
        import json
        jObj = json.loads(jsonString)
        if "oroborusFlag" in jObj:
            self._oroborusFlag = jObj["oroborusFlag"]
        else:
            self._oroborusFlag = True
        if "cycleFlag" in jObj:
            self._cycleFlag = jObj["cycleFlag"]
        else:
            self._cycleFlag = True
        if "radius" in jObj:
            self._radius = jObj["radius"]
        else:
            self._radius = 100
        if "speedRatio" in jObj:
            self._speedRatio = jObj["speedRatio"]
        else:
            self._speedRatio = 1.0
        if "lineWidth" in jObj:
            self._lineWidth = jObj["lineWidth"]
        else:
            self._lineWidth = 1
        if "dotColor" in jObj:
            self._dotColor = QColor(jObj["dotColor"])
        else:
            self._dotColor = QColor(Qt.green)
        if "lineColor" in jObj:
            self._lineColor = QColor(jObj["lineColor"])
        else:
            self._lineColor = QColor(Qt.green)
        try:
            self._digitsList = jObj["digits"]
            self._scale = int(jObj["scale"])
        except:
            print("failed to load digits: ", jObj)
        self.update()


    @Slot(float)
    def setSpeedRatio(self, newRate):
        self._speedRatio = newRate
        self._timerInterval = 25 * self._speedRatio
        self._timer.setInterval(self._timerInterval)

    @Slot('QColor')
    def setDotColor(self, newColor):
        self._dotColor = newColor

    @Slot('QColor')
    def setLineColor(self, newColor):
        self._lineColor = newColor

    @Slot(int)
    def setLineWidth(self, newLineWidth):
        self._lineWidth = newLineWidth

    @Slot('QVariant',int, bool, bool)
    def set(self, digitsList, scale, cycleFlag, oroborusFlag):
        if type(digitsList) is QJSValue:
            digitsList = digitsList.toVariant()
        self._digitsList = digitsList
        self._scale = scale
        self._cycleFlag = cycleFlag
        self._oroborusFlag = oroborusFlag
        self.update()

    def paint(self, painter):
        brushBackup = painter.brush()
        self.paintWithoutNotation(painter)
        self.drawNotation(painter)
        painter.setBrush(brushBackup)

    def paintWithoutNotation(self, painter):
        brushBackup = painter.brush()
        penBackup = painter.pen()
        localPen = QPen(self._lineColor)
        localPen.setWidth(self._lineWidth)
        painter.setPen(localPen)
        painter.drawEllipse(self._borderOffset, self._borderOffset, self._radius*2,self._radius*2)
        if self._scale == 0 or len(self._digitsList) == 0:
            return
        for i in range(1, len(self._digitsList)):
            prevDigit = self._digitsList[i-1]
            currentDigit = self._digitsList[i]
            self.drawLine(painter, prevDigit, currentDigit)
        if self._cycleFlag:
            firstDigit = self._digitsList[0]
            lastDigit = self._digitsList[-1]
            self.drawLine(painter, lastDigit, firstDigit)
        painter.setBrush(self._dotColor)
        painter.drawEllipse(self._radius - self._posX + self._borderOffset - 10/2, self._radius - self._posY + self._borderOffset - 10/2, 10, 10)
        painter.setBrush(brushBackup)
        painter.setPen(penBackup)

    def drawLine(self, painter, start, end):
        scale = self._scale
        radius = self._radius
        if self._oroborusFlag == True:
            scale -= 1
        degree1 = (scale - start) * 360.0 / scale
        y1 = radius * cos(degree1 * 3.14159265 / 180.0)
        x1 = radius * sin(degree1 * 3.14159265 / 180.0)
        degree2 = (scale - end) * 360.0 / scale
        y2 = radius * cos(degree2 * 3.14159265 / 180.0)
        x2 = radius * sin(degree2 * 3.14159265 / 180.0)
        radius += self._borderOffset 
        painter.drawLine(radius-x1, radius-y1, radius-x2, radius-y2)


    def drawNotation(self, painter):
        if len(self._digitsList) == 0:
            return

        scale = self._scale
        radius = self._radius
        if self._oroborusFlag == True:
            scale -= 1
        for i in range(0, scale):
            degree = (scale - i) * 360.0 / scale
            x = radius * sin(degree * 3.14159265 / 180.0)
            y = radius * cos(degree * 3.14159265 / 180.0)
            xWide = (radius + 12) * sin(degree * 3.14159265 / 180.0)
            yWide = (radius + 12) * cos(degree * 3.14159265 / 180.0)
            painter.drawEllipse(radius - x + self._borderOffset, radius - y + self._borderOffset, 3, 3)

            if self._digitsList[0] == i or self._digitsList[-1] == i:
                if self._digitsList[0] == i:
                    painter.setBrush(Qt.white)
                else:
                    painter.setBrush(Qt.black)
                painter.drawEllipse(radius - x + self._borderOffset - 10/2, radius - y + self._borderOffset - 10/2, 10, 10)

            if i == 0 and self._oroborusFlag == True:
                digitText = str(scale)
            else:
                digitText = str(i)
            painter.drawText(radius - xWide + self._borderOffset - 12/2, radius - yWide + self._borderOffset - 12/2, 20, 20, 0, digitText)




    def tracePositions(self, x1, y1, x2, y2, steps):
        result = []
        deltaX = x2-x1
        deltaY = y2-y1
        stepX = deltaX / steps
        stepY = deltaY / steps
        for s in range(0, steps):
            anotherPosition = [x1 + stepX*s, y1 + stepY*s]
            result.append(anotherPosition)
        return result


    def prepareAnimation(self):
        scale = self._scale
        radius = self._radius
        if self._oroborusFlag == True:
            scale -= 1
        stepsBetweenNodes = 20
        digitsPositions = []
        for digit in self._digitsList:
            degree = (scale - digit) * 360.0 / scale
            x = radius * sin(degree * 3.14159265 / 180.0)
            y = radius * cos(degree * 3.14159265 / 180.0)
            anotherPosition = [x,y]
            digitsPositions.append(anotherPosition)
        traces = []
        for i in range(0, len(digitsPositions)-1):
            x1 = digitsPositions[i][0] 
            y1 = digitsPositions[i][1]
            x2 = digitsPositions[i+1][0]
            y2 = digitsPositions[i+1][1]
            anotherTrace = self.tracePositions(x1,y1,x2,y2,stepsBetweenNodes)
            traces.extend(anotherTrace)
        x1 = digitsPositions[-1][0]
        y1 = digitsPositions[-1][1]
        x2 = digitsPositions[0][0]
        y2 = digitsPositions[0][1]
        anotherTrace = self.tracePositions(x1,y1,x2,y2,stepsBetweenNodes)
        traces.extend(anotherTrace)
        self._animationTrace = traces

    @Slot()
    def startAnimation(self):
        if len(self._digitsList) == 0:
            return
        self.prepareAnimation()
        self._timer.setInterval(self._timerInterval) 
        self._timer.start()


    @Slot()
    def requestSpecialUpdate(self):
        self.requestSpecialUpdateSafe()
        self.update()

    @Slot()
    def requestSpecialUpdateSafe(self):
        newX = self._animationTrace[self._animationIndex][0]
        newY = self._animationTrace[self._animationIndex][1]
        self._posX = newX
        self._posY = newY
        self._animationIndex += 1
        if self._animationIndex >= len(self._animationTrace):
            self._animationIndex = 0


    @Slot()
    def stopAnimation(self):
        self._timer.stop()
        self.resetAnimation()

    @Slot()
    def pauseAnimation(self):
        self._timer.stop()

    @Slot(result='bool')
    def animationIsRunning(self):
        return self._timer.isActive()

    @Slot()
    def resetAnimation(self):
        self._animationIndex = 0


    @Slot(int)
    def setRadius(self, newRadius):
        self._radius = newRadius
        self.update()
    def getRadius(self):
        return self._radius

    def setBorderOffset(self, newBorderOffset):
        self._borderOffset = newBorderOffset
        self.update()
    def getBorderOffset(self):
        return self._borderOffset

    radius = Property(int, getRadius, setRadius)
    borderOffset = Property(int, getBorderOffset, setBorderOffset)


