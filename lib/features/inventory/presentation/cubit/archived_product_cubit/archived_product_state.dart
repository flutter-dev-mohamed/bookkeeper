part of 'archived_product_cubit.dart';

@immutable
sealed class ArchivedProductState {}

final class ArchivedProductInitial extends ArchivedProductState {}

final class ArchivedProductFailure extends ArchivedProductState {}

final class GotArchivedProductDetails extends ArchivedProductState {}
