import 'package:get/get.dart';

import 'news_model.dart';

class NewsController extends GetxController {
  final Rx<NewsViewModel> state = const NewsViewModel(
    articles: <NewsArticleUiModel>[
      NewsArticleUiModel(
        id: 'arteta-etihad',
        title: 'Arsenal vs Man City: Why Mikel Arteta must win at Etihad',
        source: 'Sky Sports',
        sourceSeed: 'SKY',
        relativeTime: '2h ago',
        publishedLabel: 'Published April 17, 2026',
        readTimeLabel: '6 min read',
        bodyLead:
            'The stage is set. The lights are glaring. For Mikel Arteta and Arsenal, the trip to the Etihad Stadium is no longer just another fixture; it is the definitive litmus test of their championship credentials.',
        paragraphs: <String>[
          'For the past three seasons, the narrative has been consistent: Arsenal are brilliant, dynamic, and undeniably moving in the right direction. Yet, when the shadow of Pep Guardiola’s Manchester City looms largest, the Gunners have faltered. The Etihad has been a fortress of frustration, a graveyard for Arsenal’s loftiest ambitions.',
          'Arteta knows this better than anyone. He helped build the blue machine that currently dominates English football. But to unseat the king, the apprentice must do more than just match him tactically—he must overcome the immense psychological hurdle that City presents. It’s not just about points; it’s about breaking a mental block.',
          'A result here would reverberate far beyond the title race. It would signal maturity, resilience, and genuine belief. Lose again, and the old questions return. Can this Arsenal side truly deliver when it matters most?',
        ],
      ),
      NewsArticleUiModel(
        id: 'mercato-defender',
        title: 'Mercato : L\'OL fonce sur un défenseur à 15 millions…',
        source: 'LiveFoot.fr',
        sourceSeed: 'LF',
        relativeTime: '3h ago',
        publishedLabel: 'Published April 17, 2026',
        readTimeLabel: '3 min read',
        bodyLead: 'Lyon are reportedly accelerating talks for a new central defender as they plan an assertive summer window.',
        paragraphs: <String>[
          'The recruitment team wants to strengthen the spine of the squad after an inconsistent season at the back.',
        ],
      ),
      NewsArticleUiModel(
        id: 'mclaren-calendar',
        title: 'McLaren boss comments on calendar pause',
        source: 'Fireport.ru',
        sourceSeed: 'FP',
        relativeTime: '5h ago',
        publishedLabel: 'Published April 17, 2026',
        readTimeLabel: '4 min read',
        bodyLead: 'The team principal addressed the mid-season break and why teams are split on the current rhythm.',
        paragraphs: <String>[
          'More balance in travel and recovery remains a major talking point across the paddock.',
        ],
      ),
    ],
  ).obs;
}

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NewsController>()) {
      Get.lazyPut<NewsController>(() => NewsController());
    }
  }
}
