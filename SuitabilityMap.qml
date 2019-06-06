import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Rectangle {
        id: rectangle
        color: "#ca8787"
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ca8787"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        anchors.fill: parent

        Text {
            id: element
            color: "#fdfdfd"
            text: qsTr("Suitability Map")
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 24
        }
    }
}

/*##^## Designer {
    D{i:1;anchors_height:200;anchors_width:200;anchors_x:227;anchors_y:210}
}
 ##^##*/
