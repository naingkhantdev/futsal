import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

/// Copy announced when a submit fails client validation.
abstract final class FormCopy {
  static const String fixHighlightedFields = 'Fix the highlighted fields';
}

/// A form field for [validateFormForSubmit]: its focus node and a check
/// that re-runs its validator against the current value.
typedef FieldCheck = ({FocusNode focusNode, String? Function() validate});

/// Validates [formKey]'s form for a submit.
///
/// Valid → dismisses the keyboard and returns true. Invalid → keeps the
/// keyboard, focuses the first invalid field in [fields] order, announces
/// "Fix the highlighted fields" to screen readers, and returns false.
bool validateFormForSubmit(
  BuildContext context, {
  required GlobalKey<FormState> formKey,
  required List<FieldCheck> fields,
}) {
  final valid = formKey.currentState?.validate() ?? false;
  if (valid) {
    FocusScope.of(context).unfocus();
    return true;
  }
  for (final field in fields) {
    if (field.validate() != null) {
      field.focusNode.requestFocus();
      break;
    }
  }
  SemanticsService.announce(
    FormCopy.fixHighlightedFields,
    Directionality.of(context),
  );
  return false;
}
