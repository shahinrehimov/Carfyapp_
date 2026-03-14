# Carfy - Flutter Project

## Project Overview

Carfy is a Flutter e-commerce mobile app (car parts/accessories) targeting Android and iOS.

- **Package name**: `carfy`
- **Base URL**: `https://carfy.kvadrat-lab.com/api`
- **Flutter SDK**: ^3.9.0
- **Supported locales**: az, en, ru

---

## Architecture: Clean Architecture (3 Layers)

```
lib/
├── common/           # Shared utilities, DI, router, theme, mixins, widgets
├── data/             # Models, DTOs, datasources, repository impls, mappers
├── domain/           # Entities, params, repository abstracts, use cases, enums
├── presentation/     # Pages, widgets, cubits, states
├── gen/              # flutter_gen generated assets
└── main.dart
```

### Layer Responsibilities

**domain/**
- `entities/` - Pure Dart classes, no dependencies
- `params/` - Input objects passed to use cases
- `repositories/` - Abstract repository interfaces
- `use_cases/` - Single-responsibility callable classes (`call()` method)
- `enums/` - App-level enums

**data/**
- `datasources/` - HTTP calls via `NetworkManager`, use `DataSourceMixin`
- `dtos/` - Request body objects (serialized to JSON)
- `models/` - API response models (deserialized from JSON)
- `mappers/` - Convert models → domain entities
- `repositories/` - Implement domain repository interfaces, use `RepositorySafeCallMixin`

**presentation/**
- `<feature>/state/` - Cubit + State files
- `<feature>/ui/page/` - Full screen pages
- `<feature>/ui/widget/` - Feature-specific widgets

---

## State Management: flutter_bloc (Cubits)

### State Pattern
- State class is defined as `part of` the cubit file
- States extend `Equatable`, implement `copyWith`, have a `static initial()` factory
- Use `StateStatus` for async operation status (not freezed/sealed)

```dart
part of 'home_cubit.dart';

class HomeState extends Equatable {
  final StateStatus categoriesStatus;
  final List<Category> categories;
  // ...

  factory HomeState.initial() => HomeState(
    categoriesStatus: StateStatus.loading(),
    categories: [],
  );

  HomeState copyWith({...}) { ... }

  @override
  List<Object?> get props => [...];
}
```

### StateStatus
Custom class at `lib/common/state/state_status.dart` with `maybeWhen()`:

```dart
StateStatus.initial()
StateStatus.loading()
StateStatus.paginationLoading()
StateStatus.success()
StateStatus.successWithMessage(String msg)
StateStatus.empty()
StateStatus.failure(String msg)
StateStatus.serverFailure()
StateStatus.networkFailure()
```

Usage in UI:
```dart
state.status.maybeWhen(
  success: () => ...,
  loading: () => ...,
  orElse: () => ...,
);
```

### Cubit Pattern
- Cubits get dependencies via optional constructor params with `getIt` fallback:
```dart
HomeCubit({GetCategoriesUseCase? getCategoriesUseCase})
    : _getCategoriesUseCase = getCategoriesUseCase ?? getIt<GetCategoriesUseCase>(),
      super(HomeState.initial());
```
- Use `StateMapHelper` mixin for mapping `Failure` → `StateStatus`

---

## Dependency Injection: injectable + get_it

- DI configured at `lib/common/di/di.dart`
- Annotations: `@injectable`, `@singleton`, `@Injectable(as: Interface)`
- Generated file: `lib/common/di/di.config.dart`
- Access: `getIt<Type>()` or via constructor injection

```dart
@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository { ... }

@injectable
class LoginWithEmailUseCase { ... }

@singleton
class NetworkManager { ... }
```

---

## Navigation: auto_route

- Router at `lib/common/router/app_router.dart`
- Generated file: `lib/common/router/app_router.gr.dart`
- Router registered as singleton in `main.dart`: `getIt.registerSingleton<AppRouter>(AppRouter())`
- Access router in cubits via `getIt<AppRouter>()`

### Route Structure
```
SplashRoute (initial)
MainRoute (shell with bottom nav)
  ├── HomeRoute (initial)
  ├── MessagesRoute
  ├── WishlistRoute
  ├── BasketRoute
  └── ProfileRoute
LoginRoute, RegisterRoute, ForgotPasswordRoute, ...
CategoryDialogRoute (fullscreen dialog)
  ├── CategoriesRoute (initial)
  └── SubCategoriesRoute
```

---

## Networking: Dio via NetworkManager

- `NetworkManager` at `lib/common/network/network_manager.dart` — singleton
- Auto-injects `Authorization: Bearer <token>` and `identifier` headers from SharedPreferences
- Debug mode: curl logging enabled (`CurlLoggingInterceptor`)
- `validateStatus: (_) => true` — all status codes pass through without throwing

### DataSourceMixin
Use in remote datasources for response handling:
```dart
class AuthRemoteDataSource with DataSourceMixin {
  Future<LoginResponseModel> loginWithEmail(LoginWithEmailRequestDto dto) {
    return handleResponse(
      () => _network.post(EndpointPaths.loginWithEmail, data: dto.toJson()),
      map: (data) => LoginResponseModel.fromJson(data),
    );
  }
}
```
Handles: 200, 400, 401, 403, 422 (ValidationException), 429, connection errors.

### RepositorySafeCallMixin
Use in repository impls to wrap datasource calls in `Either<Failure, T>`:
```dart
Future<Either<Failure, LoginResponse>> loginWithEmail(...) {
  return safeCall(() async {
    final res = await _dataSource.loginWithEmail(...);
    return _mapper.mapLogin(res);
  });
}
```

---

## Error Handling

**Exceptions** (`lib/common/error/exceptions.dart`):
- `ServerException`
- `ConnectionException`
- `UserException(message)`
- `ValidationException(Map<String, List<String>> errors)`
- `ParseException`

**Failures** (`lib/common/error/failure.dart`):
- `ServerFailure`
- `ConnectionFailure`
- `UserFailure(message)`
- `ValidationFailure(Map<String, List<String>> errors)`
- `UnavailableFailure`

**StateMapHelper mixin** maps `Failure` → `StateStatus`:
```dart
StateStatus mapFailure(Failure failure)
FieldValidationState mapValidationFailure(String key, ValidationFailure failure)
```

---

## Local Storage

- **SharedPreferences** via `PrefUtil` (`lib/common/util/pref_util.dart`)
- Keys defined in `lib/common/constants/preference_keys.dart` (`AppPreferenceKeys`)
- **Hive** (`hive_ce` / `hive_ce_flutter`) for `TranslationLocalModel` — adapters registered in `main.dart`

---

## Localization

- Custom system, NOT Flutter's `intl` ARB approach
- API-driven translations fetched and cached locally
- `AppLocalizations` at `lib/common/translations/app_localizations.dart`
- Access via extension: `context.localization`
- Translation keys in `lib/common/translations/translation_keys.dart`

---

## Theming

- Custom `AppTheme` InheritedWidget at `lib/common/theme/theme.dart`
- Access via extension: `context.theme`
- Custom `ColorScheme` interface (NOT Flutter's `ColorScheme`)
- Key colors:
  - Primary: `#00569C`
  - Secondary: `#3696E7`
  - Background: `#F7FBFE`
  - Error: `#F6683C`
- Text scaling disabled app-wide (`TextScaler.noScaling`)

---

## Pagination

`PaginationHelper` at `lib/common/helper/pagination_helper.dart`:
```dart
final _helper = PaginationHelper();

// In load method:
if (!_helper.shouldLoad()) return;
emit(state.copyWith(status: _helper.getLoadingStatus())); // loading or paginationLoading
_helper.onLoadStart();
// ... fetch ...
_helper.onLoadEnd(response.lastPage);
// Append: [...state.items, ...response.data]
```

---

## Code Generation

Run after modifying annotated files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Generates:
- `lib/common/di/di.config.dart` (injectable)
- `lib/common/router/app_router.gr.dart` (auto_route)
- `lib/data/models/translation/translation_local_model.g.dart` (hive_ce)
- `lib/hive_registrar.g.dart` (hive_ce)
- `lib/gen/assets.gen.dart` (flutter_gen)

---

## showStateStatusToast

`lib/common/widgets/state_status_toast.dart`

Use in `BlocListener` to automatically show toasts for error/success states:

```dart
BlocListener<MyCubit, MyState>(
  listenWhen: (prev, curr) => prev.status != curr.status,
  listener: (context, state) {
    showStateStatusToast(context, state.status);
  },
)
```

Handles these cases automatically:
- `StateStatusFailure` → shows the failure message
- `StateStatusNetworkFailure` → shows `context.localization.connectionFailure`
- `StateStatusServerFailure` → shows `context.localization.serverFailure`
- `StateStatusSuccessWithMessage` → shows the success message

Other statuses (loading, success, empty, etc.) are silently ignored.

---

## Key Conventions

1. **Widget sections** inside pages are private classes prefixed with `_` and declared as `part of` the page file
2. **Use cases** are `@injectable`, have a single `call()` method, return `Either<Failure, T>`
3. **DTOs** have a `toJson()` method; **Models** have a `fromJson()` factory
4. **Mappers** are `@injectable`, convert Models → Domain Entities
5. **Cubits** use `StateMapHelper` mixin; never expose raw Failures to UI
6. **Constants**: API base URL and security token in `lib/common/constants/constants.dart`
7. **Endpoint paths**: all defined in `lib/common/constants/endpoint_paths.dart`

---

## API: Multi-Seller Marketplace (Breaking Changes)

> Full details in `api-docs/FRONTEND_CHANGES.md`

The backend was refactored to a multi-seller model. Each product variant now has seller-specific listings called **CPV (CompanyProductVariant)**.

### Key Concepts

- `ProductVariant` no longer stores price/stock — these come from the seller's CPV
- Every product response includes a `seller` object with the cheapest (or selected) seller's data
- `seller.uuid` = CPV UUID — **use this** for all basket/wishlist actions (not the variant UUID)
- `in_wishlist` / `in_basket` are now CPV-level flags

### Breaking Changes

**Basket endpoints** — URL param changed from `{productVariantUuid}` to `{cpvUuid}`:
```
POST /basket/add/{cpvUuid}
POST /basket/remove/{cpvUuid}
POST /basket/increment/{cpvUuid}
POST /basket/decrement/{cpvUuid}
```

**Wishlist endpoints** — same change:
```
POST /wishlist/add/{cpvUuid}
POST /wishlist/remove/{cpvUuid}
```

### New Response Fields (Product List & Detail)

```json
{
  "seller": {
    "id": 3,
    "uuid": "cpv-uuid-here",
    "city": { "id": 1, "title": "Baku" },
    "images": [{ "id": 10, "url": "https://..." }]
  },
  "sellers_count": 3
}
```

### Product Detail — New Query Params

| Param | Description |
|-------|-------------|
| `seller` | CPV UUID — load a specific seller's listing |
| `other_sellers` | `true` to include `other_sellers` array in response |

Other sellers endpoint: `GET /products/{productVariantId}/other-sellers`

---

## API: User Cars

> Full details in `api-docs/car.md`

Base: `/app/profile/cars/` — requires Bearer auth token.

| Action | Method | Endpoint |
|--------|--------|----------|
| List | GET | `/app/profile/cars/load` |
| Show | GET | `/app/profile/cars/show/{id}` |
| Add | POST (multipart) | `/app/profile/cars/add` |
| Update | POST (multipart) | `/app/profile/cars/update/{id}` |
| Delete | DELETE | `/app/profile/cars/delete/{id}` |
| Delete photo | DELETE | `/app/profile/cars/delete-photo/{id}` |

**Add/Update fields:** `brand_model_id`*, `car_type_id`*, `year`*, `engine_volume_id`, `fuel_type_id`, `transmission_type_id`, `engine_number`, `vin_number`, `photo`

**Car library dropdowns** (public, no auth):

| Data | Endpoint |
|------|----------|
| Fuel types | `GET /app/car-libraries/fuel-types` |
| Transmission types | `GET /app/car-libraries/transmission-types` |
| Car types | `GET /app/car-libraries/car-types` |
| Engine volumes | `GET /app/car-libraries/engine-volumes` |
| Brands | `GET /control/brands/list` |
| Models by brand | `GET /control/brands/{brandId}/models/list` |

---

## Features / Pages

| Feature | Route | Bottom Nav |
|---------|-------|-----------|
| Splash | `/` | - |
| Main shell | MainRoute | Yes |
| Home | HomeRoute | Tab 0 |
| Messages | MessagesRoute | Tab 1 |
| Wishlist | WishlistRoute | Tab 2 |
| Basket | BasketRoute | Tab 3 |
| Profile | ProfileRoute | Tab 4 |
| Login | LoginRoute | - |
| Register | RegisterRoute | - |
| Categories | CategoryDialogRoute (dialog) | - |
