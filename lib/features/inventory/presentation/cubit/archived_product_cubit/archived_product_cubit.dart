import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'archived_product_state.dart';

class ArchivedProductCubit extends Cubit<ArchivedProductState> {
  ArchivedProductCubit() : super(ArchivedProductInitial());
}
