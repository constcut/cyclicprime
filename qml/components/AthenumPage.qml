import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import Athenum 1.0

Item {

    id: athenumPage
    property string url : ""
    property string md5hash: ""

    property bool autoRefresh: true

    signal urlWasEdited()
    signal changeTabTitle(var newTitle)

    signal requestToOpenPage(var pageName)
    signal requestToOpenUrl(var pageUrl, var jsonObject)


    function helpPressed(){
        if (mainLoader.item.helpPressed !== undefined)
        mainLoader.item.helpPressed()
    }

    function resizePage(width, height) {
        if (athenumPage.width > mainLoader.item.width)
            mainLoader.item.width = athenumPage.width
        if (athenumPage.height > mainLoader.item.height)
            mainLoader.item.height = athenumPage.height
    }

    function loadNewUrl(newUrl, jsonObject){
        newUrl.replace("file://","file:///") //dirty hot fix
        athenumPage.url =  newUrl
        fileField.text = athenumInfo.cutShortURL(newUrl)
        var moment = Date.now()

        if (jsonObject !== undefined)
            mainLoader.setSource(athenumPage.url + "?t=" + moment, jsonObject)
        else
            mainLoader.setSource(athenumPage.url + "?t=" + moment)

        if (mainLoader.item.athName !== undefined)
            athenumPage.changeTabTitle(mainLoader.item.athName)
        else
            athenumPage.changeTabTitle("..")

        if (mainLoader.item.requestedWidth)
            mainFlick.contentWidth = mainLoader.item.requestedWidth
        else
            mainFlick.contentWidth = 1280 

        if (mainLoader.item.requestedHeight)
            mainFlick.contentHeight = mainLoader.item.requestedHeight
        else
            mainFlick.contentHeight = 720

        var hash = athenumInfo.md5fromFile(athenumPage.url)
        athenumPage.md5hash = hash

        if (athenumPage.autoRefresh)
            changeCheck.running = true
    }

    Timer{
        id: changeCheck
        interval: 2000
        repeat: true
        running: false
        onTriggered: {
           var hash = athenumInfo.md5fromFile(athenumPage.url)
           if (hash !== athenumPage.md5hash){
               loadNewUrl(athenumPage.url) //reloading QML on edit
           }
        }
    }

    TextField{
        id: fileField
        width: parent.width
        onEditingFinished: {
            if (fileField.text) {
                loadNewUrl(athenumInfo.extendURL(fileField.text))
                athenumPage.urlWasEdited()
            }
        }
        visible: false
    }

    Flickable {
        id:mainFlick
        y: fileField.height
        width: parent.width
        height: parent.height - y
        contentWidth: athenumPage.width
        contentHeight: athenumPage.height
        ScrollBar.vertical: ScrollBar { active: true }

        onContentYChanged: {
            if (mainLoader.item)
                if (mainLoader.item.flickContentY !== undefined){
                    mainLoader.item.flickContentY = contentY
                    mainLoader.item.insureVisibility()
                }
        }

        Loader{
            id: mainLoader
            anchors.fill: parent
        }
    }

}


