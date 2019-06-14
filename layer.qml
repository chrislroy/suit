import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.5


Item {

    id: layerDelegate
    width: 300
    height: 80

    Rectangle {
        id: imageRect
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
            source: "missing_thumbnail.png"
            fillMode: Image.PreserveAspectFit

            onStatusChanged: {
                if (image.status == Image.Error) {
                    console.log('****** Error loading map thumbnail')
                }
            }
        }

    }

    Rectangle {
        id: controlsRect
        color: "red"

        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: imageRect.right
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.top: parent.top
        anchors.topMargin: 0


        ColumnLayout {
            id: columnLayout
            anchors.fill: parent

            Rectangle {
                id: topRowBG
                width: 200
                Layout.preferredHeight: layerDelegate.height / 3
                Layout.fillWidth: true
                color: "red"
                RowLayout {
                    id: topRowLayout

                    Text {
                        id: layourName
                        color: "#c95f65"
                        text: "layour name"
                    }

                    Button {
                        id: deleteButton
                        width: 15
                        height: 15
                        text: qsTr("-")
                    }


                    Button {
                        id: editButton
                        width: 15
                        height: 15
                        text: qsTr("+")
                    }

                }
            }

            Rectangle {
                id: middleRowBG
                width: 200
                color: "yellow"
                Layout.preferredHeight: layerDelegate.height / 3
                Layout.fillWidth: true
                RowLayout {
                    id: middleRowLayout

                    Text {
                        id: weightSlider
                        text: qsTr("Weight")
                        font.bold: true
                        font.pixelSize: 12
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Text {
                        id: weight
                        text: qsTr("##")
                        font.pixelSize: 12
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    }
                }
            }

            Rectangle {
                id: bottomRowBG
                width: 200
                color: "blue"
                Layout.fillWidth: true
                Layout.preferredHeight: layerDelegate.height / 3
                Slider {
                    id: slider

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    from: 0
                    value: parseFloat(weight) * 100
                    to: 100

                    onPressedChanged: {
                        if(pressed)
                            return;
                        sliderValue = value / 100;
                        //console.log(sliderValue);
                        var layer = JSON.parse(layerModel.get(index).json);
                        layer["Weight"] = sliderValue;
                        //console.log(currentMapIndex);
                        var mapsJson = JSON.parse(maps);
                        var currentMap = mapsJson[currentMapIndex];
                        //console.log(JSON.stringify(currentMap["SuitabilityMap"]["SoftCostLayers"][index]));
                        //console.log(JSON.stringify(layer));
                        currentMap["SuitabilityMap"]["SoftCostLayers"][index] = layer;
                        var test = {
                            "File": fixFilePath(currentMap["File"]),
                            "ColorTheme":currentMap["SuitabilityMap"]["ColorTheme"],
                            "Enabled":currentMap["SuitabilityMap"]["Enabled"],
                            "Thumbnail":currentMap["SuitabilityMap"]["Thumbnail"],
                            "Version":currentMap["SuitabilityMap"]["Version"],
                            "Name":currentMap["SuitabilityMap"]["Name"],
                            "SoftCostLayers":currentMap["SuitabilityMap"]["SoftCostLayers"]
                        }
                        //console.log("**********************************************")
                        //console.log(JSON.stringify(test));
                        var updatedMap = [];
                        updatedMap.push(test);
                        //console.log(JSON.stringify(updatedMap));
                        applicationData.onSuitabilityMapChange(JSON.stringify(test));
                    }

                }
            }


        }


    }

}
/*##^## Designer {
    D{i:1;anchors_height:0}
}
 ##^##*/
