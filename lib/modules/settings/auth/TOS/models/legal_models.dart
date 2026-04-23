class LegalParagraphSectionModel {
  final String heading;
  final String body;

  const LegalParagraphSectionModel({required this.heading, required this.body});
}

class PrivacyPolicyUiModel {
  final String lastUpdated;
  final List<LegalParagraphSectionModel> sections;
  final String contactTitle;
  final String contactBody;
  final String contactEmail;
  final String termsButtonLabel;

  const PrivacyPolicyUiModel({
    required this.lastUpdated,
    required this.sections,
    required this.contactTitle,
    required this.contactBody,
    required this.contactEmail,
    required this.termsButtonLabel,
  });
}

class TermsAndConditionUiModel {
  final String lastUpdated;
  final List<LegalParagraphSectionModel> sections;
  final String contactTitle;
  final String contactBody;
  final String contactEmail;

  const TermsAndConditionUiModel({
    required this.lastUpdated,
    required this.sections,
    required this.contactTitle,
    required this.contactBody,
    required this.contactEmail,
  });
}
