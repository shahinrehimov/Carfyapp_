import 'package:flutter/material.dart';

import '../../localization/languages/languages.dart';
import '../state/state_status.dart';

void showStateStatusToast(BuildContext context, StateStatus state) {
  switch (state) {
    case StateStatusFailure(msg: final msg):
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      break;
    case StateStatusNetworkFailure():
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Languages.of(context)!.connectionFailure)));
      break;
    case StateStatusServerFailure():
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Languages.of(context)!.serverFailure)));
      break;
  }
}
