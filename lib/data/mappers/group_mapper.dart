import 'package:carfy/data/mappers/product_mapper.dart';
import 'package:carfy/data/models/group/group_model.dart';
import 'package:carfy/domain/entities/group/group.dart';
import 'package:injectable/injectable.dart';

@injectable
class GroupMapper {
  final ProductMapper _productMapper;

  GroupMapper(this._productMapper);

  Group mapGroup(GroupModel model) => Group(
    name: model.name,
    slug: model.slug,
    title: model.title,
    description: model.description,
    image: model.image,
    products: model.products.map(_productMapper.mapProduct).toList(),
  );
}
