import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../model/onboarding_model.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingPageData> pages = const [
    OnboardingPageData(
      title: 'Prepare for Your NCLEX Exam',
      subtitle:
          'Master the content and confidence needed to pass your boards with our comprehensive prep suite.',
      features: [
        OnboardingFeatureItem(
          icon: Icons.menu_book,
          title: 'Practice Questions',
          subtitle: '3,000+ NCLEX-style items with detailed rationales.',
        ),
        OnboardingFeatureItem(
          icon: Icons.assignment,
          title: 'Simulated Exams',
          subtitle: 'Experience the realistic test-day environment.',
        ),
        OnboardingFeatureItem(
          icon: Icons.analytics,
          title: 'Detailed Analytics',
          subtitle:
              'Identify your weak areas instantly with performance tracking.',
        ),
      ],
    ),
    OnboardingPageData(
      title: 'Master the Exam with Confidence',
      subtitle:
          'Practice with thousands of NCLEX-style questions designed to mimic the real testing environment.',
      features: [
        OnboardingFeatureItem(
          icon: Icons.psychology,
          title: 'Adaptive Difficulty',
          subtitle:
              'Questions evolve based on your performance to bridge knowledge gaps.',
        ),
        OnboardingFeatureItem(
          icon: Icons.fact_check,
          title: 'Detailed Rationales',
          subtitle:
              "Understand the 'why' behind every correct and incorrect answer choice.",
        ),
      ],
    ),
    OnboardingPageData(
      title: 'Track Your Progress',
      subtitle:
          'Master your weak areas with intelligent analytics. Identify exactly where you need to focus to pass your boards with confidence.',
      features: [],
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void skip() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    StorageService.setOnboardingComplete();
    Get.offAllNamed(AppRoute.getWelcomeScreen());
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
