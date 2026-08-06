import 'package:carfy/common/data/mappers/pagination_mapper.dart';
import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/data/models/car/car_color_model.dart';
import 'package:carfy/data/models/product/brand_model.dart';
import 'package:carfy/data/models/product/brand_model_item_model.dart';
import 'package:carfy/data/models/product/fitment_model.dart';
import 'package:carfy/data/models/product/category_slugs_model.dart';
import 'package:carfy/data/models/product/city_model.dart';
import 'package:carfy/data/models/product/filter_brand_model.dart';
import 'package:carfy/data/models/product/filter_category_model.dart';
import 'package:carfy/data/models/product/filter_option_model.dart';
import 'package:carfy/data/models/product/gallery_image_model.dart';
import 'package:carfy/data/models/product/other_seller_model.dart';
import 'package:carfy/data/models/product/price_range_model.dart';
import 'package:carfy/data/models/product/product_category_model.dart';
import 'package:carfy/data/models/product/product_detail_model.dart';
import 'package:carfy/data/models/product/product_filters_model.dart';
import 'package:carfy/data/models/product/product_info_model.dart';
import 'package:carfy/data/models/product/product_model.dart';
import 'package:carfy/data/models/product/product_option_model.dart';
import 'package:carfy/data/models/product/product_ratings_model.dart';
import 'package:carfy/data/models/product/product_show_model.dart';
import 'package:carfy/data/models/product/review_model.dart';
import 'package:carfy/data/models/product/seller_model.dart';
import 'package:carfy/data/models/product/set_item_model.dart';
import 'package:carfy/data/models/product/sort_option_model.dart';
import 'package:carfy/data/models/product/year_range_model.dart';
import 'package:carfy/domain/entities/car/car_color.dart';
import 'package:carfy/domain/entities/products/brand.dart';
import 'package:carfy/domain/entities/products/brand_model_item.dart';
import 'package:carfy/domain/entities/products/fitment.dart';
import 'package:carfy/domain/entities/products/category_slugs.dart';
import 'package:carfy/domain/entities/products/city.dart';
import 'package:carfy/domain/entities/products/filter_brand.dart';
import 'package:carfy/domain/entities/products/filter_category.dart';
import 'package:carfy/domain/entities/products/filter_option.dart';
import 'package:carfy/domain/entities/products/gallery_image.dart';
import 'package:carfy/domain/entities/products/other_seller.dart';
import 'package:carfy/domain/entities/products/price_range.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/entities/products/product_category.dart';
import 'package:carfy/domain/entities/products/product_detail.dart';
import 'package:carfy/domain/entities/products/product_filters.dart';
import 'package:carfy/domain/entities/products/product_info.dart';
import 'package:carfy/domain/entities/products/product_option.dart';
import 'package:carfy/domain/entities/products/product_ratings.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/domain/entities/products/review.dart';
import 'package:carfy/domain/entities/products/seller.dart';
import 'package:carfy/domain/entities/products/set_item.dart';
import 'package:carfy/domain/entities/products/sort_option.dart';
import 'package:carfy/domain/entities/products/year_range.dart';
import 'package:carfy/domain/enums/discount_type.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductMapper {
  Fitment mapFitment(FitmentModel model) => Fitment(
    brand: model.brand != null ? mapBrandModelItem(model.brand!) : null,
    brandModel: model.brandModel != null ? mapBrandModelItem(model.brandModel!) : null,
    yearFrom: model.yearFrom,
    yearTo: model.yearTo,
  );

  Product mapProduct(ProductModel model) => Product(
    id: model.id,
    uuid: model.uuid,
    oemCode: model.oemCode,
    title: model.title,
    hoverImage: model.hoverImage,
    isSet: model.isSet,
    stock: model.stock,
    price: model.price,
    priceFinal: model.priceFinal,
    hasDiscount: model.hasDiscount,
    discountType: DiscountType.fromString(model.discountType),
    discountTypeTitle: model.discountTypeTitle,
    discount: model.discount,
    isUniversal: model.isUniversal,
    inWishlist: model.inWishlist,
    inBasket: model.inBasket,
    seller: model.seller != null ? mapSeller(model.seller!) : null,
    product: mapProductInfo(model.product),
    ratings: model.ratings != null ? mapProductRatings(model.ratings!) : null,
  );

  ProductInfo mapProductInfo(ProductInfoModel model) => ProductInfo(
    id: model.id,
    uuid: model.uuid,
    categorySlugs: model.categorySlugs != null ? mapCategorySlugs(model.categorySlugs!) : null,
    title: model.title,
    descriptionShort: model.descriptionShort,
    hoverImage: model.hoverImage,
    isSet: model.isSet,
    brand: model.brand != null ? mapBrand(model.brand!) : null,
  );

  ProductDetail mapProductDetail(ProductDetailModel model) => ProductDetail(
    id: model.id,
    uuid: model.uuid,
    categorySlugs: model.categorySlugs != null ? mapCategorySlugs(model.categorySlugs!) : null,
    mainCategory: model.mainCategory != null ? mapProductCategory(model.mainCategory!) : null,
    categories: model.categories.map(mapProductCategory).toList(),
    title: model.title,
    descriptionShort: model.descriptionShort,
    description: model.description,
    delivery: model.delivery,
    note: model.note,
    mainImage: model.mainImage,
    hoverImage: model.hoverImage,
    images: model.images,
    isSet: model.isSet,
    brand: model.brand != null ? mapBrand(model.brand!) : null,
  );

  ProductCategory mapProductCategory(ProductCategoryModel model) => ProductCategory(
    id: model.id,
    uuid: model.uuid,
    slug: model.slug,
    title: model.title,
    parent: model.parent != null ? mapProductCategory(model.parent!) : null,
  );

  CategorySlugs mapCategorySlugs(CategorySlugsModel model) =>
      CategorySlugs(subCategorySlug: model.subCategorySlug, parentCategorySlug: model.parentCategorySlug);

  Brand mapBrand(BrandModel model) => Brand(
    id: model.id,
    uuid: model.uuid,
    slug: model.slug,
    title: model.title,
    models: model.models.map(mapBrandModelItem).toList(),
  );

  BrandModelItem mapBrandModelItem(BrandModelItemModel model) => BrandModelItem(id: model.id, title: model.title);

  City mapCity(CityModel model) => City(id: model.id, title: model.title);

  Seller mapSeller(SellerModel model) => Seller(
    uuid: model.uuid,
    storeCode: model.storeCode,
    label: model.label,
    city: model.city != null ? mapCity(model.city!) : null,
    images: model.images,
  );

  PaginationResponse<Product> mapPaginationResponse(PaginationResponseModel<ProductModel> model) =>
      PaginationMapper.map(model, mapProduct);

  FilterCategory mapFilterCategory(FilterCategoryModel model) => FilterCategory(
    id: model.id,
    slug: model.slug,
    title: model.title,
    children: model.children.map(mapFilterCategory).toList(),
  );

  FilterBrand mapFilterBrand(FilterBrandModel model) => FilterBrand(
    id: model.id,
    slug: model.slug,
    title: model.title,
    models: model.models.map(mapBrandModelItem).toList(),
  );

  PriceRange mapPriceRange(PriceRangeModel model) => PriceRange(min: model.min, max: model.max);

  FilterOption mapFilterOption(FilterOptionModel model) => FilterOption(slug: model.slug, title: model.title);

  CarColor mapCarColor(CarColorModel model) => CarColor(id: model.id, title: model.title, hexCode: model.hexCode);

  YearRange mapYearRange(YearRangeModel model) => YearRange(min: model.min, max: model.max);

  ProductFilters mapProductFilters(ProductFiltersModel model) => ProductFilters(
    categories: model.categories.map(mapFilterCategory).toList(),
    brands: model.brands.map(mapFilterBrand).toList(),
    cities: model.cities.map(mapCity).toList(),
    priceRange: mapPriceRange(model.priceRange),
    colors: model.colors.map(mapCarColor).toList(),
    conditions: model.conditions.map(mapFilterOption).toList(),
    yearRange: model.yearRange != null ? mapYearRange(model.yearRange!) : null,
    sortOptions: model.sortOptions.map(mapSortOption).toList(),
    sortTypes: model.sortTypes.map(mapSortOption).toList(),
  );

  SortOption mapSortOption(SortOptionModel model) => SortOption(id: model.id, title: model.title);

  SetItem mapSetItem(SetItemModel model) => SetItem(
    id: model.id,
    slug: model.slug,
    title: model.title,
    price: model.price,
    priceFinal: model.priceFinal,
    stock: model.stock,
  );

  ProductOption mapProductOption(ProductOptionModel model) =>
      ProductOption(name: model.optionName, label: model.optionLabel, value: model.value);

  ProductRatings mapProductRatings(ProductRatingsModel model) => ProductRatings(
    average: model.average,
    count: model.count,
    list: model.list.map((e) => RatingEntry(rating: e.rating, count: e.count)).toList(),
  );

  GalleryImage mapGalleryImage(GalleryImageModel model) => GalleryImage(source: model.source, url: model.url);

  OtherSeller mapOtherSeller(OtherSellerModel model) => OtherSeller(
    uuid: model.uuid,
    sellerLabel: model.sellerLabel,
    price: model.price,
    priceFinal: model.priceFinal,
    hasDiscount: model.hasDiscount,
    discountType: model.discountType,
    discount: model.discount,
    stock: model.stock,
    city: model.city != null ? mapCity(model.city!) : null,
    images: model.images,
  );

  Review mapReview(ReviewModel model) => Review(
    id: model.id,
    rating: model.rating,
    name: model.name,
    surname: model.surname,
    review: model.review,
    date: model.date,
  );

  ProductShow mapProductShow(ProductShowModel model) => ProductShow(
    id: model.id,
    uuid: model.uuid,
    oemCode: model.oemCode,
    title: model.title,
    mainImage: model.mainImage,
    hoverImage: model.hoverImage,
    images: model.images,
    isSet: model.isSet,
    sets: model.sets.map(mapSetItem).toList(),
    stock: model.stock,
    price: model.price,
    priceFinal: model.priceFinal,
    hasDiscount: model.hasDiscount,
    discountType: DiscountType.fromString(model.discountType),
    discountTypeTitle: model.discountTypeTitle,
    discount: model.discount,
    isUniversal: model.isUniversal,
    year: model.year,
    yearFrom: model.yearFrom,
    yearTo: model.yearTo,
    fitments: model.fitments.map(mapFitment).toList(),
    inWishlist: model.inWishlist,
    inBasket: model.inBasket,
    brandModels: model.brandModels.map(mapBrandModelItem).toList(),
    options: model.options.map(mapProductOption).toList(),
    ratings: model.ratings != null ? mapProductRatings(model.ratings!) : null,
    seller: model.seller != null ? mapSeller(model.seller!) : null,
    sellersCount: model.sellersCount,
    gallery: model.gallery.map(mapGalleryImage).toList(),
    otherSellers: model.otherSellers.map(mapOtherSeller).toList(),
    otherSellersTotal: model.otherSellersTotal,
    relatedProducts: model.relatedProducts.map(mapProduct).toList(),
    product: model.product != null ? mapProductDetail(model.product!) : null,
  );

  PaginationResponse<OtherSeller> mapOtherSellersPaginationResponse(PaginationResponseModel<OtherSellerModel> model) =>
      PaginationMapper.map(model, mapOtherSeller);

  PaginationResponse<Review> mapReviewsPaginationResponse(PaginationResponseModel<ReviewModel> model) =>
      PaginationMapper.map(model, mapReview);
}
