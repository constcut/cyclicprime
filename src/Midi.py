from PySide2.QtCore import Qt, Slot, Signal, QObject
from PySide2.QtQml import qmlRegisterType

class MidiWriter(QObject):
    def __init__(self,parent=None):
        QObject.__init__(self,parent)

    def startNewFile(self, tempo) :
        from midiutil import MIDIFile
        self._track    = 0
        self._channel  = 0
        self._time     = 0   # In beats
        self._tempo    = tempo  # In BPM
        self._volume   = 100 # 0-127, as per the MIDI standard
        self.midiFile = MIDIFile(1) # One track, defaults to format 1 (tempo track)
        self.midiFile.addTempo(self._track,self._time, self._tempo)
                            
    def addNote(self, pitch, duration) :
        self.midiFile.addNote(self._track, self._channel, pitch, self._time, duration, self._volume);
        self._time += duration

    def saveToFile(self, filename) :
        with open(filename, "wb") as output_file:
            self.midiFile.writeFile(output_file)
        print("Midi saved to file", filename)



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
        print('Not enough arguments, -midi num denom numericSystem [all/else] [local/sum/')
        return

    buildAllRationals = False
    if len(argv) > 5:
        if argv[5] == 'all':
            buildAllRationals = True

    localMode = True
    diffMode = False
    sumMode = False
    fileTail = ""
    if len(argv) > 6:
        fileTail = argv[6]
        if argv[6] == "sum":
            sumMode = True
            localMode = False
        if argv[6] == "diff":
            diffMode = True
            localMode = False
        

    from Midi import MidiWriter
    from Rational import Rational
    m = MidiWriter()
    m.startNewFile(150)

    

    if buildAllRationals == True:
        for repeats in range(3):
            for start in range(1, denom):
                r = Rational()
                r.calc(start, denom, numericSystem)
                d = r.digits("fract")
                lastValue = 0
                sum = 0
                for value in d:
                    diff = lastValue - value
                    sum += value
                    if localMode == True:
                        print("localNote")
                        midiNote = 36 + int(value)
                    if sumMode == True:
                        print("SumNote")
                        midiNote = 36 + (sum % 24)
                    if diffMode == True:
                        print("DiffMode")
                        midiNote = 48 + diff
                    m.addNote(midiNote, 0.5)

        filename =  str(numericSystem) + "_full_" + str(denom) +  fileTail + ".midi"
    else:
        for repeats in range(3):
            r = Rational()
            r.calc(num, denom, numericSystem)
            d = r.digits("fract")
            lastValue = 0
            sum = 0
            for value in d:
                diff = lastValue - value
                sum += value
                if localMode == True:
                    print("localNote")
                    midiNote = 36 + int(value)
                if sumMode == True:
                    print("SumNote")
                    midiNote = 36 + (sum % 24)
                if diffMode == True:
                    print("DiffMode")
                    midiNote = 48 + diff
                m.addNote(midiNote, 0.5)
        filename =  str(numericSystem) + "_single_" + str(num)  + "_" + str(denom) +  fileTail +  ".midi"
    m.saveToFile(filename)
    print('done midi actions')


    def generateMidi(allMode=True, num=1, denom, noteMode)