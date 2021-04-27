import QtQuick 2.0

Rectangle{
    id: area
    height: 150
    width: parent.width
    border.color: 'lightgreen'
    MouseArea{
        anchors.fill: parent
        onDoubleClicked: {
            area.grabToImage(function(result) {
                                     result.saveToFile("pageClipboard.png");
                                     copyClipboard.copyImageSrc(result.image)
                                        console.log("Image saved to pageClipboard.png and copied")
                                 });
        }
    }
}


