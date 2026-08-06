import 'package:carfy/common/translations/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/presentation/app/state/localization/localization_cubit.dart';

class AppLocalizations {
  final BuildContext context;

  AppLocalizations({required this.context});

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String _tr(String key) {
    return context.read<LocalizationCubit>().tr(key: key);
  }

  // Main navigation
  String get appName => _tr(TranslationKeys.appName);

  String get continueBtn => _tr(TranslationKeys.continueBtn);

  String get mainHome => _tr(TranslationKeys.mainHome);

  String get mainMessage => _tr(TranslationKeys.mainMessage);

  String get mainFavorite => _tr(TranslationKeys.mainFavorite);

  String get mainBasket => _tr(TranslationKeys.mainBasket);

  String get mainProfile => _tr(TranslationKeys.mainProfile);

  // Not logged in
  String get messagesNotLoggedText => _tr(TranslationKeys.messagesNotLoggedText);

  String get favoritesNotLoggedText => _tr(TranslationKeys.favoritesNotLoggedText);

  String get basketNotLoggedText => _tr(TranslationKeys.basketNotLoggedText);

  String get profileNotLoggedText => _tr(TranslationKeys.profileNotLoggedText);

  // General
  String get or => _tr(TranslationKeys.or);

  String get connectionFailure => _tr(TranslationKeys.connectionFailure);

  String get serverFailure => _tr(TranslationKeys.serverFailure);

  // Login/Register
  String get withNumber => _tr(TranslationKeys.withNumber);

  String get withEmail => _tr(TranslationKeys.withEmail);

  String get entranceToAccount => _tr(TranslationKeys.entranceToAccount);

  String get email => _tr(TranslationKeys.email);

  String get phone => _tr(TranslationKeys.phone);

  String get mobileNumber => _tr(TranslationKeys.mobileNumber);

  String get password => _tr(TranslationKeys.password);

  String get forward => _tr(TranslationKeys.forward);

  String get forgotPassword => _tr(TranslationKeys.forgotPassword);

  String get doNotHaveAccount => _tr(TranslationKeys.doNotHaveAccount);

  String get signUp => _tr(TranslationKeys.signUp);

  String get google => _tr(TranslationKeys.google);

  String get apple => _tr(TranslationKeys.apple);

  String get signUpTermsText => _tr(TranslationKeys.signUpTermsText);

  // OTP
  String get phoneVerification => _tr(TranslationKeys.phoneVerification);

  String get emailVerification => _tr(TranslationKeys.emailVerification);

  String otpSentToNumber(String number) => _tr(TranslationKeys.otpSentToNumber).replaceAll('{number}', number);

  String otpSentToEmail(String email) => _tr(TranslationKeys.otpSentToEmail).replaceAll('{email}', email);

  String get confirm => _tr(TranslationKeys.confirm);

  // Password
  String get passwordRecovery => _tr(TranslationKeys.passwordRecovery);

  String get alreadyHaveAccount => _tr(TranslationKeys.alreadyHaveAccount);

  String get login => _tr(TranslationKeys.login);

  // Profile
  String get name => _tr(TranslationKeys.name);

  String get surname => _tr(TranslationKeys.surname);

  String get gender => _tr(TranslationKeys.gender);

  String get birthDate => _tr(TranslationKeys.birthDate);

  String get male => _tr(TranslationKeys.male);

  String get female => _tr(TranslationKeys.female);

  String get enterRepeatPassword => _tr(TranslationKeys.enterRepeatPassword);

  String get emailAlreadyInUse => _tr(TranslationKeys.emailAlreadyInUse);

  String get successfullyRegistered => _tr(TranslationKeys.successfullyRegistered);

  // Home
  String get search => _tr(TranslationKeys.search);

  String get searchHint => _tr(TranslationKeys.searchHint);

  String resendOtpIn(String time) => _tr(TranslationKeys.resendOtpIn).replaceAll('{time}', time);

  String get resendOtp => _tr(TranslationKeys.resendOtp);

  String get mapPickerSearch => _tr(TranslationKeys.mapPickerSearch);

  String get categories => _tr(TranslationKeys.categories);

  String get seeAll => _tr(TranslationKeys.seeAll);

  String get allProducts => _tr(TranslationKeys.allProducts);

  String get addToBasket => _tr(TranslationKeys.addToBasket);

  String get inBasket => _tr(TranslationKeys.inBasket);

  // Payment
  String get paymentDetails => _tr(TranslationKeys.paymentDetails);

  String get amount => _tr(TranslationKeys.amount);

  String get productCount => _tr(TranslationKeys.productCount);

  String get deliveryFee => _tr(TranslationKeys.deliveryFee);

  String get discount => _tr(TranslationKeys.discount);

  String get total => _tr(TranslationKeys.total);

  String get formOrder => _tr(TranslationKeys.formOrder);

  String get piece => _tr(TranslationKeys.piece);

  String get messagesEmpty => _tr(TranslationKeys.messagesEmpty);

  String get wishlistEmpty => _tr(TranslationKeys.wishlistEmpty);

  String get basketEmpty => _tr(TranslationKeys.basketEmpty);

  // Profile page
  String get profileMyCars => _tr(TranslationKeys.profileMyCars);

  String get profileMyOrders => _tr(TranslationKeys.profileMyOrders);

  String get profileMyAddresses => _tr(TranslationKeys.profileMyAddresses);

  String get profileReferrals => _tr(TranslationKeys.profileReferrals);

  String get profileSettings => _tr(TranslationKeys.profileSettings);

  String get profileActiveSessions => _tr(TranslationKeys.profileActiveSessions);

  String get profileLanguage => _tr(TranslationKeys.profileLanguage);

  String get profileCurrentLanguage => _tr(TranslationKeys.profileCurrentLanguage);

  String get profileSupport => _tr(TranslationKeys.profileSupport);

  String get profileMyCarsSearchBtn => _tr(TranslationKeys.profileMyCarsSearchBtn);

  String get profileMyCarsAddBtn => _tr(TranslationKeys.profileMyCarsAddBtn);

  String get profileMyCarsEmpty => _tr(TranslationKeys.profileMyCarsEmpty);

  // General actions
  String get cancel => _tr(TranslationKeys.cancel);

  String get delete => _tr(TranslationKeys.delete);

  // Car delete confirmation
  String get carDeleteConfirmTitle => _tr(TranslationKeys.carDeleteConfirmTitle);

  String get carDeleteConfirmDescription => _tr(TranslationKeys.carDeleteConfirmDescription);

  // Car form validation
  String get carFormBrandRequired => _tr(TranslationKeys.carFormBrandRequired);

  String get carFormModelRequired => _tr(TranslationKeys.carFormModelRequired);

  String get carFormCarTypeRequired => _tr(TranslationKeys.carFormCarTypeRequired);

  String get carFormYearRequired => _tr(TranslationKeys.carFormYearRequired);

  // Car form
  String get carFormAddTitle => _tr(TranslationKeys.carFormAddTitle);

  String get carFormSave => _tr(TranslationKeys.carFormSave);

  String get carFormDelete => _tr(TranslationKeys.carFormDelete);

  String get carFormBrand => _tr(TranslationKeys.carFormBrand);

  String get carFormModel => _tr(TranslationKeys.carFormModel);

  String get carFormYear => _tr(TranslationKeys.carFormYear);

  String get carFormEngineVolume => _tr(TranslationKeys.carFormEngineVolume);

  String get carFormFuelType => _tr(TranslationKeys.carFormFuelType);

  String get carFormTransmissionType => _tr(TranslationKeys.carFormTransmissionType);

  String get carFormCarType => _tr(TranslationKeys.carFormCarType);

  String get carFormEngineNumber => _tr(TranslationKeys.carFormEngineNumber);

  String get carFormVinNumber => _tr(TranslationKeys.carFormVinNumber);

  String get carFormColor => _tr(TranslationKeys.carFormColor);

  String get carFormSeatCount => _tr(TranslationKeys.carFormSeatCount);

  // My Addresses

  String get profileMyAddressesAddBtn => _tr(TranslationKeys.profileMyAddressesAddBtn);

  String get profileMyAddressesEmpty => _tr(TranslationKeys.profileMyAddressesEmpty);

  String get addressDeleteConfirmTitle => _tr(TranslationKeys.addressDeleteConfirmTitle);

  String get addressDeleteConfirmDescription => _tr(TranslationKeys.addressDeleteConfirmDescription);

  String get defaultLabel => _tr(TranslationKeys.defaultLabel);

  // Address form
  String get addressFormAddTitle => _tr(TranslationKeys.addressFormAddTitle);

  String get addressFormEditTitle => _tr(TranslationKeys.addressFormEditTitle);

  String get addressFormAddressType => _tr(TranslationKeys.addressFormAddressType);

  String get addressFormAddressTypeRequired => _tr(TranslationKeys.addressFormAddressTypeRequired);

  String get addressFormCity => _tr(TranslationKeys.addressFormCity);

  String get addressFormCityRequired => _tr(TranslationKeys.addressFormCityRequired);

  String get addressFormLine1 => _tr(TranslationKeys.addressFormLine1);

  String get addressFormLine1Required => _tr(TranslationKeys.addressFormLine1Required);

  String get addressFormLine2 => _tr(TranslationKeys.addressFormLine2);

  String get addressFormPhone => _tr(TranslationKeys.addressFormPhone);

  String get addressFormPhoneRequired => _tr(TranslationKeys.addressFormPhoneRequired);

  String get addressFormPickLocation => _tr(TranslationKeys.addressFormPickLocation);

  String get addressFormLocationRequired => _tr(TranslationKeys.addressFormLocationRequired);

  String get addressFormSave => _tr(TranslationKeys.addressFormSave);

  String get addressFormDelete => _tr(TranslationKeys.addressFormDelete);

  String get mapPickerTitle => _tr(TranslationKeys.mapPickerTitle);

  String get mapPickerConfirm => _tr(TranslationKeys.mapPickerConfirm);

  String get profileUpdateTitle => _tr(TranslationKeys.profileUpdateTitle);

  String get profileUpdateSave => _tr(TranslationKeys.profileUpdateSave);

  String get profileUpdateNameRequired => _tr(TranslationKeys.profileUpdateNameRequired);

  String get profileUpdateSurnameRequired => _tr(TranslationKeys.profileUpdateSurnameRequired);

  String get profileUpdateSuccess => _tr(TranslationKeys.profileUpdateSuccess);

  String get profileUpdateSelectGender => _tr(TranslationKeys.profileUpdateSelectGender);

  String get profileUpdateSelectBirthDate => _tr(TranslationKeys.profileUpdateSelectBirthDate);

  String get profileLogout => _tr(TranslationKeys.profileLogout);

  String get profileDeleteAccount => _tr(TranslationKeys.profileDeleteAccount);

  String get logoutConfirmTitle => _tr(TranslationKeys.logoutConfirmTitle);

  String get logoutConfirmDescription => _tr(TranslationKeys.logoutConfirmDescription);

  String get deleteAccountConfirmTitle => _tr(TranslationKeys.deleteAccountConfirmTitle);

  String get deleteAccountConfirmDescription => _tr(TranslationKeys.deleteAccountConfirmDescription);

  // Sessions
  String get sessionsTitle => _tr(TranslationKeys.sessionsTitle);

  String get sessionsCurrentSession => _tr(TranslationKeys.sessionsCurrentSession);

  String get sessionsOtherSessions => _tr(TranslationKeys.sessionsOtherSessions);

  String get sessionsTerminate => _tr(TranslationKeys.sessionsTerminate);

  String get sessionsTerminateConfirmTitle => _tr(TranslationKeys.sessionsTerminateConfirmTitle);

  String get sessionsTerminateConfirmDescription => _tr(TranslationKeys.sessionsTerminateConfirmDescription);

  String get sessionsTerminatedSuccess => _tr(TranslationKeys.sessionsTerminatedSuccess);

  String get sessionsEmpty => _tr(TranslationKeys.sessionsEmpty);

  String get sessionsThisDevice => _tr(TranslationKeys.sessionsThisDevice);

  // Product detail
  String get productDetail => _tr(TranslationKeys.productDetail);

  String get productCode => _tr(TranslationKeys.productCode);

  String get reviews => _tr(TranslationKeys.reviews);

  String get reviewsAndRatings => _tr(TranslationKeys.reviewsAndRatings);

  String get writeReview => _tr(TranslationKeys.writeReview);

  String get noReviews => _tr(TranslationKeys.noReviews);

  String get showMore => _tr(TranslationKeys.showMore);

  String get relatedProducts => _tr(TranslationKeys.relatedProducts);

  String get contactUs => _tr(TranslationKeys.contactUs);

  String get writeToCarfy => _tr(TranslationKeys.writeToCarfy);

  String get callCarfy => _tr(TranslationKeys.callCarfy);

  String get city => _tr(TranslationKeys.city);

  String get brand => _tr(TranslationKeys.brand);

  String get year => _tr(TranslationKeys.year);

  String get category => _tr(TranslationKeys.category);

  // Filter
  String get filter => _tr(TranslationKeys.filter);

  String get filterShow => _tr(TranslationKeys.filterShow);

  String get filterReset => _tr(TranslationKeys.filterReset);

  String get filterModel => _tr(TranslationKeys.filterModel);

  String get filterColor => _tr(TranslationKeys.filterColor);

  String get filterCondition => _tr(TranslationKeys.filterCondition);

  String get filterYearMin => _tr(TranslationKeys.filterYearMin);

  String get filterYearMax => _tr(TranslationKeys.filterYearMax);

  String get filterPriceMin => _tr(TranslationKeys.filterPriceMin);

  String get filterPriceMax => _tr(TranslationKeys.filterPriceMax);

  String get filterSearchByCar => _tr(TranslationKeys.filterSearchByCar);

  // Product list
  String get productSearchHint => _tr(TranslationKeys.productSearchHint);

  String get productsFound => _tr(TranslationKeys.productsFound);

  String get sorting => _tr(TranslationKeys.sorting);

  String get searchResults => _tr(TranslationKeys.searchResults);

  String get productsEmpty => _tr(TranslationKeys.productsEmpty);

  String get productsEmptyDescription => _tr(TranslationKeys.productsEmptyDescription);

  String get selectCarModel => _tr(TranslationKeys.selectCarModel);

  String get carPickerCancel => _tr(TranslationKeys.carPickerCancel);

  String get searchHistory => _tr(TranslationKeys.searchHistory);

  String get searchDelete => _tr(TranslationKeys.searchDelete);

  String get searchCancel => _tr(TranslationKeys.searchCancel);

  String get selectCategory => _tr(TranslationKeys.selectCategory);

  String get categoryDone => _tr(TranslationKeys.categoryDone);

  String get categoriesSelected => _tr(TranslationKeys.categoriesSelected);

  String get rateProduct => _tr(TranslationKeys.rateProduct);

  String get giveRating => _tr(TranslationKeys.giveRating);

  String get writeReviewHint => _tr(TranslationKeys.writeReviewHint);

  String get addPhotos => _tr(TranslationKeys.addPhotos);

  String get reviewConsent => _tr(TranslationKeys.reviewConsent);

  String get send => _tr(TranslationKeys.send);

  String get reviewSubmitSuccess => _tr(TranslationKeys.reviewSubmitSuccess);

  String get ratingLabel => _tr(TranslationKeys.ratingLabel);

  String get contactMessageHint => _tr(TranslationKeys.contactMessageHint);

  String get contactSubmitSuccess => _tr(TranslationKeys.contactSubmitSuccess);

  String get contactLoginRequired => _tr(TranslationKeys.contactLoginRequired);

  String get orderConfirmTitle => _tr(TranslationKeys.orderConfirmTitle);

  String get orderConfirmAddAddress => _tr(TranslationKeys.orderConfirmAddAddress);

  String get orderConfirmAddAddressHint => _tr(TranslationKeys.orderConfirmAddAddressHint);

  String get orderConfirmEditAddress => _tr(TranslationKeys.orderConfirmEditAddress);

  String get orderConfirmSelectAddress => _tr(TranslationKeys.orderConfirmSelectAddress);

  String get orderConfirmAddNewAddress => _tr(TranslationKeys.orderConfirmAddNewAddress);

  String get orderConfirmPaymentMethod => _tr(TranslationKeys.orderConfirmPaymentMethod);

  String get orderConfirmNote => _tr(TranslationKeys.orderConfirmNote);

  String get orderConfirmNoteHint => _tr(TranslationKeys.orderConfirmNoteHint);

  String get orderConfirmAddressRequired => _tr(TranslationKeys.orderConfirmAddressRequired);

  String get orderSuccessTitle => _tr(TranslationKeys.orderSuccessTitle);

  String get orderSuccessProducts => _tr(TranslationKeys.orderSuccessProducts);

  String get orderSuccessDeliveryAddress => _tr(TranslationKeys.orderSuccessDeliveryAddress);

  String get orderSuccessGoHome => _tr(TranslationKeys.orderSuccessGoHome);

  String get paymentTitle => _tr(TranslationKeys.paymentTitle);

  String get paymentFailed => _tr(TranslationKeys.paymentFailed);

  String get notificationsTitle => _tr(TranslationKeys.notificationsTitle);

  String get notificationsReadAll => _tr(TranslationKeys.notificationsReadAll);

  String get notificationsDeleteAll => _tr(TranslationKeys.notificationsDeleteAll);

  String get notificationsRead => _tr(TranslationKeys.notificationsRead);

  String get notificationsReadConfirm => _tr(TranslationKeys.notificationsReadConfirm);

  String get notificationsReadAllConfirm => _tr(TranslationKeys.notificationsReadAllConfirm);

  String get notificationsDeleteConfirm => _tr(TranslationKeys.notificationsDeleteConfirm);

  String get notificationsDeleteAllConfirm => _tr(TranslationKeys.notificationsDeleteAllConfirm);

  String get ordersEmpty => _tr(TranslationKeys.ordersEmpty);

  String get notificationsEmpty => _tr(TranslationKeys.notificationsEmpty);

  // Order detail
  String get orderDetailTitle => _tr(TranslationKeys.orderDetailTitle);

  String get orderDetailOrder => _tr(TranslationKeys.orderDetailOrder);

  String get orderDetailDelivery => _tr(TranslationKeys.orderDetailDelivery);

  String get copied => _tr(TranslationKeys.copied);

  // Referral
  String get referralBonuses => _tr(TranslationKeys.referralBonuses);

  String get referralBalanceDetails => _tr(TranslationKeys.referralBalanceDetails);

  String get referralPendingBalance => _tr(TranslationKeys.referralPendingBalance);

  String get referralAvailableBalance => _tr(TranslationKeys.referralAvailableBalance);

  String get referralLifetimeEarned => _tr(TranslationKeys.referralLifetimeEarned);

  String get referralYourCode => _tr(TranslationKeys.referralYourCode);

  String get referralLink => _tr(TranslationKeys.referralLink);

  String get referralTotalReferrals => _tr(TranslationKeys.referralTotalReferrals);

  String get referralActive => _tr(TranslationKeys.referralActive);

  String get referralPending => _tr(TranslationKeys.referralPending);

  String get referralUpdateCode => _tr(TranslationKeys.referralUpdateCode);

  String get referralUpdateCodeHint => _tr(TranslationKeys.referralUpdateCodeHint);

  String get referralUpdateCodeSave => _tr(TranslationKeys.referralUpdateCodeSave);

  String get referralUpdateCodeSuccess => _tr(TranslationKeys.referralUpdateCodeSuccess);

  String get referralUpdateCodeRules => _tr(TranslationKeys.referralUpdateCodeRules);

  String get referralPerks => _tr(TranslationKeys.referralPerks);

  String get referralFreeDelivery => _tr(TranslationKeys.referralFreeDelivery);

  String get referralDiscount => _tr(TranslationKeys.referralDiscount);

  String get referralEarnings => _tr(TranslationKeys.referralEarnings);

  String get referralReferrals => _tr(TranslationKeys.referralReferrals);

  String get referralWithdrawals => _tr(TranslationKeys.referralWithdrawals);

  String get referralEarningsEmpty => _tr(TranslationKeys.referralEarningsEmpty);

  String get referralReferralsEmpty => _tr(TranslationKeys.referralReferralsEmpty);

  String get referralWithdrawalsEmpty => _tr(TranslationKeys.referralWithdrawalsEmpty);

  String get referralOrder => _tr(TranslationKeys.referralOrder);

  String get referralWithdraw => _tr(TranslationKeys.referralWithdraw);

  String get referralMinimumWithdrawal => _tr(TranslationKeys.referralMinimumWithdrawal);

  String get referralWithdrawTitle => _tr(TranslationKeys.referralWithdrawTitle);

  String get referralWithdrawAmount => _tr(TranslationKeys.referralWithdrawAmount);

  String get referralWithdrawCardLast4 => _tr(TranslationKeys.referralWithdrawCardLast4);

  String get referralWithdrawCardHolder => _tr(TranslationKeys.referralWithdrawCardHolder);

  String get referralWithdrawSuccess => _tr(TranslationKeys.referralWithdrawSuccess);

  String get referralWithdrawSubmit => _tr(TranslationKeys.referralWithdrawSubmit);

  String get orderSummary => _tr(TranslationKeys.orderSummary);

  String get shippingLabel => _tr(TranslationKeys.shippingLabel);

  String get shippingMinutes => _tr(TranslationKeys.shippingMinutes);

  String get earningStatusPending => _tr(TranslationKeys.earningStatusPending);

  String get earningStatusAvailable => _tr(TranslationKeys.earningStatusAvailable);

  String get earningStatusRefunded => _tr(TranslationKeys.earningStatusRefunded);

  String get earningStatusCancelled => _tr(TranslationKeys.earningStatusCancelled);

  String get earningStatusFraudHold => _tr(TranslationKeys.earningStatusFraudHold);

  String get earningStatusPendingDescription => _tr(TranslationKeys.earningStatusPendingDescription);

  String get earningStatusFraudHoldDescription => _tr(TranslationKeys.earningStatusFraudHoldDescription);

  String get attributionStatusPending => _tr(TranslationKeys.attributionStatusPending);

  String get attributionStatusActive => _tr(TranslationKeys.attributionStatusActive);

  String get attributionStatusFraudBlocked => _tr(TranslationKeys.attributionStatusFraudBlocked);

  String get withdrawalStatusPending => _tr(TranslationKeys.withdrawalStatusPending);

  String get withdrawalStatusApproved => _tr(TranslationKeys.withdrawalStatusApproved);

  String get withdrawalStatusPaid => _tr(TranslationKeys.withdrawalStatusPaid);

  String get withdrawalStatusRejected => _tr(TranslationKeys.withdrawalStatusRejected);

  String get freeDeliveryApplied => _tr(TranslationKeys.freeDeliveryApplied);

  String get referralDiscountApplied => _tr(TranslationKeys.referralDiscountApplied);

  String get useReferralBalance => _tr(TranslationKeys.useReferralBalance);

  String get freeLabel => _tr(TranslationKeys.freeLabel);

  String get forceUpdateTitle => _tr(TranslationKeys.forceUpdateTitle);

  String get forceUpdateMessage => _tr(TranslationKeys.forceUpdateMessage);

  String get forceUpdateButton => _tr(TranslationKeys.forceUpdateButton);

  // Contact change
  String get changeEmailTitle => _tr(TranslationKeys.changeEmailTitle);

  String get changePhoneTitle => _tr(TranslationKeys.changePhoneTitle);

  String get sendOtp => _tr(TranslationKeys.sendOtp);

  String get changeEmailNewHint => _tr(TranslationKeys.changeEmailNewHint);

  String get changePhoneNewHint => _tr(TranslationKeys.changePhoneNewHint);

  String changeEmailOtpDesc(String value) =>
      _tr(TranslationKeys.changeEmailOtpDesc).replaceAll('{value}', value);

  String changePhoneOtpDesc(String value) =>
      _tr(TranslationKeys.changePhoneOtpDesc).replaceAll('{value}', value);

  String otpExpiresIn(String time) =>
      _tr(TranslationKeys.otpExpiresIn).replaceAll('{time}', time);
}
