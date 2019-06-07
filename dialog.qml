import QtQuick 2.10
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4

Dialog {
    id: addLayerDialog

    Rectangle {
        id: rectangle
        color: "#ffffff"
        anchors.fill: parent

        Rectangle {
            id: naveBackground
            height: 40
            color: "#aa9595"
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            RowLayout {
                id: rowLayout3
                anchors.fill: parent
            }
        }

        Rectangle {
            id: minBackground
            height: 40
            color: "#857171"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: naveBackground.bottom
            anchors.topMargin: 0

            RowLayout {
                id: rowLayout2
                anchors.fill: parent
            }
        }

        Rectangle {
            id: maxBackground
            height: 40
            color: "#aa9595"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: minBackground.bottom
            anchors.topMargin: 0

            RowLayout {
                id: rowLayout1
                anchors.fill: parent
            }
        }

        Rectangle {
            id: controlsBackground
            height: 40
            color: "#c3aeae"
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: maxBackground.bottom
            anchors.topMargin: 0

            RowLayout {
                id: rowLayout
                anchors.fill: parent

                RoundButton {
                    id: roundButton
                    width: 80
                    text: "Cancel"
                    visible: true
                    Layout.fillHeight: false

                }

                RoundButton {
                    id: acceptButton
                    width: 80
                    text: "Accept"
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }
        }
    }
}
