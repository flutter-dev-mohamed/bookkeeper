import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) {
      OPrint.m(event.toString());
    });

    on<CreateOrderEvent>(_onCreateOrderEvent);
  }

  void _onCreateOrderEvent(
    CreateOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {}
}
