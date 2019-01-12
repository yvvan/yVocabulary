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

class EventsHandler : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool new_button READ Dummy WRITE ClickNewButton)
  Q_PROPERTY(bool repeat_button READ Dummy WRITE ClickRepeatButton)

  Q_PROPERTY(bool nouns_button READ Dummy WRITE ClickNounsButton)
  Q_PROPERTY(bool verbs_button READ Dummy WRITE ClickVerbsButton)
  Q_PROPERTY(bool adjectives_button READ Dummy WRITE ClickAdjectivesButton)
  Q_PROPERTY(bool adverbs_button READ Dummy WRITE ClickAdverbsButton)
  Q_PROPERTY(bool all_button READ Dummy WRITE ClickAllButton)

  Q_PROPERTY(QString translation READ CurrentTranslation NOTIFY TranslationChanged)
  Q_PROPERTY(QString next_translation READ NextTranslation NOTIFY NextTranslationChanged)
  Q_PROPERTY(QString prev_translation READ PrevTranslation NOTIFY PrevTranslationChanged)

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

  QString CurrentTranslation() const;
  QString NextTranslation() const;
  QString PrevTranslation() const;

signals:
    void CancelRequests();
    void TranslationChanged();
    void NextTranslationChanged();
    void PrevTranslationChanged();

private:
  bool IsEngineOnline() const;

  void NameCategoriesButtons();
  void onNewWordsInCategoryClicked();

  QQmlApplicationEngine* engine_ = nullptr;

  std::unique_ptr<Translator> translator_;

  Utils::Data prev_translation_;
  Utils::Data current_translation_;
  Utils::Data next_translation_;

  Utils::Language main_language_ = Utils::English;
  Utils::Language target_language_ = Utils::German;
  CurrentAction current_action_ = CurrentAction::None;

  Utils::Key initial_category_;
  Utils::Key category_;
  bool revealed_;
  bool one_shot_;
  bool prev_translation_active_ = false;

  QNetworkAccessManager manager_;
  QNetworkConfigurationManager config_manager_;
};
