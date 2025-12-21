import 'package:flutter/material.dart';

import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';

void showStateStatusToast(BuildContext context, StateStatus state) {
  switch (state) {
    case StateStatusFailure(msg: final msg):
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      break;
    case StateStatusNetworkFailure():
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.localization.connectionFailure)));
      break;
    case StateStatusServerFailure():
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.localization.serverFailure)));
      break;
    case StateStatusSuccessWithMessage(msg: final msg):
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      break;
  }
}
