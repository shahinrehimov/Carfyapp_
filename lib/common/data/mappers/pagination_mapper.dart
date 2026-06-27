import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/domain/entities/pagination_response.dart';

class PaginationMapper {
  static PaginationResponse<E> map<M, E>(PaginationResponseModel<M> model, E Function(M) itemMapper) {
    return PaginationResponse(
      data: model.data.map((item) => itemMapper(item)).toList(),
      currentPage: model.currentPage,
      lastPage: model.lastPage,
      total: model.total,
      perPage: model.perPage,
    );
  }
}
