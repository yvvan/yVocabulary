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
            objectName: "target"
            width: innerSwipeView.width - 10
            Layout.minimumWidth: innerSwipeView.width - 10
            Layout.maximumWidth: innerSwipeView.width - 10
            title: qsTr("Current word")

            Label {
                visible: current ? cpp_handler.translation.revealed : (next ? cpp_handler.next_translation.revealed : cpp_handler.prev_translation.revealed)
                width: innerSwipeView.width - 20
                text: current ? cpp_handler.translation.target.translations : (next ? cpp_handler.next_translation.target.translations : cpp_handler.prev_translation.target.translations)
                wrapMode: Label.WordWrap
            }
        }
        Switch {
            text: qsTr("Reveal")
            onClicked: current ? cpp_handler.translation.revealed
                                 = checked : (next ? cpp_handler.next_translation.revealed = checked : cpp_handler.prev_translation.revealed = checked)
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
                    visible: tr_label.text.length > 0

                    Label {
                        id: tr_label
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
                    visible: desc_label.text.length > 0

                    Label {
                        id: desc_label
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.main.native_description : (next ? cpp_handler.next_translation.main.native_description : cpp_handler.prev_translation.main.native_description)
                        wrapMode: Label.WordWrap
                    }
                }
                GroupBox {
                    width: innerSwipeView.width - 10
                    Layout.minimumWidth: innerSwipeView.width - 10
                    Layout.maximumWidth: innerSwipeView.width - 10
                    title: qsTr("Synonyms")
                    visible: syn_label.text.length > 0

                    Label {
                        id: syn_label
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.main.synonyms : (next ? cpp_handler.next_translation.main.synonyms : cpp_handler.prev_translation.main.synonyms)
                        wrapMode: Label.WordWrap
                    }
                }
                GroupBox {
                    width: innerSwipeView.width - 10
                    Layout.minimumWidth: innerSwipeView.width - 10
                    Layout.maximumWidth: innerSwipeView.width - 10
                    title: qsTr("Examples")
                    visible: ex_label.text.length > 0

                    Label {
                        id: ex_label
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.main.examples : (next ? cpp_handler.next_translation.main.examples : cpp_handler.prev_translation.main.examples)
                        wrapMode: Label.WordWrap
                    }
                }
            }

            ColumnLayout {
                GroupBox {
                    width: innerSwipeView.width - 10
                    Layout.minimumWidth: innerSwipeView.width - 10
                    Layout.maximumWidth: innerSwipeView.width - 10
                    title: qsTr("Translation")
                    visible: en_tr_label.text.length > 0

                    Label {
                        id: en_tr_label
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.english.translations : (next ? cpp_handler.next_translation.english.translations : cpp_handler.prev_translation.english.translations)
                        wrapMode: Label.WordWrap
                    }
                }
                GroupBox {
                    width: innerSwipeView.width - 10
                    Layout.minimumWidth: innerSwipeView.width - 10
                    Layout.maximumWidth: innerSwipeView.width - 10
                    title: qsTr("Description")
                    visible: en_desc_label.text.length > 0

                    Label {
                        id: en_desc_label
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.english.native_description : (next ? cpp_handler.next_translation.english.native_description : cpp_handler.prev_translation.english.native_description)
                        wrapMode: Label.WordWrap
                    }
                }
                GroupBox {
                    width: innerSwipeView.width - 10
                    Layout.minimumWidth: innerSwipeView.width - 10
                    Layout.maximumWidth: innerSwipeView.width - 10
                    title: qsTr("Synonyms")
                    visible: en_syn_label.text.length > 0

                    Label {
                        id: en_syn_label
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.english.synonyms : (next ? cpp_handler.next_translation.english.synonyms : cpp_handler.prev_translation.english.synonyms)
                        wrapMode: Label.WordWrap
                    }
                }
                GroupBox {
                    width: innerSwipeView.width - 10
                    Layout.minimumWidth: innerSwipeView.width - 10
                    Layout.maximumWidth: innerSwipeView.width - 10
                    title: qsTr("Examples")
                    visible: en_ex_label.text.length > 0

                    Label {
                        id: en_ex_label
                        width: innerSwipeView.width - 20
                        text: current ? cpp_handler.translation.english.examples : (next ? cpp_handler.next_translation.english.examples : cpp_handler.prev_translation.english.examples)
                        wrapMode: Label.WordWrap
                    }
                }
            }
        }
    }
}
