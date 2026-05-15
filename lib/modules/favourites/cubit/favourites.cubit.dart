import 'dart:convert';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'favourites.state.dart';

class FavouritesCubit extends Cubit<FavouritesState> {
  static const _boxName = 'settings';
  static const _favKey = 'favourites';

  FavouritesCubit() : super(const FavouritesState()) {
    _loadFavourites();
  }

  void _loadFavourites() {
    final box = Hive.box(_boxName);
    final raw = box.get(_favKey);
    if (raw != null) {
      try {
        final List<dynamic> decoded = json.decode(raw as String);
        final items = decoded.map((p) => ProductModel.fromJson(p)).toList();
        emit(state.copyWith(items: items));
      } catch (_) {
        // Handle error or empty
      }
    }
  }

  void toggleFavourite(ProductModel product) {
    final items = List<ProductModel>.from(state.items);
    final exists = items.any((p) => p.id == product.id);

    if (exists) {
      items.removeWhere((p) => p.id == product.id);
    } else {
      items.add(product);
    }

    emit(state.copyWith(items: items));
    _saveFavourites(items);
  }

  void _saveFavourites(List<ProductModel> items) {
    final box = Hive.box(_boxName);
    final encoded = json.encode(items.map((p) => p.toJson()).toList());
    box.put(_favKey, encoded);
  }
}
