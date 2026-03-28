part of 'product_detail_cubit.dart';

class ProductDetailState extends Equatable {
  final StateStatus status;
  final ProductShow? product;
  final int selectedImageIndex;
  final StateStatus reviewsStatus;
  final List<Review> reviews;
  final int totalReviews;

  const ProductDetailState({
    required this.status,
    this.product,
    required this.selectedImageIndex,
    required this.reviewsStatus,
    required this.reviews,
    required this.totalReviews,
  });

  factory ProductDetailState.initial() => ProductDetailState(
    status: StateStatus.loading(),
    selectedImageIndex: 0,
    reviewsStatus: StateStatus.initial(),
    reviews: const [],
    totalReviews: 0,
  );

  ProductDetailState copyWith({
    StateStatus? status,
    ProductShow? product,
    int? selectedImageIndex,
    StateStatus? reviewsStatus,
    List<Review>? reviews,
    int? totalReviews,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      reviewsStatus: reviewsStatus ?? this.reviewsStatus,
      reviews: reviews ?? this.reviews,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  @override
  List<Object?> get props => [status, product, selectedImageIndex, reviewsStatus, reviews, totalReviews];
}
