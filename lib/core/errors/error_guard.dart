import 'dart:async';

import 'firebase_error_mapper.dart';

/// Runs [action] and rethrows any failure as an `AppException`.
/// Used by repositories so nothing raw escapes the data layer.
Future<T> guardAppException<T>(Future<T> Function() action) async {
  try {
    return await action();
  } catch (error, stackTrace) {
    throw FirebaseErrorMapper.map(error, stackTrace);
  }
}

/// Re-emits stream errors as `AppException`s.
Stream<T> mapStreamErrors<T>(Stream<T> source) {
  return source.transform(
    StreamTransformer<T, T>.fromHandlers(
      handleError: (error, stackTrace, sink) =>
          sink.addError(FirebaseErrorMapper.map(error, stackTrace), stackTrace),
    ),
  );
}
