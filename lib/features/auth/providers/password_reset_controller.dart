import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/errors/firebase_error_mapper.dart';
import '../../../data/repositories/auth_repository.dart';

/// Forgot-password form state. [sentTo] non-null = success view shown.
@immutable
class PasswordResetState {
  const PasswordResetState({
    this.sentTo,
    this.sentAt,
    this.isSending = false,
    this.error,
  });

  final String? sentTo;

  /// When the last link was sent; drives the resend cooldown.
  final DateTime? sentAt;
  final bool isSending;
  final AppException? error;

  bool get isSent => sentTo != null;
}

class PasswordResetController
    extends AutoDisposeNotifier<PasswordResetState> {
  @override
  PasswordResetState build() => const PasswordResetState();

  /// Sends (or resends) the reset link. Keeps the success view on resend.
  Future<void> send(String email) async {
    final trimmed = email.trim();
    state = PasswordResetState(
      sentTo: state.sentTo,
      sentAt: state.sentAt,
      isSending: true,
    );
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(trimmed);
      state = PasswordResetState(sentTo: trimmed, sentAt: DateTime.now());
    } catch (error, stackTrace) {
      state = PasswordResetState(
        sentTo: state.sentTo,
        sentAt: state.sentAt,
        error: FirebaseErrorMapper.map(error, stackTrace),
      );
    }
  }
}

final passwordResetControllerProvider = NotifierProvider.autoDispose<
    PasswordResetController, PasswordResetState>(
  PasswordResetController.new,
);
