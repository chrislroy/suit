import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4

Window {
    id: suitbilityWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property string maps;
    property string currentMap: ""
    property string currentMapIndex: ""

    minimumHeight: 7 * 40 + layerModel.count * 80
    Connections {
        target: applicationData
        onMapChanged: {
            //console.log("Got map changed " + applicationData.map)
            onMapChanged(applicationData.map)
        }
    }


    function onMapChanged(map) {
        console.log(map);

        maps = map;

        updateUi()
    }

    // functions
    function toQrc(s) {
        return s.replace("img://file/", "file:///");
    }

    function toColor(s) {
        return s.replace("0x", "#");
    }

    function isArray (value) {
        return value && typeof value === 'object' && value.constructor === Array;
    }

    function addLayer(layerObj) {
        layerModel.append({
            "object" : layerObj, //JSON.stringify(layerObj),
            "name": layerObj["DisplayName"],
            "weight": layerObj["Weight"],
            "thumbnail": layerObj["Thumbnail"]
        });
    }

    function updateUi() {

        console.log("updateUi: Current map " + maps)
        layerModel.clear();
        mapModel.clear()
        if (maps === "") {
            return;
        }

        var mapsJson = JSON.parse(maps);

        var currentIndex = ""
        for(var j in mapsJson) {
            if (mapsJson[j]["SuitabilityMap"]["Enabled"] && currentIndex === "") {
                currentIndex = j;
            }
            mapModel.append( { mapName : mapsJson[j]["SuitabilityMap"]["Name"] })
        }
        mapModel.append( { mapName : "Create new map..." })

        currentMapIndex = currentIndex;

        // update the layer model
        if (currentMapIndex !== "") {
            mapThumbnail.source = toQrc(mapsJson[currentMapIndex]["SuitabilityMap"]["Thumbnail"]);

            var layers = mapsJson[currentMapIndex]["SuitabilityMap"]["SoftCostLayers"];
            for (var i in layers) {
                console.log("adding layer " + layers[i]["DisplayName"])
                addLayer(layers[i]);
            }

            mapSelector.currentIndex = parseInt(currentMapIndex, 10);;
        }
    }

    // disable suitability map or enable current map
    function updateCurrentMap(checked) {

        console.log("update all maps " + checked)

        mapSelector.enabled = checked
        if (!checked) {
            layerModel.clear();
            applicationData.onSuitabilityMapChange("");
            return;
        }

        mapSelector.currentIndex = parseInt(currentMapIndex, 10);;
        var mapsJson = JSON.parse(maps);

        applicationData.onSuitabilityMapChange(mapsJson[currentMapIndex]["File"]);
    }

    // combo box model
    ListModel {
        id: mapModel
    }

    ListModel {
        id: layerModel
    }

    Rectangle {
        id: activeMapsBG
        color: "white"
        height: 40
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        RowLayout {
            id: activateMapsLayout
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
                checked: true
                onClicked: updateCurrentMap(activeMapsSwitch.checked)
            }
        }
    }

    Rectangle {
        id: selectorBG
        color: "#2e2e2e"
        height: 80
        anchors {
            top: activeMapsBG.bottom
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
                Layout.leftMargin: 15
                fillMode: Image.PreserveAspectFit
            }

            ComboBox {
                id: mapSelector
                x: -240
                y: 20
                model: mapModel
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
        id: costGradiantBG
        color: "white"
        anchors.topMargin: 0
        height: 80
        anchors {
            top: selectorBG.bottom
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
        id: layersLabelBG
        color: "#2e2e2e"

        height: 40
        anchors {
            left: parent.left
            right: parent.right
            top: costGradiantBG.bottom
            topMargin: 0
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


    ListView {
        id: layerList
        model: layerModel
        delegate: layerDelegate
        height: 200
        Layout.preferredHeight: 40

        anchors {
            top: layersLabelBG.bottom
            left: parent.left
            right: parent.right

        }

    }

    Rectangle {
        id: controlBG
        height: 40
        anchors {
            top: filler.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        RowLayout {
            id: controls
            anchors.fill:parent

            Button {
                id: applyButton
                text: "      Apply     "
                Layout.leftMargin: 15
                onClicked: {
                    console.log("Apply");
                    suitbilityWindow.close();
                }

            }

            Button {
                id: addlayerButton
                text: "   Add Layer   "
                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                onClicked: {
                    console.log("Add Layer")
                    layerWindow.show()
                }
            }

        }
    }



    Component {
        id: layerDelegate

        Rectangle {
            id: layerBG
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


    Window {
        id: layerWindow
        width: 640
        height: 480

        property bool layerOK : false
        title: "Layer Settings"

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
                anchors.fill:parent
                Text {
                    text: "Layer Name"
                    Layout.column: 0
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
                anchors.fill:parent

                Text {
                    text: "Gradient Function"
                    font.pointSize: 19
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1

                }

                ComboBox {
                    id: gradientFunction
                    x: 371
                    y: 8
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
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
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                }

                TextEdit {
                    id: gradientWidth
                    font.pointSize: 19
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    color: "#b5b5b5"
                    property string placeholderText: "50 m"
                    Text {
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

                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                }

                TextEdit {
                    id: offset
                    property string placeholderText: "0 m"
                    color: "#b5b5b5"
                    font.pointSize: 19

                    Layout.fillWidth: true
                    Layout.preferredWidth: 1

                    Text {
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
                    onClicked: {
                        console.log("Accept")
                        layerWindow.layerOK = true;
                        layerWindow.close()
                    }
                }

                Button {
                    id: cancelButton
                    text: "   Cancel   "
                    Layout.rightMargin: 15
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    onClicked: {
                        console.log("Cancel")
                        layerWindow.layerOK = false;
                        layerWindow.close()
                    }
                }

            }
        }


    }


}



































































/*##^## Designer {
    D{i:24;anchors_height:200;anchors_width:200}
}
 ##^##*/
