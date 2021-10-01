import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.12
import QtQuick.Dialogs 1.3

Item {
    id: ractionRotation

    property string athName: "FractionRotation"

    TextField {
        id: numerator
        y: 20
        x: 5 + 10
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
        text: "10" //replace with 24 or else

        ToolTip {
            parent: numericSystem.handles
            visible: numericSystem.hovered 
            text: 'Numeric system: ' + numericSystem.text
        }
    }

    Button {
        id: calcButton
        y: 20
        x: numericSystem.x + numericSystem.width + 10
        text: "calc"
        onClicked : {
            rational.calc(numerator.text, denominator.text, numericSystem.text)
            var d = rational.digits("fract", 0)
            circle.stopAnimation()
            circle.reset()
            circle.add(d, numericSystem.text, true, true, "black")
            factionName.text = rational.getFullString()
        }
    }

    
    Button {
        id: leftButton
        y: 20
        x: calcButton.x + calcButton.width + 10
        text: "<"
        onClicked: {
            rational.rotatePeriodLeft()
            var d = rational.digits("fract", 0)
            circle.stopAnimation()
            circle.reset()
            circle.add(d, numericSystem.text, true, true, "black")
            factionName.text = rational.getFullString()
        }
    }

    Button {
        id: rightButton
        y: 20
        x: leftButton.x + leftButton.width + 10
        text: ">"
        onClicked: {
            rational.rotatePeriodRight()
            var d = rational.digits("fract", 0)
            circle.stopAnimation()
            circle.reset()
            circle.add(d, numericSystem.text, true, true, "black")
            factionName.text = rational.getFullString()
        }
    }

    Button {
        id: reverseButton
        y: 20
        x: rightButton.x + rightButton.width + 10
        text: "Reverse"

        onClicked: {
            rational.inversePeriond()
            var d = rational.digits("fract", 0)
            circle.stopAnimation()
            circle.reset()
            circle.add(d, numericSystem.text, true, true, "black")
            factionName.text = rational.getFullString()
        }
    }

    Button {
        id: allRotations
        text: "All"
        y: 20
        x: reverseButton.x + reverseButton.width + 10
        onClicked: {
            rational.calc(numerator.text, denominator.text, numericSystem.text)
            circle.stopAnimation()
            circle.reset()
            for (var i = 0; i < parseInt(numericSystem.text); ++i) {
                var d = rational.digits("fract", 0)
                circle.add(d, numericSystem.text, true, true, "#00ff00") //Other colors
                rational.rotatePeriodRight()
            }
        }
    }

    Button {
        id: playButton
        y: 20
        x: allRotations.x + allRotations.width + 10
        text: "Play"
        onClicked: {
            circle.startAnimation()
        }
    }

    Text {
        y: 20
        x:  playButton.x + playButton.width + 10
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
        circle.add(d, numericSystem.text, true, true, "black")
        factionName.text = rational.getFullString()
    }
}
