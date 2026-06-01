import '../models/legal_models.dart';

class LegalContentService {
  const LegalContentService();

  PrivacyPolicyUiModel getPrivacyPolicy() {
    return const PrivacyPolicyUiModel(
      lastUpdated: 'LAST UPDATED: MAY 31, 2026',
      sections: [
        LegalParagraphSectionModel(
          heading: 'Introduction',
          body:
              'Welcome to KICSCORE. This privacy policy explains how we collect, use, store, and protect information when you use our website and Android app to view live football scores, league details, team details, match details, upcoming and previous fixtures, World Cup information, player details, coach details, and football news.',
        ),
        LegalParagraphSectionModel(
          heading: 'Information We Collect',
          body:
              'We may collect account information when you register or sign in, such as your name, email address, profile photo, account status, and authentication details. We also collect app or browser information needed to keep the service working, including a unique installation ID for users who are not signed in.',
        ),
        LegalParagraphSectionModel(
          heading: 'Follow Data and Installation ID',
          body:
              'You can follow leagues, teams, players, coaches, or matches whether you are registered or not. If you are registered, your follow data is saved with your account. If you are not registered, your follow data is saved against a unique device or app installation ID so your followed items can still work without creating an account.',
        ),
        LegalParagraphSectionModel(
          heading: 'Notifications',
          body:
              'KICSCORE may send push notifications and in-app notifications for followed matches, teams, leagues, players, coaches, football updates, and news. News notifications may be enabled by default, but you can turn off news notifications, match alerts, team alerts, league alerts, player alerts, push notifications, and in-app notifications from the settings page.',
        ),
        LegalParagraphSectionModel(
          heading: 'Football Content and Usage Data',
          body:
              'To provide live scores and football information, we may process the leagues, teams, matches, players, coaches, news, pages, and features you view or interact with. This helps us show relevant content, maintain your following list, improve search, troubleshoot issues, and keep the service reliable.',
        ),
        LegalParagraphSectionModel(
          heading: 'How We Use Your Information',
          body:
              'We use your information to create and manage accounts, keep users signed in, save follow preferences, deliver live score updates and notifications, show football news, improve product performance, protect the service from misuse, and provide customer support.',
        ),
        LegalParagraphSectionModel(
          heading: 'Registered and Non-Registered Users',
          body:
              'Registered and non-registered users can use the main follow and notification features. The main difference is that registered users have follow data linked to their account, while non-registered users have follow data linked to the unique installation ID used by the website or app.',
        ),
        LegalParagraphSectionModel(
          heading: 'Cookies and Local Storage',
          body:
              'On the website, we may use cookies or local storage to keep authentication, theme, installation ID, follow, and preference data available across sessions. These technologies help the website remember your choices and provide a consistent experience.',
        ),
        LegalParagraphSectionModel(
          heading: 'Data Sharing',
          body:
              'We do not sell your personal information. We may share limited information with trusted service providers only when needed to operate KICSCORE, such as hosting, analytics, file storage, authentication, football data, push notification delivery, security, and support services.',
        ),
        LegalParagraphSectionModel(
          heading: 'Data Retention',
          body:
              'We keep account, follow, notification, and installation data for as long as needed to provide the service, comply with legal requirements, resolve disputes, protect the platform, or until you delete your account or request deletion where applicable.',
        ),
        LegalParagraphSectionModel(
          heading: 'Your Choices and Rights',
          body:
              'You can update your profile, unfollow entities, change notification settings, turn off notification categories, and request account or data deletion where applicable. You can also control push notification permissions from your browser or Android device settings.',
        ),
        LegalParagraphSectionModel(
          heading: 'Security',
          body:
              'We use reasonable technical and organizational measures to protect your information. However, no online service can guarantee absolute security, so you should keep your login credentials safe and contact us if you believe your account has been misused.',
        ),
        LegalParagraphSectionModel(
          heading: 'Changes to This Policy',
          body:
              'We may update this privacy policy when we change our features, data practices, or legal requirements. The latest version will always show the updated date on this page.',
        ),
      ],
      contactTitle: 'Contact Us',
      contactBody:
          'If you have questions about this privacy policy, please contact our support team at:',
      contactEmail: 'hello@kicscore.com',
      termsButtonLabel: 'View Terms & Condition',
    );
  }

  TermsAndConditionUiModel getTermsAndCondition() {
    return const TermsAndConditionUiModel(
      lastUpdated: 'LAST UPDATED: MAY 31, 2026',
      sections: [
        LegalParagraphSectionModel(
          heading: 'Agreement to Terms',
          body:
              'By downloading, accessing, or using KICSCORE, you agree to be bound by these Terms & Conditions. If you do not agree with any part of these terms, you must not use the app.',
        ),
        LegalParagraphSectionModel(
          heading: 'Live Scores & Data Accuracy',
          body:
              'KICSCORE strives to provide accurate and real-time football scores, match statistics, and news. However, live sports data is subject to inherent delays and human error. All match data is provided "as is" for informational and entertainment purposes only. We do not guarantee 100% accuracy of live timers, scorelines, or VAR decisions.',
        ),
        LegalParagraphSectionModel(
          heading: 'Not for Betting Purposes',
          body:
              'The information provided within KICSCORE should not be relied upon for placing financial wagers or betting. We are not liable for any financial losses incurred based on the data displayed in this application.',
        ),
        LegalParagraphSectionModel(
          heading: 'Team Logos & Trademarks',
          body:
              'All team names, club logos, league badges, and player images displayed in the app are the property of their respective owners and are used strictly under fair use for identification and news reporting purposes.',
        ),
      ],
      contactTitle: 'Contact Us',
      contactBody:
          'If you have questions about these terms, please contact our support team at:',
      contactEmail: 'hello@kicscore.com',
    );
  }
}
