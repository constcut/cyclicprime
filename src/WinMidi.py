#This file works only for MS Windows - so shouldn't be imported on other platforms

from ctypes import c_buffer, windll
from sys import getfilesystemencoding


def printErrorCode(errorCode):
    if errorCode != 0:
        print("MIDI winmm error!")
        errorBuffer = c_buffer(255)
        windll.winmm.mciGetErrorStringA(errorCode, errorBuffer, 254)
        print(errorCode, errorBuffer)


def playMidiFile(filename):
    buf = c_buffer(255)
    filesystemencoding = getfilesystemencoding()
    closeCommand = 'close testX'
    openCommand = 'open ' + filename + ' type sequencer alias testX'
    playCommand = 'play testX wait'
    stopCode = int(windll.winmm.mciSendStringA(closeCommand.encode(filesystemencoding), buf, 254, 0))
    if stopCode = 263:
        printErrorCode(stopCode)
    printErrorCode(int(windll.winmm.mciSendStringA(openCommand.encode(filesystemencoding), buf, 254, 0)))
    printErrorCode(int(windll.winmm.mciSendStringA(playCommand.encode(filesystemencoding), buf, 254, 0)))
   