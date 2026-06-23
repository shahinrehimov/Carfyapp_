// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:carfy/common/network/network_manager.dart' as _i597;
import 'package:carfy/data/datasources/address_remote_data_source.dart'
    as _i930;
import 'package:carfy/data/datasources/advertisement_remote_data_source.dart'
    as _i951;
import 'package:carfy/data/datasources/auth_remote_data_source.dart' as _i250;
import 'package:carfy/data/datasources/basket_remote_data_source.dart' as _i490;
import 'package:carfy/data/datasources/car_remote_data_source.dart' as _i304;
import 'package:carfy/data/datasources/category_remote_data_source.dart'
    as _i861;
import 'package:carfy/data/datasources/contact_remote_data_source.dart'
    as _i1057;
import 'package:carfy/data/datasources/group_remote_data_source.dart' as _i874;
import 'package:carfy/data/datasources/notification_remote_data_source.dart'
    as _i49;
import 'package:carfy/data/datasources/order_remote_data_source.dart' as _i150;
import 'package:carfy/data/datasources/payment_remote_data_source.dart'
    as _i1047;
import 'package:carfy/data/datasources/product_remote_data_source.dart'
    as _i881;
import 'package:carfy/data/datasources/referral_remote_data_source.dart'
    as _i861;
import 'package:carfy/data/datasources/translation_local_data_source.dart'
    as _i1053;
import 'package:carfy/data/datasources/translation_remote_data_source.dart'
    as _i387;
import 'package:carfy/data/datasources/version_remote_data_source.dart'
    as _i713;
import 'package:carfy/data/datasources/wishlist_remote_data_source.dart'
    as _i685;
import 'package:carfy/data/mappers/address_mapper.dart' as _i303;
import 'package:carfy/data/mappers/advertisement_mapper.dart' as _i755;
import 'package:carfy/data/mappers/auth_mapper.dart' as _i163;
import 'package:carfy/data/mappers/basket_mapper.dart' as _i751;
import 'package:carfy/data/mappers/car_mapper.dart' as _i407;
import 'package:carfy/data/mappers/category_mapper.dart' as _i109;
import 'package:carfy/data/mappers/group_mapper.dart' as _i12;
import 'package:carfy/data/mappers/notification_mapper.dart' as _i787;
import 'package:carfy/data/mappers/order_mapper.dart' as _i778;
import 'package:carfy/data/mappers/payment_mapper.dart' as _i237;
import 'package:carfy/data/mappers/product_mapper.dart' as _i344;
import 'package:carfy/data/mappers/referral_mapper.dart' as _i839;
import 'package:carfy/data/repositories/address_repository_impl.dart' as _i1024;
import 'package:carfy/data/repositories/advertisement_repository_impl.dart'
    as _i198;
import 'package:carfy/data/repositories/auth_repository_impl.dart' as _i407;
import 'package:carfy/data/repositories/basket_repository_impl.dart' as _i522;
import 'package:carfy/data/repositories/car_repository_impl.dart' as _i663;
import 'package:carfy/data/repositories/category_repository_impl.dart' as _i395;
import 'package:carfy/data/repositories/contact_repository_impl.dart' as _i1031;
import 'package:carfy/data/repositories/group_repository_impl.dart' as _i294;
import 'package:carfy/data/repositories/notification_repository_impl.dart'
    as _i750;
import 'package:carfy/data/repositories/order_repository_impl.dart' as _i506;
import 'package:carfy/data/repositories/payment_repository_impl.dart' as _i390;
import 'package:carfy/data/repositories/product_repository_impl.dart' as _i848;
import 'package:carfy/data/repositories/referral_repository_impl.dart' as _i655;
import 'package:carfy/data/repositories/translations_repository_impl.dart'
    as _i35;
import 'package:carfy/data/repositories/version_repository_impl.dart' as _i235;
import 'package:carfy/data/repositories/wishlist_repository_impl.dart' as _i224;
import 'package:carfy/domain/repositories/address_repository.dart' as _i574;
import 'package:carfy/domain/repositories/advertisement_repository.dart'
    as _i443;
import 'package:carfy/domain/repositories/auth_repository.dart' as _i655;
import 'package:carfy/domain/repositories/basket_repository.dart' as _i449;
import 'package:carfy/domain/repositories/car_repository.dart' as _i194;
import 'package:carfy/domain/repositories/category_repository.dart' as _i557;
import 'package:carfy/domain/repositories/contact_repository.dart' as _i157;
import 'package:carfy/domain/repositories/group_repository.dart' as _i1037;
import 'package:carfy/domain/repositories/notification_repository.dart'
    as _i765;
import 'package:carfy/domain/repositories/order_repository.dart' as _i603;
import 'package:carfy/domain/repositories/payment_repository.dart' as _i504;
import 'package:carfy/domain/repositories/product_repository.dart' as _i39;
import 'package:carfy/domain/repositories/referral_repository.dart' as _i200;
import 'package:carfy/domain/repositories/translation_repository.dart' as _i611;
import 'package:carfy/domain/repositories/version_repository.dart' as _i745;
import 'package:carfy/domain/repositories/wishlist_repository.dart' as _i54;
import 'package:carfy/domain/use_cases/address/add_address_use_case.dart'
    as _i374;
import 'package:carfy/domain/use_cases/address/delete_address_use_case.dart'
    as _i967;
import 'package:carfy/domain/use_cases/address/get_address_types_use_case.dart'
    as _i1062;
import 'package:carfy/domain/use_cases/address/get_addresses_use_case.dart'
    as _i956;
import 'package:carfy/domain/use_cases/address/get_countries_with_cities_use_case.dart'
    as _i684;
import 'package:carfy/domain/use_cases/address/set_default_address_use_case.dart'
    as _i358;
import 'package:carfy/domain/use_cases/address/update_address_use_case.dart'
    as _i438;
import 'package:carfy/domain/use_cases/advertisements/get_active_advertisements_use_case.dart'
    as _i524;
import 'package:carfy/domain/use_cases/auth/check_email_use_case.dart' as _i581;
import 'package:carfy/domain/use_cases/auth/check_phone_otp_use_case.dart'
    as _i818;
import 'package:carfy/domain/use_cases/auth/forgot_password_use_case.dart'
    as _i62;
import 'package:carfy/domain/use_cases/auth/generate_guest_identifier_use_case.dart'
    as _i593;
import 'package:carfy/domain/use_cases/auth/get_google_auth_redirect_use_case.dart'
    as _i559;
import 'package:carfy/domain/use_cases/auth/get_profile_use_case.dart' as _i2;
import 'package:carfy/domain/use_cases/auth/get_sessions_use_case.dart'
    as _i236;
import 'package:carfy/domain/use_cases/auth/login_with_email_use_case.dart'
    as _i601;
import 'package:carfy/domain/use_cases/auth/login_with_phone_use_case.dart'
    as _i963;
import 'package:carfy/domain/use_cases/auth/logout_all_use_case.dart' as _i311;
import 'package:carfy/domain/use_cases/auth/logout_session_use_case.dart'
    as _i521;
import 'package:carfy/domain/use_cases/auth/logout_use_case.dart' as _i992;
import 'package:carfy/domain/use_cases/auth/register_with_email_use_case.dart'
    as _i401;
import 'package:carfy/domain/use_cases/auth/register_with_phone_use_case.dart'
    as _i71;
import 'package:carfy/domain/use_cases/auth/send_phone_login_otp_use_case.dart'
    as _i90;
import 'package:carfy/domain/use_cases/auth/send_phone_otp_use_case.dart'
    as _i620;
import 'package:carfy/domain/use_cases/auth/send_verification_email_use_case.dart'
    as _i25;
import 'package:carfy/domain/use_cases/auth/third_party_login_use_case.dart'
    as _i401;
import 'package:carfy/domain/use_cases/auth/update_profile_use_case.dart'
    as _i915;
import 'package:carfy/domain/use_cases/auth/verify_email_otp_use_case.dart'
    as _i346;
import 'package:carfy/domain/use_cases/basket/add_to_basket_use_case.dart'
    as _i307;
import 'package:carfy/domain/use_cases/basket/decrement_quantity_use_case.dart'
    as _i828;
import 'package:carfy/domain/use_cases/basket/decrement_set_item_use_case.dart'
    as _i712;
import 'package:carfy/domain/use_cases/basket/get_basket_use_case.dart' as _i7;
import 'package:carfy/domain/use_cases/basket/increment_quantity_use_case.dart'
    as _i685;
import 'package:carfy/domain/use_cases/basket/increment_set_item_use_case.dart'
    as _i861;
import 'package:carfy/domain/use_cases/basket/remove_from_basket_use_case.dart'
    as _i509;
import 'package:carfy/domain/use_cases/basket/remove_set_item_use_case.dart'
    as _i853;
import 'package:carfy/domain/use_cases/car/add_car_use_case.dart' as _i325;
import 'package:carfy/domain/use_cases/car/delete_car_photo_use_case.dart'
    as _i256;
import 'package:carfy/domain/use_cases/car/delete_car_use_case.dart' as _i881;
import 'package:carfy/domain/use_cases/car/get_brand_models_use_case.dart'
    as _i84;
import 'package:carfy/domain/use_cases/car/get_brands_use_case.dart' as _i774;
import 'package:carfy/domain/use_cases/car/get_car_colors_use_case.dart'
    as _i47;
import 'package:carfy/domain/use_cases/car/get_car_types_use_case.dart'
    as _i411;
import 'package:carfy/domain/use_cases/car/get_car_use_case.dart' as _i229;
import 'package:carfy/domain/use_cases/car/get_cars_use_case.dart' as _i1057;
import 'package:carfy/domain/use_cases/car/get_engine_volumes_use_case.dart'
    as _i323;
import 'package:carfy/domain/use_cases/car/get_fuel_types_use_case.dart'
    as _i392;
import 'package:carfy/domain/use_cases/car/get_transmission_types_use_case.dart'
    as _i1004;
import 'package:carfy/domain/use_cases/car/update_car_use_case.dart' as _i936;
import 'package:carfy/domain/use_cases/category/get_categories_use_case.dart'
    as _i202;
import 'package:carfy/domain/use_cases/contact/send_contact_use_case.dart'
    as _i914;
import 'package:carfy/domain/use_cases/group/get_group_use_case.dart' as _i442;
import 'package:carfy/domain/use_cases/group/get_groups_bulk_use_case.dart'
    as _i863;
import 'package:carfy/domain/use_cases/group/get_groups_list_use_case.dart'
    as _i321;
import 'package:carfy/domain/use_cases/notifications/delete_all_notifications_use_case.dart'
    as _i276;
import 'package:carfy/domain/use_cases/notifications/delete_notification_use_case.dart'
    as _i682;
import 'package:carfy/domain/use_cases/notifications/get_unread_count_use_case.dart'
    as _i514;
import 'package:carfy/domain/use_cases/notifications/load_notifications_use_case.dart'
    as _i532;
import 'package:carfy/domain/use_cases/notifications/read_all_notifications_use_case.dart'
    as _i243;
import 'package:carfy/domain/use_cases/notifications/read_notification_use_case.dart'
    as _i211;
import 'package:carfy/domain/use_cases/notifications/register_device_token_use_case.dart'
    as _i788;
import 'package:carfy/domain/use_cases/orders/check_payment_status_use_case.dart'
    as _i944;
import 'package:carfy/domain/use_cases/orders/checkout_use_case.dart' as _i353;
import 'package:carfy/domain/use_cases/orders/get_checkout_preview_use_case.dart'
    as _i786;
import 'package:carfy/domain/use_cases/orders/get_order_details_use_case.dart'
    as _i827;
import 'package:carfy/domain/use_cases/orders/load_orders_use_case.dart'
    as _i224;
import 'package:carfy/domain/use_cases/payment/get_payment_methods_use_case.dart'
    as _i135;
import 'package:carfy/domain/use_cases/product/get_other_sellers_use_case.dart'
    as _i854;
import 'package:carfy/domain/use_cases/product/get_product_filters_use_case.dart'
    as _i250;
import 'package:carfy/domain/use_cases/product/get_product_show_use_case.dart'
    as _i309;
import 'package:carfy/domain/use_cases/product/get_products_use_case.dart'
    as _i603;
import 'package:carfy/domain/use_cases/product/load_reviews_use_case.dart'
    as _i303;
import 'package:carfy/domain/use_cases/product/store_review_use_case.dart'
    as _i139;
import 'package:carfy/domain/use_cases/referral/create_withdrawal_use_case.dart'
    as _i511;
import 'package:carfy/domain/use_cases/referral/get_referral_balance_use_case.dart'
    as _i652;
import 'package:carfy/domain/use_cases/referral/get_referral_info_use_case.dart'
    as _i892;
import 'package:carfy/domain/use_cases/referral/get_referral_perks_use_case.dart'
    as _i807;
import 'package:carfy/domain/use_cases/referral/load_referral_earnings_use_case.dart'
    as _i644;
import 'package:carfy/domain/use_cases/referral/load_referral_users_use_case.dart'
    as _i538;
import 'package:carfy/domain/use_cases/referral/load_referral_withdrawals_use_case.dart'
    as _i414;
import 'package:carfy/domain/use_cases/referral/update_referral_code_use_case.dart'
    as _i247;
import 'package:carfy/domain/use_cases/translations/get_cached_translations_use_case.dart'
    as _i187;
import 'package:carfy/domain/use_cases/translations/get_languages_list_use_case.dart'
    as _i731;
import 'package:carfy/domain/use_cases/translations/get_remote_translations_use_case.dart'
    as _i567;
import 'package:carfy/domain/use_cases/translations/save_translations_use_case.dart'
    as _i740;
import 'package:carfy/domain/use_cases/version/get_versions_use_case.dart'
    as _i450;
import 'package:carfy/domain/use_cases/wishlist/add_to_wishlist_use_case.dart'
    as _i456;
import 'package:carfy/domain/use_cases/wishlist/get_wishlist_ids_use_case.dart'
    as _i214;
import 'package:carfy/domain/use_cases/wishlist/get_wishlist_use_case.dart'
    as _i676;
import 'package:carfy/domain/use_cases/wishlist/remove_from_wishlist_use_case.dart'
    as _i904;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i303.AddressMapper>(() => _i303.AddressMapper());
    gh.factory<_i755.AdvertisementMapper>(() => _i755.AdvertisementMapper());
    gh.factory<_i163.AuthMapper>(() => _i163.AuthMapper());
    gh.factory<_i407.CarMapper>(() => _i407.CarMapper());
    gh.factory<_i109.CategoryMapper>(() => _i109.CategoryMapper());
    gh.factory<_i787.NotificationMapper>(() => _i787.NotificationMapper());
    gh.factory<_i237.PaymentMapper>(() => _i237.PaymentMapper());
    gh.factory<_i344.ProductMapper>(() => _i344.ProductMapper());
    gh.factory<_i839.ReferralMapper>(() => _i839.ReferralMapper());
    gh.singleton<_i597.NetworkManager>(() => _i597.NetworkManager());
    gh.factory<_i1057.ContactRemoteDataSource>(
      () => _i1057.ContactRemoteDataSourceImpl(),
    );
    gh.factory<_i1047.PaymentRemoteDataSource>(
      () => _i1047.PaymentRemoteDataSourceImpl(),
    );
    gh.factory<_i490.BasketRemoteDataSource>(
      () => _i490.BasketRemoteDataSourceImpl(),
    );
    gh.factory<_i304.CarRemoteDataSource>(
      () => _i304.CarRemoteDataSourceImpl(),
    );
    gh.factory<_i685.WishlistRemoteDataSource>(
      () => _i685.WishlistRemoteDataSourceImpl(),
    );
    gh.factory<_i49.NotificationRemoteDataSource>(
      () => _i49.NotificationRemoteDataSourceImpl(),
    );
    gh.factory<_i713.VersionRemoteDataSource>(
      () => _i713.VersionRemoteDataSourceImpl(),
    );
    gh.factory<_i881.ProductRemoteDataSource>(
      () => _i881.ProductRemoteDataSourceImpl(),
    );
    gh.factory<_i54.WishlistRepository>(
      () => _i224.WishlistRepositoryImpl(
        gh<_i685.WishlistRemoteDataSource>(),
        gh<_i344.ProductMapper>(),
      ),
    );
    gh.factory<_i504.PaymentRepository>(
      () => _i390.PaymentRepositoryImpl(
        gh<_i1047.PaymentRemoteDataSource>(),
        gh<_i237.PaymentMapper>(),
      ),
    );
    gh.factory<_i951.AdvertisementRemoteDataSource>(
      () => _i951.AdvertisementRemoteDataSourceImpl(),
    );
    gh.factory<_i456.AddToWishlistUseCase>(
      () => _i456.AddToWishlistUseCase(gh<_i54.WishlistRepository>()),
    );
    gh.factory<_i214.GetWishlistIdsUseCase>(
      () => _i214.GetWishlistIdsUseCase(gh<_i54.WishlistRepository>()),
    );
    gh.factory<_i676.GetWishlistUseCase>(
      () => _i676.GetWishlistUseCase(gh<_i54.WishlistRepository>()),
    );
    gh.factory<_i904.RemoveFromWishlistUseCase>(
      () => _i904.RemoveFromWishlistUseCase(gh<_i54.WishlistRepository>()),
    );
    gh.factory<_i861.CategoryRemoteDataSource>(
      () => _i861.CategoryRemoteDataSourceImpl(),
    );
    gh.factory<_i930.AddressRemoteDataSource>(
      () => _i930.AddressRemoteDataSourceImpl(),
    );
    gh.factory<_i1053.TranslationLocalDataSource>(
      () => _i1053.TranslationLocalDataSourceImpl(),
    );
    gh.factory<_i874.GroupRemoteDataSource>(
      () => _i874.GroupRemoteDataSourceImpl(),
    );
    gh.factory<_i250.AuthRemoteDataSource>(
      () => _i250.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i150.OrderRemoteDataSource>(
      () => _i150.OrderRemoteDataSourceImpl(),
    );
    gh.factory<_i861.ReferralRemoteDataSource>(
      () => _i861.ReferralRemoteDataSourceImpl(),
    );
    gh.factory<_i387.TranslationRemoteDataSource>(
      () => _i387.TranslationRemoteDataSourceImpl(),
    );
    gh.factory<_i443.AdvertisementRepository>(
      () => _i198.AdvertisementRepositoryImpl(
        gh<_i951.AdvertisementRemoteDataSource>(),
        gh<_i755.AdvertisementMapper>(),
      ),
    );
    gh.factory<_i194.CarRepository>(
      () => _i663.CarRepositoryImpl(
        gh<_i304.CarRemoteDataSource>(),
        gh<_i407.CarMapper>(),
      ),
    );
    gh.factory<_i751.BasketMapper>(
      () => _i751.BasketMapper(gh<_i344.ProductMapper>()),
    );
    gh.factory<_i12.GroupMapper>(
      () => _i12.GroupMapper(gh<_i344.ProductMapper>()),
    );
    gh.factory<_i778.OrderMapper>(
      () => _i778.OrderMapper(gh<_i344.ProductMapper>()),
    );
    gh.factory<_i574.AddressRepository>(
      () => _i1024.AddressRepositoryImpl(
        gh<_i930.AddressRemoteDataSource>(),
        gh<_i303.AddressMapper>(),
      ),
    );
    gh.factory<_i157.ContactRepository>(
      () => _i1031.ContactRepositoryImpl(gh<_i1057.ContactRemoteDataSource>()),
    );
    gh.factory<_i200.ReferralRepository>(
      () => _i655.ReferralRepositoryImpl(
        gh<_i861.ReferralRemoteDataSource>(),
        gh<_i839.ReferralMapper>(),
      ),
    );
    gh.factory<_i765.NotificationRepository>(
      () => _i750.NotificationRepositoryImpl(
        gh<_i49.NotificationRemoteDataSource>(),
        gh<_i787.NotificationMapper>(),
      ),
    );
    gh.factory<_i524.GetActiveAdvertisementsUseCase>(
      () => _i524.GetActiveAdvertisementsUseCase(
        gh<_i443.AdvertisementRepository>(),
      ),
    );
    gh.factory<_i135.GetPaymentMethodsUseCase>(
      () => _i135.GetPaymentMethodsUseCase(gh<_i504.PaymentRepository>()),
    );
    gh.factory<_i511.CreateWithdrawalUseCase>(
      () => _i511.CreateWithdrawalUseCase(gh<_i200.ReferralRepository>()),
    );
    gh.factory<_i652.GetReferralBalanceUseCase>(
      () => _i652.GetReferralBalanceUseCase(gh<_i200.ReferralRepository>()),
    );
    gh.factory<_i892.GetReferralInfoUseCase>(
      () => _i892.GetReferralInfoUseCase(gh<_i200.ReferralRepository>()),
    );
    gh.factory<_i807.GetReferralPerksUseCase>(
      () => _i807.GetReferralPerksUseCase(gh<_i200.ReferralRepository>()),
    );
    gh.factory<_i644.LoadReferralEarningsUseCase>(
      () => _i644.LoadReferralEarningsUseCase(gh<_i200.ReferralRepository>()),
    );
    gh.factory<_i538.LoadReferralUsersUseCase>(
      () => _i538.LoadReferralUsersUseCase(gh<_i200.ReferralRepository>()),
    );
    gh.factory<_i414.LoadReferralWithdrawalsUseCase>(
      () =>
          _i414.LoadReferralWithdrawalsUseCase(gh<_i200.ReferralRepository>()),
    );
    gh.factory<_i247.UpdateReferralCodeUseCase>(
      () => _i247.UpdateReferralCodeUseCase(gh<_i200.ReferralRepository>()),
    );
    gh.factory<_i745.VersionRepository>(
      () => _i235.VersionRepositoryImpl(gh<_i713.VersionRemoteDataSource>()),
    );
    gh.factory<_i603.OrderRepository>(
      () => _i506.OrderRepositoryImpl(
        gh<_i150.OrderRemoteDataSource>(),
        gh<_i778.OrderMapper>(),
      ),
    );
    gh.factory<_i39.ProductRepository>(
      () => _i848.ProductRepositoryImpl(
        gh<_i881.ProductRemoteDataSource>(),
        gh<_i344.ProductMapper>(),
      ),
    );
    gh.factory<_i557.CategoryRepository>(
      () => _i395.CategoryRepositoryImpl(
        gh<_i861.CategoryRemoteDataSource>(),
        gh<_i109.CategoryMapper>(),
      ),
    );
    gh.factory<_i374.AddAddressUseCase>(
      () => _i374.AddAddressUseCase(gh<_i574.AddressRepository>()),
    );
    gh.factory<_i967.DeleteAddressUseCase>(
      () => _i967.DeleteAddressUseCase(gh<_i574.AddressRepository>()),
    );
    gh.factory<_i1062.GetAddressTypesUseCase>(
      () => _i1062.GetAddressTypesUseCase(gh<_i574.AddressRepository>()),
    );
    gh.factory<_i956.GetAddressesUseCase>(
      () => _i956.GetAddressesUseCase(gh<_i574.AddressRepository>()),
    );
    gh.factory<_i684.GetCountriesWithCitiesUseCase>(
      () => _i684.GetCountriesWithCitiesUseCase(gh<_i574.AddressRepository>()),
    );
    gh.factory<_i358.SetDefaultAddressUseCase>(
      () => _i358.SetDefaultAddressUseCase(gh<_i574.AddressRepository>()),
    );
    gh.factory<_i438.UpdateAddressUseCase>(
      () => _i438.UpdateAddressUseCase(gh<_i574.AddressRepository>()),
    );
    gh.factory<_i854.GetOtherSellersUseCase>(
      () => _i854.GetOtherSellersUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i250.GetProductFiltersUseCase>(
      () => _i250.GetProductFiltersUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i309.GetProductShowUseCase>(
      () => _i309.GetProductShowUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i603.GetProductsUseCase>(
      () => _i603.GetProductsUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i303.LoadReviewsUseCase>(
      () => _i303.LoadReviewsUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i139.StoreReviewUseCase>(
      () => _i139.StoreReviewUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i914.SendContactUseCase>(
      () => _i914.SendContactUseCase(gh<_i157.ContactRepository>()),
    );
    gh.factory<_i202.GetCategoriesUseCase>(
      () => _i202.GetCategoriesUseCase(gh<_i557.CategoryRepository>()),
    );
    gh.factory<_i325.AddCarUseCase>(
      () => _i325.AddCarUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i256.DeleteCarPhotoUseCase>(
      () => _i256.DeleteCarPhotoUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i881.DeleteCarUseCase>(
      () => _i881.DeleteCarUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i84.GetBrandModelsUseCase>(
      () => _i84.GetBrandModelsUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i774.GetBrandsUseCase>(
      () => _i774.GetBrandsUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i47.GetCarColorsUseCase>(
      () => _i47.GetCarColorsUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i411.GetCarTypesUseCase>(
      () => _i411.GetCarTypesUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i229.GetCarUseCase>(
      () => _i229.GetCarUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i1057.GetCarsUseCase>(
      () => _i1057.GetCarsUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i323.GetEngineVolumesUseCase>(
      () => _i323.GetEngineVolumesUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i392.GetFuelTypesUseCase>(
      () => _i392.GetFuelTypesUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i1004.GetTransmissionTypesUseCase>(
      () => _i1004.GetTransmissionTypesUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i936.UpdateCarUseCase>(
      () => _i936.UpdateCarUseCase(gh<_i194.CarRepository>()),
    );
    gh.factory<_i655.AuthRepository>(
      () => _i407.AuthRepositoryImpl(
        gh<_i250.AuthRemoteDataSource>(),
        gh<_i163.AuthMapper>(),
      ),
    );
    gh.factory<_i611.TranslationRepository>(
      () => _i35.TranslationsRepositoryImpl(
        gh<_i387.TranslationRemoteDataSource>(),
        gh<_i1053.TranslationLocalDataSource>(),
      ),
    );
    gh.factory<_i449.BasketRepository>(
      () => _i522.BasketRepositoryImpl(
        gh<_i490.BasketRemoteDataSource>(),
        gh<_i751.BasketMapper>(),
      ),
    );
    gh.factory<_i1037.GroupRepository>(
      () => _i294.GroupRepositoryImpl(
        gh<_i874.GroupRemoteDataSource>(),
        gh<_i12.GroupMapper>(),
      ),
    );
    gh.factory<_i442.GetGroupUseCase>(
      () => _i442.GetGroupUseCase(gh<_i1037.GroupRepository>()),
    );
    gh.factory<_i863.GetGroupsBulkUseCase>(
      () => _i863.GetGroupsBulkUseCase(gh<_i1037.GroupRepository>()),
    );
    gh.factory<_i321.GetGroupsListUseCase>(
      () => _i321.GetGroupsListUseCase(gh<_i1037.GroupRepository>()),
    );
    gh.factory<_i276.DeleteAllNotificationsUseCase>(
      () => _i276.DeleteAllNotificationsUseCase(
        gh<_i765.NotificationRepository>(),
      ),
    );
    gh.factory<_i682.DeleteNotificationUseCase>(
      () => _i682.DeleteNotificationUseCase(gh<_i765.NotificationRepository>()),
    );
    gh.factory<_i514.GetUnreadCountUseCase>(
      () => _i514.GetUnreadCountUseCase(gh<_i765.NotificationRepository>()),
    );
    gh.factory<_i532.LoadNotificationsUseCase>(
      () => _i532.LoadNotificationsUseCase(gh<_i765.NotificationRepository>()),
    );
    gh.factory<_i243.ReadAllNotificationsUseCase>(
      () =>
          _i243.ReadAllNotificationsUseCase(gh<_i765.NotificationRepository>()),
    );
    gh.factory<_i211.ReadNotificationUseCase>(
      () => _i211.ReadNotificationUseCase(gh<_i765.NotificationRepository>()),
    );
    gh.factory<_i788.RegisterDeviceTokenUseCase>(
      () =>
          _i788.RegisterDeviceTokenUseCase(gh<_i765.NotificationRepository>()),
    );
    gh.factory<_i450.GetVersionsUseCase>(
      () => _i450.GetVersionsUseCase(gh<_i745.VersionRepository>()),
    );
    gh.factory<_i944.CheckPaymentStatusUseCase>(
      () => _i944.CheckPaymentStatusUseCase(gh<_i603.OrderRepository>()),
    );
    gh.factory<_i353.CheckoutUseCase>(
      () => _i353.CheckoutUseCase(gh<_i603.OrderRepository>()),
    );
    gh.factory<_i786.GetCheckoutPreviewUseCase>(
      () => _i786.GetCheckoutPreviewUseCase(gh<_i603.OrderRepository>()),
    );
    gh.factory<_i827.GetOrderDetailsUseCase>(
      () => _i827.GetOrderDetailsUseCase(gh<_i603.OrderRepository>()),
    );
    gh.factory<_i224.LoadOrdersUseCase>(
      () => _i224.LoadOrdersUseCase(gh<_i603.OrderRepository>()),
    );
    gh.factory<_i581.CheckEmailUseCase>(
      () => _i581.CheckEmailUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i818.CheckPhoneOtpUseCase>(
      () => _i818.CheckPhoneOtpUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i62.ForgotPasswordUseCase>(
      () => _i62.ForgotPasswordUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i593.GenerateGuestIdentifierUseCase>(
      () => _i593.GenerateGuestIdentifierUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i559.GetGoogleAuthRedirectUseCase>(
      () => _i559.GetGoogleAuthRedirectUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i2.GetProfileUseCase>(
      () => _i2.GetProfileUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i236.GetSessionsUseCase>(
      () => _i236.GetSessionsUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i601.LoginWithEmailUseCase>(
      () => _i601.LoginWithEmailUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i963.LoginWithPhoneUseCase>(
      () => _i963.LoginWithPhoneUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i311.LogoutAllUseCase>(
      () => _i311.LogoutAllUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i521.LogoutSessionUseCase>(
      () => _i521.LogoutSessionUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i992.LogoutUseCase>(
      () => _i992.LogoutUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i401.RegisterWithEmailUseCase>(
      () => _i401.RegisterWithEmailUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i71.RegisterWithPhoneUseCase>(
      () => _i71.RegisterWithPhoneUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i90.SendPhoneLoginOtpUseCase>(
      () => _i90.SendPhoneLoginOtpUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i620.SendPhoneRegisterOtpUseCase>(
      () => _i620.SendPhoneRegisterOtpUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i25.SendVerificationEmailUseCase>(
      () => _i25.SendVerificationEmailUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i401.ThirdPartyLoginUseCase>(
      () => _i401.ThirdPartyLoginUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i915.UpdateProfileUseCase>(
      () => _i915.UpdateProfileUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i346.VerifyEmailOtpUseCase>(
      () => _i346.VerifyEmailOtpUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i307.AddToBasketUseCase>(
      () => _i307.AddToBasketUseCase(gh<_i449.BasketRepository>()),
    );
    gh.factory<_i828.DecrementQuantityUseCase>(
      () => _i828.DecrementQuantityUseCase(gh<_i449.BasketRepository>()),
    );
    gh.factory<_i712.DecrementSetItemUseCase>(
      () => _i712.DecrementSetItemUseCase(gh<_i449.BasketRepository>()),
    );
    gh.factory<_i7.GetBasketUseCase>(
      () => _i7.GetBasketUseCase(gh<_i449.BasketRepository>()),
    );
    gh.factory<_i685.IncrementQuantityUseCase>(
      () => _i685.IncrementQuantityUseCase(gh<_i449.BasketRepository>()),
    );
    gh.factory<_i861.IncrementSetItemUseCase>(
      () => _i861.IncrementSetItemUseCase(gh<_i449.BasketRepository>()),
    );
    gh.factory<_i509.RemoveFromBasketUseCase>(
      () => _i509.RemoveFromBasketUseCase(gh<_i449.BasketRepository>()),
    );
    gh.factory<_i853.RemoveSetItemUseCase>(
      () => _i853.RemoveSetItemUseCase(gh<_i449.BasketRepository>()),
    );
    gh.factory<_i187.GetCachedTranslationsUseCase>(
      () =>
          _i187.GetCachedTranslationsUseCase(gh<_i611.TranslationRepository>()),
    );
    gh.factory<_i731.GetLanguagesListUseCase>(
      () => _i731.GetLanguagesListUseCase(gh<_i611.TranslationRepository>()),
    );
    gh.factory<_i567.GetRemoteTranslationsUseCase>(
      () =>
          _i567.GetRemoteTranslationsUseCase(gh<_i611.TranslationRepository>()),
    );
    gh.factory<_i740.SaveTranslationsUseCase>(
      () => _i740.SaveTranslationsUseCase(gh<_i611.TranslationRepository>()),
    );
    return this;
  }
}
