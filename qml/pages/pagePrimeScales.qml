import QtQuick 2.13
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.13

import '../components'



Item {
    id: primeScalesPage
    property string athName: "PrimeScales"
    property string descriptionText: "Full reptend in prime scales"

    property bool helpWasPressed: false

    function helpPressed(){
        if (helpWasPressed) {
            helpWasPressed = false;
        }
        else{
            helpWasPressed = true;
        }
    }


    Timer {
          id:updateTimer
          interval: 150; running: false; repeat: false
          onTriggered: {
              var moment = Date.now()
              pTableLoader.setSource("../components/PrimeScalesTable.qml" + "?t=" + moment,
                                     {'elementSize':scale.value,'primeLow':primeRange.first.value,
                                         'primeHigh':primeRange.second.value, 'cells':cells.value,
                                     'viewMode':highlightMode.currentText})
          }
      }

    Slider{
        id: cells
        from: 100
        to: 5000
        value: 1000
        stepSize: 100
        y: 5
        x: 0
        width: parent.width/4 - 30
        onValueChanged: {
            updateTimer.restart()
        }
        ToolTip {
            parent: cells.handles
            visible: cells.hovered || primeScalesPage.helpWasPressed
            text: 'Amount of cells: ' + cells.value
        }
    }

    RangeSlider {
        id: primeRange

        from: 2
        to: 127
        stepSize: 1
        snapMode: RangeSlider.SnapAlways

        first.value: 2
        second.value: 67

        ToolTip {
            parent: primeRange.handle
            visible: primeRange.hovered || primeScalesPage.helpWasPressed
            text: 'Bases n: ' + primeRange.first.value + ' ' + primeRange.second.value
        }

        first.onMoved: {
            updateTimer.restart()
        }
        second.onMoved: {
            updateTimer.restart()
        }

        y: 5
        x: parent.width/4
        width: parent.width/4 - 30
    }

    Slider{
        id: scale
        from: 15 
        to: 100
        value: 25
        y: 5
        x: parent.width/2
        width: parent.width/4 - 30

        onValueChanged: {
            updateTimer.restart()
        }
        ToolTip {
            parent: scale.handle
            visible: scale.hovered || primeScalesPage.helpWasPressed
            text: 'Scale: ' + scale.value
        }
    }

    ComboBox {
        id: highlightMode
        y: 5
        x: parent.width * 3/4
        width: parent.width/4 - 30
        model: ["P-1", "(P-1)/2", "(P-1)/3", "All"]
        currentIndex: 3
        onCurrentIndexChanged:{
            updateTimer.restart()
        }
    }

    Loader{
        id: pTableLoader
        y: 50
        x: 0
        width: parent.width
        height: parent.height-50
    }
    Component.onCompleted: {
        updateTimer.restart()
    }

}
