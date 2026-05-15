import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/dashboard/screens/dashboard.home.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/product_card.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductListScreen extends StatefulWidget {
  final String title;
  final String? categoryId;

  const ProductListScreen({
    super.key,
    this.title = 'Catalogue Produits',
    this.categoryId,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch if products are empty to avoid redundant calls
    if (context.read<ProductCubit>().state.products.isEmpty) {
      context.read<ProductCubit>().fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state.genLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          var displayedProducts = state.products;

          // Filter by category if categoryId is provided (Similar Products)
          if (widget.categoryId != null) {
            displayedProducts = displayedProducts
                .where((p) => p.category.id == widget.categoryId)
                .toList();
          }

          if (displayedProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.black12,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun produit trouvé',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final double cardW = (MediaQuery.of(context).size.width - 48) / 2;

          return RefreshIndicator(
            onRefresh: () => context.read<ProductCubit>().fetchProducts(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 0.7,
              ),
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                final product = displayedProducts[index];
                return ProductCard(
                  product: product,
                  width: cardW,
                  categoryStyle:
                      catStyles[product.category.slug.toLowerCase()] ??
                      catStyles['promotions']!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
