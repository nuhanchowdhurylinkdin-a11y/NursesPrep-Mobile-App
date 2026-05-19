import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/library_controller.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final String materialId = Get.arguments?['materialId'] ?? '';
  final LibraryController _libraryController = Get.find<LibraryController>();
  final PdfViewerController _pdfController = PdfViewerController();

  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  bool _hasError = false;

  Uint8List? _pdfBytes;
  bool _isLoadingPdf = false;

  double get _progress =>
      _totalPages > 0 ? (_currentPage) / _totalPages : 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _libraryController.fetchMaterialDetail(materialId);
    final detail = _libraryController.materialDetail.value;
    final url = detail?.resource?.fileUrl ?? '';
    if (url.isNotEmpty) {
      await _loadPdfBytes(url);
    }
  }

  Future<void> _loadPdfBytes(String url) async {
    if (!mounted) return;
    setState(() {
      _isLoadingPdf = true;
      _hasError = false;
      _pdfBytes = null;
    });
    try {
      // Use http package with explicit clean headers — avoids any
      // Authorization bearer token accidentally leaking to Cloudinary,
      // which responds with 401 for unknown bearer tokens.
      final response = await http.get(
        Uri.parse(url),
        headers: const {
          'Accept': '*/*',
          'User-Agent': 'hayzee152_app',
        },
      );

      if (!mounted) return;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
            'PDF load failed: HTTP ${response.statusCode} from $url');
        setState(() {
          _hasError = true;
          _isLoadingPdf = false;
        });
        return;
      }

      if (response.bodyBytes.isEmpty) {
        setState(() {
          _hasError = true;
          _isLoadingPdf = false;
        });
        return;
      }

      setState(() {
        _pdfBytes = response.bodyBytes;
        _isLoadingPdf = false;
      });
    } catch (e, stack) {
      debugPrint('PDF load error: $e');
      debugPrint('Stack: $stack');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoadingPdf = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  bool _isDownloading = false;
  double _downloadProgress = 0;

  Future<void> _downloadFile(String url, String fileName) async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      final dir = await getTemporaryDirectory();
      final savePath = '${dir.path}/$fileName';

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      if (mounted) {
        setState(() => _isDownloading = false);
        final box = context.findRenderObject() as RenderBox?;
        await Share.shareXFiles(
          [XFile(savePath)],
          sharePositionOrigin:
              box != null ? box.localToGlobal(Offset.zero) & box.size : Rect.zero,
        );
      }
    } catch (e, stack) {
      debugPrint('Download error: $e');
      debugPrint('Stack: $stack');
      if (mounted) {
        setState(() => _isDownloading = false);
        AppHelperFunctions.showErrorSnackBar('Download failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          centerTitle: true,
          title: Obx(() {
            final detail = _libraryController.materialDetail.value;
            return Text(
              detail?.title ?? 'Document',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
          actions: [
            Obx(() {
              final detail = _libraryController.materialDetail.value;
              if (detail == null) return const SizedBox.shrink();

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (detail.actions.downloadSupported &&
                      detail.resource != null &&
                      detail.resource!.fileUrl.isNotEmpty)
                    GestureDetector(
                      onTap: () => _downloadFile(
                        detail.resource!.fileUrl,
                        detail.resource!.fileName,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: _isDownloading
                            ? SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: CircularProgressIndicator(
                                  value: _downloadProgress > 0
                                      ? _downloadProgress
                                      : null,
                                  strokeWidth: 2.5,
                                  color: const Color(0xFF0F58BD),
                                ),
                              )
                            : Icon(Iconsax.document_download,
                                size: 24.sp,
                                color: const Color(0xFF0F58BD)),
                      ),
                    ),
                  if (detail.actions.bookmarkSupported)
                    Obx(() {
                      final isSaved =
                          _libraryController.materialDetail.value?.isSaved ??
                              false;
                      final isToggling =
                          _libraryController.isTogglingBookmark.value;
                      return GestureDetector(
                        onTap: isToggling
                            ? null
                            : () =>
                                _libraryController.toggleBookmark(detail.id),
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Icon(
                            isSaved ? Iconsax.bookmark_2 : Iconsax.bookmark,
                            size: 24.sp,
                            color: isSaved
                                ? const Color(0xFF0F58BD)
                                : const Color(0xFF0F58BD),
                          ),
                        ),
                      );
                    }),
                ],
              );
            }),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(32.h),
            child: _buildProgressBar(),
          ),
        ),
        body: Obx(() {
          final isLoadingDetail = _libraryController.isLoadingDetail.value;
          final detail = _libraryController.materialDetail.value;

          if (isLoadingDetail || _isLoadingPdf) {
            return Skeletonizer(
              enabled: true,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone(
                      width: double.infinity,
                      height: 24.h,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    SizedBox(height: 12.h),
                    const Bone.multiText(lines: 4),
                    SizedBox(height: 20.h),
                    Bone(
                      width: double.infinity,
                      height: 200.h,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    SizedBox(height: 20.h),
                    const Bone.multiText(lines: 6),
                    SizedBox(height: 20.h),
                    Bone(
                      width: double.infinity,
                      height: 200.h,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ],
                ),
              ),
            );
          }

          final fileUrl = detail?.resource?.fileUrl ?? '';

          if (fileUrl.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.document,
                      size: 48.sp, color: c.textHint),
                  SizedBox(height: 12.h),
                  Text(
                    'No file available',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (_hasError || _pdfBytes == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.warning_2,
                      size: 48.sp, color: const Color(0xFFEF4444)),
                  SizedBox(height: 12.h),
                  Text(
                    'Failed to load PDF',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () => _loadPdfBytes(fileUrl),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F58BD),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Retry',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SfPdfViewer.memory(
            _pdfBytes!,
            controller: _pdfController,
            canShowScrollHead: false,
            canShowPaginationDialog: false,
            onDocumentLoaded: (details) {
              if (mounted) {
                setState(() {
                  _totalPages = details.document.pages.count;
                  _currentPage = 1;
                  _isReady = true;
                });
              }
            },
            onDocumentLoadFailed: (details) {
              if (mounted) {
                setState(() => _hasError = true);
              }
            },
            onPageChanged: (details) {
              if (mounted) {
                setState(() {
                  _currentPage = details.newPageNumber;
                });
              }
            },
          );
        }),
      ),
    );
  }

  Widget _buildProgressBar() {
    final c = context.appColors;
    return Container(
      color: c.cardBg,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reading Progress',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
              Text(
                _isReady
                    ? 'Page $_currentPage of $_totalPages'
                    : 'Loading...',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6.h,
              backgroundColor: c.borderSubtle,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF0F58BD)),
            ),
          ),
        ],
      ),
    );
  }
}
