import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/router.dart';

class CommonFooterLinks extends StatelessWidget {
  const CommonFooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => context.push(
            AppRoutes.markdownViewer,
            extra: ['assets/markdown/legal/conditions_of_use.md', 'Conditions of Use'],
          ),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(
              context,
            ).colorScheme.onSecondary.withAlpha(75),
          ),
          child: const Text("Conditions of Use"),
        ),
        TextButton(
          onPressed: () => context.push(
            AppRoutes.markdownViewer,
            extra: ['assets/markdown/legal/privacy_notes.md', 'Privacy Notice'],
          ),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(
              context,
            ).colorScheme.onSecondary.withAlpha(75),
          ),
          child: const Text("Privacy Notice"),
        ),
      ],
    );
  }
}
