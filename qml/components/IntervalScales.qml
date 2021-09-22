import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.12
import QtQuick.Dialogs 1.3

Item {
    id: autoSumItem

    property string athName: "IntervalsScales"
    property int prime: 7

    LogOctaves {
        id: logOctaves
    }


    Component.onCompleted:{
        updateTimer.running = true
    }

    Timer {
          id:updateTimer
          interval: 200; running: false; repeat: false
          onTriggered: {
              intervalsTable1.model = undefined
              intervalsTable2.model = undefined
              intervalsTable3.model = undefined
              intervalsTable4.model = undefined
              logOctaves.setBaseNumber(baseNumber.text)
              logOctaves.setNumberElements(scalesCount.text)
              //logOctaves.setMultiplyFactor(multiplyNumber.currentText) //pentatonic requres rework
              logOctaves.setScaleRatio(ratio.value/10.0)
              intervalsTable1.model = logOctaves.getLine(1)
              intervalsTable2.model = logOctaves.getLine(2)
              intervalsTable3.model = logOctaves.getLine(3)
              intervalsTable4.model = logOctaves.getLine(4)

          }
      }

    Slider {
        id: ratio
        from: 2
        to: 100
        value: 100
        stepSize: 1
        y: 5
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
    }

    TextField {
        id: baseNumber
        y: 5
        x: ratio.x + ratio.width + 10
        width: 70
        placeholderText: "Base number"
        text: "14"

        ToolTip {
            parent: baseNumber.handles
            visible: baseNumber.hovered 
            text: 'Base number: ' + baseNumber.text
        }
    }

    /*
    ComboBox {
        id: multiplyNumber
        y: 5
        x: baseNumber.x + baseNumber.width + 10
        width: 70
        model : ["2", "3"]

        ToolTip {
            parent: multiplyNumber.handles
            visible: multiplyNumber.hovered 
            text: 'Multiply number: ' + multiplyNumber.text
        }
    } */ //Pentatonic visualization requres better work around estimation scales and length

    TextField {
        id: tempoValue
        y: 5
        x: baseNumber.x + baseNumber.width + 10
        width: 70
        placeholderText: "Tempo"
        text: "180"

        ToolTip {
            parent: tempoValue.handles
            visible: tempoValue.hovered 
            text: 'Tempo: ' + tempoValue.text
        }
    }

    TextField {
        id: durationValue
        y: 5
        x: tempoValue.x + tempoValue.width + 10
        width: 70
        placeholderText: "Dur"
        text: "0.25"

        ToolTip {
            parent: durationValue.handles
            visible: durationValue.hovered 
            text: 'Duration: ' + durationValue.text
        }
    }

    TextField {
        id: startNoteValue
        y: 5
        x: durationValue.x + durationValue.width + 10
        width: 70
        placeholderText: "Start Midi"
        text: "36"

        ToolTip {
            parent: startNoteValue.handles
            visible: startNoteValue.hovered 
            text: 'Start midi note: ' + startNoteValue.text
        }
    }
    
    TextField {
        id: endNoteValue
        y: 5
        x: startNoteValue.x + startNoteValue.width + 10
        width: 70
        placeholderText: "End Midi"
        text: "83"

        ToolTip {
            parent: endNoteValue.handles
            visible: endNoteValue.hovered 
            text: 'End midi note: ' + endNoteValue.text
        }
    }

    TextField {
        id: scalesCount
        y: 5
        x: endNoteValue.x + endNoteValue.width + 10
        width: 70
        placeholderText: "Scales count"
        text: "1000"

        ToolTip {
            parent: scalesCount.handles
            visible: scalesCount.hovered 
            text: 'Scales count: ' + scalesCount.text
        }
    }

    Button {
        id: calcButton
        y: 5
        x: scalesCount.x + scalesCount.width + 10
        text: "Calc"
        onClicked: {
            updateTimer.running = true
        }
    }

    Item {
        id: dialogItem
        FileDialog {
            id: fileDialog
            title: "Save midi file"
            folder: shortcuts.desktop
            onAccepted: {
                var filename = fileDialog.fileUrls.toString().substr(8)
                intervalsTable1.model.generateByIntervals(
                    filename, startNoteValue.text, endNoteValue.text,
                    tempoValue.text, durationValue.text)
            }
            nameFilters: [ "MIDI files (*.midi *.mid)", "All files (*)" ]
            selectExisting: false
            visible: false
        } //Проблема из-за диалога.. теряются правильные размеры - перенести как это
    }

    Button {
        y: 5
        x: parent.width - width - 10
        text: "Save midi"
        onClicked: {
            fileDialog.visible = true
        }
    }

    Rectangle{
        id: visualArea1
        width: parent.width
        height: 90
        y: 150
        x:0
        TableView{
            id: intervalsTable1
            onContentXChanged:  {
                intervalsTable2.contentX = contentX
                intervalsTable3.contentX = contentX
                intervalsTable4.contentX = contentX
            }
            y: 0
            width: parent.width
            height: parent.height - y
            columnWidthProvider: function (column) { return model.getColumnWidth(column) }
            delegate:
                Rectangle {
                    color: display[4]
                    visible: ratio.value > 25
                    Text {
                    width: 10
                    text: display[2] 
                    visible: ratio.value > 80
                }
                implicitHeight: 90
                implicitWidth: 30
                border.color: 'lightgray'
            }
        }
   }
   
    Rectangle {
        id: visualArea2
        width: parent.width
        height: 90
        y: visualArea1.y + visualArea1.height
        x:0
        TableView{
            onContentXChanged:  {
                intervalsTable1.contentX = contentX
                intervalsTable3.contentX = contentX
                intervalsTable4.contentX = contentX
            }
            id: intervalsTable2
            y: 0
            width: parent.width
            height: parent.height - y
            columnWidthProvider: function (column) {  return model.getColumnWidth(column)  }
            delegate:
                Rectangle{
                    color: display[4]
                    visible: ratio.value > 2
                    Text {
                    width: 10
                    text: display[2] + " " + display[3]
                    visible: ratio.value > 40
                }
                implicitHeight: 90
                implicitWidth: 30
                border.color: 'lightgray'
            }
        }
   }

    Rectangle{
        id: visualArea3
        width: parent.width
        height: 90
        y: visualArea2.y + visualArea2.height
        x:0
        TableView{
            onContentXChanged:  {
                intervalsTable1.contentX = contentX
                intervalsTable2.contentX = contentX
                intervalsTable4.contentX = contentX
            }
            id: intervalsTable3
            y: 0
            width: parent.width
            height: parent.height - y
            columnWidthProvider: function (column) { return model.getColumnWidth(column) }
            delegate:
                Rectangle{
                    color: display[4]
                    Text {
                    width: 10
                    text: display[1] + " " + display[2]
                }
                implicitHeight: 90
                implicitWidth: 30
                border.color: 'lightgray'
            }
        }
   }

    Rectangle{
        id: visualArea4
        width: parent.width
        height: 90
        y: visualArea3.y + visualArea3.height
        x:0
        TableView{
            onContentXChanged:  {
                intervalsTable1.contentX = contentX
                intervalsTable2.contentX = contentX
                intervalsTable3.contentX = contentX
            }
            id: intervalsTable4
            y: 0
            width: parent.width
            height: parent.height - y
            columnWidthProvider: function (column) {  return model.getColumnWidth(column) }
            delegate:
                Rectangle{
                    color: display[4]
                    Text {
                    width: 10
                    text: display[1] + " " + display[2]
                }
                implicitHeight: 90
                implicitWidth: 30
                border.color: 'lightgray'
            }
        }
   }

}
