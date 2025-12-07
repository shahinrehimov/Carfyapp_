class StateStatus {
  const StateStatus();

  factory StateStatus.initial() = StateStatusInitial;

  factory StateStatus.loading() = StateStatusLoading;

  factory StateStatus.paginationLoading() = StateStatusPaginationLoading;

  factory StateStatus.empty() = StateStatusEmpty;

  factory StateStatus.failure(String msg) = StateStatusFailure;

  factory StateStatus.serverFailure() = StateStatusServerFailure;

  factory StateStatus.networkFailure() = StateStatusNetworkFailure;

  factory StateStatus.success() = StateStatusSuccess;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function()? paginationLoading,
    T Function()? empty,
    T Function(String msg)? failure,
    T Function(int seconds)? blockedFailure,
    T Function()? serverFailure,
    T Function()? networkFailure,
    T Function()? success,
    required T Function() orElse,
  }) {
    if (this is StateStatusInitial && initial != null) return initial();
    if (this is StateStatusLoading && loading != null) return loading();
    if (this is StateStatusPaginationLoading && paginationLoading != null) return paginationLoading();
    if (this is StateStatusEmpty && empty != null) return empty();
    if (this is StateStatusFailure && failure != null) {
      return failure((this as StateStatusFailure).msg);
    }

    if (this is StateStatusServerFailure && serverFailure != null) {
      return serverFailure();
    }
    if (this is StateStatusNetworkFailure && networkFailure != null) {
      return networkFailure();
    }
    if (this is StateStatusSuccess && success != null) return success();
    return orElse();
  }
}

class StateStatusInitial extends StateStatus {
  StateStatusInitial();
}

class StateStatusLoading extends StateStatus {
  StateStatusLoading();
}

class StateStatusPaginationLoading extends StateStatus {
  StateStatusPaginationLoading();
}

class StateStatusEmpty extends StateStatus {
  StateStatusEmpty();
}

class StateStatusFailure extends StateStatus {
  final String msg;

  StateStatusFailure(this.msg);
}

class StateStatusServerFailure extends StateStatus {
  StateStatusServerFailure();
}

class StateStatusNetworkFailure extends StateStatus {
  StateStatusNetworkFailure();
}

class StateStatusSuccess extends StateStatus {
  StateStatusSuccess();
}
