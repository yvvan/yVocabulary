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
            Layout.minimumWidth: innerSwipeView.width - 10
            Layout.maximumWidth: innerSwipeView.width - 10
            title: qsTr("Current word")

            Label {
                id: label
                visible: current ? cpp_handler.translation.revealed : (next ? cpp_handler.next_translation.revealed : cpp_handler.prev_translation.revealed)
                width: innerSwipeView.width - 20
                text: current ? cpp_handler.translation.target.translations : (next ? cpp_handler.next_translation.target.translations : cpp_handler.prev_translation.target.translations)
                wrapMode: Label.WordWrap
            }
        }

        TabBar {
            id: langBar
            TabButton {
                text: "Your Language"
            }
            TabButton {
                text: "English"
            }
        }
        StackLayout {
            width: app.width
            currentIndex: langBar.currentIndex
            ColumnLayout {
                GroupBox {
                    width: innerSwipeView.width - 10
                    Layout.minimumWidth: innerSwipeView.width - 10
                    Layout.maximumWidth: innerSwipeView.width - 10
                    title: qsTr("Translation")

                    Label {
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.main.translations : (next ? cpp_handler.next_translation.main.translations : cpp_handler.prev_translation.main.translations)
                        wrapMode: Label.WordWrap
                    }
                }
                GroupBox {
                    width: innerSwipeView.width - 10
                    Layout.minimumWidth: innerSwipeView.width - 10
                    Layout.maximumWidth: innerSwipeView.width - 10
                    title: qsTr("Description")

                    Label {
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.main.native_description : (next ? cpp_handler.next_translation.main.native_description : cpp_handler.prev_translation.main.native_description)
                        wrapMode: Label.WordWrap
                    }
                }
            }

            Item {
                id: discoverTab
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
