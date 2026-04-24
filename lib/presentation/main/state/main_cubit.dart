import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/presentation/main/ui/enum/main_pages.dart';

@singleton
class MainCubit extends Cubit<MainPages> {
  MainCubit() : super(MainPages.home);

  void changePage(MainPages page) {
    emit(page);
  }
}
