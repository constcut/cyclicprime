import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.12

Item {
    id: multiSumItem

    anchors.fill: parent

    property string athName: "MultiSum"
    property int num: nom.text
    property int prime: den.text

    Component.onCompleted: {
    }

    MultiSumModel{
        id: sumModel
    }


    TextField{
        placeholderText: "num"
        width: 100
        x: 0
        y: 5
        text: '1'
        id: nom
    }
    Text{
        x:102
        text:"/"
        y: 5
    }
    TextField{
        placeholderText: "den"
        width: 125
        x: 110
        y: 5
        text: '7'
        id: den
    }
    Button{
     y: 5
     x: 240
     text: 'calc'
     id: calcButton
     function calc(){
         sumModel.clear()
         for (var i = 0; i <= progressionsCount.value; ++i){
             sumModel.addNew(num,prime,10,i,amountElements.value)
         }
         sumTable.model = sumModel
         sumModel.refresh()
     }
     onPressed: calcButton.calc()
    }

    Button{
        y: 5
        x: 650
        text: 'clear'
        onClicked: {
            sumModel.clear()
        }
    }

    Button{
        y: 5
        x: 800
        text: 'add single'
        onClicked: {
            sumModel.addNew(num,prime,10,progressionsCount.value,amountElements.value)
            sumModel.refresh()
        }
    }

    Slider{
        from: 1
        to: 100
        value: 40
        id: amountElements
        width: 125
        x: 350
        y: 5
        stepSize: 1

        ToolTip {
            parent: amountElements.handle
            visible: amountElements.hovered
            text: 'Amount of elements: ' + amountElements.value
        }
    }

    Slider{
        x: 500
        width: 125
        y: 5
        from: 0
        to: 13
        value: 7
        stepSize: 1

        id: progressionsCount

        ToolTip {
            parent: progressionsCount.handle
            visible: progressionsCount.hovered
            text: 'Progressions count: ' + progressionsCount.value
        }
    }

    TableView{
        id: sumTable

        y: 50
        width: parent.width
        height: parent.height - y

        delegate:
            Rectangle{
            Text {
            width: 10
            text: display[0] + ' '}

            color: display[1]
            implicitWidth: 15
            implicitHeight: 15
            border.color: 'lightgray'
        }
    }

}
