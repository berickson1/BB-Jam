#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>
#include "ReportDB.hpp"
#include <bb/cascades/SceneCover>
#include <bb/cascades/Container>
#include <bb/platform/bbm/Context>
#include <bb/platform/bbm/MessageService>
#include <bb/platform/bbm/UserProfile>
namespace bb {
namespace cascades {
class Application;
class LocaleHandler;
}
}

class QTranslator;

/*!
 * @brief Application object
 *
 *
 */

class ApplicationUI: public QObject {
Q_OBJECT
public:
	ApplicationUI(bb::cascades::Application *app);
	virtual ~ApplicationUI() {
	}
	ReportDB * m_reportDB;Q_INVOKABLE
	void inviteUserToDownloadViaBBM();Q_INVOKABLE
	void updatePersonalMessage(const QString &message);
private slots:
	void onSystemLanguageChanged();
private:
	void handle_events();
	QTranslator* m_pTranslator;
	bb::cascades::LocaleHandler* m_pLocaleHandler;
	bb::platform::bbm::UserProfile * m_userProfile;
	bb::platform::bbm::Context *m_context;
	bb::platform::bbm::MessageService *m_messageService;Q_SLOT
	void registrationStateUpdated(
			bb::platform::bbm::RegistrationState::Type state);
};

#endif /* ApplicationUI_HPP_ */
