import 'package:carfy/data/models/category/category_model.dart';
import 'package:carfy/domain/entities/categories/category.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryMapper {
  Category mapCategory(CategoryModel model) => Category(
    id: model.id,
    uuid: model.uuid,
    slug: model.slug,
    title: model.title,
    image: model.image,
    subs: model.subs.map((e) => SubCategory(id: e.id, uuid: e.uuid, slug: e.slug, title: e.title)).toList(),
  );
}
