import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Tabs")
    id: app

    SwipeView {
        id: swipeView
        anchors.fill: parent
        interactive: false

        LogoForm {
            logoPageMouseArea.onClicked: {
                swipeView.currentIndex = 1
            }
        }

        MenuForm {
            newWordsButton.onClicked: {
                swipeView.currentIndex = 2
            }
            repeatWordsButton.onClicked: {
                swipeView.currentIndex = 2
            }
            addNewWordButton.onClicked: {
                swipeView.currentIndex = 4
            }
            languagesButton.onClicked: {
                swipeView.currentIndex = 5
            }
        }

        CategorySelectionForm {
            nounsButton.onClicked: {
                swipeView.currentIndex = 3
            }
            verbsButton.onClicked: {
                swipeView.currentIndex = 3
            }
            adjectivesButton.onClicked: {
                swipeView.currentIndex = 3
            }
            adverbsButton.onClicked: {
                swipeView.currentIndex = 3
            }
            allButton.onClicked: {
                swipeView.currentIndex = 3
            }
        }

        TranslationsForm {
            innerSwipeView.onCurrentIndexChanged: {
                //console.log(innerSwipeView.currentIndex)
                if (innerSwipeView.currentIndex == 2) {
                    innerSwipeView.moveItem(0, 3)
                }
                cpp_handler.swipe = (prevIndex <= innerSwipeView.currentIndex)
                prevIndex = innerSwipeView.currentIndex
            }
        }
    }
}
