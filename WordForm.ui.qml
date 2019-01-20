import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    width: innerSwipeView.width
    height: innerSwipeView.height
    property bool current: false
    property bool next: false

    ColumnLayout {
        x: 0
        y: 0
        width: innerSwipeView.width
        height: innerSwipeView.height

        GroupBox {
            id: groupBox
            objectName: "target"
            width: innerSwipeView.width - 10
            title: qsTr("Current word")

            RowLayout {
                Label {
                    id: label
                    visible: current ? cpp_handler.translation.revealed : (next ? cpp_handler.next_translation.revealed : cpp_handler.prev_translation.revealed)
                    Layout.minimumWidth: innerSwipeView.width - 30
                    width: innerSwipeView.width - 30
                    text: current ? cpp_handler.translation.target.translations : (next ? cpp_handler.next_translation.target.translations : cpp_handler.prev_translation.target.translations)
                    wrapMode: Label.WordWrap
                }
            }
        }

        GroupBox {
            id: groupBox2
            width: app.width - 10
            height: 200
            title: qsTr("Group")

            Label {
                id: label2
                width: app.width - 30
                text: "123" //cpp_handler.next_translation
            }
        }

        Button {
            id: button
            text: qsTr("Reveal")
            Layout.fillWidth: true
            visible: current ? !cpp_handler.translation.revealed : (next ? !cpp_handler.next_translation.revealed : !cpp_handler.prev_translation.revealed)
            onClicked: current ? cpp_handler.translation.revealed
                                 = true : (next ? cpp_handler.next_translation.revealed
                                                  = true : cpp_handler.prev_translation.revealed
                                                  = true)
        }
    }
}
