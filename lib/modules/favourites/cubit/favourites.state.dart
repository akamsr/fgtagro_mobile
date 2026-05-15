import 'package:equatable/equatable.dart';
import 'package:fgtagro_mobile/models/product.dart';

class FavouritesState extends Equatable {
  final List<ProductModel> items;
  final bool isLoading;

  const FavouritesState({
    this.items = const [],
    this.isLoading = false,
  });

  bool isFavourite(String productId) => items.any((p) => p.id == productId);

  FavouritesState copyWith({
    List<ProductModel>? items,
    bool? isLoading,
  }) {
    return FavouritesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, isLoading];
}
