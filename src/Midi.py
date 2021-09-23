from PySide2.QtCore import Qt, Slot, Signal, QObject
from PySide2.QtQml import qmlRegisterType
import platform

def midiMode(argv):
    num = 1
    denom = 7
    numericSystem = 24
    if len(argv) > 4:
        print("Argv[2]: num = ", argv[2])
        print("Argv[3]: denom = ", argv[3])
        print("Argv[4]: numericSystem = ", argv[4])
        num = int(argv[2])
        denom = int(argv[3])
        numericSystem = int(argv[4])
    else:
        print('Not enough arguments, -midi num denom numericSystem [all/else] [local/sum/diff]')
        return
    buildAllRationals = False
    if len(argv) > 5:
        if argv[5] == 'all':
            buildAllRationals = True
    mode = "local"
    if len(argv) > 6:
        mode = argv[6]
    modulus = 24
    generateMidiFile(denom, numericSystem, mode, buildAllRationals, num)
    

ionianScale = {0:1, 2:1, 4:1, 5:1, 7:1, 9:1, 11:1}
miksolidianScale = {0:1, 2:1, 4:1, 5:1, 7:1, 9:1, 10:1}
dorianScale = {0:1, 2:1, 3:1, 5:1, 7:1, 9:1, 10:1}
eolianScale = {0:1, 2:1, 3:1, 5:1, 7:1, 8:1, 10:1}
frigianScale = {0:1, 1:1, 3:1, 5:1, 7:1, 8:1, 10:1}
lokrianScale = {0:1, 1:1, 3:1, 5:1, 6:1, 8:1, 10:1}
lidianScale = {0:1, 2:1, 4:1, 6:1, 7:1, 9:1, 11:1}

ionianSharp = {0:1, 1:1, 3:1, 5:1, 6:1, 8:1, 10:1}
miksolidianSharp = {1:1, 3:1, 5:1, 6:1, 8:1, 10:1, 11:1}
dorianSharp = {1:1, 3:1, 4:1, 6:1, 8:1, 10:1, 11:1}
eolianSharp = {1:1, 3:1, 4:1, 6:1, 8:1, 9:1, 11:1}
frigianSharp = {1:1, 2:1, 4:1, 6:1, 8:1, 9:1, 11:1}
lokrianSharp = {1:1, 2:1, 4:1, 6:1, 7:1, 9:1, 11:1}
lidianSharp = {0:1, 1:1, 3:1, 5:1, 7:1, 8:1, 10:1}

scales = {"ionianScale":ionianScale, "miksolidianScale":miksolidianScale, "dorianScale":dorianScale,
"eolianScale":eolianScale, "frigianScale": frigianScale, "lokrianScale":lokrianScale,"lidianScale":lidianScale,
"ionianSharp":ionianSharp, "miksolidianSharp":miksolidianSharp, "dorianSharp":dorianSharp,
"eolianSharp":eolianSharp, "frigianSharp": frigianSharp, "lokrianSharp":lokrianSharp,"lidianSharp":lidianSharp}


def checkForScale(notesDict):
    listOfScales = []
    for scaleName, scaleDict in scales.items():
        scaleIsFine = True
        for key, value in notesDict.items():
            if scaleDict.get(key) == None:
                scaleIsFine = False
                break
        if scaleIsFine:
            listOfScales.append(scaleName)
    #print(listOfScales)
    return listOfScales


intervalsCons = {0:"perfect", 1: "dis", 2: "dis", 3: "unperfect", 4: "unperfect",
5: "almost", 6: "dis", 7: "almost", 8: "unperfect", 9: "unperfect", 10: "dis", 11: "dis"}


def checkConsonanse(intervalsDict):
    intervalsSet = set()
    for interval, count in intervalsDict.items():
        interval = abs(interval)
        while interval > 12 :
            interval -= 12
        intervalsSet.add(intervalsCons[interval])
    return intervalsSet


def addNotesFromDigits(digits, mode, modulus, midiWriter, duration=0.5, midiStart=36): #TODO add mode let ring like effect
    lastValue = 0
    sum = 0
    prevNote = midiStart
    notesDict = dict()
    intervalsDict = dict()
    for value in digits:
        diff = lastValue - value
        sum += value
        if mode == "local":
            midiNote = midiStart + (int(value) % modulus)
        if mode == "sum":
            midiNote = midiStart + (sum % modulus)
        if mode == "diff":
            midiNote = midiStart + (diff % modulus)

        if notesDict.get(midiNote % 12) == None:
            notesDict[midiNote % 12] = 1
        else:    
            notesDict[midiNote % 12] = notesDict.get(midiNote % 12) + 1 

        if intervalsDict.get(midiNote - prevNote) == None:
            intervalsDict[midiNote - prevNote] = 1 
        else:
            intervalsDict[midiNote - prevNote] = intervalsDict.get(midiNote - prevNote) + 1

        prevNote = midiNote
        midiWriter.addNote(midiNote, duration)
    return checkForScale(notesDict), checkConsonanse(intervalsDict)


def generateMidiFile(denom, numericSystem, mode="local", buildAllRationals=False, 
                        num = 1, tempo=150,  repeats=3, modulus=24, duration=0.5, filename=""):
    from Midi import MidiWriter
    from Rational import Rational
    scalesSet = set()
    intervalsSet = set()
    m = MidiWriter()
    m.startNewFile(tempo)
    if buildAllRationals == True:
        for repeats in range(repeats):
            for start in range(1, denom):
                r = Rational()
                r.calc(start, denom, numericSystem)
                scalesList, intervals = addNotesFromDigits(r.digits("fract"), mode, modulus, m, duration) #TODO move outside repeats cycle
                scalesSet.update(scalesList)
                intervalsSet.update(intervals)
        if filename == "":
            filename =  str(numericSystem) + "_full_" + str(denom) +  mode + ".midi"
    else:
        for repeats in range(repeats):
            r = Rational()
            r.calc(num, denom, numericSystem)
            scalesList, intervals = addNotesFromDigits(r.digits("fract"), mode, modulus, m, duration) #TODO move outside repeats cycle
            scalesSet.update(scalesList)
            intervalsSet.update(intervals)
        if filename == "":
            filename =  str(numericSystem) + "_single_" + str(num)  + "_" + str(denom) +  mode +  ".midi"
    m.saveToFile(filename)
    return filename, scalesSet, intervalsSet
    


def registerQMLTypes():
    qmlRegisterType(Midi, 'Athenum', 1,0, 'Midi')
def getQMLTypes():
    theTypes = ['Midi']
    return theTypes    


class Midi(QObject):
    def __init__(self, parent=None):
        QObject.__init__(self, parent)
        if platform.system() == "Windows":
            from WinMidi import WindowsMidi
            self._winMidi = WindowsMidi()

    @Slot(result='QVariant')
    def getLastScales(self):
        return ' '.join(list(self._lastScalesSet))

    @Slot(result='QVariant')
    def getLastIntervals(self):
        return ' '.join(list(self._lastIntervalsSet))


    @Slot('int','int','QString', 'bool', 'int', 'int', 'int', 'int', 'float', 'QString', result='QString')
    def generateMidiFileFromRational(self, denom, numericSystem, mode="local", buildAllRationals=False, 
                        num = 1, tempo=150,  repeats=3, modulus=24, duration=0.5, filename=""):
        self._lastGeneratedFile, self._lastScalesSet, self._lastIntervalsSet = generateMidiFile(
            denom, numericSystem, mode, buildAllRationals, num, tempo, repeats, modulus, duration, filename)
        return self._lastGeneratedFile

    @Slot('QString')
    def playFile(self, filename):
        if platform.system() == "Windows":    
            self._winMidi.playMidiFile(filename)

    @Slot()
    def playLastFile(self):
        if self._lastGeneratedFile != None:
            self.playFile(self._lastGeneratedFile)

    @Slot()
    def stop(self):
        if platform.system() == "Windows":
            self._winMidi.stopMidi()



class MidiWriter(QObject):
    def __init__(self,parent=None):
        QObject.__init__(self,parent)


    def startNewFile(self, tempo, instrument=0) :
        from midiutil import MIDIFile
        self._track    = 0
        self._channel  = 0
        self._time     = 0   # In beats
        self._tempo    = tempo  # In BPM
        self._volume   = 100 # 0-127, as per the MIDI standard
        self.midiFile = MIDIFile(1) # One track, defaults to format 1 (tempo track)
        self.midiFile.addTempo(self._track, self._time, self._tempo)
        self.midiFile.addProgramChange(0, 0, 0, instrument)

                            
    def addNote(self, pitch, duration) :
        self.midiFile.addNote(self._track, self._channel, pitch, self._time, duration, self._volume)
        self._time += duration

    def saveToFile(self, filename) :
        with open(filename, "wb") as output_file:
            self.midiFile.writeFile(output_file)
        print("Midi saved to file", filename)



