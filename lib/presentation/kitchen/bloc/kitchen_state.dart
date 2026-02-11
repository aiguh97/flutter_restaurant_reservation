part of 'kitchen_bloc.dart';

@freezed
class KitchenState with _$KitchenState {
  const factory KitchenState.loading() = _Loading;
  const factory KitchenState.loaded(List<KitchenOrder> orders) = _Loaded;
  const factory KitchenState.error(String message) = _Error;
}
