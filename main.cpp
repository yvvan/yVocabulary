#include "eventshandler.h"

#include <translate_utils.h>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QThread>
#include <assert.h>

class ExecuteOnExit {
  using FunctionObj = std::function<void()>;
public:
  ExecuteOnExit(FunctionObj&& function) : function(function) {}
  ~ExecuteOnExit() { function(); }
private:
  FunctionObj function;
};

int main(int argc, char *argv[])
{
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  const QUrl mainQml(QStringLiteral("qrc:/main.qml"));

  // Catch the objectCreated signal, so that we can determine if the root component was loaded
  // successfully. If not, then the object created from it will be null. The root component may
  // get loaded asynchronously.
  const QMetaObject::Connection connection =
      QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                       [&](QObject *object, const QUrl &url) {
                         if (url != mainQml)
                           return;

                         if (!object)
                           app.exit(-1);
                         else
                           QObject::disconnect(connection);
                       },
                       Qt::QueuedConnection);

  qmlRegisterInterface<QDataEntry>("DataEntry");
  qmlRegisterInterface<QData>("Data");

  EventsHandler cpp_handler;
  engine.rootContext()->setContextProperty("cpp_handler", &cpp_handler);
  engine.load(mainQml);

  cpp_handler.setEngine(&engine);

  //  QThread *logic_thread = QThread::create([&engine]() {
  //    auto root_objects = engine.rootObjects();
  //    assert(!root_objects.empty());

  //    auto* page_name_label =
  //    root_objects[0]->findChild<QObject*>("PageName");
  //    page_name_label->setProperty("text", "changed from c++");
  //  });

  //  QObject::connect(logic_thread, &QThread::finished, [&engine]() {
//    auto root_objects = engine.rootObjects();
//    assert(!root_objects.empty());
//    root_objects[0]->setProperty("height", 100);
//  });
//  logic_thread->start();

//  ExecuteOnExit executeOnExit([logic_thread]() {
//    logic_thread->wait();
//    delete logic_thread;
//  });

  return app.exec();
}
