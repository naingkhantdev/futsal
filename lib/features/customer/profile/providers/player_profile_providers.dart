import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../data/repositories/player_repository.dart';
import '../../../../data/vos/auth_session.dart';
import '../../../../data/vos/player_profile_vo.dart';
import '../../../auth/providers/auth_session_provider.dart';
import '../../bookings/providers/customer_bookings_providers.dart';

/// CUSTOMER (self) scope: the signed-in user's own player card, `null`
/// until they create one.
final myPlayerProfileProvider =
    StreamProvider.autoDispose<PlayerProfileVO?>((ref) {
  final uid = ref.watch(
    currentAuthSessionProvider.select((s) => s is SignedIn ? s.uid : null),
  );
  if (uid == null) return Stream<PlayerProfileVO?>.value(null);
  return ref.watch(playerRepositoryProvider).watch(uid);
});

typedef PlayingHistory = ({int played, DateTime? lastPlayed});

/// CUSTOMER (self) scope: games played = own completed bookings. Derived
/// from `myBookingsProvider`, so it is private to the user (other players
/// can't read someone's bookings).
final myPlayingHistoryProvider =
    Provider.autoDispose<AsyncValue<PlayingHistory>>((ref) {
  return ref.watch(myBookingsProvider).whenData((bookings) {
    var played = 0;
    DateTime? last;
    for (final b in bookings) {
      if (b.status != BookingStatus.completed) continue;
      played++;
      final start = b.startAt;
      if (start != null && (last == null || start.isAfter(last))) last = start;
    }
    return (played: played, lastPlayed: last);
  });
});

/// Saves the signed-in user's player card.
class PlayerProfileController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save({
    required PlayerPosition position,
    required SkillLevel skillLevel,
    String? bio,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(playerRepositoryProvider).saveMine(
            position: position,
            skillLevel: skillLevel,
            bio: bio,
          ),
    );
    return !state.hasError;
  }
}

final playerProfileControllerProvider =
    AsyncNotifierProvider.autoDispose<PlayerProfileController, void>(
  PlayerProfileController.new,
);
