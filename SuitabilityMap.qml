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

    Connections {
        target: applicationData
        onMapChanged: {
            console.log("Got map changed " + applicationData.map)
            onMapChanged(applicationData.map)
        }
    }

    function onMapChanged(map) {
        console.log(map);

        suitabilityMap = map;
    }

    // functions
    function toQrc(s) {
        return s.replace("img://file/", "file:///");
    }

    function toColor(s) {
        return s.replace("0x", "#");
    }

    Rectangle {
        id: activeMapsBackground
        color: "white"
        height: 40
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        RowLayout {
            id: activateMaps
            height: 40

            anchors.fill:parent

            Text {
                id: activeMapsLabel
                height: 23
                color: "#797979"
                text: "Activate Maps"
                Layout.leftMargin: 15
                font.bold: true
                font.pointSize: 19
                font.wordSpacing: -0.1
            }
            Switch {
                id: activeMapsSwitch
                Layout.rightMargin: 15
                Layout.leftMargin: 1
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                onClicked: console.log("Switch clicked:" + checked)
            }
        }
    }

    Rectangle {
        id: selectorBackground
        color: "#2e2e2e"
        height: 80
        anchors {
            top: activeMapsBackground.bottom
            left: parent.left
            right: parent.right
        }

        RowLayout {
            id: mapsSelector

            anchors.fill:parent


            Image {
                id: mapThumbnail
                y: 40
                width: 70
                height: 70
                Layout.preferredWidth: 80
                Layout.bottomMargin: 5
                Layout.topMargin: 5
                Layout.fillHeight: true
                Layout.fillWidth: false
                source: "map-thumbnail.png"
                Layout.leftMargin: 15
                fillMode: Image.PreserveAspectFit
            }

            ComboBox {
                id: mapSelector
                x: -240
                y: 20
                Layout.leftMargin: 50
                Layout.fillWidth: true
            }

            Button {
                id: mapEdit
                x: -100
                y: 12
                width: 20
                height: 20
                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }

        }
    }
    Rectangle {
        id: costGradiantBackground
        color: "white"
        anchors.topMargin: 0
        height: 80
        anchors {
            top: selectorBackground.bottom
            left: parent.left
            right: parent.right
        }
        RowLayout {
            id: costGradient
            anchors.fill:parent

            Text {
                id: costGradientLabel
                color: "#797979"
                text: "Cost Gradient"
                Layout.topMargin: 5
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: 15
                font.bold: true
                font.pointSize: 19
            }

            Rectangle {
                id: gradientRectangle
                Layout.bottomMargin: 5
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.fillWidth: true
                gradient : Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#640000ff" }
                    GradientStop { position: 0.25; color: "#8000ff00" }
                    GradientStop { position: 0.5; color: "#a5ffff00" }
                    GradientStop { position: 0.75; color: "#e2ff5a00" }
                    GradientStop { position: 1.0; color: "#f0ff0000" }
                }
            }
        }
    }

    Rectangle {
        id: layersLabelBackground
        color: "#2e2e2e"
        anchors.top: costGradiantBackground.bottom
        anchors.topMargin: 0
        height: 40
        anchors {
            left: parent.left
            right: parent.right
        }

        RowLayout {
            id: layers
            anchors.fill:parent

            Text {
                text: "Layers"
                Layout.leftMargin: 15
                font.bold: true
                font.pointSize: 19
                color: "#797979"
            }
        }
    }
    Rectangle {
        id: junk
        height: 200
        color: "#cb5d5d"
        anchors.topMargin: 0
        anchors {
            top: layersLabelBackground.bottom
            right: parent.right
            left: parent.left
        }

        Rectangle {
            id: rectangle
            color: "#cb3434"

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#cb3434"
                }

                GradientStop {
                    position: 1
                    color: "#000000"
                }
            }

            anchors.fill: parent
        }
/*
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#cb5d5d"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
*/
    }

    Rectangle {
        id: controlBackground
        width: 40
        anchors.top: junk.bottom
        anchors {
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        RowLayout {
            id: controls
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            anchors.fill:parent

            Button {
                id: applyButton
                text: "Apply"
                Layout.bottomMargin: 0
                Layout.topMargin: 0
                Layout.leftMargin: 15
            }

            Button {
                id: addlayerButton
                width: 0
                text: "Add Layer"
                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }

        }
    }



    /*



    ListModel {
        id: layerModel
    }

    Component {
        id: layerDelegate
        Rectangle {

        }
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
*/

}

































































/*##^## Designer {
    D{i:24;anchors_height:200;anchors_width:200}
}
 ##^##*/
