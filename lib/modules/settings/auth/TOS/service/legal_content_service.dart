import '../models/legal_models.dart';

class LegalContentService {
  const LegalContentService();

  PrivacyPolicyUiModel getPrivacyPolicy() {
    return const PrivacyPolicyUiModel(
      lastUpdated: 'LAST UPDATED: JUNE 14, 2026',
      sections: [
        LegalParagraphSectionModel(
          heading: 'Introduction',
          body:
              'Welcome to KICSCORE. This Privacy Policy explains how we collect, use, store, share, and protect information when you use our Android app and related services to view live football scores, fixtures, league tables, match details, player and team information, World Cup information, and football news.',
        ),
        LegalParagraphSectionModel(
          heading: 'Information We Collect',
          body:
              'We may collect account information when you register or sign in, including your name, email address, profile photo, account status, and authentication details. We may also collect app and device information needed to operate the service, such as device type, app version, operating system version, language, diagnostics, crash information, and a unique installation ID for users who are not signed in.',
        ),
        LegalParagraphSectionModel(
          heading: 'Advertising and Monetization',
          body:
              'KICSCORE is an ad-supported app. We may show banner ads, native ads, or other ad formats from third-party advertising partners, including Meta Audience Network. These partners may collect or receive device information, advertising identifiers, app activity, approximate usage information, diagnostics, and similar data to deliver ads, measure ad performance, prevent fraud and abuse, and improve ad relevance. Advertising data processing may be controlled by the advertising partner\'s own policies and settings.',
        ),
        LegalParagraphSectionModel(
          heading: 'Advertising ID and Device Controls',
          body:
              'On Android, advertising partners may use the Google Advertising ID or similar device identifiers where available. You can reset or delete your Advertising ID, limit ad personalization, or manage related advertising settings from your Android device settings. If you reset or delete the Advertising ID, ads may still appear, but they may be less personalized.',
        ),
        LegalParagraphSectionModel(
          heading: 'Follow Data and Installation ID',
          body:
              'You can follow leagues, teams, players, coaches, or matches whether you are registered or not. If you are registered, your follow data is saved with your account. If you are not registered, your follow data is saved against a unique device or app installation ID so your followed items can work without creating an account.',
        ),
        LegalParagraphSectionModel(
          heading: 'Notifications',
          body:
              'KICSCORE may send push notifications and in-app notifications for followed matches, teams, leagues, players, coaches, football updates, and news. You can manage notification permissions from your Android device settings and change supported notification preferences inside the app where available.',
        ),
        LegalParagraphSectionModel(
          heading: 'Football Content and Usage Data',
          body:
              'To provide live scores and football information, we may process the leagues, teams, matches, players, coaches, news, pages, and features you view or interact with. This helps us show relevant content, maintain your following list, improve search, troubleshoot issues, protect the service, and keep the app reliable.',
        ),
        LegalParagraphSectionModel(
          heading: 'How We Use Information',
          body:
              'We use information to create and manage accounts, keep users signed in, save follow preferences, deliver live score updates and notifications, show football news, display and measure ads, improve app performance, prevent fraud and abuse, protect the service from misuse, and provide customer support.',
        ),
        LegalParagraphSectionModel(
          heading: 'Registered and Non-Registered Users',
          body:
              'Registered and non-registered users can use the main follow and notification features. Registered users have follow data linked to their account. Non-registered users have follow data linked to the unique installation ID used by the app.',
        ),
        LegalParagraphSectionModel(
          heading: 'Cookies, Local Storage, and Similar Technologies',
          body:
              'The app may use local storage and similar technologies to keep authentication, theme, installation ID, follow, notification, and preference data available across sessions. Related web services may use cookies or local storage to provide a consistent experience.',
        ),
        LegalParagraphSectionModel(
          heading: 'Data Sharing',
          body:
              'We do not sell your personal information. We may share limited information with trusted service providers and partners when needed to operate, secure, analyze, monetize, and support KICSCORE, including hosting providers, analytics and diagnostics providers, file storage providers, authentication providers, football data providers, push notification providers, and advertising partners such as Meta Audience Network.',
        ),
        LegalParagraphSectionModel(
          heading: 'Third-Party Services',
          body:
              'Some features depend on third-party services, including football data providers, Firebase services, cloud hosting, image storage, notification services, and advertising SDKs. These third parties may process information according to their own privacy policies and legal terms.',
        ),
        LegalParagraphSectionModel(
          heading: 'Data Retention',
          body:
              'We keep account, follow, notification, installation, diagnostic, and support data for as long as needed to provide the service, comply with legal requirements, resolve disputes, protect the platform, or until you delete your account or request deletion where applicable. Some data may remain for backup, security, fraud prevention, or legal reasons for a limited period.',
        ),
        LegalParagraphSectionModel(
          heading: 'Your Choices and Rights',
          body:
              'You can update your profile, unfollow entities, change notification settings, control push notification permissions from Android settings, reset or delete your Advertising ID from Android settings, and request account or data deletion where applicable. You may also stop using the app or uninstall it at any time.',
        ),
        LegalParagraphSectionModel(
          heading: 'Children\'s Privacy',
          body:
              'KICSCORE is intended for a general football audience and is not directed to children under the age of 13. We do not knowingly collect personal information from children under 13. If you believe a child has provided personal information, please contact us so we can take appropriate action.',
        ),
        LegalParagraphSectionModel(
          heading: 'Security',
          body:
              'We use reasonable technical and organizational measures to protect information. However, no online service can guarantee absolute security, so you should keep your login credentials safe and contact us if you believe your account has been misused.',
        ),
        LegalParagraphSectionModel(
          heading: 'Changes to This Policy',
          body:
              'We may update this Privacy Policy when we change our features, advertising setup, data practices, service providers, or legal requirements. The latest version will show the updated date on this page.',
        ),
      ],
      contactTitle: 'Contact Us',
      contactBody:
          'If you have questions about this Privacy Policy or want to request support for privacy-related matters, please contact us at:',
      contactEmail: 'hello@kicscore.com',
      termsButtonLabel: 'View Terms & Conditions',
    );
  }

  TermsAndConditionUiModel getTermsAndCondition() {
    return const TermsAndConditionUiModel(
      lastUpdated: 'LAST UPDATED: JUNE 14, 2026',
      sections: [
        LegalParagraphSectionModel(
          heading: 'Agreement to Terms',
          body:
              'By downloading, accessing, or using KICSCORE, you agree to be bound by these Terms & Conditions and our Privacy Policy. If you do not agree with any part of these terms, you must not use the app.',
        ),
        LegalParagraphSectionModel(
          heading: 'Use of the Service',
          body:
              'KICSCORE provides football scores, fixtures, match details, league tables, team profiles, player profiles, coach details, football news, notifications, and related features for informational and entertainment purposes. You agree to use the app only in a lawful and respectful way.',
        ),
        LegalParagraphSectionModel(
          heading: 'Live Scores and Data Accuracy',
          body:
              'KICSCORE strives to provide accurate and timely football scores, match statistics, fixtures, standings, and news. However, live sports data may be delayed, incomplete, changed, corrected, or affected by third-party data issues. All football data is provided as is and we do not guarantee that every timer, scoreline, lineup, table, statistic, or match event is always complete or error-free.',
        ),
        LegalParagraphSectionModel(
          heading: 'Not for Betting or Financial Decisions',
          body:
              'The information provided in KICSCORE must not be relied on for betting, gambling, financial decisions, or any activity where inaccurate or delayed sports data could cause loss. We are not responsible for any loss or damage caused by decisions made using the app content.',
        ),
        LegalParagraphSectionModel(
          heading: 'Accounts, Profiles, and Security',
          body:
              'You are responsible for keeping your account credentials secure and for activity under your account. You must provide accurate information where required and must not misuse another user\'s account, attempt unauthorized access, or interfere with the security or operation of the service.',
        ),
        LegalParagraphSectionModel(
          heading: 'Follow Features and Notifications',
          body:
              'The app may allow you to follow matches, teams, leagues, players, and coaches and receive related notifications. Notifications are provided for convenience and may be delayed, unavailable, or inaccurate. You can manage supported notification preferences in the app and from your Android device settings.',
        ),
        LegalParagraphSectionModel(
          heading: 'Ads and Monetization',
          body:
              'KICSCORE is an ad-supported app and may show third-party ads, including banner ads and native ads. Ads may be delivered by advertising partners such as Meta Audience Network. We are not responsible for third-party ads, advertiser websites, products, services, or claims. You must not attempt to generate fraudulent ad impressions or clicks, and you should not click ads for testing or artificial revenue purposes.',
        ),
        LegalParagraphSectionModel(
          heading: 'Third-Party Content and Services',
          body:
              'KICSCORE may use third-party services for football data, news content, images, hosting, analytics, notifications, authentication, file storage, and advertising. Third-party services may be subject to their own terms and policies. Links or ads that lead to third-party websites or services are provided for convenience and do not mean that we endorse them.',
        ),
        LegalParagraphSectionModel(
          heading: 'Team Logos, Trademarks, and Media',
          body:
              'Team names, club logos, league badges, player images, coach images, and other football-related trademarks or media shown in the app belong to their respective owners. They are used for identification, informational, and news-related purposes. KICSCORE does not claim ownership of third-party trademarks or media.',
        ),
        LegalParagraphSectionModel(
          heading: 'Acceptable Use',
          body:
              'You must not use KICSCORE to violate laws, abuse the service, scrape or copy large amounts of content without permission, reverse engineer the app, interfere with ads or tracking systems, upload harmful content, attempt unauthorized access, or take actions that may harm users, KICSCORE, or third-party service providers.',
        ),
        LegalParagraphSectionModel(
          heading: 'Service Availability',
          body:
              'We may update, modify, suspend, or discontinue any part of the service at any time. Features may be unavailable because of maintenance, network issues, third-party service problems, data provider limitations, or other causes outside our control.',
        ),
        LegalParagraphSectionModel(
          heading: 'Limitation of Liability',
          body:
              'To the maximum extent permitted by applicable law, KICSCORE and its operators will not be liable for indirect, incidental, special, consequential, or financial damages arising from your use of the app, data inaccuracies, ads, third-party services, service interruptions, or loss of data.',
        ),
        LegalParagraphSectionModel(
          heading: 'Changes to These Terms',
          body:
              'We may update these Terms & Conditions when we change our features, monetization, service providers, legal requirements, or business practices. The latest version will show the updated date on this page. Continued use of the app after changes means you accept the updated terms.',
        ),
      ],
      contactTitle: 'Contact Us',
      contactBody:
          'If you have questions about these Terms & Conditions, please contact us at:',
      contactEmail: 'hello@kicscore.com',
    );
  }
}
