import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/services/products/product.services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product.state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService productService;

  ProductCubit({ProductService? productService})
      : productService = productService ?? ProductService(),
        super(ProductState());

  void emitLoading() {
    emit(state.copyWith(genLoading: true, genError: null, showError: false));
  }

  void emitLoaded() {
    emit(state.copyWith(genLoading: false));
  }

  void emitError(dynamic e, StackTrace s) {
    emit(
      state.copyWith(
        genLoading: false,
        genError: ErrorMapper.map(e, s),
        showError: true,
      ),
    );
  }

  Future<void> fetchCategories() async {
    emitLoading();
    try {
      final categories = await productService.getCategories();
      emit(state.copyWith(
        genLoading: false, 
        categories: categories, 
        genError: null, 
        showError: false,
      ));
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> fetchFeaturedProducts() async {
    emitLoading();
    try {
      final products = await productService.getFeaturedProducts();
      emit(state.copyWith(
        genLoading: false, 
        featuredProducts: products, 
        genError: null, 
        showError: false,
      ));
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> fetchProducts({int page = 1, int limit = 20, String? search}) async {
    emitLoading();
    try {
      final result = await productService.getPublishedProducts(
        page: page,
        limit: limit,
        search: search,
      );
      emit(state.copyWith(
        genLoading: false,
        products: result['products'],
        genError: null,
        showError: false,
      ));
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> fetchProductById(String id) async {
    emitLoading();
    try {
      final product = await productService.getProductById(id);
      emit(state.copyWith(
        genLoading: false,
        selectedProduct: product,
        genError: null,
        showError: false,
      ));
    } catch (e, s) {
      emitError(e, s);
    }
  }
}
