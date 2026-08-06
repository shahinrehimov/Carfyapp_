part of 'profile_update_cubit.dart';

enum ProfileUpdateFieldError { required }

class ProfileUpdateState extends Equatable {
  final StateStatus submitStatus;
  final StateStatus logoutStatus;
  final StateStatus deleteStatus;
  final StateStatus imageStatus;

  final String name;
  final String surname;
  final String? selectedGender;
  final String? birthDate; // stored as dd.MM.yyyy for API

  // Initial values for change detection
  final String initialName;
  final String initialSurname;
  final String? initialGender;
  final String? initialBirthDate;

  final ProfileUpdateFieldError? nameError;
  final ProfileUpdateFieldError? surnameError;
  final String? nameValidationError;
  final String? surnameValidationError;
  final String? genderValidationError;
  final String? birthDateValidationError;

  final AuthUser? updatedUser;
  final String? currentImageUrl;
  final String email;
  final String phone;
  final String? registerType;

  bool get hasChanges =>
      name != initialName ||
      surname != initialSurname ||
      selectedGender != initialGender ||
      birthDate != initialBirthDate;

  const ProfileUpdateState({
    required this.submitStatus,
    required this.logoutStatus,
    required this.deleteStatus,
    required this.imageStatus,
    required this.name,
    required this.surname,
    this.selectedGender,
    this.birthDate,
    required this.initialName,
    required this.initialSurname,
    this.initialGender,
    this.initialBirthDate,
    this.nameError,
    this.surnameError,
    this.nameValidationError,
    this.surnameValidationError,
    this.genderValidationError,
    this.birthDateValidationError,
    this.updatedUser,
    this.currentImageUrl,
    this.email = '',
    this.phone = '',
    this.registerType,
  });

  factory ProfileUpdateState.initial() => ProfileUpdateState(
    submitStatus: StateStatus.initial(),
    logoutStatus: StateStatus.initial(),
    deleteStatus: StateStatus.initial(),
    imageStatus: StateStatus.initial(),
    name: '',
    surname: '',
    initialName: '',
    initialSurname: '',
  );

  ProfileUpdateState copyWith({
    StateStatus? submitStatus,
    StateStatus? logoutStatus,
    StateStatus? deleteStatus,
    StateStatus? imageStatus,
    String? name,
    String? surname,
    String? selectedGender,
    String? birthDate,
    String? initialName,
    String? initialSurname,
    String? initialGender,
    String? initialBirthDate,
    ProfileUpdateFieldError? nameError,
    ProfileUpdateFieldError? surnameError,
    String? nameValidationError,
    String? surnameValidationError,
    String? genderValidationError,
    String? birthDateValidationError,
    AuthUser? updatedUser,
    String? currentImageUrl,
    bool clearCurrentImageUrl = false,
    bool clearNameError = false,
    bool clearSurnameError = false,
    bool clearBirthDate = false,
    String? email,
    String? phone,
    String? registerType,
  }) => ProfileUpdateState(
    submitStatus: submitStatus ?? this.submitStatus,
    logoutStatus: logoutStatus ?? this.logoutStatus,
    deleteStatus: deleteStatus ?? this.deleteStatus,
    imageStatus: imageStatus ?? this.imageStatus,
    name: name ?? this.name,
    surname: surname ?? this.surname,
    selectedGender: selectedGender ?? this.selectedGender,
    birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
    initialName: initialName ?? this.initialName,
    initialSurname: initialSurname ?? this.initialSurname,
    initialGender: initialGender ?? this.initialGender,
    initialBirthDate: initialBirthDate ?? this.initialBirthDate,
    nameError: clearNameError ? null : (nameError ?? this.nameError),
    surnameError: clearSurnameError ? null : (surnameError ?? this.surnameError),
    nameValidationError: nameValidationError ?? this.nameValidationError,
    surnameValidationError: surnameValidationError ?? this.surnameValidationError,
    genderValidationError: genderValidationError ?? this.genderValidationError,
    birthDateValidationError: birthDateValidationError ?? this.birthDateValidationError,
    updatedUser: updatedUser ?? this.updatedUser,
    currentImageUrl: clearCurrentImageUrl ? null : (currentImageUrl ?? this.currentImageUrl),
    email: email ?? this.email,
    phone: phone ?? this.phone,
    registerType: registerType ?? this.registerType,
  );

  @override
  List<Object?> get props => [
    submitStatus,
    logoutStatus,
    deleteStatus,
    name,
    surname,
    selectedGender,
    birthDate,
    initialName,
    initialSurname,
    initialGender,
    initialBirthDate,
    nameError,
    surnameError,
    nameValidationError,
    surnameValidationError,
    genderValidationError,
    birthDateValidationError,
    updatedUser,
    currentImageUrl,
    imageStatus,
    email,
    phone,
    registerType,
  ];
}
