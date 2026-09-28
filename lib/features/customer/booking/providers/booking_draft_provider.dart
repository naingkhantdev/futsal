import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/vos/booking_draft.dart';

/// What the customer picked on the slot screen, read by the review screen.
/// Cleared once the flow ends.
class BookingDraftNotifier extends Notifier<BookingDraft?> {
  @override
  BookingDraft? build() => null;

  void set(BookingDraft draft) => state = draft;

  void clear() => state = null;
}

final bookingDraftProvider =
    NotifierProvider<BookingDraftNotifier, BookingDraft?>(
  BookingDraftNotifier.new,
);
