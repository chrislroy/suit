import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4

Window {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property string suitabilityMap: ""
    property int currentMap: -1
    property string thumbnail: ""

    // functions
    function toQrc(s) {
        return s.replace("img://file/", "file:///");
    }

    function toColor(s) {
        return s.replace("0x", "#");
    }

    Row {
        id: activateMaps
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors {
            top: parent.top
        }

        Text {
            text: "Activate Maps"
            anchors.left: parent.left
            anchors.leftMargin: 15
            font.family: "Times New Roman"
            font.bold: false
            font.pointSize: 19
            font.wordSpacing: -0.1
            anchors.verticalCenter: parent.verticalCenter
            Layout.fillWidth: true
        }
        Switch {
            anchors.right: parent.right
            anchors.rightMargin: 15
            onClicked: console.log("Switch clicked:" + checked)
        }

    }

    Row {
        id: mapsSelector
        height: 80
        anchors.top: activateMaps.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Rectangle {
            id: selectorBackground
            color: "#21211e"
            anchors.fill: parent

            Image {
                id: mapThumbnail
                y: 40
                width: 70
                height: 70
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter

                source: toQrc(thumbnail)
                fillMode: Image.PreserveAspectFit
            }

            ComboBox {
                id: mapSelector
                x: -240
                y: 20
                anchors.right: mapEdit.left
                anchors.rightMargin: 100
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                id: mapEdit
                x: -100
                y: 12
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }

        }
    }

    Row {
        id: costGradient
        height: 80
        anchors.top: mapsSelector.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        Rectangle {
            id: costGradiantBackground
            color: "white"

            Text {
                id: costGradientLabel
                color: "#21211e"
                text: "Cost Gradient"
                anchors.left: parent.left
                anchors.leftMargin: 15
                font.bold: true
                font.pointSize: 19
                anchors.top: parent.top
                anchors.topMargin: 11
            }

            Rectangle {
                id: gradientRectangle
                anchors.top: costGradientLabel.bottom
                anchors.topMargin: 5
                anchors.left : parent.left
                anchors.leftMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 11
                Gradient {

                    GradientStop { position: 0.0; color: "#640000ff" }
                    GradientStop { position: 0.25; color: "#8000ff00" }
                    GradientStop { position: 0.5; color: "#a5ffff00" }
                    GradientStop { position: 0.75; color: "#e2ff5a00" }
                    GradientStop { position: 1.0; color: "#f0ff0000" }
                }
            }


        }
    }

    Row {
        id: layers
        height: 40
        anchors.top: costGradient.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Rectangle {
            id: rectangle1
            anchors.fill: parent
            color: "#21211e"
            Text {
                text: "Layers"
                font.bold: true
                font.pointSize: 19
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
            }
        }
    }

    ListModel {
        id: layerModel
    }

    Component {
        id: layerDelegate

        Rectangle {
            id: layer
            height: 80
            property double sliderValue : 0
            anchors {
                left: parent.left
                right:parent.right
            }

            Rectangle {
                id: rectangle
                width: 80
                height: 80
                color: "#ffffff"
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0

                Image {
                    id: image
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 5
                    anchors.topMargin: 5
                    anchors.fill: parent
                    source: toQrc(thumbnail)
                    fillMode: Image.PreserveAspectFit
                }

            }

            Rectangle {
                id: sliderRect
                color: "#ffffff"
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: rectangle.right
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 80
                anchors.top: parent.top
                anchors.topMargin: 0

                Slider {
                    id: slider
                    height: 14
                    anchors.top: parent.top
                    anchors.topMargin: 57
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    from: 0
                    value: parseFloat(weight) * 100
                    to: 100
                    onValueChanged: {
                        sliderValue = value / 100;
                        //var t = JSON.parse(object);
                        object["Weight"] = sliderValue;
                        var s = JSON.stringify(object)
                        console.log(s);
                        applicationData.onLayerChange(s)
                        console.log(sliderValue)
                    }

                }


                Text {
                    id: layerName
                    color: "#c95f65"
                    text: name
                    anchors.top: parent.top
                    anchors.topMargin: 7
                    font.bold: true
                    lineHeight: 1.1
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    font.pixelSize: 12
                }
                Text {
                    id: weightSlider
                    text: qsTr("Weight")
                    anchors.top: parent.top
                    anchors.topMargin: 29
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    font.bold: true
                    font.pixelSize: 12
                }
            }
        }

    }


    ListView {
        id: layerList
        model: layerModel
        delegate: layerDelegate

        anchors {
            top: layers.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

    }
}













/*##^## Designer {
    D{i:1;anchors_height:200;anchors_width:200;anchors_x:227;anchors_y:210}D{i:6;anchors_x:-240}
D{i:7;anchors_x:-240}D{i:5;anchors_height:200;anchors_width:200}
}
 ##^##*/
