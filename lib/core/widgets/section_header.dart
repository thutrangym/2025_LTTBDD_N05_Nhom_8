import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onSeeAll;
  final VoidCallback? onTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onSeeAll,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (trailing != null)
            trailing!
          else if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: const Text('See All')),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: header,
      );
    }

    return header;
  }
}
