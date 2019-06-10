import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Dialog {
    id: layerDialog
    width: 640
    height: 480


    Rectangle {
        id: layerNameBG
        y: 0
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        Layout.fillWidth: true

        RowLayout {
            id: layerNameLayout
            Text {
                text: "Layer Name"
                Layout.column: 1
                anchors.left: parent.left
                anchors.leftMargin: 5
                font.pointSize: 19
                anchors.verticalCenter: parent.verticalCenter
            }

            TextEdit {
                id: layerName
                font.pointSize: 19
                Layout.column: 1
                property string placeholderText: "New Layer"

                Text {
                    Layout.fillWidth: true
                    text: layerName.placeholderText
                    font.pointSize: 19
                    color: "#aaa"
                    visible: !layerName.text
                }
            }
        }


    }


    Rectangle {
        id: featureSets
        y: 0
        height: 40
        color: "#2b2b2b"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: layerNameBG.bottom
        anchors.topMargin: 0
        Layout.fillWidth: true

        Text {
            id: addFeatureSetsLabel
            color: "#7b7b7b"
            text: qsTr("Add Feature Sets")
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 17
        }
    }




    Rectangle {
        id: featureSetSelectionBG
        y: 0
        height: 160
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: featureSets.bottom
        anchors.topMargin: 0
        Layout.fillWidth: true

        ListView {
            id: listView
            anchors.fill: parent
            delegate:
                Rectangle {
                width: 20
                height: 30
                color: index % 2 == 0 ? "#fbfbfb" : "#ebebeb"
            }

        }


    }


    Rectangle {
        id: layerSettingBG
        y: 0
        height: 40
        color: "#2b2b2b"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: featureSetSelectionBG.bottom
        anchors.topMargin: 0
        Layout.fillWidth: true

        Text {
            color: "#7b7b7b"
            text: "Layer Settings"
            font.pointSize: 19
        }
    }



    Rectangle {
        id: gradientFunctionBG
        y: 0
        height: 40
        color: "#fbfbfb"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: layerSettingBG.bottom
        anchors.topMargin: 0
        Layout.fillWidth: true

        RowLayout {
            id: gradientFunctionLayout


            Text {
                text: "Gradient Function"
                font.pointSize: 19

            }

            ComboBox {
                id: gradientFunction
                x: 371
                y: 8
                Layout.rightMargin: layerDialog.width-100
                font.pointSize: 19
                model: ["Linear"]
            }

        }
    }



    Rectangle {
        id: gradientWidthBG
        y: 0
        height: 40
        color: "#ebebeb"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: gradientFunctionBG.bottom
        anchors.topMargin: 0
        Layout.fillWidth: true

        RowLayout {
            id: gradientWidthLayout
            anchors.fill: parent
            Text {
                text: "Gradient Function"
                font.pointSize: 19

            }

            TextEdit {
                id: gradientWidth
                property string placeholderText: "50 m"
                Layout.rightMargin: layerDialog.width - 100
                Text {
                    Layout.fillWidth: true
                    text: gradientWidth.placeholderText
                    font.pointSize: 19
                    color: "#aaa"
                    visible: !gradientWidth.text
                }
            }
        }
    }




    Rectangle {
        id: offsetAroundFeatureBG
        height: 40
        color: "#fbfbfb"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: gradientWidthBG.bottom
        anchors.topMargin: 0
        Layout.fillWidth: true

        RowLayout {
            id: offsetAroundFeatureLayout
            anchors.fill: parent

            Text {
                text: "Offset Around Feature"
                font.pointSize: 19
            }

            TextEdit {
                id: offset
                property string placeholderText: "0 m"
                color: "#b5b5b5"
                Layout.rightMargin: layerDialog.width - 100
                font.pointSize: 19
                Layout.columnSpan: 1

                Text {
                    Layout.fillWidth: true
                    text: offset.placeholderText
                    font.pointSize: 19
                    color: "#aaa"
                    visible: !offset.text
                }
            }


        }
    }

    Rectangle {
        id: editLayerControlsBG
        height: 40
        anchors {
            top: filler.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        RowLayout {
            id: editLayerControlsLayout
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.fill:parent

            Button {
                id: acceptButton
                text: "      OK     "
                Layout.leftMargin: 15
                onClicked: console.log("Accept")
            }

            Button {
                id: cancelButton
                text: "   Cancel   "
                Layout.rightMargin: parent.width/2
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                onClicked: {
                    console.log("Cancel")
                    layerDialog.open()
                }
            }

        }
    }
}
