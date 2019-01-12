import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: translationsPage
    width: app.width
    height: app.height
    property alias page4: page4
    property alias page3: page3
    property alias page2: page2
    property alias page1: page1
    property alias innerSwipeView: innerSwipeView
    property alias caption: caption
    property int prevIndex: 0

    ColumnLayout {
        id: columnLayout
        x: 0
        y: 0
        width: app.width
        height: app.height

        Label {
            id: caption
            visible: false
            objectName: "TranslationMessage"
            height: 50
        }
        SwipeView {
            id: innerSwipeView
            objectName: "InnerSwipe"
            width: app.width
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillHeight: true
            interactive: true

            Page {
                id: page1
                WordForm {
                    current: innerSwipeView.currentItem == page1
                    next: innerSwipeView.currentItem == page4
                }
            }

            Page {
                id: page2
                WordForm {
                    current: innerSwipeView.currentItem == page2
                    next: innerSwipeView.currentItem == page1
                }
            }

            Page {
                id: page3
                WordForm {
                    current: innerSwipeView.currentItem == page3
                    next: innerSwipeView.currentItem == page3
                }
            }

            Page {
                id: page4
                WordForm {
                    current: innerSwipeView.currentItem == page4
                    next: innerSwipeView.currentItem == page3
                }
            }
        }
    }
}
