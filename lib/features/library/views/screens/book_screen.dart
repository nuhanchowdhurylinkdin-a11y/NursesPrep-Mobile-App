import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Beta Blockers',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111418),
            ),
          ),
          actions: [
            Icon(Iconsax.bookmark, size: 24.sp, color: const Color(0xFF0F58BD)),
            SizedBox(width: 12.w),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Text(
                'AA',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F58BD),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reading progress
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reading Progress',
                                  style: getTextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF617289))),
                              Text('45%',
                                  style: getTextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF111418))),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9999),
                            child: LinearProgressIndicator(
                              value: 0.45,
                              minHeight: 6.h,
                              backgroundColor: const Color(0xFFDBE0E6),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0F58BD)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Pharmacology of Beta Blockers',
                        style: getTextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111418),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Icon + intro
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F6FF),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Icon(Iconsax.heart,
                                size: 36.sp,
                                color: const Color(0xFF0F58BD)),
                            SizedBox(height: 12.h),
                            RichText(
                              text: TextSpan(
                                style: getTextStyle(
                                    fontSize: 17,
                                    color: const Color(0xFF333333)),
                                children: [
                                  const TextSpan(
                                      text:
                                          'Beta-adrenergic blocking agents, popularly known as '),
                                  TextSpan(
                                    text: 'beta blockers',
                                    style: getTextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F58BD)),
                                  ),
                                  const TextSpan(
                                      text:
                                          ', are a cornerstone class of medications in cardiovascular medicine. They work primarily by competing with catecholamines (epinephrine and norepinephrine) for binding sites at beta-adrenoceptors.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'These medications are essential for managing abnormal heart rhythms, hypertension, and providing cardioprotection following a myocardial infarction. By reducing the workload on the heart, they decrease oxygen demand and improve overall cardiac efficiency.',
                        style: getTextStyle(
                            fontSize: 17, color: const Color(0xFF333333)),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Mechanism of Action
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Mechanism of Action',
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F58BD),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Beta blockers are categorized based on their receptor selectivity:',
                        style: getTextStyle(
                            fontSize: 17, color: const Color(0xFF333333)),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Bullet points
                    _BulletPoint(
                      title: 'Beta-1 Selectivity (Cardioselective):',
                      body:
                          'Predominantly found in heart tissue. Blocking these reduces heart rate (chronotropic) and contractility (inotropic).',
                    ),
                    SizedBox(height: 8.h),
                    _BulletPoint(
                      title: 'Beta-2 Receptors:',
                      body:
                          'Located in bronchial and vascular smooth muscle. Blocking these can cause bronchoconstriction.',
                    ),
                    SizedBox(height: 24.h),
                    // Exam Tip
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border(
                            left: BorderSide(
                                color: const Color(0xFF0F58BD), width: 4.w),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exam Tip: Clinical Pearl',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F58BD),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Before administering any beta blocker, the nurse must assess the patient\'s heart rate for one full minute and check blood pressure. Typically, if the HR is <60 bpm or Systolic BP <90 mmHg, the dose should be held and the provider notified.',
                              style: getTextStyle(
                                  fontSize: 16,
                                  color: const Color(0xFF444444)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Nursing Considerations
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Nursing Considerations',
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F58BD),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'When managing patients on beta-blocker therapy, nursing professionals should prioritize the following:',
                        style: getTextStyle(
                            fontSize: 17, color: const Color(0xFF333333)),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _NumberedItem(
                      number: '1',
                      title: 'Masking Hypoglycemia:',
                      body:
                          'Be aware that beta blockers can mask the tachycardic response to low blood sugar in diabetic patients.',
                    ),
                    SizedBox(height: 8.h),
                    _NumberedItem(
                      number: '2',
                      title: 'Orthostatic Hypotension:',
                      body:
                          'Educate patients to change positions slowly to prevent falls and dizziness.',
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: const Color(0xFFF3F4F6))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F58BD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Iconsax.tick_circle,
                      size: 24.sp, color: Colors.white),
                  label: Text(
                    'Mark as Complete',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String title;
  final String body;

  const _BulletPoint({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: RichText(
        text: TextSpan(
          style: getTextStyle(fontSize: 17, color: const Color(0xFF333333)),
          children: [
            TextSpan(
              text: title,
              style: getTextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111418)),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: body),
          ],
        ),
      ),
    );
  }
}

class _NumberedItem extends StatelessWidget {
  final String number;
  final String title;
  final String body;

  const _NumberedItem({
    required this.number,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F58BD),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: getTextStyle(
                    fontSize: 17, color: const Color(0xFF333333)),
                children: [
                  TextSpan(
                    text: title,
                    style: getTextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111418)),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
