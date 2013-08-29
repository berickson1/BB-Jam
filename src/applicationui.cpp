#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>


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
	m_context = new bb::platform::bbm::Context(
			//UUID was generated at random for this sample
			//BE SURE TO USE YOUR OWN UNIQUE UUID. You can gerneate one here: http://www.guidgenerator.com/
			QUuid("93b43cf5-df17-4fab-bd4c-53571c385ca9"));
	if (m_context->registrationState()
			!= bb::platform::bbm::RegistrationState::Allowed) {
		connect(m_context,
				SIGNAL(registrationStateUpdated (bb::platform::bbm::RegistrationState::Type)),
				this,
				SLOT(registrationStateUpdated (bb::platform::bbm::RegistrationState::Type)));
		m_context->requestRegisterApplication();
	}
}

void ApplicationUI::inviteUserToDownloadViaBBM() {
	if (m_context->registrationState()
			== bb::platform::bbm::RegistrationState::Allowed) {
		m_messageService->sendDownloadInvitation();
	} else {
		SystemDialog *bbmDialog = new SystemDialog("OK");
		bbmDialog->setTitle("BBM Connection Error");
		bbmDialog->setBody(
				"BBM is not currently connected. Please setup / sign-in to BBM to remove this message.");
		connect(bbmDialog, SIGNAL(finished(bb::system::SystemUiResult::Type)),
				this, SLOT(dialogFinished(bb::system::SystemUiResult::Type)));
		bbmDialog->show();
		return;
	}
}
void ApplicationUI::updatePersonalMessage(const QString &message) {
	if (m_context->registrationState()
			== bb::platform::bbm::RegistrationState::Allowed) {
		m_userProfile->requestUpdatePersonalMessage(message);
	} else {
		SystemDialog *bbmDialog = new SystemDialog("OK");
		bbmDialog->setTitle("BBM Connection Error");
		bbmDialog->setBody(
				"BBM is not currently connected. Please setup / sign-in to BBM to remove this message.");
		connect(bbmDialog, SIGNAL(finished(bb::system::SystemUiResult::Type)),
				this, SLOT(dialogFinished(bb::system::SystemUiResult::Type)));
		bbmDialog->show();
		return;
	}
}
void ApplicationUI::registrationStateUpdated(
		bb::platform::bbm::RegistrationState::Type state) {
	if (state == bb::platform::bbm::RegistrationState::Allowed) {
		m_messageService = new bb::platform::bbm::MessageService(m_context,
				this);
		m_userProfile = new bb::platform::bbm::UserProfile(m_context, this);
	} else if (state == bb::platform::bbm::RegistrationState::Unregistered) {
		m_context->requestRegisterApplication();
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
