part of 'my_order_bloc.dart';

@freezed
class MyOrderEvent with _$MyOrderEvent {
  const factory MyOrderEvent.fetch() = _Fetch;
}
