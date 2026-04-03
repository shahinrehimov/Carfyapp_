import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/products/review.dart';
import 'package:carfy/presentation/product_detail/state/product_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      buildWhen: (prev, curr) => prev.reviewsStatus != curr.reviewsStatus || prev.reviews != curr.reviews,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Divider(color: Color(0xFFE3E3E3), height: 1),
              const SizedBox(height: 16),
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.localization.reviewsAndRatings,
                      style: TextStyle(
                        color: context.theme.colors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {}, // TODO: navigate to write review page
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: context.theme.colors.secondary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        context.localization.writeReview,
                        style: TextStyle(
                          color: context.theme.colors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (state.reviews.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    context.localization.noReviews,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.theme.colors.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ...state.reviews.map((review) => _ReviewItem(review: review)),
              if (state.totalReviews > state.reviews.length) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {}, // TODO: navigate to all reviews
                  child: Text(
                    context.localization.showMore,
                    style: TextStyle(
                      color: context.theme.colors.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final Review review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.theme.colors.primary.withValues(alpha: 0.1),
                child: Text(
                  review.name[0].toUpperCase(),
                  style: TextStyle(color: context.theme.colors.primary, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${review.name[0]}*****',
                  style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              ...List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: const Color(0xFFF6683C),
                );
              }),
              const SizedBox(width: 4),
              Text(
                '(${review.rating}/5)',
                style: TextStyle(color: context.theme.colors.textDark, fontSize: 10, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(
              review.review,
              textAlign: TextAlign.justify,
              style: TextStyle(color: context.theme.colors.textDark, fontSize: 10, fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(
              review.date,
              style: const TextStyle(color: Color(0xFF7B7B7B), fontSize: 10, fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE3E3E3), height: 1),
        ],
      ),
    );
  }
}
