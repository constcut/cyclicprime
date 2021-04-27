import QtQuick 2.12
import QtQuick.Controls 2.5
import Athenum 1.0
import QtQml 2.12

Item {
    id: manyRationalsPage

    property string athName: "Many rationals"
    property int requestedWidth: width
    property int requestedHeight: 800

    property int prime : 0
    property int numericSystem : 0
    property bool oroboro: true

    Component.onCompleted: {
        if (prime !== 0) {
            var oro = numericSystem > (prime + 1)
            selectComboBox.reset()
              for (var i = 1; i < prime; ++i)
                    addPrimeToCircle(i,prime,numericSystem,oro,2)      
        }
    }

    DigitalCircleList{
        id: circle
        x: 100
        y: 100
        width: 300
        height: 300
    }

    DigitalCircleList{
        id: circle2
        x: 100 + 350
        y: 100
        width: 300
        height: 300
    }

    DigitalCircleList{
        id: circle3
        x: 100 + 700
        y: 100
        width: 300
        height: 300
    }

    DigitalCircleList {
        id: circle4
        x: 100
        y: 100 + 350
        width: 300
        height: 300
    }

    DigitalCircleList {
        id: circle5
        x: 100 + 350
        y: 100 + 350
        width: 300
        height: 300
    }

    DigitalCircleList {
        id: circle6
        x: 100 + 700
        y: 100 + 350
        width: 300
        height: 300
    }


    Rational{
        id: number
    }


    ComboBox {
        
        id: selectComboBox

        y: 5
        x: 5
        model: ["All of rationals from 1/7 till 6/7", "All rationals from 1/49 till 48/49",
                "All rationals from 1/91 till 90/91", "1/13 .. 12/13", "1/5..4/5", "1/3 and 2/3",
                "FIRST NON REPTEND", "FIRST REPTEND", "11", "13"]

        width: parent.width/2 - 50

        function reset() {
            circle.reset()
            circle2.reset()
            circle3.reset()
            circle4.reset()
            circle5.reset()
            circle6.reset()
        }

        onActivated: {
            reset()

            if (index == 0) {
                scale = 10
                addPrimeToCircleColored(1,7,scale,true,1, "#ff0000")
                addPrimeToCircleColored(2,7,scale,true,1, "#ff8000")
                addPrimeToCircleColored(3,7,scale,true,1, "#808000")
                addPrimeToCircleColored(4,7,scale,true,1, "#00ff00")
                addPrimeToCircleColored(5,7,scale,true,1, "#00ff80")
                addPrimeToCircleColored(6,7,scale,true,1, "#0000ff")
                var scale = 10
                addPrimeToCircle(1,7,scale,true,2)
                addPrimeToCircle(2,7,scale,true,2)
                addPrimeToCircle(3,7,scale,true,2)
                addPrimeToCircle(4,7,scale,true,2)
                addPrimeToCircle(5,7,scale,true,2)
                addPrimeToCircle(6,7,scale,true,2)
                scale = 3
                addPrimeToCircle(1,7,scale,false,3)
                addPrimeToCircle(2,7,scale,false,3)
                addPrimeToCircle(3,7,scale,false,3)
                addPrimeToCircle(4,7,scale,false,3)
                addPrimeToCircle(5,7,scale,false,3)
                addPrimeToCircle(6,7,scale,false,3)


                addPrimeToCircle(1,7,2,false,4)
                addPrimeToCircle(1,7,9,true,4)
                //addPrimeToCircle(1,7,3,false,2)
                //addPrimeToCircle(1,7,10,true,2)
                //addPrimeToCircle(1,7,4,false,3)
                //addPrimeToCircle(1,7,11,true,3)
                addPrimeToCircle(1,7,5,false,5)
                addPrimeToCircle(1,7,12,true,5)
                //addPrimeToCircle(1,7,6,false,5)
                //addPrimeToCircle(1,7,13,true,5)
                addPrimeToCircle(1,7,10,true,6)
                addPrimeToCircle(1,7,17,true,6)
            }
            else if (index == 1) {
                for (var i = 1; i < 49; ++i)
                    addPrimeToCircle(i,49,10,true,2)        
            }
            else if (index == 2) {
                for (i = 1; i < 91; ++i)
                    addPrimeToCircle(i,91,10,true,2)
            }
            else if (index == 3) {
                var searchOne = 13
                for (var i = 1; i < 13; ++i)
                    addPrimeToCircle(i,searchOne,10,true,3)

                addPrimeToCircle(1,searchOne,10,true,1)
                addPrimeToCircle(2,searchOne,10,true,2)

                addPrimeToCircle(1,searchOne,10,true,5)
                addPrimeToCircle(2,searchOne,10,true,5)
            }
            else if (index == 4) {
                scale = 7
                addPrimeToCircle(1,5,scale,true,4)
                addPrimeToCircle(2,5,scale,true,4)
                addPrimeToCircle(3,5,scale,true,4)
                addPrimeToCircle(4,5,scale,true,4)
                scale = 2
                addPrimeToCircle(1,5,scale,false,5)
                addPrimeToCircle(2,5,scale,false,5)
                addPrimeToCircle(3,5,scale,false,5)
                addPrimeToCircle(4,5,scale,false,5)
                scale = 7
                addPrimeToCircle(1,5,scale,true,6)
                addPrimeToCircle(2,5,scale,true,6)
                addPrimeToCircle(3,5,scale,true,6)
                addPrimeToCircle(4,5,scale,true,6)
                scale = 2
                addPrimeToCircle(1,5,scale,false,6)
                addPrimeToCircle(2,5,scale,false,6)
                addPrimeToCircle(3,5,scale,false,6)
                addPrimeToCircle(4,5,scale,false,6)

                var searchOne = 5*5
                for (var i = 1; i < searchOne; ++i)
                addPrimeToCircle(i,searchOne,7,true,1)
                addPrimeToCircle(1,5,2,false,2)
                addPrimeToCircle(1,5,7,true,2)
                addPrimeToCircle(1,5,3,false,3)
                addPrimeToCircle(1,5,8,true,3)
                //addPrimeToCircle(1,5,4,false,3)
                //addPrimeToCircle(1,5,9,true,3)
            }
            else if (index == 5) {
                addPrimeToCircle(1,3,2,false,1)
                addPrimeToCircle(1,3,5,true,1)
                addPrimeToCircle(1,3,8,true,2)
                addPrimeToCircle(1,3,5,true,2)
                addPrimeToCircle(1,3,8,true,3)
                addPrimeToCircle(1,3,11,true,3)
                addPrimeToCircle(1,3,14,true,4)
                addPrimeToCircle(1,3,11,true,4)
                addPrimeToCircle(1,3,14,true,5)
                addPrimeToCircle(1,3,17,true,5)
                addPrimeToCircle(1,3,2,false,6)
                addPrimeToCircle(1,3,5,true,6)
                addPrimeToCircle(1,3,8,true,6)
                addPrimeToCircle(1,3,11,true,6)
                addPrimeToCircle(1,3,14,true,6)
                addPrimeToCircle(1,3,17,true,6)
                addPrimeToCircle(1,3,20,true,6)
                addPrimeToCircle(1,3,23,true,6)
                addPrimeToCircle(1,3,26,true,6)    
            }
            else if (index == 6) {
                addPrimeToCircle(1,3,2,false,1)
                addPrimeToCircle(1,3,5,true,1)
                addPrimeToCircle(1,5,2,false,2)
                addPrimeToCircle(1,5,7,true,2)
                addPrimeToCircle(1,7,2,false,3)
                addPrimeToCircle(1,7,9,true,3)
                addPrimeToCircle(1,11,2,false,4)
                addPrimeToCircle(1,11,13,true,4)
                addPrimeToCircle(1,13,2,false,5)
                addPrimeToCircle(1,13,15,true,5)
                addPrimeToCircle(1,17,2,false,6)
                addPrimeToCircle(1,17,19,true,6)  
            }
            else if (index == 7) {
                addPrimeToCircle(1,5,2,false,1)
                addPrimeToCircle(1,5,7,true,1)
                addPrimeToCircle(1,7,3,false,2)
                addPrimeToCircle(1,7,10,true,2)
                addPrimeToCircle(1,11,2,false,3)
                addPrimeToCircle(1,11,13,true,3)
                addPrimeToCircle(1,13,2,false,4)
                addPrimeToCircle(1,13,15,true,4)
                addPrimeToCircle(1,17,3,false,5)
                addPrimeToCircle(1,17,20,true,5)
                addPrimeToCircle(1,19,2,false,6)
                addPrimeToCircle(1,19,21,true,6)   
            }
            else if (index == 8) {
                addPrimeToCircle(1,11,2,false,1)
                addPrimeToCircle(1,11,13,true,1)
                addPrimeToCircle(1,11,3,false,2)
                addPrimeToCircle(1,11,14,true,2)
                addPrimeToCircle(1,11,4,false,3)
                addPrimeToCircle(1,11,15,true,3)
                addPrimeToCircle(1,11,5,false,4)
                addPrimeToCircle(1,11,16,true,4)
                addPrimeToCircle(1,11,6,false,5)
                addPrimeToCircle(1,11,17,true,5)
                addPrimeToCircle(1,11,7,false,6)
                addPrimeToCircle(1,11,18,true,6)    
            }
            else if (index == 9) {
                addPrimeToCircle(1,13,2,false,1)
                addPrimeToCircle(1,13,15,true,1)
                addPrimeToCircle(1,13,3,false,2)
                addPrimeToCircle(1,13,16,true,2)
                addPrimeToCircle(1,13,4,false,3)
                addPrimeToCircle(1,13,17,true,3)
                addPrimeToCircle(1,13,5,false,4)
                addPrimeToCircle(1,13,18,true,4)
                addPrimeToCircle(1,13,6,false,5)
                addPrimeToCircle(1,13,19,true,5)
                addPrimeToCircle(1,11,7,false,6)
                addPrimeToCircle(1,13,20,true,6)
            }
            
            /* //CASE FOR OPTIMIZATION - this one runs too slow
            for (var i = 1; i < 13*13; ++i)
            addPrimeToCircle(i,13*13,10,true,5)*/
        }

    }

    Slider{
        y: 5
        x: 600
        from: 0.25
        to: 4.0
        value: 1.0
        id: speedSlider

        onValueChanged: {
            circle.setSpeedRatio(speedSlider.value)
            circle2.setSpeedRatio(speedSlider.value)
            circle3.setSpeedRatio(speedSlider.value)
            circle4.setSpeedRatio(speedSlider.value)
            circle5.setSpeedRatio(speedSlider.value)
            circle6.setSpeedRatio(speedSlider.value)
        }
        ToolTip {
            parent: speedSlider.handle
            visible: speedSlider.hovered
            text: 'Speed ratio: ' + speedSlider.value
        }
    }


    function addPrimeToCircle(num, den, scale, oro, circleNum) {
        number.calc(num,den,scale)
        var digits = number.digits('period',0)

        var colorValue = "#00ff00"

        if (circleNum === 1)
            circle.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 2)
            circle2.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 3)
            circle3.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 4)
            circle4.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 5)
            circle5.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 6)
            circle6.add(digits,scale, true, oro, colorValue)
    }

    function addPrimeToCircleColored(num, den, scale, oro, circleNum, colorValue) {
        number.calc(num,den,scale)
        var digits = number.digits('period',0)

        if (circleNum === 1)
            circle.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 2)
            circle2.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 3)
            circle3.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 4)
            circle4.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 5)
            circle5.add(digits,scale, true, oro, colorValue)
        else if (circleNum === 6)
            circle6.add(digits,scale, true, oro, colorValue)
    }

    Button{
        y: 5
        x: 950
        text: 'Play'
        onClicked: {
            circle.startAnimation()
            circle2.startAnimation()
            circle3.startAnimation()
            circle4.startAnimation()
            circle5.startAnimation()
            circle6.startAnimation()
        }
    }


}
