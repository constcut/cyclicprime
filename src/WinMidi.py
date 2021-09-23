#This file works only for MS Windows - so shouldn't be imported on other platforms

from ctypes import c_buffer, windll,  c_void_p, c_int, byref
from sys import getfilesystemencoding
import threading
from time import sleep


class WindowsMidi:
    def __init__(self):
        self.winmm = windll.winmm
        self.threadObject = None
        self._playMidi = False

    def printErrorCode(self, errorCode, section = "none"):
        if errorCode != 0:
            print("MIDI winmm error! In section", section)
            errorBuffer = c_buffer(255)
            self.winmm.mciGetErrorStringA(errorCode, errorBuffer, 254)
            print(errorCode, errorBuffer)


    def playMidiThreadFun(self, filename):
        buf = c_buffer(255)
        filesystemencoding = getfilesystemencoding()
        closeCommand = 'close testX'
        openCommand = 'open ' + filename + ' type sequencer alias testX' 
        playCommand = 'play testX'
        stopCode = int(self.winmm.mciSendStringA(closeCommand.encode(filesystemencoding), buf, 254, 0))
        if stopCode == 263:
            self.printErrorCode(stopCode, "close")
        self.printErrorCode(int(self.winmm.mciSendStringA(openCommand.encode(filesystemencoding), buf, 254, 0)), "open")
        self.printErrorCode(int(self.winmm.mciSendStringA(playCommand.encode(filesystemencoding), buf, 254, 0)), "play")
        
        while (self._playMidi == True):
            sleep(0.05)
        closeCommand = 'stop testX'
        stopCode = int(self.winmm.mciSendStringA(closeCommand.encode(filesystemencoding), 0, 0, 0))
        self.printErrorCode(stopCode, "stop all")
        closeCommand = 'close ALL'
        stopCode = int(self.winmm.mciSendStringA(closeCommand.encode(filesystemencoding), 0, 0, 0))
        self.printErrorCode(stopCode, "stop all")


    def playMidiFile(self, filename):
        if self._playMidi:
            self._playMidi = False
            sleep(0.1)
        self.threadObject = threading.Thread(target=self.playMidiThreadFun, args=(filename,))
        self._playMidi = True
        self.threadObject.start()
   

    def stopMidi(self):
        if self._playMidi:
            self._playMidi = False
            sleep(0.1)
