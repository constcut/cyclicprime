import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.12

Item {
    id: autoSumItem

    property string athName: "Geometric Progression"
    property int prime: 7

    Component.onCompleted:{
        nom.text = '1'
        den.text = prime.toString()
        calcButton.calc()
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
         sumModel.calculate(nom.text,den.text,base.value,geoNumber.value,geoElements.value)
         sumModel.setTableWidth(1000)

         var f = sumModel.firstStep()
         var m = sumModel.multiply()
         var d = sumModel.decrease()

         sumTable.model = sumModel
     }

     onPressed: calcButton.calc()
    }

    Slider{
        x: 350
        from: 2
        to: 62
        value: 10
        id: base
        y: 5
        stepSize: 1

        onValueChanged: {
        }

        ToolTip {
            parent: base.handle
            visible: base.hovered
            text: 'Base: ' + base.value
        }
    }

    Slider{
        x: 550
        from: 0
        value: 0
        to: 49
        id: geoNumber
        y: 5
        stepSize: 1
        onValueChanged: {
        }
        ToolTip {
            parent: geoNumber.handle
            visible: geoNumber.hovered
            text: 'Progression: ' + geoNumber.value
        }
    }

    Slider{
        x: 750
        from: 1
        value: 50 
        to: 500
        id: geoElements
        y: 5
        stepSize: 1

        ToolTip {
            parent: geoElements.handle
            visible: geoElements.hovered
            text: 'Members: ' + geoElements.value
        }
    }

    CheckBox{
        text: '0'
        x: 950
        id: displayZeros
        onCheckStateChanged: {
            sumModel.switchZeroes()
        }
        ToolTip {
            parent: displayZeros.handle
            visible: displayZeros.hovered
            text: 'Display zeroes'
        }
    }


    Button{
        x: 1050
        text: "copy"
        onClicked: {
            visualArea.grabToImage(function(result) {
                                     //result.saveToFile("autosum.png");
                                     copyClipboard.copyImageSrc(result.image)
                                     console.log("Image saved copied")
                                 });
        }
    }



    SumModel{
        id: sumModel
    }


   Rectangle{
   id: visualArea
   width: parent.width
   height: parent.height - 50

   y:50
   x:0

    TableView{
        id: sumTable
        y: 50

        width: parent.width
        height: parent.height - y

        delegate:
            Rectangle{
                Text {
                width: 10
                text: display
            }

            implicitWidth: 15
            implicitHeight: 15
            border.color: 'lightgray'
        }
    }
    }
}
