#include "eventshandler.h"

#include <translator.h>

#include <QFile>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QTimer>
#include <QtNetwork/QNetworkReply>

#include <assert.h>

EventsHandler::EventsHandler() = default;

EventsHandler::~EventsHandler() = default;

void EventsHandler::NameCategoriesButtons() {
  auto root_objects = engine_->rootObjects();
  assert(!root_objects.empty());

  root_objects[0]->findChild<QObject*>("Nouns")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::Noun)));
  root_objects[0]->findChild<QObject*>("Verbs")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::Verb)));
  root_objects[0]->findChild<QObject*>("Adjectives")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::Adjective)));
  root_objects[0]->findChild<QObject*>("Adverbs")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::Adverb)));
  root_objects[0]->findChild<QObject*>("All")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::All)));
}

bool EventsHandler::IsEngineOnline() const {
  return config_manager_.isOnline();
}

static void HandleError(QNetworkReply* reply) {
  qWarning() <<"ErrorNo: "<< reply->error() << "for url: " << reply->url().toString();
  qDebug() << "Request failed, " << reply->errorString();
  qDebug() << "Headers:"<<  reply->rawHeaderList()<< "content:" << reply->readAll();
  reply->deleteLater();
}

void EventsHandler::setEngine(QQmlApplicationEngine *engine) {
  engine_ = engine;
  auto root_objects = engine->rootObjects();
  root_objects[0]->findChild<QObject*>("newWords")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::NewWords)));
  root_objects[0]->findChild<QObject*>("repeatWords")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::RepeatWords)));
  root_objects[0]->findChild<QObject*>("addNewWord")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::AddWord)));
  root_objects[0]->findChild<QObject*>("languages")->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::Languages)));

  auto data_path = QStandardPaths::locate(QStandardPaths::AppDataLocation, QString(),
                                          QStandardPaths::LocateDirectory);
  QString asset_path;
  QString file_path;
  for (size_t i = 0; i < Utils::kLangPairs.size(); ++i) {
#ifdef Q_OS_ANDROID
    asset_path = "assets:/" + QString::fromStdString(Utils::kLangPairs[i]) + "_";
#else
    asset_path = ":/android/assets/" + QString::fromStdString(Utils::kLangPairs[i]) + "_";
#endif
    file_path = data_path + QString::fromStdString(Utils::kLangPairs[i]) + "_";
    for (Utils::Key j = Utils::Key::Noun; j < Utils::Key::All;) {
      QFile asset(asset_path + QString::fromStdString(Utils::CategoryToStr(j)));
      QFile file(file_path + QString::fromStdString(Utils::CategoryToStr(j)));
      if (file.exists()) {
        j = static_cast<Utils::Key>(j + 1);
        continue;
      }
      asset.open(QIODevice::ReadOnly);
      file.open(QIODevice::WriteOnly);
      file.write(asset.readAll());
      file.close();
      asset.close();
      j = static_cast<Utils::Key>(j + 1);
    }
  }
  translator_ = std::make_unique<Translator>(
      main_language_, target_language_, data_path.toStdString(),
      [this](std::string request, RequestEngine::QueryCallback &&callback,
             RequestEngine::FailCallback &&fail) {
          QNetworkRequest req(QUrl(QString::fromStdString(request)));
          req.setRawHeader("User-Agent", "yv.ivan@gmail.com");
          QNetworkReply *reply = manager_.get(req);
          connect(this, &EventsHandler::CancelRequests, reply, &QNetworkReply::abort);
          connect(reply, &QNetworkReply::finished, this,
                  [reply, callback = std::move(callback),
                   fail = std::move(fail)]() {
                      if (reply->error() != QNetworkReply::NoError) {
                          HandleError(reply);
                          fail();
                          return;
                      }
                      callback(reply->readAll().toStdString());
                      reply->deleteLater();
                  });
      });

  QObject::connect(&config_manager_,
                   &QNetworkConfigurationManager::onlineStateChanged,
                   [this](bool isOnline) {
                     if (!isOnline) {
                       return;
                     }
                     for (auto i = Utils::Key::Noun; i < Utils::Key::All;) {
                       translator_->InitialTranslate(i);
                       i = static_cast<Utils::Key>(i + 1);
                     }
                   });

  translator_->Restore();
}

void EventsHandler::ClickNewButton(bool /*state*/) {
  NameCategoriesButtons();

  current_action_ = CurrentAction::NewWords;

  //Translator translator(Utils::Language::English, Utils::Language::Russian);
//  RequestEngine request_engine;
//  request_engine.QueryWiktionary(Utils::Language::German, "Flug",
//                                 [](std::string reply) {
//                                   __android_log_write(ANDROID_LOG_DEBUG,
//                                                       "yVocabulary",
//                                                       reply.c_str());

//                                 },
//                                 [](){});

//  auto* page_name_label = root_objects[0]->findChild<QObject*>("PageName");
//  page_name_label->setProperty("text", "changed from c++");
}

void EventsHandler::ClickRepeatButton(bool /*state*/) {
  NameCategoriesButtons();

  current_action_ = CurrentAction::RepeatWords;
}

static Utils::Key RandomCategory() {
  size_t index = std::rand() % 8;
  if (index < 1) {
    return Utils::Key::Adverb;
  }
  if (index < 2) {
    return Utils::Key::Adjective;
  }
  if (index < 4) {
    return Utils::Key::Verb;
  }
  return Utils::Key::Noun;
}

#define GenerateDataFieldGetter(CallName, field_name) \
static std::string CallName(const Utils::Data& data) { \
  std::string text = data.target_.field_name; \
  if (!text.empty()) { \
    return text; \
  } \
  text = data.main_.field_name; \
  if (!text.empty()) { \
    return text; \
  } \
  text = data.english_.field_name; \
  return text; \
}

GenerateDataFieldGetter(GetNativeDescription, native_description_)
GenerateDataFieldGetter(GetSynonyms, synonyms_)
GenerateDataFieldGetter(GetExamples, examples_)
//static void AddTranslationData(QBoxLayout* layout,
//                               const Utils::Data& translation,
//                               Utils::Language main_language,
//                               bool open_description,
//                               bool revealed) {
//  if (!translation.main_.translations_.isEmpty()) {
//    auto native_label = std::make_unique<QLabel>(Utils::kLangNames[main_language] + ":");
//    QFont font = native_label->font();
//    font.setBold(true);
//    font.setPointSize(8);
//    native_label->setFont(font);
//    layout->addWidget(native_label.release());
//    auto tr_label = std::make_unique<QLabel>(translation.main_.translations_);
//    tr_label->setWordWrap(true);
//    layout->addWidget(tr_label.release());
//  }

//  if (!translation.english_.translations_.isEmpty()) {
//    auto eng_label = std::make_unique<QLabel>("English:");
//    QFont font = eng_label->font();
//    font.setBold(true);
//    font.setPointSize(8);
//    eng_label->setFont(font);
//    layout->addWidget(eng_label.release());
//    auto tr_eng_label = std::make_unique<QLabel>(translation.english_.translations_);
//    tr_eng_label->setWordWrap(true);
//    layout->addWidget(tr_eng_label.release());
//  }

//  const auto& native_description = GetNativeDescription(translation);
//  if (!native_description.isEmpty()) {
//    layout->addWidget(std::make_unique<Spoiler>(
//                        Utils::GetString(main_language, Utils::Description),
//                        native_description, open_description).release());
//  }

//  const auto& synonyms = GetSynonyms(translation);
//  if (!synonyms.isEmpty()) {
//    layout->addWidget(std::make_unique<Spoiler>(
//                        Utils::GetString(main_language, Utils::Synonyms),
//                        synonyms).release());
//  }

//  const auto& examples = GetExamples(translation);
//  if (revealed && !examples.isEmpty()) {
//    layout->addWidget(std::make_unique<Spoiler>(
//                        Utils::GetString(main_language, Utils::Examples),
//                        examples).release());
//  }
//}

void EventsHandler::onNewWordsInCategoryClicked() {
  if (one_shot_) {
    revealed_ = true;
  }

  if (!revealed_) {
    translator_->TranslateNext(category_);
  }

  auto root_objects = engine_->rootObjects();
  auto translation_message = root_objects[0]->findChild<QObject*>("TranslationMessage");

  if (!translator_->IsAnythingLeft(initial_category_, category_)) {
    translation_message->setProperty("visible", true);
    translation_message->setProperty("text", QString::fromStdString(Utils::GetString(main_language_, Utils::NoMoreWords)));
    return;
  }

  auto translation = translator_->GetAt(category_, 0);
  auto next_translation = translator_->GetAt(category_, 1);
  // TODO: Case when it's the end of the list.
  if (!IsTranslationComplete(translation) || !IsTranslationComplete(next_translation)) {
    std::string error(
        Utils::GetString(main_language_, Utils::PreparingTranslation));
    if (!IsEngineOnline()) {
      error = Utils::GetString(main_language_, Utils::ConnectionError);
    } else {
      QTimer::singleShot(1000, this, [=]() {
        if (current_action_ != CurrentAction::NewWords) {
          return;
        }
        onNewWordsInCategoryClicked();
      });
    }
    translation_message->setProperty("visible", true);
    translation_message->setProperty("text", QString::fromStdString(error));
    return;
  }
  bool open_description = false;

  if (translation.main_.translations_.empty() &&
      translation.english_.translations_.empty()) {
    if (!IsTranslationGood(translation)) {
      // We did not find any kind of translation or description to this word
      translator_->RemoveAt(category_, 0);
      std::string error(Utils::GetString(main_language_, Utils::PreparingTranslation));
      QTimer::singleShot(1000, this, [=]() {
        if (current_action_ != CurrentAction::NewWords) {
          return;
        }
        onNewWordsInCategoryClicked();
      });
      translation_message->setProperty("visible", true);
      translation_message->setProperty("text", QString::fromStdString(error));
      return;
    }
    open_description = true;
  }

  if (!one_shot_) {
//    auto next_word_btn = std::make_unique<QPushButton>(Utils::GetString(main_language_, Utils::Next));
//    connect(next_word_btn.get(), &QPushButton::clicked, [this, translation, initial_category, category]() {
//      translator_->PopFirst(category);
//      translator_->AddLeart(category, translation);
//      onNewWordsInCategoryClicked(initial_category);
//    });
//    auto remove_btn = std::make_unique<QPushButton>(Utils::GetString(main_language_, Utils::Remove));
//    connect(remove_btn.get(), &QPushButton::clicked, this, [this, initial_category, category]() {
//      translator_->PopFirst(category);
//      onNewWordsInCategoryClicked(initial_category);
//    });
  }

//  if (!revealed) {
//    auto translate_btn = std::make_unique<QPushButton>(Utils::GetString(main_language_, Utils::Reveal));
//    connect(translate_btn.get(), &QPushButton::clicked, this, [this, initial_category, category]() {
//      onNewWordsInCategoryClicked(initial_category, category, true);
//    });
//    ui_->scrollAreaLayout->addWidget(translate_btn.release());
//  } else {
//    auto orig_label = std::make_unique<QLabel>(translation.target_.translations_);
//    QFont font = orig_label->font();
//    font.setBold(true);
//    font.setPointSize(14);
//    orig_label->setFont(font);
//    ui_->scrollAreaLayout->addWidget(orig_label.release());
//  }

  current_translation_ = translation;
  emit TranslationChanged();

  if (!IsTranslationGood(next_translation)) {
    // We did not find any kind of translation or description to this word
    translator_->RemoveAt(category_, 1);
    QTimer::singleShot(1000, this, [=]() {
      if (current_action_ != CurrentAction::NewWords) {
        return;
      }
      onNewWordsInCategoryClicked();
    });
  } else {
    next_translation_ = next_translation;
    emit NextTranslationChanged();
  }
//  AddTranslationData(ui_->scrollAreaLayout, translation, main_language_,
//                     open_description, revealed);
//  ui_->scrollAreaLayout->addStretch();
}

QString EventsHandler::CurrentTranslation() const {
  return QString::fromStdString(current_translation_.main_.translations_);
}

QString EventsHandler::NextTranslation() const {
  return QString::fromStdString(next_translation_.main_.translations_);
}

QString EventsHandler::PrevTranslation() const {
  return QString::fromStdString(prev_translation_.main_.translations_);
}

void EventsHandler::ClickNounsButton(bool) {
  category_ = initial_category_ = Utils::Key::Noun;
  revealed_ = one_shot_ = false;
  onNewWordsInCategoryClicked();
}

void EventsHandler::ClickVerbsButton(bool) {
  category_ = initial_category_ = Utils::Key::Verb;
  revealed_ = one_shot_ = false;
  onNewWordsInCategoryClicked();
}

void EventsHandler::ClickAdjectivesButton(bool) {
  category_ = initial_category_ = Utils::Key::Adjective;
  revealed_ = one_shot_ = false;
  onNewWordsInCategoryClicked();
}

void EventsHandler::ClickAdverbsButton(bool) {
  category_ = initial_category_ = Utils::Key::Adverb;
  revealed_ = one_shot_ = false;
  onNewWordsInCategoryClicked();
}

void EventsHandler::ClickAllButton(bool) {
  initial_category_ = Utils::Key::All;
  category_ = RandomCategory();
  revealed_ = one_shot_ = false;
  onNewWordsInCategoryClicked();
}

void EventsHandler::Swipe(bool forward) {
  if (current_action_ == CurrentAction::NewWords) {
    if (forward && !prev_translation_active_) {
      prev_translation_ = current_translation_;
      emit PrevTranslationChanged();
      translator_->RemoveAt(category_, 0);
      translator_->AddLeart(category_, current_translation_);
      onNewWordsInCategoryClicked();
      return;
    }

    if (forward) {
      prev_translation_active_ = false;
      auto tmp = prev_translation_;
      prev_translation_ = current_translation_;
      current_translation_ = next_translation_;
      next_translation_ = tmp;
      emit PrevTranslationChanged();
      emit TranslationChanged();
      emit NextTranslationChanged();
      return;
    }

    prev_translation_active_ = true;
    auto tmp = next_translation_;
    next_translation_ = current_translation_;
    current_translation_ = prev_translation_;
    prev_translation_ = tmp;
    emit PrevTranslationChanged();
    emit TranslationChanged();
    emit NextTranslationChanged();
  }
}
