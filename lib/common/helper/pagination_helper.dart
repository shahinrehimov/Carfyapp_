import 'package:carfy/common/state/state_status.dart';

class PaginationHelper {
  int _currentPage = 1;
  int? _maxPage;
  bool _isLoading = false;

  int get currentPage => _currentPage;

  void setMaxPage(int max) {
    _maxPage ??= max;
  }

  void reset() {
    _currentPage = 1;
    _maxPage = null;
    _isLoading = false;
  }

  bool shouldLoad() {
    return !_isLoading && (_maxPage == null || _currentPage <= _maxPage!);
  }

  void onLoadStart() {
    _isLoading = true;
  }

  void onLoadEnd(int maxPage) {
    _isLoading = false;
    _maxPage ??= maxPage;
    _currentPage++;
  }

  StateStatus getLoadingStatus() {
    return _currentPage == 1 ? StateStatus.loading() : StateStatus.paginationLoading();
  }
}
