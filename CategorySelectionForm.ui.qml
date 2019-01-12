import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: categoriesPage
    width: 600
    height: 400
    property alias nounsButton: nounsButton
    property alias verbsButton: verbsButton
    property alias adjectivesButton: adjectivesButton
    property alias adverbsButton: adverbsButton
    property alias allButton: allButton

    ColumnLayout {
        id: columnLayout
        x: 0
        y: 0
        width: app.width
        height: 400

        Button {
            id: nounsButton
            objectName: "Nouns"
            text: qsTr("Nouns")
            Layout.fillWidth: true
            onClicked: cpp_handler.nouns_button = true /*click*/
        }

        Button {
            id: verbsButton
            objectName: "Verbs"
            text: qsTr("Verbs")
            Layout.fillWidth: true
            onClicked: cpp_handler.verbs_button = true /*click*/
        }

        Button {
            id: adjectivesButton
            objectName: "Adjectives"
            text: qsTr("Adjectives")
            Layout.fillWidth: true
            onClicked: cpp_handler.adjectives_button = true /*click*/
        }

        Button {
            id: adverbsButton
            objectName: "Adverbs"
            text: qsTr("Adverbs")
            Layout.fillWidth: true
            onClicked: cpp_handler.adverbs_button = true /*click*/
        }

        Button {
            id: allButton
            objectName: "All"
            text: qsTr("All")
            Layout.fillWidth: true
            onClicked: cpp_handler.all_button = true /*click*/
        }
        Item {
            id: spacer
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}



