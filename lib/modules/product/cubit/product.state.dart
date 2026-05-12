import 'package:fgtagro_mobile/models/category.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/global_app_state.dart';

class ProductState extends GlobalAppState {
  final bool genLoading;
  final GlobalErrorData? genError;
  final bool showError;
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final List<ProductModel> featuredProducts;
  final ProductModel? selectedProduct;

  ProductState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.categories = const [],
    this.products = const [],
    this.featuredProducts = const [],
    this.selectedProduct,
  });

  ProductState copyWith({
    bool? genLoading,
    GlobalErrorData? genError,
    bool? showError,
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    List<ProductModel>? featuredProducts,
    ProductModel? selectedProduct,
  }) {
    return ProductState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError,
      showError: showError ?? this.showError,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }

  @override
  List<Object?> get extraprops => [
        genLoading,
        genError,
        showError,
        categories,
        products,
        featuredProducts,
        selectedProduct,
      ];
}
