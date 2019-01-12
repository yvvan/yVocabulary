import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    width: innerSwipeView.width
    height: innerSwipeView.height
    property alias groupBox: groupBox
    property bool current: false
    property bool next: false

    ColumnLayout {
        x: 0
        y: 0
        width: innerSwipeView.width
        height: innerSwipeView.height

        GroupBox {
            id: groupBox
            width: innerSwipeView.width - 10
            title: qsTr("Group")

            RowLayout {
                Label {
                    id: label
                    Layout.minimumWidth: innerSwipeView.width - 30
                    width: innerSwipeView.width - 30
                    text: current ? cpp_handler.translation : (next ? cpp_handler.next_translation : cpp_handler.prev_translation)
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
                text: cpp_handler.next_translation
            }
        }
    }
}
