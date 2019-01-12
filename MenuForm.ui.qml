import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: menuPage
    width: 600
    height: 400
    property alias languagesButton: languagesButton
    property alias addNewWordButton: addNewWordButton
    property alias repeatWordsButton: repeatWordsButton
    property alias newWordsButton: newWordsButton

    ColumnLayout {
        id: columnLayout
        x: 0
        y: 0
        width: app.width
        height: 400

        Button {
            id: newWordsButton
            objectName: "newWords"
            text: qsTr("New words")
            Layout.fillWidth: true
            onClicked: cpp_handler.new_button = true /*click*/
        }

        Button {
            id: repeatWordsButton
            objectName: "repeatWords"
            text: qsTr("Repeat words")
            Layout.fillWidth: true
            onClicked: cpp_handler.repeat_button = true /*click*/
        }

        Button {
            id: addNewWordButton
            objectName: "addNewWord"
            text: qsTr("Add new word")
            Layout.fillWidth: true
        }

        Button {
            id: languagesButton
            objectName: "languages"
            text: qsTr("Languages")
            Layout.fillWidth: true
        }
        Item {
            id: spacer
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
