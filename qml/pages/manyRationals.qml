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
    Component.onDestruction : {
        circle.stopAnimation()
        circle2.stopAnimation()
        circle3.stopAnimation()
        circle4.stopAnimation()
        circle5.stopAnimation()
        circle6.stopAnimation()
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
                "FIRST NON REPTEND", "FIRST REPTEND", "11", "13", "penta", "Num reduction Mult dec", "1/7 24 rotations", "1/7 12 rotations","1/7 10 rotations"]

        width: parent.width/2 - 50

        function reset() {
            circle.stopAnimation()
            circle2.stopAnimation()
            circle3.stopAnimation()
            circle4.stopAnimation()
            circle5.stopAnimation()
            circle6.stopAnimation()
            circle.reset()
            circle2.reset()
            circle3.reset()
            circle4.reset()
            circle5.reset()
            circle6.reset()
        }

        onActivated: {
            reset()

            //#TODO перести в cicles page, и там позволять операции реверсирования
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
            else if (index == 10) {
                addPrimeToCircle(358,3124,5,false,2)
            }
            else if (index == 11) {

                var colorValue = "#00ff00"
                var oro = true
                circle.add([1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true, oro, colorValue) //1 and rev 8
                circle2.add([2, 4, 6, 8, 1, 3, 5, 7, 9], 10, true, oro, colorValue) //2 and rev 7
                circle3.add([3, 6, 9, 3, 6, 9, 3, 6, 9], 10, true, oro, colorValue) //3 and rev 6
                circle5.add([4, 8, 3, 7, 2, 6, 1, 5, 9], 10, true, oro, colorValue) //4 and rev 5
                circle6.add([2, 4, 8, 7, 5, 1], 10, true, true, colorValue) 
            }    
            else if (index == 12) {
                /*
                var colorValue = "#00ff00"
                var oro = true
                circle.add([2, 4, 6, 8, 2, 4, 6], 9, true, oro, colorValue) 
                circle2.add([3, 6, 1, 4, 7, 2, 5], 9, true, oro, colorValue) 
                circle4.add([2, 4, 6, 1, 3, 5], 8, true, oro, colorValue) 
                circle5.add([3, 6, 2, 5, 1, 4], 8, true, oro, colorValue) 
                circle6.add([3, 2, 6, 4, 5, 1], 8, true, oro, colorValue) */
                addPrimeToCircle(1,7,24,true,2)
                addPrimeToCircle(30,161,24,true,2)
                addPrimeToCircle(37, 161, 24,true,2)
                addPrimeToCircle(44, 161, 24,true,2)
                addPrimeToCircle(60522477, 191102975, 24,true,2)
                addPrimeToCircle(68831302, 191102975, 24,true,2)
                addPrimeToCircle(77140127, 191102975, 24,true,2)
                addPrimeToCircle(85448929, 191102975, 24,true,2)
                addPrimeToCircle(93757754, 191102975, 24,true,2)
                addPrimeToCircle(102066579, 191102975, 24,true,2)
                addPrimeToCircle(110375404, 191102975, 24,true,2)

                addPrimeToCircle(28211,45425,24,true,2)
                addPrimeToCircle(30186, 45425,24,true,2)
                addPrimeToCircle(32161, 45425, 24,true,2)
                addPrimeToCircle(135979304, 191102975, 24,true,2)
                addPrimeToCircle(144288129, 191102975, 24,true,2)
                addPrimeToCircle(152596954, 191102975, 24,true,2)
                addPrimeToCircle(160905779, 191102975, 24,true,2)
                addPrimeToCircle(168896652, 191102975, 24,true,2)
                addPrimeToCircle(177205477, 191102975, 24,true,2)
                addPrimeToCircle(185514302, 191102975, 24,true,2)
                addPrimeToCircle(9, 161, 24,true,2)
                addPrimeToCircle(16, 161, 24,true,2)

            }    
            else if (index == 13) {
                addPrimeToCircle(1,7,12,true,2)
                addPrimeToCircle(18,77,12,true,2)
                addPrimeToCircle(967891, 2985983, 12,true,2)
                addPrimeToCircle(1239344, 2985983, 12,true,2)
                addPrimeToCircle(183243, 426569, 12,true,2)
                addPrimeToCircle(222022, 426569, 12,true,2)
                addPrimeToCircle(11507, 19019, 12,true,2)
                addPrimeToCircle(296863, 426569, 12,true,2)
                addPrimeToCircle(335642, 426569, 12,true,2)
                addPrimeToCircle(2620815, 2985983, 12,true,2)
                addPrimeToCircle(2892268, 2985983, 12,true,2)

            } 
            else if (index == 14) {
                addPrimeToCircle(1,7,10,true,2)
                addPrimeToCircle(16,63,10,true,2)
                addPrimeToCircle(121393, 333333, 10,true,2)
                addPrimeToCircle(17603, 37037, 10,true,2)
                addPrimeToCircle(195464, 333333, 10,true,2)
                addPrimeToCircle(6283, 9009, 10,true,2)
                addPrimeToCircle(26612, 37037, 10,true,2)
                addPrimeToCircle(276545, 333333, 10,true,2)
                addPrimeToCircle(310582, 333333, 10,true,2)
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
