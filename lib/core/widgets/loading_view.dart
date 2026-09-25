import 'package:flutter/material.dart';

import '../theme/app_sizes.dart';

/// Centered spinner. Prefer skeletons for screens with a known layout;
/// use this only where no layout is known yet.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.semanticLabel = 'Loading'});

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: semanticLabel,
        child: const SizedBox.square(
          dimension: AppSizes.loadingSpinner,
          child: CircularProgressIndicator(
            strokeWidth: AppSizes.buttonSpinnerStroke,
          ),
        ),
      ),
    );
  }
}
