import QtQuick 2.0
import Athenum 1.0 
import QtQuick.Controls 2.2

Item {
    id: primesCombo

    ListModel{
        id: primeModel
    }
    ComboBox{
        id: innerCombo
        model: primeModel
    }
    property string text: innerCombo.currentText

    function setPrime(primeNum){
        var p = primes.getPrimesList(1,100)
        for (var i = 0; i < p.length; ++i){
            if (p[i] === primeNum){
                innerCombo.currentIndex = i
                console.log("Prime combo set to ",i)
                break;     
            }
        }
        console.log("Failed to find?", primeNum)
    }

    Component.onCompleted: {
        primeModel.clear()
        var p = primes.getPrimesList(1,100)
        for (var i = 0; i < p.length; ++i){
            primeModel.append({text:p[i]})
        }
    }
    Primes{
        id: primes
        Component.onCompleted: {
        }
    }
}


