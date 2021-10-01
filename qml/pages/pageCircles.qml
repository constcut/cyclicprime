import QtQuick 2.12
import QtQuick.Controls 2.5
import Athenum 1.0
import QtQuick.Layouts 1.12
import '../components'

Item {
    id: pageCircles

    property string athName: "Circles"
    property int requestedWidth: width
    property int requestedHeight: 500
    property int circleRadius: radiusSlider.value

    property int circlesCount : 2

    Component.onCompleted: {
        //Example of import/export
       /*var jsonText =  '{"digits":[1,3,2,6,4,5],"dotColor":"#0000ff","lineColor":"#00ff00","lineWidth":3,"radius":100,"scale":7}'
       circleRepeater.itemAt(0).importJson(jsonText)
       var jsonText2 =  '{"circles":[{"digits":[1,4,2,8,5,7],"dotColor":"#0000ff","lineColor":"#00ff00","lineWidth":3,"radius":100,"scale":10},{"digits":[0,1,0,2,1,2],"dotColor":"#0000ff","lineColor":"#00ff00","lineWidth":3,"radius":100,"scale":4}]}'
       circleRepeater.itemAt(1).importJson(jsonText2) */
       pageCircles.circlesCount = 0 //Make 0 if remove upper code
    }

    function updateAllCircles() {
        for (var i = 0; i < circleRepeater.model; ++i)
            circleRepeater.itemAt(i).updateCircle()
    }

    Button {
       x: parent.width - width - 10 
       y: 5
       text: "Export / import"
       onClicked: {
         exportedText.text = "["
         for (var i = 0; i < circleRepeater.model; ++i) {
            exportedText.text += circleRepeater.itemAt(i).exportJson()
            if (i < circleRepeater.model-1)
                exportedText.text +=  ",\n";
         }
         exportedText.text += "]";
         exportPopup.open()
       }
    }


    Slider{
        id: circlesSlider
        from: 1
        to: 255
        value: 20
        stepSize: 1
        y: 5
        x: 5
        width: 200
        onValueChanged: {
            updateAllCircles()
        }
        ToolTip {
            parent: circlesSlider.handles
            visible: circlesSlider.hovered // || pageCircles.helpWasPressed
            text: 'Amount of cells: ' + circlesSlider.value
        }
    }

    Slider{
        id: radiusSlider
        from: 10
        to: 400
        value: 240
        stepSize: 1
        y: 5
        x: 220
        width: 200
        onValueChanged: {
            updateAllCircles()
        }
        ToolTip {
            parent: radiusSlider.handles
            visible: radiusSlider.hovered // || pageCircles.helpWasPressed
            text: 'Radius: ' + radiusSlider.value
        }
    }

    TextField {
        id: denominator
        y: 20
        x: radiusSlider.x + radiusSlider.width + 10
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
        text: "10" //replace with 24 or else

        ToolTip {
            parent: numericSystem.handles
            visible: numericSystem.hovered 
            text: 'Numeric system: ' + numericSystem.text
        }
    }

    Rational {
        id: rational
    }


    Button {
        id: addAllNums
        text: "Add all nums"
        y: 20
        x: numericSystem.x + numericSystem.width + 10

        onClicked: {
            for (var i = 1; i < parseInt(denominator.text); ++i) {
                rational.calc(i, denominator.text, numericSystem.text)
                var d = rational.digits("fract", 0)
                circleRepeater.itemAt(pageCircles.circlesCount).add(d, numericSystem.text, true, true, "#00ff00")  
            }
            pageCircles.circlesCount += 1
        }
    }

    PrimeComboBox {
        y: 20
        x: addAllNums.x + addAllNums.width + 10
        id: primesCombo
        width: 140
    }

    Button {
        text: "Add oroboric"
        y: 20
        x: primesCombo.x + primesCombo.width + 10
        id: addOroButton

        onClicked : {
            var prime = parseInt(primesCombo.text)
            console.log(prime)

            //a little dirty but fast to write code

            for (var i = 2; i < prime; ++i) {
                rational.calc(1, prime, i)
                var d = rational.digits("fract", 0)
                if (d.length == prime - 1) {
                    rational.calc(1, prime, i + prime)
                    var d2 = rational.digits("fract", 0)
                    circleRepeater.itemAt(pageCircles.circlesCount).add(d2, i + prime, true, true, "#00ff00")
                    circleRepeater.itemAt(pageCircles.circlesCount).add(d, i, true, false, "#00ff00") 
                    pageCircles.circlesCount += 1
                    print(i, "got full reptend")
                }
            }
        }
    }

    Popup{
        id: exportPopup
        width: pageCircles.width - 300
        height: pageCircles.height - 200
        x: 150
        y: 100
        TextArea {
            id: exportedText
            placeholderText: '{}'
            width: parent.width
            height: parent.height - 50
        }
        Button {
            x: 5
            y: parent.height - 40
            text: "Import"
            onPressed: {
                var j = JSON.parse(exportedText.text)
                var j2 = athenumInfo.divideJson(exportedText.text)
                for (var i = 0; i < j2.length; ++i) {
                        circleRepeater.itemAt(i).importJson(j2[i])
                    }
            }
        }
        Button {
            x: parent.width - width - 10
            y: parent.height - 40
            text: "Close"
            onPressed: exportPopup.close()
        }
    }

    Flickable {
        id:mainFlick
        y: 50
        width: parent.width
        height: parent.height - y

        contentWidth: pageCircles.width
        contentHeight: 3000

        ScrollBar.vertical: ScrollBar { active: true }

   Grid {
        id: repeatersGrid
        x: 10; y: 50
        rows: 10
        columns: pageCircles.width / ( pageCircles.circleRadius + 10) 
        spacing: 10

        width: parent.width
        height: parent.height - 50

    Repeater {
        id: circleRepeater
        model: circlesSlider.value
        Rectangle {
            id: innerRect
            x: 5 + index * pageCircles.circleRadius
            y: 0
            width: pageCircles.circleRadius
            height: pageCircles.circleRadius + 50
            border.color: 'green'

            function importJson(conf) {
                digitsCircle.importJson(conf)
            }
            function exportJson() {
                return digitsCircle.exportJson()
            }
            function updateCircle() {
            }
            function add(digits, numericSystem, cycleFlag, oroFlag, color ) {
                digitsCircle.add(digits, numericSystem, cycleFlag, oroFlag, color )
            }
            function setRadius(radius) {
                digitsCircle.setRadius()
            }

            DigitalCircleList{
                id: digitsCircle
                anchors.horizontalCenter: parent !== null ? parent.horizontalCenter : null
                y: 5
                width: parent !== null ? parent.height-60 : 10
                height: (parent !== null ? parent.height-60 : 10)  + 50
                Component.onCompleted: {
                }
                MouseArea{
                    anchors.fill: parent
                    onDoubleClicked: {
                      digitsCircle.startAnimation()
                    }
                }
            }
        }
    } //Repeater

    }

    }

}
