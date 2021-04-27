import QtQuick 2.12
import QtQuick.Controls 2.5
import Athenum 1.0

import QtQuick.Layouts 1.12

import '../components'

Item {
    id: pageFullReptendPrime



    property string athName: "Full reptend prime"
    property int requestedWidth: width
    property int requestedHeight: 2400
    property string descriptionText: "This page shows some of the regularities related to the theme full reptend prime.\nLater here could be a mask for input params to make initial runs."

    Text{
        anchors.horizontalCenter:  parent.horizontalCenter
        text: "Full reptend prime"
        font.pixelSize: 18
        id: mainText
    }

    ListModel{
        id: primeModel
    }

    property int prime: 1
    property int numericSystem: 10

    ComboBox{
        id: baseCombo
        model: [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
        currentIndex: 8
        onCurrentIndexChanged: {
            pageFullReptendPrime.numericSystem = baseCombo.currentIndex+2
            loadPrime()
        }
    }

    WikiLink{
        x: primeCombo.x - 100
        link: 'https://en.wikipedia.org/wiki/Full_reptend_prime'
        pageName: 'Full reptend prime'
    }

    ComboBox{
        id: primeCombo
        x: parent.width - width - 10
        model: primeModel

        displayText: primeCombo.currentIndex === -1 ? 'Select prime:' : primeCombo.currentText

        function fillPrimes(){ 
           primeModel.clear()
           primeModel.append({text:'3'})
           primeModel.append({text:'5'}) 
           primeModel.append({text:'7'})
           primeModel.append({text:'11'})
           primeModel.append({text:'13'})
           primeModel.append({text:'17'})
           primeModel.append({text:'19'})
           primeModel.append({text:'23'})
           primeModel.append({text:'29'})
           primeModel.append({text:'31'})
           primeModel.append({text:'37'})
           primeModel.append({text:'47'})
           primeModel.append({text:'59'})
           primeModel.append({text:'61'})
           primeModel.append({text:'89'})
           primeModel.append({text:'97'})
           primeModel.append({text:'127'})
        }

        onCurrentIndexChanged: {
            if (primeCombo.currentIndex === -1) return
            var primeNumber = parseInt(primeModel.get(primeCombo.currentIndex).text)
            pageFullReptendPrime.prime = primeNumber
            loadPrime()
            //autoSum.jsonStr = "{\"prime\":" + pageFullReptendPrime.prime.toString() +"}";
            //autoSum.reload()
            //eLo.jsonStr = "{\"prime\":" + pageFullReptendPrime.prime.toString() +",\"primeTypeStr\":\"sub\",\"dontScroll\":true}";
            //eLo.reload()
            //console.log("All reloading done")
        }
    }

    Component.onCompleted: {
        primeCombo.fillPrimes()
        //console.log("FRP: ", prime, numericSystem)
        if (numericSystem >= 2)
            baseCombo.currentIndex = numericSystem-2
        if (prime !== 1){
            loadPrime()
        }
    }

    function loadPrime(){
        var primeNumber = pageFullReptendPrime.prime
        var base = pageFullReptendPrime.numericSystem
        if (typeof primeNumber !== "number")
            return
        number.calc(1,primeNumber,base)
        mainText.text = number.getFullString()
        spectrumArea.display()
        regularityArea.display()
        remainsArea.display()
        cyclicArea.display()
        cycleArea.display() //достаточно быстро
        scalesArea.display() //долговато
        vtableCircles.display()
    }

    property var number

    Rational{
        id: number
    }


    PageArea{
        y: 50
        id: spectrumArea
        function display(){
            var dSpec = number.digitSpectrum('fract')
            digSpec.plot(dSpec)
        }
        DigitalSpectrum{
            id: digSpec
            x: 10
        }
    }

    PageArea{
        y: 210
        id: remainsArea
        function display(){
            var rem = number.remains()
            remText.text = "Remains: [" + rem + "]"
            digitsCircle.set(rem, pageFullReptendPrime.prime, number.getPeriod() > 0, true)
            //digitsCircle.setDotColor("#ff0000")
            //digitsCircle.setLineColor("#ff0000")
            //digitsCircle.setLineWidth(3)
        }
        Text{
            id: remText
            text: "Remains: "
        }


        DigitalCircle{
            id: digitsCircle
            anchors.horizontalCenter: parent !== null ? parent.horizontalCenter : null
            y: 5
            width: parent !== null ? parent.height-10 : 10
            height: parent !== null ? parent.height-10 : 10
            Component.onCompleted: {
                digitsCircle.setRadius((digitsCircle.height-40)/2)
            }
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                  var jStr = digitsCircle.exportJson()
                  console.log("Exported str ", jStr)
                  digitsCircle.importJson(jStr)
                  digitsCircle.startAnimation()
                }
            }
        }
    }


    PageArea{
        y: 370
        id: regularityArea
        function display(){
            var reg = number.regularity('period')
            regular.plot(reg)
        }
        Regularity{
            id: regular
            x: 10
        }
    }


    PageArea{
        y: 520
        id: cyclicArea
        property string walkaround : ''
        function display(){
            var isCyclic = number.isCyclic()
            if (isCyclic){
                cyclicText.text = "Number is cyclic and got " + number.getAmountOfCycles() + " cycles, each cycle got period " + number.getPeriod()
                var multiplyShift = number.multiplyShift()
                var mListStr = "[" + multiplyShift.join() + "]"
                cyclicText.text += "\nMuliply shifts: " + mListStr
                mShiftsCircle.set(multiplyShift, number.getPeriod(), true, false)
                var vTab = number.verticalTables()
                var lenCols = vTab.length
                var lenRows = vTab[0].length
            }
            else
                cyclicText.text = 'Number is not cyclic'
        }
        Text{
            id: cyclicText
            text: "Cyclic: "
        }
        DigitalCircle{
            id: mShiftsCircle
            anchors.horizontalCenter: parent !== null ? parent.horizontalCenter : null
            y: 10
            width:  parent !== null ? parent.height - 20 : 10
            height:  parent !== null ? parent.height - 20 : 10
            Component.onCompleted: {
                setRadius((height-40)/2)
            }
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                    mShiftsCircle.startAnimation()
                }
            }

        }

    }


    PageArea{
        id: vtableCircles
        y:680
        height: 200
        Text{
            text: ""
        }
        function display(){
            var vTab = number.verticalTables()
            vtableRep.model = vTab.length
            vcirclesFlick.contentWidth = (vTab.length/7.0)* vtableCircles.width
            for (var i = 0; i < vTab.length; ++i){
                    var list = vTab[i]
                    vtableRep.itemAt(i).set(list,baseCombo.currentIndex+2,true,true)
                }
            }
            Flickable {
                id: vcirclesFlick
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: 200
                ScrollBar.horizontal: ScrollBar { active: true }
                Repeater{
                    id: vtableRep
                    model: 0
                    DigitalCircle{ 
                        id: vtabCircle
                        x: (vtableRep.width / vtableRep.model )*index + 10
                        y: 20
                        width: 150
                        height: 150
                        Component.onCompleted: {
                            setRadius((height-40)/2)
                        }

                        MouseArea{
                            anchors.fill: parent
                            onDoubleClicked: {
                                for (var i = 0; i < vtableRep.model; ++i){
                                    vtableRep.itemAt(i).startAnimation()
                                }  
                            }
                        }
                    }
                    anchors.fill: parent
                }
            }
        }

    PageArea{
        y: 890
        height: 200
        id: scalesArea
        Rational {
            id: rNum
        }
        function display(){
            var scalesPeriod = number.scalesPeriod()
            scalesText.text = 'Scales period: [' + scalesPeriod.join() +']'
            /* //TODO load by a timer, takes few seconds
            scalesRep.model = scalesPeriod.length * 3 
            scalesFlick.contentWidth = (scalesPeriod.length*3/7.0)* scalesArea.width
            for (var i = 0; i < scalesPeriod.length*3; ++i){
                rNum.calc(1, pageFullReptendPrime.prime, i+2)
                var digits = rNum.intDigits('fract') 
                if (i < scalesPeriod.length)
                    scalesRep.itemAt(i).set(digits, i+2, true, false)
                else
                    scalesRep.itemAt(i).set(digits, i+2, true, true) //oroborus
            }*/
        }
        Text{
            id: scalesText
            text: "Scales period: "
        }
        Flickable {
            id: scalesFlick
            anchors.fill: parent
            contentWidth: parent.width * 4
            contentHeight: 200
            ScrollBar.horizontal: ScrollBar { active: true }
            Repeater{
                id: scalesRep
                model: 0
                DigitalCircle{
                    id: scalesCircle
                    x: (scalesRep.width / scalesRep.model ) * index
                    y: 20
                    width: 150 
                    height: 150
                    Component.onCompleted: {
                        setRadius((height-40)/2)
                    }
                    MouseArea{
                        anchors.fill: parent
                        onDoubleClicked: {
                            console.log("Starting scales " + scalesRep.model)
                            for (var i = 0; i < scalesRep.model; ++i){
                                scalesRep.itemAt(i).startAnimation()
                            }
                        }
                    }
                }
                anchors.fill: parent
            }
        }
    }


    PageArea{
        id: cycleArea
        y:1100
        height: 200
        Rational {
            id: tempNumber
        }
        function display(){
            cycleRep.model = pageFullReptendPrime.prime-1 
            cycleFlick.contentWidth = ((pageFullReptendPrime.prime-1)/7.0)* scalesArea.width
            for (var i = 0; i < pageFullReptendPrime.prime-1; ++i){
                tempNumber.calc(i+1,pageFullReptendPrime.prime,baseCombo.currentIndex+2)
            var digits = tempNumber.intDigits('fract')
            var oroborus = true
            if (baseCombo.currentIndex+2 < pageFullReptendPrime.prime)
                oroborus = false
            cycleRep.itemAt(i).set(digits,baseCombo.currentIndex+2,true,oroborus)
            }
        }
        Flickable { 
            id: cycleFlick
            anchors.fill: parent
            contentWidth: parent.width * 4
            contentHeight: 200
            ScrollBar.horizontal: ScrollBar { active: true }
            Repeater{
                id: cycleRep
                model: 0
                DigitalCircle{
                    id: localDigitCircle
                    x: (parent.width / cycleRep.model )*index
                    y: 20
                    width: 150
                    height: 150
                    Component.onCompleted: {
                        localDigitCircle.setRadius((localDigitCircle.height-40)/2)
                    }


                    MouseArea{
                        anchors.fill: parent
                        onDoubleClicked: {
                            for (var i = 0; i < cycleRep.model; ++i){
                                cycleRep.itemAt(i).startAnimation()
                            }
                        }
                    }
                }
                anchors.fill: parent
            }
        }
    }

}
