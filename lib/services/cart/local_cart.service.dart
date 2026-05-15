import 'dart:convert';
import 'package:fgtagro_mobile/models/cart.dart';
import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:hive_ce/hive.dart';

/// Local cart service – stores cart data in Hive.
/// Used until the backend cart API endpoint is implemented.
class LocalCartService {
  static const _boxName = 'settings';
  static const _cartKey = 'local_cart';

  Box get _box => Hive.box(_boxName);

  // ── Read ──────────────────────────────────────────────────────────────────

  Cart getCart() {
    final raw = _box.get(_cartKey);
    if (raw == null) return _emptyCart();
    try {
      final map = json.decode(raw as String) as Map<String, dynamic>;
      return Cart.fromMap(map);
    } catch (_) {
      return _emptyCart();
    }
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  Cart addItem(ProductModel product, {int qty = 1}) {
    final cart = getCart();
    final items = List<CartItem>.from(cart.items);

    final existingIndex =
        items.indexWhere((i) => i.productId == product.id);

    if (existingIndex >= 0) {
      final existing = items[existingIndex];
      final newQty =
          (existing.qty + qty).clamp(1, product.stockQuantity).toInt();
      items[existingIndex] = existing.copyWith(qty: newQty);
    } else {
      items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch,
        productId: product.id,
        qty: qty.clamp(1, product.stockQuantity).toInt(),
        businessId: int.tryParse(product.seller.id) ?? 0,
        originalPrice: product.unitPrice,
        finalPrice: product.unitPrice,
        productName: product.name,
        productPhoto: product.photos.isNotEmpty ? product.photos.first : null,
        sellerName: product.seller.businessName,
        sellerCity: null,
        availableStock: product.stockQuantity,
        unit: product.unitOfSale,
      ));
    }

    return _saveAndReturn(items);
  }

  Cart removeItem(int cartItemId) {
    final cart = getCart();
    final items = cart.items.where((i) => i.id != cartItemId).toList();
    return _saveAndReturn(items);
  }

  Cart updateQty(int cartItemId, int qty) {
    if (qty <= 0) return removeItem(cartItemId);
    final cart = getCart();
    final items = cart.items.map((i) {
      if (i.id == cartItemId) {
        return i.copyWith(qty: qty.clamp(1, i.availableStock).toInt());
      }
      return i;
    }).toList();
    return _saveAndReturn(items);
  }

  Cart clearCart() {
    _box.delete(_cartKey);
    return _emptyCart();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Cart _saveAndReturn(List<CartItem> items) {
    final totalItems = items.fold<int>(0, (s, i) => s + i.qty);
    final subTotal =
        items.fold<double>(0, (s, i) => s + i.finalPrice * i.qty);

    final updatedCart = Cart(
      id: 1,
      items: items,
      totalItems: totalItems,
      subTotal: subTotal,
      grandTotal: subTotal,
      reservedAt: DateTime.now().toIso8601String(),
      expiresAt:
          DateTime.now().add(const Duration(minutes: 15)).toIso8601String(),
    );

    _box.put(_cartKey, json.encode(updatedCart.toJson()));
    return updatedCart;
  }

  Cart _emptyCart() => Cart(id: 1);
}
