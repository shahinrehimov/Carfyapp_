import 'package:carfy/common/widgets/custom_toast.dart';
import 'package:flutter/material.dart';

import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';

void showStateStatusToast(BuildContext context, StateStatus state) {
  switch (state) {
    case StateStatusFailure(msg: final msg):
      CustomToast.showError(context, msg);
      break;
    case StateStatusNetworkFailure():
      CustomToast.showError(context, context.localization.connectionFailure);
      break;
    case StateStatusServerFailure():
      CustomToast.showError(context, context.localization.serverFailure);
      break;
    case StateStatusSuccessWithMessage(msg: final msg):
      CustomToast.showSuccess(context, msg);
      break;
  }
}
