#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include "RegistrationHandler.hpp"

#include <bb/cascades/Application>

#include <QLocale>
#include <QTranslator>

#include <bb/platform/bbm/Context>

using namespace bb::cascades;

ApplicationUI::ApplicationUI(bb::cascades::Application *app) :
        QObject(app)
{
	m_reportDB = new ReportDB();
    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);
    if(!QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()))) {
        // This is an abnormal situation! Something went wrong!
        // Add own code to recover here
        qWarning() << "Recovering from a failed connect()";
    }
    // initial load
    onSystemLanguageChanged();

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    qml->setContextProperty("dbobject", this->m_reportDB);
    qml->setContextProperty("_app", this);
    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    //Create ActiveFrame
    QmlDocument *qmlCover = QmlDocument::create("asset:///PageActiveFrame.qml").parent(
            this);

    if (!qmlCover->hasErrors()) {
        // Create the QML Container from using the QMLDocument.
        Container *coverContainer = qmlCover->createRootObject<Container>();

        // Create a SceneCover and set the application cover
        SceneCover *sceneCover = SceneCover::create().content(coverContainer);
        Application::instance()->setCover(sceneCover);
    }

    // Set created root object as the application scene
    app->setScene(root);
    const QUuid uuid("93b43cf5-df17-4fab-bd4c-53571c385ca9");
    RegistrationHandler *regHandler = new RegistrationHandler(uuid, this);
    regHandler->registerApplication();
    m_profile = new bb::platform::bbm::UserProfile(&regHandler->context(), this);

    if(!QObject::connect(m_reportDB, SIGNAL(BBMUpdate(QString)), this, SLOT(onBBMStatusUpdate(QString)))) {
            // This is an abnormal situation! Something went wrong!
            // Add own code to recover here
            qWarning() << "Recovering from a failed connect()";
        }
}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("BB_Jam_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}
void ApplicationUI::onBBMStatusUpdate(const QString& newStatus)
{
	bool what = m_profile->requestUpdatePersonalMessage(newStatus);
	qDebug() << "BBM UPDATE RETURN: " << what;
}
