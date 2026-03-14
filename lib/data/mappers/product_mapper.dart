import 'package:carfy/common/data/mappers/pagination_mapper.dart';
import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/data/models/product/brand_model.dart';
import 'package:carfy/data/models/product/category_slugs_model.dart';
import 'package:carfy/data/models/product/product_detail_model.dart';
import 'package:carfy/data/models/product/product_model.dart';
import 'package:carfy/domain/entities/products/brand.dart';
import 'package:carfy/domain/entities/products/category_slugs.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/entities/products/product_detail.dart';
import 'package:carfy/domain/enums/discount_type.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductMapper {
  Product mapProduct(ProductModel model) => Product(
    id: model.id,
    uuid: model.uuid,
    slug: model.slug,
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
    inWishlist: model.inWishlist,
    inBasket: model.inBasket,
    sellerUuid: model.sellerUuid,
    product: mapProductDetail(model.product),
  );

  ProductDetail mapProductDetail(ProductDetailModel model) => ProductDetail(
    id: model.id,
    uuid: model.uuid,
    slug: model.slug,
    categorySlugs: model.categorySlugs != null ? mapCategorySlugs(model.categorySlugs!) : null,
    title: model.title,
    descriptionShort: model.descriptionShort,
    hoverImage: model.hoverImage,
    isSet: model.isSet,
    brand: model.brand != null ? mapBrand(model.brand!) : null,
  );

  CategorySlugs mapCategorySlugs(CategorySlugsModel model) =>
      CategorySlugs(subCategorySlug: model.subCategorySlug, parentCategorySlug: model.parentCategorySlug);

  Brand mapBrand(BrandModel model) => Brand(id: model.id, uuid: model.uuid, slug: model.slug, title: model.title);

  PaginationResponse<Product> mapPaginationResponse(PaginationResponseModel<ProductModel> model) =>
      PaginationMapper.map(model, mapProduct);
}
