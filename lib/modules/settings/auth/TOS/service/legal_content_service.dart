import '../models/legal_models.dart';

class LegalContentService {
  const LegalContentService();

  PrivacyPolicyUiModel getPrivacyPolicy() {
    return const PrivacyPolicyUiModel(
      lastUpdated: 'Last Updated: April 18, 2026',
      sections: [
        LegalParagraphSectionModel(
          heading: 'Introduction',
          body:
              'Welcome to KICSCORE. We are committed to protecting your personal information and your right to privacy. This policy explains how we collect and use your data when you use our mobile application to follow live football scores, news, and team updates.',
        ),
        LegalParagraphSectionModel(
          heading: 'Information We Collect',
          body:
              'To provide you with personalized match updates, push notifications for your favorite teams, and to sync your preferences across devices, we collect account information (if you choose to sign in) and device identifiers. We may also collect non-precise location data to show you localized leagues and relevant news.',
        ),
        LegalParagraphSectionModel(
          heading: 'Usage of Information',
          body:
              'Your data is used strictly to enhance your app experience. This includes delivering real-time goal alerts, tailoring the Following tab to your selected clubs and leagues, and improving app stability through crash reporting.',
        ),
      ],
      contactTitle: 'Contact Us',
      contactBody:
          'If you have questions about this privacy policy, please contact our support team at:',
      contactEmail: 'support@kicscore.com',
      termsButtonLabel: 'View Terms & Condition',
    );
  }

  TermsAndConditionUiModel getTermsAndCondition() {
    return const TermsAndConditionUiModel(
      lastUpdated: 'Last Updated: April 18, 2026',
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
          'If you have questions about this privacy policy, please contact our support team at:',
      contactEmail: 'support@kicscore.com',
    );
  }
}
