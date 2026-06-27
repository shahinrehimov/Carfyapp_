import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/write_review/state/write_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class WriteReviewPage extends StatefulWidget implements AutoRouteWrapper {
  final String cpvUuid;
  final String productTitle;
  final String? productImage;

  const WriteReviewPage({super.key, required this.cpvUuid, required this.productTitle, this.productImage});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => WriteReviewCubit()..init(), child: this);

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _consentChecked = false;
  final List<String> _selectedImages = [];
  late final bool _isGuest = PrefUtil.getString(AppPreferenceKeys.authToken) == null;

  @override
  void initState() {
    super.initState();
    _reviewController.addListener(() => setState(() {}));
    if (_isGuest) {
      _nameController.addListener(() => setState(() {}));
      _surnameController.addListener(() => setState(() {}));
      _emailController.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (_rating == 0 || _reviewController.text.trim().isEmpty) return false;
    if (_isGuest) {
      if (_nameController.text.trim().isEmpty ||
          _surnameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty) {
        return false;
      }
    } else {
      if (context.read<WriteReviewCubit>().state.user == null) return false;
    }
    return true;
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;
    setState(() {
      _selectedImages.addAll(picked.map((x) => x.path));
    });
  }

  void _submit() {
    if (!_canSubmit) return;
    final cubit = context.read<WriteReviewCubit>();
    final user = cubit.state.user;
    cubit.submit(
      cpvUuid: widget.cpvUuid,
      rating: _rating,
      name: _isGuest ? _nameController.text.trim() : (user?.name ?? ''),
      surname: _isGuest ? _surnameController.text.trim() : (user?.surname ?? ''),
      email: _isGuest ? _emailController.text.trim() : (user?.email ?? ''),
      review: _reviewController.text.trim(),
      imagePaths: _selectedImages,
      successMessage: context.localization.reviewSubmitSuccess,
    );
  }

  void _resetForm() {
    setState(() {
      _rating = 0;
      _reviewController.clear();
      _nameController.clear();
      _surnameController.clear();
      _emailController.clear();
      _selectedImages.clear();
      _consentChecked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final writeState = context.watch<WriteReviewCubit>().state;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: SvgPicture.asset(Assets.icons.arrowNarrowLeft),
        ),
        title: Text(
          context.localization.rateProduct,
          style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: BlocListener<WriteReviewCubit, WriteReviewState>(
        listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
        listener: (context, state) {
          showStateStatusToast(context, state.submitStatus);
          if (state.submitStatus is StateStatusSuccessWithMessage) {
            _resetForm();
            context.router.maybePop(true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product info row
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.productImage != null
                          ? CachedNetworkImage(imageUrl: widget.productImage!, width: 78, height: 78, fit: BoxFit.cover)
                          : Container(
                              width: 78,
                              height: 78,
                              color: const Color(0xFFF0F0F0),
                              child: const Icon(Icons.image, size: 32, color: Colors.grey),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.productTitle,
                        style: TextStyle(
                          color: context.theme.colors.textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFE0E7F8), height: 1),
                const SizedBox(height: 16),

                // Rating row
                Row(
                  children: [
                    Text(
                      context.localization.giveRating,
                      style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    ...List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _rating = index + 1),
                        child: SvgPicture.asset(
                          Assets.icons.star,
                          width: 28,
                          height: 28,
                          colorFilter: ColorFilter.mode(
                            index < _rating ? const Color(0xFFFE764C) : const Color(0xFFDFDFDF),
                            BlendMode.srcIn,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                if (writeState.ratingValidationState is FieldValidationFailure) ...[
                  const SizedBox(height: 4),
                  _FieldError(message: writeState.ratingValidationState.message!),
                ],
                const SizedBox(height: 16),

                // Guest user info fields
                if (_isGuest) ...[
                  CustomTextField(
                    controller: _nameController,
                    hint: context.localization.name,
                    hasBorder: true,
                    errorText: writeState.nameValidationState.message,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _surnameController,
                    hint: context.localization.surname,
                    hasBorder: true,
                    errorText: writeState.surnameValidationState.message,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _emailController,
                    hint: context.localization.email,
                    keyboardType: TextInputType.emailAddress,
                    hasBorder: true,
                    errorText: writeState.emailValidationState.message,
                  ),
                  const SizedBox(height: 16),
                ],

                // Review text area
                Container(
                  height: 129,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: writeState.reviewValidationState is FieldValidationFailure
                          ? context.theme.colors.error
                          : const Color(0xFFE0E7F8),
                    ),
                  ),
                  child: TextField(
                    controller: _reviewController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                    style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                      hintText: context.localization.writeReviewHint,
                      hintStyle: const TextStyle(color: Color(0xFF83847E), fontSize: 14, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                if (writeState.reviewValidationState is FieldValidationFailure) ...[
                  const SizedBox(height: 4),
                  _FieldError(message: writeState.reviewValidationState.message!),
                ],
                const SizedBox(height: 16),

                // Image upload area
                if (_selectedImages.isEmpty)
                  GestureDetector(
                    onTap: _pickImages,
                    child: CustomPaint(
                      painter: _DashedBorderPainter(color: const Color(0xFFCCD2DF), radius: 11),
                      child: SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.icons.plus,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(context.theme.colors.textLight, BlendMode.srcIn),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.localization.addPhotos,
                              style: TextStyle(
                                color: context.theme.colors.textLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 63,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ..._selectedImages.map(
                          (path) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(path), width: 63, height: 63, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 63,
                            height: 63,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(color: const Color(0xFFCCD2DF)),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                Assets.icons.plus,
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(context.theme.colors.textLight, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (writeState.imagesValidationState is FieldValidationFailure) ...[
                  const SizedBox(height: 4),
                  _FieldError(message: writeState.imagesValidationState.message!),
                ],
                const SizedBox(height: 16),

                // Consent checkbox
                GestureDetector(
                  onTap: () => setState(() => _consentChecked = !_consentChecked),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _consentChecked ? context.theme.colors.secondary : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: _consentChecked ? null : Border.all(color: const Color(0xFFE0E7F8)),
                        ),
                        child: _consentChecked ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.localization.reviewConsent,
                          style: TextStyle(
                            color: context.theme.colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Submit button
                BlocBuilder<WriteReviewCubit, WriteReviewState>(
                  builder: (context, state) {
                    final loading = state.submitStatus is StateStatusLoading;
                    return CustomButton(
                      onPressed: (_canSubmit && !loading) ? _submit : null,
                      text: context.localization.send,
                      height: 48,
                      loading: loading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldError extends StatelessWidget {
  final String message;

  const _FieldError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(color: context.theme.colors.error, fontSize: 11, fontWeight: FontWeight.w400),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  static const double _strokeWidth = 1;
  static const double _dashLength = 6;
  static const double _gapLength = 4;

  _DashedBorderPainter({required this.color, this.radius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + _dashLength;
        canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length)), paint);
        distance = next + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color || old.radius != radius;
}
