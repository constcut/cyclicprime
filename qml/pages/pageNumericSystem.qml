import QtQuick 2.12
import QtQuick.Controls 2.2
import Athenum 1.0

import '../components'

Item {
    id: pageNumericSystems

    property string athName: "Numeric systems"
    property int requestedWidth: width
    property int requestedHeight: 500
    property string descriptionText: "Numerical systems - translation from one to another"

    NumericSystem{
        id: translator
    }

    TextField{
        y:5
        width: parent.width
        placeholderText: "Input number to translate it"
        id: numberInput
        horizontalAlignment: TextInput.AlignHCenter
        onEditingFinished: {

            var indexDivisor = numberInput.text.indexOf("/")
            var indexDot = numberInput.text.indexOf(".")
            var indexSpace = numberInput.text.indexOf(" ")

            if ((indexDivisor === -1) && (indexDot === -1) && (indexSpace === -1))
                result.text = translator.translate(numberInput.text, originBase.currentIndex, destBase.currentIndex)
            else if (indexDivisor != -1){
                result.text = translator.translateRational(numberInput.text, originBase.currentIndex, destBase.currentIndex)
            }
            else if (indexDot != -1){
                result.text = translator.translateFraction(numberInput.text, originBase.currentIndex, destBase.currentIndex)
            }
            else if (indexSpace != -1){
                result.text = translator.translateSepparated(numberInput.text, originBase.currentIndex, destBase.currentIndex)
            }
        }

    }

    ComboBox{
        id: originBase
        y: 55
        x: 5
        model:1000
        currentIndex: 10
    }
    ComboBox{
        id: destBase
        y: 55
        x: parent.width/2
        model:1000
        currentIndex: 2
    }

    Text{
        id: result
        font.pixelSize: 20
        y: 120
        anchors.horizontalCenter: parent.horizontalCenter
        color:'darkgreen'
    }

    WikiLink{
        x: parent.width - width - 30
        y: 120
        link: 'https://en.wikipedia.org/wiki/Numeral_system'
        pageName: 'Scale of notation'
    }


}
