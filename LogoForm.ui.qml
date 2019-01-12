import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: logoPage
    width: 600
    height: 400

    property alias logoPageMouseArea: logoPageMouseArea
    MouseArea {
        id: logoPageMouseArea
        anchors.fill: parent
    }

    ColumnLayout {
        id: columnLayout
        x: 0
        y: 0
        width: app.width
        height: app.height

        Label {
            id: label
            width: 600
            height: 55
            color: "#ee00ff"
            text: qsTr("yVocabulary")
            font.family: "Arial"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 30
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
