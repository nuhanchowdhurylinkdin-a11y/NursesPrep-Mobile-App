import '../../features/daily_progress/model/daily_progress_model.dart';
import '../../features/exam_history/model/exam_history_model.dart';
import '../../features/home/model/dashboard_model.dart';
import '../../features/library/model/library_home_model.dart';
import '../../features/performance_details/model/performance_details_model.dart';
import '../../features/practice/model/practice_data_model.dart';
import '../../features/progress_trend/model/progress_trend_model.dart';
import '../../features/profile/model/profile_model.dart';
import '../../features/todays_focus/model/todays_focus_model.dart';

/// Static mock data shown to guest users (those who entered via "View as Guest").
class GuestMockData {
  GuestMockData._();

  static const String guestName = 'Guest User';
  static const String guestEmail = 'guest@nurseprep.app';
  static const String guestLicense = 'NCLEX-RN';

  // ─── Dashboard ──────────────────────────────────────────────────
  static DashboardModel get dashboard => DashboardModel(
        welcome: WelcomeData(
          fullName: guestName,
          licenseType: guestLicense,
        ),
        performanceSummary: PerformanceSummary(
          accuracy: 78.0,
          examsTotal: 12,
          focusNeeded: FocusNeeded(
            title: 'Pharmacology',
            averageScore: 62,
          ),
        ),
        dailyProgress: DailyProgress(
          answeredQuestions: 24,
          targetQuestions: 50,
          completionPercentage: 48,
        ),
      );

  // ─── Library ────────────────────────────────────────────────────
  static LibraryHomeModel get libraryHome => LibraryHomeModel(
        savedTopics: SavedTopicsInfo(totalBookmarked: 8),
        medicalCategories: [
          MedicalCategoryItem(
              id: 'mock-cat-1', name: 'Cardiology', totalMaterials: 24),
          MedicalCategoryItem(
              id: 'mock-cat-2', name: 'Pharmacology', totalMaterials: 36),
          MedicalCategoryItem(
              id: 'mock-cat-3', name: 'Pediatrics', totalMaterials: 18),
          MedicalCategoryItem(
              id: 'mock-cat-4', name: 'Mental Health', totalMaterials: 22),
        ],
        studyGuides: List.generate(
          4,
          (i) => StudyGuideItem(
            id: 'mock-guide-$i',
            title: [
              'NCLEX Prep: Cardiac Basics',
              'Pharmacology Quick Reference',
              'Pediatric Vital Signs',
              'Mental Health Assessment Guide',
            ][i],
            description:
                'A concise study guide covering essential nursing concepts and exam-focused review material.',
            itemType: 'pdf',
            badgeLabel: ['New', 'Popular', 'Updated', 'Trending'][i],
            category: GuideCategory(
                id: 'mock-cat-${i + 1}',
                name: ['Cardiology', 'Pharmacology', 'Pediatrics', 'Mental Health'][i]),
            topic: GuideTopic(id: 'mock-topic-$i', name: 'Topic ${i + 1}'),
            fileName: 'guide_${i + 1}.pdf',
            fileUrl: null,
            pageCount: 20 + i * 5,
            estimatedReadMinutes: 15 + i * 5,
            isSaved: i.isEven,
            hasViewed: false,
            userState: 'unread',
            progressPercentage: null,
            thumbnailUrl: null,
            updatedAt: null,
          ),
        ),
      );

  // ─── Profile ────────────────────────────────────────────────────
  static ProfileData get profile {
    final now = DateTime.now();
    return ProfileData(
      id: 'guest',
      fullName: guestName,
      email: guestEmail,
      role: 'guest',
      licenseType: ProfileLicenseType(
        id: 'mock-license',
        licenseName: guestLicense,
        createdAt: now,
      ),
      avatarUrl: null,
      is2FaEnabled: false,
      lastActive: now,
      platform: 'mobile',
      createdAt: now,
      updatedAt: now,
      deletedAt: null,
      isEmailVerified: false,
      lastLoginAt: now,
      lastLoginIp: '0.0.0.0',
      fcmToken: null,
      practiceDailyGoal: 50,
      subscriptions: const [],
    );
  }

  // ─── Today's Focus ──────────────────────────────────────────────
  static TodaysFocusModel get todaysFocus => TodaysFocusModel(
        examReadiness: ExamReadiness(
          percentage: 72,
          changePercentage: 4,
          basedOnQuestions: 240,
        ),
        dailyQuestionGoal: DailyQuestionGoal(
          answeredQuestions: 24,
          targetQuestions: 50,
          completionPercentage: 48,
          remainingQuestions: 26,
          message: 'Keep going — you\'re halfway there!',
        ),
        weakCategories: [
          WeakCategoryItem(
            categoryId: 'mock-cat-2',
            categoryName: 'Pharmacology',
            facedQuestions: 40,
            correctAnswers: 22,
            lastActiveAt: null,
            accuracyRate: 55,
            priority: 'high',
            statusText: 'Needs review',
            lastActiveDays: 2,
          ),
          WeakCategoryItem(
            categoryId: 'mock-cat-3',
            categoryName: 'Pediatrics',
            facedQuestions: 30,
            correctAnswers: 18,
            lastActiveAt: null,
            accuracyRate: 60,
            priority: 'medium',
            statusText: 'Improving',
            lastActiveDays: 4,
          ),
        ],
        smartRecommendation: SmartRecommendation(
          title: 'Focus on Pharmacology',
          description:
              'Strengthen your weakest area with a targeted 20-question session.',
          questionCount: 20,
          action: null,
        ),
      );

  // ─── Progress Trend ─────────────────────────────────────────────
  static ProgressTrendModel get progressTrend => ProgressTrendModel(
        period: '30d',
        avgAccuracy: 76,
        predictiveScore: PredictiveScore(
          label: 'Likely to pass',
          level: 'high',
        ),
        trendPoints: List.generate(
          7,
          (i) => TrendPoint(
            date: '2026-04-0${i + 1}',
            accuracy: 65 + i * 2.5,
            mode: 'practice',
          ),
        ),
        clinicalGrowthInsight: ClinicalGrowthInsight(
          strongestArea: 'Cardiology',
          weakestArea: 'Pharmacology',
          narrative:
              'Your cardiology mastery is excellent. Spend more time on pharmacology to round out your readiness.',
        ),
        milestones: [
          Milestone(
            sessionId: 'mock-session-1',
            mode: 'practice',
            title: 'First 100 questions',
            scorePercentage: 78,
            completedAt: DateTime.now().subtract(const Duration(days: 7)),
          ),
          Milestone(
            sessionId: 'mock-session-2',
            mode: 'exam',
            title: 'Mock NCLEX completed',
            scorePercentage: 82,
            completedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
      );

  // ─── Performance Details ────────────────────────────────────────
  static PerformanceDetailsModel get performanceDetails =>
      PerformanceDetailsModel(
        period: '7d',
        overview: PerformanceOverview(
          overallAccuracy: 78,
          overallAccuracyChange: 4,
          timePerQuestionSeconds: 45,
          timePerQuestionImprovement: 3,
          studyHours: 12.5,
          studyHoursChange: 1.5,
          facedQuestions: 240,
          correctAnswers: 187,
        ),
        chart: PerformanceChart(
          granularity: 'day',
          points: [
            ChartPoint(key: 'd1', label: 'Mon', facedQuestions: 22, accuracy: 70),
            ChartPoint(key: 'd2', label: 'Tue', facedQuestions: 30, accuracy: 76),
            ChartPoint(key: 'd3', label: 'Wed', facedQuestions: 18, accuracy: 72),
            ChartPoint(key: 'd4', label: 'Thu', facedQuestions: 35, accuracy: 80),
            ChartPoint(key: 'd5', label: 'Fri', facedQuestions: 28, accuracy: 78),
            ChartPoint(key: 'd6', label: 'Sat', facedQuestions: 24, accuracy: 82),
            ChartPoint(key: 'd7', label: 'Sun', facedQuestions: 23, accuracy: 84),
          ],
        ),
        topicMastery: [
          TopicMasteryItem(
            topicId: 'mock-topic-1',
            topicName: 'Cardiology',
            facedQuestions: 60,
            correctAnswers: 50,
            accuracyRate: 83,
            status: 'strong',
            insight: 'Excellent grasp of cardiac concepts',
          ),
          TopicMasteryItem(
            topicId: 'mock-topic-2',
            topicName: 'Pharmacology',
            facedQuestions: 40,
            correctAnswers: 22,
            accuracyRate: 55,
            status: 'weak',
            insight: 'Focus on drug interactions',
          ),
          TopicMasteryItem(
            topicId: 'mock-topic-3',
            topicName: 'Pediatrics',
            facedQuestions: 30,
            correctAnswers: 21,
            accuracyRate: 70,
            status: 'moderate',
            insight: 'Improving steadily',
          ),
        ],
      );

  // ─── Practice Data ──────────────────────────────────────────────
  static PracticeDataModel get practiceData {
    final now = DateTime.now();
    return PracticeDataModel(
      categories: [
        CategoryModel(
            id: 'mock-cat-1', categoryName: 'Cardiology', createdAt: now),
        CategoryModel(
            id: 'mock-cat-2', categoryName: 'Pharmacology', createdAt: now),
        CategoryModel(
            id: 'mock-cat-3', categoryName: 'Pediatrics', createdAt: now),
        CategoryModel(
            id: 'mock-cat-4', categoryName: 'Mental Health', createdAt: now),
      ],
      topics: [
        TopicModel(id: 'mock-topic-1', topicName: 'Heart Failure', createdAt: now),
        TopicModel(id: 'mock-topic-2', topicName: 'Hypertension', createdAt: now),
        TopicModel(id: 'mock-topic-3', topicName: 'Antibiotics', createdAt: now),
        TopicModel(id: 'mock-topic-4', topicName: 'Vaccinations', createdAt: now),
      ],
      difficulties: [
        DifficultyModel(id: 'mock-diff-1', levelName: 'Easy', createdAt: now),
        DifficultyModel(id: 'mock-diff-2', levelName: 'Medium', createdAt: now),
        DifficultyModel(id: 'mock-diff-3', levelName: 'Hard', createdAt: now),
      ],
      licenses: [
        LicenseModel(
            id: 'mock-license', licenseName: guestLicense, createdAt: now),
      ],
    );
  }

  // ─── Exam Summary ───────────────────────────────────────────────
  static ExamSummary get examSummary => ExamSummary(
        averageScore: 68.5,
        totalExams: 8,
      );

  // ─── Exam History ──────────────────────────────────────────────
  static List<ExamHistoryItem> get examHistory => [
        ExamHistoryItem(
          id: 'mock-exam-1',
          title: 'Full Mock Exam #3',
          mode: 'exam',
          scorePercentage: 82,
          passed: true,
          passLabel: 'Passed',
          correctCount: 41,
          incorrectCount: 9,
          totalQuestions: 50,
          timeTakenSeconds: 4800,
          timeSpentLabel: '1h 20m',
          submittedAt: DateTime.now().subtract(const Duration(days: 1)),
          category: null,
          topic: null,
          examTitle: 'Full Mock Exam #3',
        ),
        ExamHistoryItem(
          id: 'mock-exam-2',
          title: 'Pharmacology Practice',
          mode: 'practice',
          scorePercentage: 64,
          passed: false,
          passLabel: 'Retake',
          correctCount: 16,
          incorrectCount: 9,
          totalQuestions: 25,
          timeTakenSeconds: 1800,
          timeSpentLabel: '30m',
          submittedAt: DateTime.now().subtract(const Duration(days: 3)),
          category: 'Pharmacology',
          topic: 'Drug Interactions',
          examTitle: 'Pharmacology Practice',
        ),
        ExamHistoryItem(
          id: 'mock-exam-3',
          title: 'Full Mock Exam #2',
          mode: 'exam',
          scorePercentage: 75,
          passed: true,
          passLabel: 'Passed',
          correctCount: 38,
          incorrectCount: 12,
          totalQuestions: 50,
          timeTakenSeconds: 5400,
          timeSpentLabel: '1h 30m',
          submittedAt: DateTime.now().subtract(const Duration(days: 5)),
          category: null,
          topic: null,
          examTitle: 'Full Mock Exam #2',
        ),
        ExamHistoryItem(
          id: 'mock-exam-4',
          title: 'Cardiology Review',
          mode: 'practice',
          scorePercentage: 88,
          passed: true,
          passLabel: 'Passed',
          correctCount: 22,
          incorrectCount: 3,
          totalQuestions: 25,
          timeTakenSeconds: 1500,
          timeSpentLabel: '25m',
          submittedAt: DateTime.now().subtract(const Duration(days: 7)),
          category: 'Cardiology',
          topic: 'Heart Failure',
          examTitle: 'Cardiology Review',
        ),
      ];

  // ─── Daily Progress ─────────────────────────────────────────────
  static DailyProgressModel get dailyProgress {
    return DailyProgressModel(
      dailyProgress: DailyProgressInfo(
        answeredQuestions: 24,
        targetQuestions: 50,
        remainingQuestions: 26,
        completionPercentage: 48,
        message: 'You\'re on track for today',
      ),
      activeSession: null,
      streak: StreakInfo(currentDays: 5, message: '5-day streak — keep it up!'),
      weeklyPerformance: WeeklyPerformance(
        totalAnswered: 180,
        changePercentage: 12,
        series: [
          WeeklySeriesItem(date: '', label: 'Mon', answeredQuestions: 22),
          WeeklySeriesItem(date: '', label: 'Tue', answeredQuestions: 30),
          WeeklySeriesItem(date: '', label: 'Wed', answeredQuestions: 18),
          WeeklySeriesItem(date: '', label: 'Thu', answeredQuestions: 35),
          WeeklySeriesItem(date: '', label: 'Fri', answeredQuestions: 28),
          WeeklySeriesItem(date: '', label: 'Sat', answeredQuestions: 24),
          WeeklySeriesItem(date: '', label: 'Sun', answeredQuestions: 23),
        ],
      ),
      dailyGoal: DailyGoalSettings(
        currentTarget: 50,
        allowedOptions: [10, 25, 50, 100, 150, 200],
      ),
    );
  }
}
