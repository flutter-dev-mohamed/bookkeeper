import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_client_orders.dart';

part 'client_orders_state.dart';

class ClientOrdersCubit extends Cubit<ClientOrdersState> {
  final GetClientOrders _getClientOrders;
  final int clientId;

  ClientOrdersCubit({required this._getClientOrders, required this.clientId})
    : super(ClientOrdersInitial()) {
    getClientOrders();
  }

  void getClientOrders() async {
    emit(ClientOrdersLoading());

    final res = await _getClientOrders(clientId);

    res.fold(
      (error) => emit(ClientOrdersFailure(message: error.message)),
      (orders) => emit(GotClientOrders(orders: orders)),
    );
  }
}
