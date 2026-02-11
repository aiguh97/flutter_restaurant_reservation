part of 'kitchen_bloc.dart';

@freezed
class KitchenEvent with _$KitchenEvent {
  const factory KitchenEvent.fetch() = _Fetch;
  const factory KitchenEvent.updateStatus(int orderId, String status) =
      _UpdateStatus;
}
