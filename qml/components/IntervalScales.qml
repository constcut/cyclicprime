import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.12

Item {
    id: autoSumItem

    property string athName: "IntervalsScales"
    property int prime: 7

    Component.onCompleted:{
        logOctaves.setScaleRatio(ratio.value/10.0)
        intervalsTable1.model = logOctaves.getLine(1)
        intervalsTable2.model = logOctaves.getLine(2)
        intervalsTable3.model = logOctaves.getLine(3)
        intervalsTable4.model = logOctaves.getLine(4)
    }

    LogOctaves {
        id: logOctaves
    }



    Timer {
          id:updateTimer
          interval: 200; running: false; repeat: false
          onTriggered: {
              intervalsTable1.model = undefined
              intervalsTable2.model = undefined
              intervalsTable3.model = undefined
              intervalsTable4.model = undefined
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
        width: parent.width/2
        onValueChanged: {
            updateTimer.restart()
        }
        ToolTip {
            parent: ratio.handles
            visible: ratio.hovered 
            text: 'Scale ratio: ' + ratio.value
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
