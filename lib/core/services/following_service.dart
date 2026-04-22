import 'package:get/get.dart';

enum FollowEntityType { league, player, team, coach, match }

class FollowingService extends GetxService {
  final RxInt revision = 0.obs;

  final Map<FollowEntityType, Set<String>> _followedIds =
      <FollowEntityType, Set<String>>{
        FollowEntityType.league: <String>{
          'premier-league',
          'laliga',
          'serie-a',
          'champions-league',
          'bundesliga',
        },
        FollowEntityType.player: <String>{'cristiano-ronaldo'},
        FollowEntityType.team: <String>{'bangladesh', 'arsenal', 'al-nassr'},
        FollowEntityType.coach: <String>{'diego-simeone'},
        FollowEntityType.match: <String>{'barcelona-vs-atletico'},
      };

  bool isFollowing(FollowEntityType type, String id) {
    return _followedIds[type]?.contains(id) ?? false;
  }

  void follow(FollowEntityType type, String id) {
    _followedIds.putIfAbsent(type, () => <String>{}).add(id);
    revision.value++;
  }

  void unfollow(FollowEntityType type, String id) {
    _followedIds[type]?.remove(id);
    revision.value++;
  }
}
