import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import 'components'

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1280 
    height: 720

    ListModel{
        id: openedTabsList
    }

    property int webGLCounter : 0
    onClosing: {
        if (athenumInfo.isWebGl()){
            if (webGLCounter){
                Qt.quit()}
            ++webGLCounter
        }
    }

    Component.onCompleted: { 
        openedTabsList.append({"pageName":".","pageURL":"/pages/pagePrimeScales.qml","ls":"","prevInd":""})
        //openedTabsList.append({"pageName":".","pageURL":"/pages/pageFullReptendPrime.qml","ls":"","prevInd":""})
        //openedTabsList.append({"pageName":".","pageURL":"/pages/manyRationals.qml","ls":"","prevInd":""})
        //openedTabsList.append({"pageName":".","pageURL":"/pages/pageCircles.qml","ls":"","prevInd":""})
        //openedTabsList.append({"pageName":".","pageURL":"/components/GeometricProgression.qml","ls":"","prevInd":""}) 
        //openedTabsList.append({"pageName":".","pageURL":"/components/IntervalScales.qml","ls":"","prevInd":""})
        //openedTabsList.append({"pageName":".","pageURL":"/pages/pagePrimeFactor.qml","ls":"","prevInd":""})
        //openedTabsList.append({"pageName":".","pageURL":"/pages/pageCyclicPrimes.qml","ls":"","prevInd":""})
        initPages()
    }

    Popup{
        id: newWindowPopup
        ComboBox{ 
            id:newWindowName
            width: 490
            model: ["failed","to load","qml","files"]
            Component.onCompleted: {
                var list = athenumInfo.loadQmlFilesList()
                var subList = list
                for (var i = 0; i < list.length; ++i){
                    var element = list[i]
                    hiddenComboLoader.setSource(athenumInfo.getQMLPath() + element)
                    if (hiddenComboLoader.item !== null) {
                        var pageName = "..."
                        if (hiddenComboLoader.item.athName !== undefined)
                            pageName = hiddenComboLoader.item.athName
                        list[i] = pageName
                    }
                }
                newWindowName.model = list
            }
            Loader{
                visible: false
                id: hiddenComboLoader
            }

            onCurrentTextChanged: {
                var list = athenumInfo.loadQmlFilesList()
                hiddenLoader.setSource(athenumInfo.getQMLPath() + list[currentIndex])
                if (hiddenLoader.item !== null) {
                    if (hiddenLoader.item.descriptionText !== undefined)
                        descriptionArea.text = hiddenLoader.item.descriptionText
                }
            }
        }

        width: 750
        height: 270
        x:100
        y:100

        Button{
            text: "open"
            y: 0
            x: 500
            onPressed: {
                var saveIndex = tabBar.currentIndex
                var list = athenumInfo.loadQmlFilesList()

                var jsonOb
                if (startParams.text.length > 0)
                    jsonOb = JSON.parse(startParams.text);

                openedTabsList.append({"pageName":"New page","pageURL":list[newWindowName.currentIndex],"jObj":jsonOb,"ls":"","prevInd":""})
                tabsRepeater.model = openedTabsList.count
                tabBar.currentIndex = tabsRepeater.model-1
                newWindowPopup.close()
                initPages()
            }
        }
        Button{
            text: "close"
            y: 0
            x: 615
            onPressed: {
               newWindowPopup.close()
            }
        }

        TextArea{
            id: descriptionArea
            y: 70
            x: 0
            placeholderText: "Description would be there if its implemented in qml file"
            width: parent.width
            height: 100
        }
        TextArea{
            id: startParams
            y: 175
            x:0
            height: 120
            width: parent.width
            placeholderText: "{initialParams:values,...}"
        }
        Loader{
            visible: false
            id: hiddenLoader
        }
    }

    Button {
        id: reloadButton
        
        text: ":" 
        width: 25
        x: 0
        onClicked: { 
            var url = mainRepeater.itemAt(tabBar.currentIndex).url
            mainRepeater.itemAt(tabBar.currentIndex).loadNewUrl(url)
        }
    }

    Button {
        x: tabBar.width + 25
        text: "+"
        width: 25
        onClicked: {
            newWindowPopup.open()
        }
        id: outerAdd
    }

    Button {
        x: parent.width - width - 5
        text: "[h?]"
        onClicked: {
            mainRepeater.itemAt(tabBar.currentIndex).helpPressed()
        }
    }

    TabBar {
        id: tabBar
        width: (parent.width-50) > tabBar.contentWidth ? tabBar.contentWidth : parent.width - 50
        x: 25
        Repeater{
            id: tabsRepeater
            model: openedTabsList.count
            TabButton{
                text: openedTabsList.get(index).pageName
                width: implicitWidth
                onDoubleClicked: {
                    openedTabsList.remove(index)
                    tabsRepeater.model = openedTabsList.count
                }
            }
        } 
    }

    function loadNewPage(pageName){
        var list = athenumInfo.loadQmlFilesList()
        var pageUrl = '...'
        for (var i = 0; i < list.length; ++i)
            if (newWindowName.model[i] === pageName) {
                pageUrl = list[i]
            }
        openedTabsList.append({"pageName":"New page","pageURL":pageUrl,"ls":"","prevInd":""}) 
        tabsRepeater.model = openedTabsList.count
        tabBar.currentIndex = tabsRepeater.model-1
        initPages()
    }

    function loadNewUrl(pageUrl){
        openedTabsList.append({"pageName":"New page","pageURL":pageUrl,"ls":"","prevInd":""}) 
        tabsRepeater.model = openedTabsList.count
        tabBar.currentIndex = tabsRepeater.model-1
        initPages()
    }

    function loadNewUrlInit(pageUrl, jStr){
        var jsonOb = null
        if (jStr.length > 0)
            jsonOb = JSON.parse(jStr);

        openedTabsList.append({"pageName":"New page","pageURL":pageUrl,"ls":"","prevInd":"","jObj":jsonOb}) 
        tabsRepeater.model = openedTabsList.count
        tabBar.currentIndex = tabsRepeater.model-1
        initPages()
    }

    Timer{
        interval: 500; running: true; repeat: true
        onTriggered: {
            mainRepeater.itemAt(tabBar.currentIndex).resizePage(pagesLayout.width, pagesLayout.height)
        }
    }

    function initPages(){
        for (var i = 0; i < openedTabsList.count; ++i){
            if (openedTabsList.get(i).ls === "loaded")
                continue
            var pageURL = "file:///" + athenumInfo.getQMLPath() + openedTabsList.get(i).pageURL
            var emptyJson = openedTabsList.get(i).jObj
            mainRepeater.itemAt(i).loadNewUrl(pageURL, emptyJson)
            openedTabsList.get(i).ls = "loaded";
            openedTabsList.get(i).prevInd = i 
        }
        tabBar.currentIndex = openedTabsList.count - 1
    }

    StackLayout {
        y: 5
        anchors.fill: parent
        id: pagesLayout
        currentIndex: tabBar.currentIndex
        Repeater {
            id: mainRepeater
            model: 64
            AthenumPage{id: athenumPageObject
                Component.onCompleted: {
                }
                onUrlWasEdited: {
                    openedTabsList.get(index).pageURL = athenumInfo.cutAppPath(athenumPageObject.url)
                }
                onChangeTabTitle: {
                    if (newTitle){
                        openedTabsList.get(index).pageName = newTitle

                        if (tabsRepeater.itemAt(index))
                            tabsRepeater.itemAt(index).text = openedTabsList.get(index).pageName
                    }
                }
                onRequestToOpenPage:{
                   mainWindow.loadNewPage(pageName)
                }
                onRequestToOpenUrl:{
                   if (typeof jsonObject !== undefined) {
                       mainWindow.loadNewUrlInit(pageUrl, jsonObject)
                   }
                   else
                    mainWindow.loadNewUrl(pageUrl)
                }
            }
            onModelChanged: {
            }
        }
    }
}
