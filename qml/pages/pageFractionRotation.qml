import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.12
import QtQuick.Dialogs 1.3

Item {
    id: ractionRotation

    property string athName: "FractionRotation"

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
        x: 5 + 150
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

    
    Button {
        id: leftButton
        y: 20
        x: numericSystem.x + numericSystem.width + 10
        text: "<"
        onClicked: {
         
        }
    }

    Button {
        id: rightButton
        y: 20
        x: leftButton.x + leftButton.width + 10
        text: ">"
        onClicked: {
         
        }
    }

    Button {
        id: reverseButton
        y: 20
        x: rightButton.x + rightButton.width + 10
        text: "Reverse"
    }

    Text {
        y: 20
        x:  reverseButton.x + reverseButton.width + 10
        id: factionName
        text : "1/7"
    }

    DigitalCircleList{
        id: circle
        x: 100 + 350
        y: 100
        width: 300
        height: 300
    }

    Rational {
        id: rational
    }

    Component.onCompleted : {
        rational.calc(numerator.text, denominator.text, numericSystem.text)
        var d = rational.digits("fract", 0)
        print(d, "digits")
        //var oroborus = 
        circle.add(d, numericSystem.text, true, true, "black")
    }
}
