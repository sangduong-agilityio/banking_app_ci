import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/order_history/states/order_history_event.dart';
import 'package:tradly_app/features/order_history/states/order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvt, OrderHistoryState> {
  OrderHistoryBloc() : super(const OrderHistoryState()) {
    on<AddProductToOrderHistoryEvt>(_onAddProduct);
  }

  void _onAddProduct(
    AddProductToOrderHistoryEvt event,
    Emitter<OrderHistoryState> emit,
  ) {
    final updatedProducts = List<ProductModel>.from(state.products);
    updatedProducts.add(event.product);

    emit(
      state.copyWith(products: updatedProducts),
    );
  }
}
