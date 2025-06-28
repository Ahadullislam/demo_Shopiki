import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class AnimatedDashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String lottieAsset;
  const AnimatedDashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Lottie.asset(lottieAsset, width: 48, height: 48),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ],
      ).animate().fadeIn().slide(),
    );
  }
}
