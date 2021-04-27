import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: expendableLoaderItem

    width: parent.width

    property string source : ""
    property bool preLoad: false
    property string jsonStr: ""

    Component.onCompleted: {
        if (preLoad) {
            reload()
        }
    }

    function reload() {
            animateOpacity1.start()
            animateColor1.start()
            animateSize1.start()
            showLoader.alreadyLoaded = 0 

            var jsonOb = null
            if (jsonStr.length > 0)
                jsonOb = JSON.parse(jsonStr);

            //console.log("Pushing loader with json ",jsonStr)
            var moment = Date.now() 
            loader.setSource(expendableLoaderItem.source + "?t=" + moment, jsonOb)
            //console.log("Loader setten ", expendableLoaderItem.source)
            showLoader.start()
    }

    Rectangle{
        id:baseRectangle
        width: parent.width
        height: button.height
        border.color: 'lightgray'
        RoundButton{
            anchors.centerIn: parent
            id: button
            text: "+"
            onClicked:{
                animateOpacity1.start()
                animateColor1.start()
                animateSize1.start()
                showLoader.alreadyLoaded = 0 
                loader.setSource(expendableLoaderItem.source)
                showLoader.start()
            }
        }

        Loader{
            id: loader
            visible: false
            anchors.fill: parent
            onLoaded: {
                showLoader.alreadyLoaded = 1
            }
        }
    }

    Timer{
        repeat: false
        running: false
        interval: 200
        id: showLoader
        property int alreadyLoaded: 0

        onTriggered: {
            animateColor2.start()
            animateOpacity2.start()
            loader.visible = true
            baseRectangle.border.color = 'green'
        }
    }

    PropertyAnimation {
        id: animateOpacity1
        target: loader
        property: "opacity"; to: 1
        duration: 200
    }

    PropertyAnimation {
        id: animateOpacity2
        target: button
        property: "opacity"; to: 0
        duration: 200
    }
    PropertyAnimation {
        id: animateColor1
        target: baseRectangle
        properties: "color"; to: "lightgray"
        duration: 200
    }
    PropertyAnimation {
        id: animateColor2
        target: baseRectangle
        properties: "color"; to: "white"
        duration: 200
    }
    PropertyAnimation {
        id: animateSize1
        target: baseRectangle
        properties:"height"; to: 300
        duration: 400
    }
    PropertyAnimation {
        id: animateSize2
        target: baseRectangle
        properties:"width"; to: 800
        duration: 400
    }

}
