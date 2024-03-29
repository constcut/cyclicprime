import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.12
import QtQuick.Dialogs

Item {
    id: musicFromFractions

    property string athName: "MusicFromFractions"

    Midi {
        id: midiManager
    }

    Component.onDestruction :{
        midiManager.stop()
    }

    /*
    Slider {
        id: ratio
        from: 2
        to: 100
        value: 100
        stepSize: 1
        y: 20
        x: 0
        width: parent.width/4
        onValueChanged: {
            updateTimer.restart()
        }
        ToolTip {
            parent: ratio.handles
            visible: ratio.hovered 
            text: 'Scale ratio: ' + ratio.value
        }
    }*/

    TextField {
        id: numerator
        y: 20
        x: 5
        width: 70
        placeholderText: "numerator"
        text: "1"

        ToolTip {
            parent: numerator.handles
            visible: numerator.hovered 
            text: 'Numerator: ' + numerator.text
        }
    }

    TextField {
        id: denominator
        y: 20
        x: numerator.x + numerator.width + 10
        width: 70
        placeholderText: "denominator"
        text: "7"
        ToolTip {
            parent: denominator.handles
            visible: denominator.hovered 
            text: 'Denominator: ' + denominator.text
        }
    }

    TextField {
        id: numericSystem
        y: 20
        x: denominator.x + denominator.width + 10
        width: 70
        placeholderText: "Num sys"
        text: "24"

        ToolTip {
            parent: numericSystem.handles
            visible: numericSystem.hovered 
            text: 'Numeric system: ' + numericSystem.text
        }
    }

    TextField {
        id: startMidi
        y: 20
        x: numericSystem.x + numericSystem.width + 10
        width: 70
        placeholderText: "Start Note"
        text: "36"
        ToolTip {
            parent: startMidi.handles
            visible: startMidi.hovered 
            text: 'Start MIDI note: ' + startMidi.text
        }
    }


    TextField {
        id: modValue
        y: 20
        x: startMidi.x + startMidi.width + 10
        width: 70
        placeholderText: "Mod value"
        text: "24"
        ToolTip {
            parent: modValue.handles
            visible: modValue.hovered 
            text: 'Mod value: ' + modValue.text 
        }
    }

    TextField {
        id: rhythmList
        y: 20
        x: modValue.x + modValue.width + 10
        width: 70
        placeholderText: "rhy list"
        text: "0.5"
        ToolTip {
            parent: rhythmList.handles
            visible: rhythmList.hovered 
            text: 'Rhythm list: ' + rhythmList.text
        }
    }

    CheckBox {
        id: fullSequence
        y: 20
        x: rhythmList.x + rhythmList.width + 10
        width: 130
        text: "All rationals"
        checked: true
    }

    ComboBox {
        id: typeCombo
        y: 20
        x: fullSequence.x + fullSequence.width + 10
        width: 100
        model : ["local", "sum", "diff", "all"]
    }


    TextField {
        id: tempoValue
        y: 20
        x: typeCombo.x + typeCombo.width + 20
        width: 70
        placeholderText: "tempo"
        text: "150"
        ToolTip {
            parent: tempoValue.handles
            visible: tempoValue.hovered 
            text: 'Tempo bpm: ' + tempoValue.text
        }
    }

    TextField {
        id: repeatsValue
        y: 20
        x: tempoValue.x + tempoValue.width + 20
        width: 70
        placeholderText: "repeats"
        text: "4"
        ToolTip {
            parent: repeatsValue.handles
            visible: repeatsValue.hovered 
            text: 'Repeats: ' + repeatsValue.text
        }
    }

    Button {
        id: playButton
        y: 20
        x: repeatsValue.x + repeatsValue.width + 10
        text: "Play"
        onClicked: {
            midiManager.stop() //To insure file access released
            midiManager.generateMidiFileFromRational(denominator.text, numericSystem.text,
            typeCombo.currentText, fullSequence.checked, numerator.text, tempoValue.text,
            repeatsValue.text, modValue.text, rhythmList.text, "")
            midiManager.playLastFile()
            scalesNames.text = midiManager.getLastScales()
            intervalsTypes.text = midiManager.getLastIntervals()
            rational.calc(numerator.text, denominator.text, numericSystem.text)
            var digits = rational.digits('fract',0)
            //circle2.add(digits, numericSystem, true, parseInt(denominator) > parseInt(numericSystem)), "green")
        }
    }

    Text {
        id: scalesNames
        y: playButton.y + playButton.height + 10
        x: playButton.x
        text: "Names of possible scales"
    }

    Text {
        id: intervalsTypes
        y: scalesNames.y + scalesNames.height + 10
        x: playButton.x
        text: "Types of intervals"
    }

    Button {
        id: stopButton
        y: 20
        x: playButton.x + playButton.width + 10
        text: "Stop"
        onClicked: {
            midiManager.stop()
        }
    }

    Item {
        id: dialogItem
        FileDialog {
            id: fileDialog
            title: "Save midi file"
            //folder: shortcuts.desktop
            onAccepted: {
                var filename = fileDialog.fileUrls.toString().substr(8)
                midiManager.stop() //To insure file access released
                midiManager.generateMidiFileFromRational(denominator.text, numericSystem.text,
                typeCombo.currentText, fullSequence.checked, numerator.text, tempoValue.text,
                repeatsValue.text, modValue.text, rhythmList.text, filename)
            }
            nameFilters: [ "MIDI files (*.midi *.mid)", "All files (*)" ]
            //selectExisting: false
            visible: false
        } 
    }

    Button {
        y: 20
        x: parent.width - width - 10
        text: "Save midi"
        onClicked: {
            fileDialog.visible = true
        }
    }
}
