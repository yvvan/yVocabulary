QT += quick
CONFIG += c++14 resources_big

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
    eventshandler.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    eventshandler.h

INCLUDEPATH += "$$(TRANSLATOR_PATH)"
msvc: LIBS += $$(TRANSLATOR_LIB_PATH)/translatorlib.lib
#$$(CURL_PATH)/lib/libcurl.lib
else: LIBS += $$(TRANSLATOR_LIB_PATH)/libtranslatorlib.a
#$$(CURL_LIB_PATH)/libcurl.a

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/assets/de_en_Adjective \
    android/assets/de_en_Adverb \
    android/assets/de_en_Noun \
    android/assets/de_en_Verb \
    android/assets/de_Adjective \
    android/assets/de_Adverb \
    android/assets/de_Noun \
    android/assets/de_Verb \
    android/assets/en_Adjective \
    android/assets/en_Adverb \
    android/assets/en_Noun \
    android/assets/en_Verb \
    android/assets/es_Adjective \
    android/assets/es_Adverb \
    android/assets/es_Noun \
    android/assets/es_Verb \
    android/assets/fr_Adjective \
    android/assets/fr_Adverb \
    android/assets/fr_Noun \
    android/assets/fr_Verb \
    android/assets/it_Adjective \
    android/assets/it_Adverb \
    android/assets/it_Noun \
    android/assets/it_Verb \
    android/assets/pt_Adjective \
    android/assets/pt_Adverb \
    android/assets/pt_Noun \
    android/assets/pt_Verb \
    android/assets/ru_Adjective \
    android/assets/ru_Adverb \
    android/assets/ru_Noun \
    android/assets/ru_Verb \
    android/res/values-de/libs.xml \
    android/res/values-de/strings.xml \
    android/res/values-es/libs.xml \
    android/res/values-es/strings.xml \
    android/res/values-fr/libs.xml \
    android/res/values-fr/strings.xml \
    android/res/values-it/libs.xml \
    android/res/values-it/strings.xml \
    android/res/values-pt/libs.xml \
    android/res/values-pt/strings.xml \
    android/res/values-ru/libs.xml \
    android/res/values-ru/strings.xml

RESOURCES += \
    res.qrc

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}
