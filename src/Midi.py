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
        print("Saved to file", filename)


