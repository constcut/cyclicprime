import QtQuick 2.13
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.13


Item {
    id: primeScalesItem 
    property string athName: "PrimeScales"

    property int elementSize: 30
    property int primeLow: 2
    property int primeHigh: 62
    property int cells: 1000
    property string viewMode: "P-1"

    signal requestToOpenPage(var pageName)

    PrimeScales{
        id: primeScales
    }
    Rational{
        id:rational
    }
    Component.onCompleted: {
        calc()
    }
    function calc(){
        primeScales.calculate(primeScalesItem.primeLow, primeScalesItem.primeHigh, primeScalesItem.cells)
        scalesTable.model = primeScales
    }
    Rectangle {
    id: visualArea
    width: parent.width
    height: parent.height - 50
    y:0
    x:0
    border.color: 'green'
        TableView{
            id: scalesTable
            y: 50
            width: parent.width
            height: parent.height - y
            delegate:Component{
                Rectangle{
                id: globalDelegate
                color:   {
                            var color = "white"
                            if (viewMode === "All") {
                                var color = display[1] === 1 ?
                                "lightGreen"
                                : display[1] === 2 ?
                                "lightBlue"
                                : display[1] === 3 ?
                                "#FFFF77"
                                : "white"     
                            }
                            if (viewMode === "P-1") {
                                if (display[1]  === 1)
                                    color = "lightGreen"
                            }
                            if (viewMode === "(P-1)/2") {
                                if (display[1] === 2) 
                                    color = "lightBlue"   
                            }
                            if (viewMode === "(P-1)/3"){
                                if (display[1] === 3) 
                                    color = "#FFFF77"    
                            }

                            return color
                        }  
                    Text {
                    visible: primeScalesItem.elementSize > 20
                    width: 20
                    text: display[0] !== undefined ? display[0] : ""
                }

                Button {
                    visible: primeScalesItem.elementSize > 120 
                    text: "Open popup"
                    y: subText.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20

                }
                Button{
                    visible: primeScalesItem.elementSize > 120
                    text: "Full reptend page"
                    y: subText.height + 33
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                }
                Button{
                    visible: primeScalesItem.elementSize > 120
                    text: "Cyclic prime page"
                    y: subText.height + 72
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                }

                Text{
                    id: subText
                    text:
                        display[1] === 1 ?
                            "P-1"
                          : display[1] === 2 ?
                            "P-2"
                          : ""
                    y: parent.height - height
                    visible: primeScalesItem.elementSize > 70
                }

                border.color: 'lightgray'
                implicitHeight: primeScalesItem.elementSize
                implicitWidth: primeScalesItem.elementSize

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (column < 2)
                            return
                        var primeNumber = primeScales.getPrime(row-2)
                        rational.calc(1,primeNumber,column)
                        rationalPopup.primeNum = primeNumber
                        rationalPopup.numericSystem = column
                        popupText.text =  'Rational: ' + rational.getFullString()
                        rationalPopup.visible = true

                        rationalCircle.stopAnimation()
                        var digits = rational.digits('fract', 0)
                        if (column < primeNumber)
                            rationalCircle.set(digits, column, true, false)
                        else
                            rationalCircle.set(digits, column, true, true)
                        rationalCircle.startAnimation()
                    }
                }
            }
            }
        }
    }

    Popup {
        x:(parent.width-width)/2
        y:(parent.height-height)/2

        id: rationalPopup
        width: parent.width - parent.width/5
        height: 300
        visible: false

        property int primeNum : 0
        property int numericSystem : 0

        Text{
            id: popupText
            x: 10
            y: 10
            text: "Rational number: "
        }
        DigitalCircle{
            y: 10 + popupText.height
            anchors.horizontalCenter: parent.horizontalCenter
            id: rationalCircle
            width: 240
            height: 240
        }

        Menu{
            id: popupMenu
            MenuItem {
                 text: "Open full reptend prime page"
                 onTriggered: {
                    rationalPopup.visible = false
                    primeScalesItem.parent.parent.parent.parent.parent.parent.requestToOpenUrl("/pages/pageFullReptendPrime.qml",
                                                                                                 "{\"prime\":" + rationalPopup.primeNum.toString() + ",\"numericSystem\":"
                                                                                                 + rationalPopup.numericSystem.toString() + "}");
                 }
            }
            MenuItem {
                 text: "Open 1/P..P-1/P rationals"
                 onTriggered: {
                    rationalPopup.visible = false
                    primeScalesItem.parent.parent.parent.parent.parent.parent.requestToOpenUrl("/pages/manyRationals.qml",
                                                                                                 "{\"prime\":" + rationalPopup.primeNum.toString() + ",\"numericSystem\":"
                                                                                                 + rationalPopup.numericSystem.toString() + "}");
                 }
            }
            MenuItem {
                 text: "Open geometric progression"
                 visible: rationalPopup.numericSystem === 10
                 onTriggered: {
                    rationalPopup.visible = false
                    primeScalesItem.parent.parent.parent.parent.parent.parent.requestToOpenUrl("/components/GeometricProgression.qml",
                                                                                                 "{\"prime\":" + rationalPopup.primeNum.toString() + "}");
                 }
            }
            MenuItem {
                 text: "Open cyclic prime numbers"
                 onTriggered: {
                    rationalPopup.visible = false
                    primeScalesItem.parent.parent.parent.parent.parent.parent.requestToOpenUrl("/components/CyclicPrime.qml",
                                                                                                 "{\"prime\":" + rationalPopup.primeNum.toString() + ",\"primeTypeStr\":\"full\",\"dontScroll\":true}"); 
                 }
            }
        }

        Button {
            x: parent.width - width - 5
            text: ":"
            onPressed: {
                popupMenu.popup()
            }
        }
    }
}
