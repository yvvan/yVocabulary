#pragma once

#include <translate_utils.h>

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkConfigurationManager>

#include <memory>

class QQmlApplicationEngine;
class Translator;

enum class CurrentAction : uint8_t {
  None,
  NewWords,
  RepeatWords
};

class QDataEntry : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString translations MEMBER translations_ NOTIFY Changed)
  Q_PROPERTY(QString native_description MEMBER native_description_ NOTIFY Changed)
  Q_PROPERTY(QString synonyms MEMBER synonyms_ NOTIFY Changed)
  Q_PROPERTY(QString examples MEMBER examples_ NOTIFY Changed)
public:
  QDataEntry() = default;
  QDataEntry(const QDataEntry& entry) {
    translations_ = entry.translations_;
    native_description_ = entry.native_description_;
    synonyms_ = entry.synonyms_;
    examples_ = entry.examples_;
  }
  ~QDataEntry() {}
  QDataEntry &operator=(const QDataEntry& entry) {
    translations_ = entry.translations_;
    native_description_ = entry.native_description_;
    synonyms_ = entry.synonyms_;
    examples_ = entry.examples_;
    return *this;
  }
  QDataEntry(const Utils::DataEntry& data_entry) {
    translations_ = QString::fromStdString(data_entry.translations_);
    native_description_ = QString::fromStdString(data_entry.native_description_);
    synonyms_ = QString::fromStdString(data_entry.synonyms_);
    examples_ = QString::fromStdString(data_entry.examples_);
  }
  bool operator!=(const QDataEntry &entry) {
    return translations_ != entry.translations_ ||
        native_description_ != entry.native_description_ ||
        synonyms_ != entry.synonyms_ || examples_ != entry.examples_;
  }

  Utils::DataEntry toDataEntry() const {
    Utils::DataEntry entry;
    entry.translations_ = translations_.toStdString();
    entry.native_description_ = native_description_.toStdString();
    entry.synonyms_ = synonyms_.toStdString();
    entry.examples_ = examples_.toStdString();
    return entry;
  }

signals:
  void Changed();

private:
  QString translations_;
  QString native_description_;
  QString synonyms_;
  QString examples_;
};

Q_DECLARE_METATYPE(QDataEntry)

class QData : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool revealed MEMBER revealed_ NOTIFY Changed)
  Q_PROPERTY(QDataEntry* main READ main NOTIFY Changed)
  Q_PROPERTY(QDataEntry* target READ target NOTIFY Changed)
  Q_PROPERTY(QDataEntry* english READ english NOTIFY Changed)
public:
  QData() = default;
  QData(const QData& data) {
    main_ = data.main_;
    target_ = data.target_;
    english_ = data.english_;
    revealed_ = data.revealed_;
  }
  ~QData() {}
  QData &operator=(const QData& data) {
    main_ = data.main_;
    target_ = data.target_;
    english_ = data.english_;
    revealed_ = data.revealed_;
    return *this;
  }
  QData(const Utils::Data &data)
      : main_(data.main_), target_(data.target_), english_(data.english_) {}
  bool operator!=(const QData &data) {
    return main_ != data.main_ || target_ != data.target_ ||
        english_ != data.english_;
  }

  Utils::Data toData() const {
    Utils::Data data;
    data.main_ = main_.toDataEntry();
    data.target_ = target_.toDataEntry();
    data.english_ = english_.toDataEntry();
    return data;
  }

  QDataEntry* main() {
    return &main_;
  }
  QDataEntry* target() {
    return &target_;
  }
  QDataEntry* english() {
    return &english_;
  }

signals:
  void Changed();

private:
  QDataEntry main_;
  QDataEntry target_;
  QDataEntry english_;
  bool revealed_ = false;
};

Q_DECLARE_METATYPE(QData)

class EventsHandler : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool new_button READ Dummy WRITE ClickNewButton)
  Q_PROPERTY(bool repeat_button READ Dummy WRITE ClickRepeatButton)

  Q_PROPERTY(bool nouns_button READ Dummy WRITE ClickNounsButton)
  Q_PROPERTY(bool verbs_button READ Dummy WRITE ClickVerbsButton)
  Q_PROPERTY(bool adjectives_button READ Dummy WRITE ClickAdjectivesButton)
  Q_PROPERTY(bool adverbs_button READ Dummy WRITE ClickAdverbsButton)
  Q_PROPERTY(bool all_button READ Dummy WRITE ClickAllButton)

  Q_PROPERTY(QData* translation READ current_translation NOTIFY TranslationChanged)
  Q_PROPERTY(QData* next_translation READ next_translation NOTIFY TranslationChanged)
  Q_PROPERTY(QData* prev_translation READ prev_translation NOTIFY TranslationChanged)

  Q_PROPERTY(bool swipe READ Dummy WRITE Swipe)
public:
  EventsHandler();
  ~EventsHandler();

  void setEngine(QQmlApplicationEngine *engine);

  bool Dummy() { return true; }

  void ClickNewButton(bool state);
  void ClickRepeatButton(bool state);

  void ClickNounsButton(bool state);
  void ClickVerbsButton(bool state);
  void ClickAdjectivesButton(bool state);
  void ClickAdverbsButton(bool state);
  void ClickAllButton(bool state);

  void Swipe(bool forward);

  Utils::Language MainLanguage() const {
    return main_language_;
  }

  Utils::Language TargetLanguage() const {
    return target_language_;
  }

  QData* prev_translation() {
    return &prev_translation_;
  }
  QData* current_translation() {
    return &current_translation_;
  }
  QData* next_translation() {
    return &next_translation_;
  }

signals:
    void CancelRequests();
    void TranslationChanged();

private:
  bool IsEngineOnline() const;

  void NameCategoriesButtons();
  void onNewWordsInCategoryClicked();
  void onRepeatWordsInCategoryClicked();

  QQmlApplicationEngine* engine_ = nullptr;

  std::unique_ptr<Translator> translator_;

  QData prev_translation_;
  QData current_translation_;
  QData next_translation_;

  Utils::Language main_language_ = Utils::English;
  Utils::Language target_language_ = Utils::German;
  CurrentAction current_action_ = CurrentAction::None;

  Utils::Key initial_category_;
  Utils::Key category_;
  bool one_shot_;
  bool prev_translation_active_ = false;

  QNetworkAccessManager manager_;
  QNetworkConfigurationManager config_manager_;
};
