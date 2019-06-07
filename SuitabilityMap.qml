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
                checked: true
                onClicked: updateCurrentMap(activeMapsSwitch.checked)
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

        height: 40
        anchors {
            left: parent.left
            right: parent.right
            top: costGradiantBackground.bottom
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
            top: layersLabelBackground.bottom
            left: parent.left
            right: parent.right

            //bottom: controlBackground.top
        }

    }
/*
    Rectangle {
        id: filler
        color: "red"

        anchors {
            topMargin: 0
            top: layerList.bottom
            right: parent.right
            left: parent.left
            //bottom: controlBackground.top
        }
    }
*/
    Rectangle {
        id: controlBackground
        height: 40
        anchors {
            top: filler.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        RowLayout {
            id: controls
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.fill:parent

            RoundButton {
                id: applyButton
                text: "      Apply     "
                Layout.leftMargin: 15
                onClicked: console.log("Apply")
            }

            RoundButton {
                id: addlayerButton
                text: "   Add Layer   "
                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                onClicked: {
                    console.log("Add Layer")
                    dialog.open()
                }
            }

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

    Dialog {
        id: dialog
        title: "Title"
        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: console.log("Ok clicked")
        onRejected: console.log("Cancel clicked")
    }

}

































































/*##^## Designer {
    D{i:24;anchors_height:200;anchors_width:200}
}
 ##^##*/
