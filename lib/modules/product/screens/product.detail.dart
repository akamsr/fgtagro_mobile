import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.state.dart';
import 'package:fgtagro_mobile/modules/product/widgets/product_feature_card.dart';
import 'package:fgtagro_mobile/modules/product/widgets/product_hero_action.dart';
import 'package:fgtagro_mobile/modules/product/widgets/quantity_selector.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductDetailScreen extends StatefulWidget {
  final String id;
  const ProductDetailScreen({Key? key, @PathParam('id') required this.id})
    : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int qty = 1;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProductById(widget.id);
  }

  final Map<String, Color> _catBg = {
    'engrais': const Color(0xFFFFF8E7),
    'semences': const Color(0xFFFFF0F0),
    'pesticides': const Color(0xFFF0FFF0),
    'outils': const Color(0xFFEFF6FF),
    'riz': const Color(0xFFFFFBEB),
    'sucre': const Color(0xFFFDE8E8),
    'tracteurs': const Color(0xFFE8F4FD),
    'promotions': const Color(0xFFFFF8E7),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state.genLoading && state.selectedProduct == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final product = state.selectedProduct;

        if (product == null) {
          return Scaffold(
            appBar: AppBar(leading: const BackButton()),
            body: const Center(child: Text("Produit introuvable")),
          );
        }

        final bgColor =
            _catBg[product.category.slug.toLowerCase()] ??
            const Color(0xFFF5F5F5);
        final imageUri = product.photos.isNotEmpty ? product.photos[0] : null;

        final features = [
          {
            'icon': Icons.local_offer_outlined,
            'label': 'Unité de vente',
            'value': product.unitOfSale,
          },
          {
            'icon': Icons.layers_outlined,
            'label': 'Catégorie',
            'value': product.category.name,
          },
          {
            'icon': Icons.inventory_2_outlined,
            'label': 'Stock',
            'value': '${product.stockQuantity} unités',
          },
          {
            'icon': Icons.verified_user_outlined,
            'label': 'Vendeur',
            'value': 'Vérifié ✓',
          },
        ];

        final bottomPadding = MediaQuery.of(context).padding.bottom;
        final featureWidth = (MediaQuery.of(context).size.width - 40 - 12) / 2;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    // Hero
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width,
                      color: bgColor,
                      child: Stack(
                        children: [
                          if (imageUri != null)
                            Positioned.fill(
                              child: Image.network(imageUri, fit: BoxFit.cover),
                            )
                          else
                            const Center(
                              child: Icon(
                                Icons.eco_outlined,
                                size: 80,
                                color: Colors.black12,
                              ),
                            ),

                          SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductHeroAction(
                                    icon: Icons.arrow_back,
                                    onTap: () => context.router.pop(),
                                  ),
                                  Row(
                                    children: [
                                      ProductHeroAction(
                                        icon: Icons.share_outlined,
                                        onTap: () {},
                                      ),
                                      const SizedBox(width: 4),
                                      ProductHeroAction(
                                        icon: Icons.shopping_cart_outlined,
                                        onTap: () => context.router.push(
                                          const CartRoute(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.secondaryColor,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${product.unitPrice} ',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.secondaryColor,
                                  letterSpacing: -1,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  'FCFA',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Bento grid
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: features.map((f) {
                              return ProductFeatureCard(
                                icon: f['icon'] as IconData,
                                label: f['label'] as String,
                                value: f['value'] as String,
                                width: featureWidth,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Quantity
                          QuantitySelector(
                            quantity: qty,
                            onIncrement: () => setState(
                              () => qty = min(product.stockQuantity, qty + 1),
                            ),
                            onDecrement: () =>
                                setState(() => qty = max(1, qty - 1)),
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    max(bottomPadding, 16.0),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color.fromRGBO(36, 44, 88, 0.08)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<CartCubit>().addToCart(
                              product.id,
                              qty: qty,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ajouté au panier !'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: const BorderSide(
                              color: AppColors.secondaryColor,
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'Panier',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<CartCubit>().addToCart(
                              product.id,
                              qty: qty,
                            );
                            context.router.push(const CartRoute());
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            backgroundColor: AppColors.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Acheter maintenant',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
