import sys, os
from PySide2.QtGui import QGuiApplication
from PySide2.QtCore import Property, Signal, QUrl, QObject, QDir, Slot, QFile, QIODevice, QCryptographicHash, QByteArray
from PySide2.QtQml import qmlRegisterType, QQmlContext, QQmlApplicationEngine, QQmlEngine
from PySide2.QtQuick import QQuickView
import importlib
import platform


def consoleMode(argv): 
    P = 7
    if len(argv) > 2:
        print("Argv[2]: Prime = ", argv[2])
        P = int(argv[2])
    if len(argv) > 3:
        print("Argv[3]: NumericSystem = ", argv[3])
        NS = int(argv[3])
        from CyclicPrimes import CyclicPrimes
        c = CyclicPrimes()
        c.setDigitsToCheck(500) #amount of digits to search
        primes = c.find(P,NS,"full")
        for p in primes:
            print("Found prime with ", len(str(p)), " digits ", p)
    else:
        from CyclicPrimes import checkCyclicPrimes
        checkCyclicPrimes(P)
                    
    

def athenumModuleImport(moduleName):
    module = importlib.import_module(moduleName)
    module.registerQMLTypes()
    return module

def athenumEngineStart():
    app = QGuiApplication(sys.argv)
    athenumInfo = AthenumInfo()

    if len(sys.argv) > 1:
        if sys.argv[1] == '-platform' and sys.argv[2].find('webgl') != -1:
            print("Starting WebGl mode")
            athenumInfo.setWebGL()
        if sys.argv[1] == '-c':
            print("Console mode activated")
            consoleMode(sys.argv)
            sys.exit(0)

    app.setApplicationName("Full reptend prime & cyclic prime numbers")
    engine = QQmlApplicationEngine()
    platformName = platform.system()
    print('Platform name is',platformName)
    from Rational import Rational
    qmlRegisterType(Rational, 'Athenum', 1,0, 'Rational') 
    athenumModuleImport("SumModels")
    athenumModuleImport("DigitalCircle")
    athenumModuleImport("PrimeScales")
    athenumModuleImport("IntervalScales")
    athenumModuleImport("CyclicPrimes")
    athenumModuleImport("Primes")
    athenumModuleImport("GeometricProgression")
    athenumModuleImport("NumericSystem")
    copyClipboard = CopyClipboard()
    engine.rootContext().setContextProperty("athenumInfo",athenumInfo)
    engine.rootContext().setContextProperty("copyClipboard",copyClipboard)
    engine.load('qml/athenum.qml')
    print("Starting viewer")
    res = app.exec_()
    del engine
    sys.exit(res)




class AthenumInfo (QObject): 
    def __init__(self, parent = None):
        QObject.__init__(self, parent)
        self._path = QDir.currentPath()
        self._OS = str("linux")
        self._webGL = False
    @Slot(result='QString')
    def getQMLPath(self):
        return QDir.cleanPath(self._path  + '/qml')
    @Slot(result='QString')
    def getPath(self):
        return self._path
    @Slot(result='QString')
    def getOS(self):
        return self._OS
    @Slot(str,result='QString')
    def cutShortURL(self, sourceURL):
        replaceString = str("file:///") + self._path + '/qml'
        sourceURL = sourceURL.replace(replaceString,"%app%")
        return sourceURL
    @Slot(str,result='QString')
    def extendURL(self, sourceURL):
        replaceString = str("file:///") + self._path + '/qml'
        sourceURL = sourceURL.replace("%app%",replaceString)
        return sourceURL
    @Slot(str,result='QString')
    def cutAppPath(self, sourceURL):
        replaceString = str("file:///") + self._path + '/qml'
        sourceURL = sourceURL.replace(replaceString,"")
        return sourceURL
    @Slot(result='QVariant')
    def isWebGl(self):
        return self._webGL
    def setWebGL(self):
        self._webGL = True

    @Slot(str,result='QString')
    def md5fromFile(self, filename):
        filename = filename.replace("file:///","")
        filename = filename.replace("file://","") #dirty trick for both os
        file = QFile(filename)
        file.open(QIODevice.ReadOnly)
        hash = QCryptographicHash(QCryptographicHash.Md5)
        hash.addData(file)
        strVal = str(hash.result().toHex())
        return strVal

    def findQmlNames(self, dir, shortDir):
        resultList = []
        d = QDir("")
        d.cd(dir)
        l = d.entryList()
        for file in l:
            anotherFile = shortDir + file
            resultList.append(anotherFile)
        resultList.pop(0)
        resultList.pop(0)
        return resultList


    @Slot(result='QVariant')
    def loadQmlFilesList(self):
        pageList = self.findQmlNames("qml/pages","/pages/")
        compList = self.findQmlNames("qml/components","/components/")
        return pageList + compList

    @Slot(str, result='QVariant')
    def divideJson(self, jsonString):
        from PySide2.QtCore import QJsonDocument, QByteArray, QJsonArray
        jBytes = QByteArray(jsonString.encode())
        jDoc = QJsonDocument.fromJson(jBytes)
        jObj = jDoc.array()
        l2 = []
        for i in range(0, jObj.size()):
            l2.append(str(jObj.at(i).toObject()))
        return l2


from PySide2.QtCore import QMimeData
from PySide2.QtGui import QImage
from PySide2.QtGui import QGuiApplication
from PySide2.QtGui import QClipboard

class CopyClipboard(QObject):
    def __init__(self, parent=None):
        QObject.__init__(self,parent)

    @Slot('QString')
    def copyImageFile(self, filename):
        clipboard = QGuiApplication.clipboard()
        image = QImage(filename)
        data = QMimeData()
        data.setImageData(image)
        clipboard.setMimeData(data)

    @Slot('QVariant')
    def copyImageSrc(self, image):
        clipboard = QGuiApplication.clipboard()
        clipboard.setImage(image)

    @Slot('QString')
    def copyText(self, text):
        clipboard = QGuiApplication.clipboard()
        clipboard.setText(text)

