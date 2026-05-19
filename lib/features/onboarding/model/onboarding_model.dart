import 'package:flutter/material.dart';

class OnboardingFeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const OnboardingFeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingPageData {
  final String title;
  final String subtitle;
  final List<OnboardingFeatureItem> features;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.features,
  });
}
