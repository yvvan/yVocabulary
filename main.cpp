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

  const QUrl main_qml(QStringLiteral("qrc:/main.qml"));

  // Catch the objectCreated signal, so that we can determine if the root component was loaded
  // successfully. If not, then the object created from it will be null. The root component may
  // get loaded asynchronously.
  const QMetaObject::Connection connection =
      QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                       [&](QObject *object, const QUrl &url) {
                         if (url != main_qml)
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
  engine.load(main_qml);

  cpp_handler.setEngine(&engine);

  return app.exec();
}
