import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0
import QtQml 2.12

import '../components'

Item {

    id: pagePrime

    property string athName: "Prime factorization"
    property int requestedWidth: width
    property int requestedHeight: 800
    property string descriptionText: "Some prime factorization operations"

    TextField{
        y:5
        width: parent.width
        placeholderText: "Input number to check is it prime or decompose it"

        id: primeInput

        horizontalAlignment: TextInput.AlignHCenter

        onEditingFinished: {
            var list = primes.decompose(primeInput.text, base.text)
            primeOutput.text = ''
            for (var i = 0; i < list.length; ++i){
                primeOutput.text += list[i]
                if (i !== list.length-1)
                     primeOutput.text += ' * '
            }
            console.log("decompose log",list)
        }


    }

    Primes{
        id: primes
        Component.onCompleted: {
        }
    }
    Rational{
        id: rNum
    }

    Text{
        id: primeOutput
        y:60
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 20
    }
    WikiLink{
        x: parent.width - width - 30
        y: 60
        link: 'https://en.wikipedia.org/wiki/Prime_number'
        pageName: 'Prime number'
    }


    TextField{
        y: 100
        id: num
        placeholderText: "num"
        text: "1"
    }
    TextField{
        y: 100
        x: 150
        id: den
        placeholderText: "den"
        text: "7"
    }

    TextField{
        y: 100
        x: 350
        id: base
        placeholderText: 'base scale'
        text: '10'
    }


    TextField{
        y: 100
        x: 800
        id: num2
        placeholderText: "num alt spec"
        text: "1"
    }
    TextField{
        y: 100
        x: 950
        id: den2
        placeholderText: "den alt spec"
        text: "7"
    }

    TextField{
        y: 100
        x: 1050
        id: base2
        placeholderText: 'base alt scale'
        text: '10'
    }


    Button{
        y: 200
        text: "Decompose"
        onClicked: {
            prList.clear()
            rNum.calc(parseInt(num.text),parseInt(den.text),parseInt(base.text))
            for (var i = 2; i < amount.value; ++i){
                var anotherStep = rNum.intFromFractQML(i)
                var pL = primes.decompose(anotherStep,base.text)
                //console.log('\n\n ',pL,' primes at', i, anotherStep)
                var primeText = ''
                for (var j = 0; j < pL.length; ++j){
                    primeText += pL[j]
                    if (j !== pL.length-1)
                        primeText += ' * '
                }

                var red = 0
                var green = 0.5
                var blue = 0

                if (i % 6 === 2){
                    red = 0; blue = 0.01; green = 0.5
                }
                if (i % 6 === 3){
                    red = 0; blue = 0.5; green = 0.01
                }
                if (i % 6 === 4){
                    red = 0.5; blue = 0.01; green = 0.01
                }
                if (i % 6 === 5){
                    red = 0.3; blue = 0.3; green = 0.01
                }
                if (i % 6 === 0){
                    red = 0.3; blue = 0.01; green = 0.3
                }
                if (i % 6 === 1){
                    red = 0; blue = 0.03; green = 0.3
                }

                prList.append({'texts':primeText,'red':red,'green':green,'blue':blue})
            }
        }
    }

    Slider{
        y: 100
        x: 550
        value: 10
        from: 10
        to: 700
        id: amount
        stepSize: 1
        ToolTip {
            parent: amount.handle
            visible: amount.hovered
            text: 'Elements amount: ' + amount.value
        }
    }

    Button{
        y: 250
        visible: false
        text: "Find by spectrum" //yet for only 6 - blocked
        onPressed: {
            prList.clear()
            rNum.calc(parseInt(num2.text),parseInt(den2.text),parseInt(base2.text))
            var spectrum = rNum.digitSpectrum('fract')

            rNum.calc(parseInt(num.text),parseInt(den.text),parseInt(base.text))

            for (var i = 2; i < amount.value; ++i){
                var anotherStep = rNum.intFromFractQML(i)
                var pL = primes.decWithSpec(anotherStep,spectrum,parseInt(base2.text))


                if (pL.length){
                    console.log(pL,pL.length, i, i/7, anotherStep)
                    var primeText = pL.join(' * ')
                    var red = 0
                    var green = 0.4
                    var blue = 0.01
                    prList.append({'texts':primeText,'red':red,'green':green,'blue':blue})
                }
            }

            console.log(prList.length, " total len")

        }
    }

    ListModel{
        id: prList
    }

    ListView{
        model: prList
        y:150
        x: 120
        width: parent.width/2
        height: parent.height - 150
        delegate: Rectangle{
            TextField{
                id: pTexts
                text: texts
                font.pixelSize: 20
                color: Qt.rgba(red,green,blue)
                width: pagePrime.width
                cursorPosition: 0
            }
            height: 40
            width: pagePrime.width
            border.color: 'lightgray'
        }
    }


}
