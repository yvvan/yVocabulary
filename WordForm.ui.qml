import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    width: innerSwipeView.width
    height: innerSwipeView.height
    property bool current: false
    property bool next: false

    ScrollView {
        anchors.fill: parent
        contentWidth: -1
        visible: currentWord.text.length > 0

        ColumnLayout {
            x: 0
            y: 0
            width: innerSwipeView.width
            height: innerSwipeView.height

            GroupBox {
                objectName: "current_word"
                width: innerSwipeView.width - 10
                Layout.minimumWidth: innerSwipeView.width - 10
                Layout.maximumWidth: innerSwipeView.width - 10
                title: qsTr("Current word")

                Label {
                    id: currentWord
                    visible: current ? cpp_handler.translation.revealed : (next ? cpp_handler.next_translation.revealed : cpp_handler.prev_translation.revealed)
                    width: innerSwipeView.width - 20
                    text: current ? cpp_handler.translation.target.translations : (next ? cpp_handler.next_translation.target.translations : cpp_handler.prev_translation.target.translations)
                    wrapMode: Label.WordWrap
                }
            }
            Switch {
                text: qsTr("Reveal")
                checked: current ? cpp_handler.translation.revealed : (next ? cpp_handler.next_translation.revealed : cpp_handler.prev_translation.revealed)
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
                        objectName: "translation"
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
                        objectName: "description"
                        width: innerSwipeView.width - 10
                        Layout.minimumWidth: innerSwipeView.width - 10
                        Layout.maximumWidth: innerSwipeView.width - 10
                        title: qsTr("Description")
                        visible: desc_label.text.length > 0

                        Label {
                            id: desc_label
                            width: innerSwipeView.width - 20
                            text: current ? cpp_handler.translation.target.native_description : (next ? cpp_handler.next_translation.target.native_description : cpp_handler.prev_translation.target.native_description)
                            wrapMode: Label.WordWrap
                        }
                    }
                    GroupBox {
                        objectName: "synonyms"
                        width: innerSwipeView.width - 10
                        Layout.minimumWidth: innerSwipeView.width - 10
                        Layout.maximumWidth: innerSwipeView.width - 10
                        title: qsTr("Synonyms")
                        visible: syn_label.text.length > 0

                        Label {
                            id: syn_label
                            width: innerSwipeView.width - 20
                            text: current ? cpp_handler.translation.target.synonyms : (next ? cpp_handler.next_translation.target.synonyms : cpp_handler.prev_translation.target.synonyms)
                            wrapMode: Label.WordWrap
                        }
                    }
                    GroupBox {
                        objectName: "examples"
                        width: innerSwipeView.width - 10
                        Layout.minimumWidth: innerSwipeView.width - 10
                        Layout.maximumWidth: innerSwipeView.width - 10
                        title: qsTr("Examples")
                        visible: ex_label.text.length > 0

                        Label {
                            id: ex_label
                            width: innerSwipeView.width - 20
                            text: current ? cpp_handler.translation.target.examples : (next ? cpp_handler.next_translation.target.examples : cpp_handler.prev_translation.target.examples)
                            wrapMode: Label.WordWrap
                        }
                    }
                }

                ColumnLayout {
                    GroupBox {
                        objectName: "en_translation"
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
                        objectName: "en_description"
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
                        objectName: "en_synonyms"
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
                        objectName: "en_examples"
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
}
