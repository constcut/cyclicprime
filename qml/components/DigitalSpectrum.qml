import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: digitalSpectrumItem

    function plot(listOfDigits){
        digSpec.text = "Digital spectrum: [" + listOfDigits + "]"
        specRep.model = listOfDigits.length

        var maxSpec = 0
        for (var i = 0; i < specRep.model; ++i)
            if (listOfDigits[i] > maxSpec)
                maxSpec = listOfDigits[i]

        for (i = 0; i < specRep.model; ++i){
            var digit = listOfDigits[i]
            if (digit === 0)
                specRep.itemAt(i).height = 1
            else{
                var height = 100*(digit/maxSpec)
                specRep.itemAt(i).height = height
            }
            specRep.itemAt(i).digit = digit
        }
    }
    Text{ 
        id: digSpec
        text:"Digital spectrum: "
    }
    Repeater{
        id: specRep
        model: 0
        Rectangle{
            id: innerRect
            x: index*(pageFullReptendPrime.width/specRep.model) 
            y: 30
            width: 30
            height: 100
            color: 'green'
            property int digit: -1
            Text{
                text: digit 
            }
        }
        anchors.fill: parent
    }
}
