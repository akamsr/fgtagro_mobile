import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.state.dart';
import 'package:fgtagro_mobile/modules/product/widgets/product_hero_action.dart';
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

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int qty = 1;
  String selectedSize = 'M';
  late ScrollController _scrollController;
  late AnimationController _floatingBarController;
  bool _isFloatingBarVisible = false;

  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProductById(widget.id);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _floatingBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _floatingBarController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final threshold = _scrollController.position.maxScrollExtent * 0.15;
      final shouldShow = _scrollController.offset > threshold;

      if (shouldShow != _isFloatingBarVisible) {
        setState(() {
          _isFloatingBarVisible = shouldShow;
          if (_isFloatingBarVisible) {
            _floatingBarController.forward();
          } else {
            _floatingBarController.reverse();
          }
        });
      }
    }
  }

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
            body: const Center(child: Text("Product not found")),
          );
        }

        final imageUri = product.photos.isNotEmpty ? product.photos[0] : null;
        final bottomPadding = MediaQuery.of(context).padding.bottom;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App Bar
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProductHeroAction(
                        icon: Icons.arrow_back,
                        onTap: () => context.router.pop(),
                      ),
                    ),
                    centerTitle: true,
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<CartCubit, CartState>(
                          builder: (context, cartState) {
                            final totalItems = cartState.cart?.totalItems ?? 0;
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ProductHeroAction(
                                  icon: Icons.shopping_cart,
                                  onTap: () =>
                                      context.router.push(const CartRoute()),
                                ),
                                if (totalItems > 0)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        '$totalItems',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          // Main Image
                          Container(
                            height: 400,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(24),
                              image: imageUri != null
                                  ? DecorationImage(
                                      image: NetworkImage(imageUri),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: imageUri == null
                                ? const Icon(
                                    Icons.image,
                                    size: 80,
                                    color: Colors.black12,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 12),
                          // Thumbnails
                          SliverToBoxAdapterThumbnails(product: product),
                          const SizedBox(height: 10),

                          // Product Info
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.category.name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '4.9',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(1283 Reviews)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${product.unitPrice} FCFA',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Size Selector
                          const Text(
                            'Size',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: sizes.map((size) {
                              final isSelected = selectedSize == size;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => selectedSize = size),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : Colors.grey.withOpacity(0.3),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Description
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(text: product.description),
                                const TextSpan(
                                  text: ' Read more...',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Reviews Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Review (1283)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('See More'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Single Review Preview
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFF5F5F5),
                                child: Icon(Icons.person, color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Alexa Walters',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Great quality and fit. Highly recommend!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 120), // Bottom space for bar
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Floating Bottom Bar
              Positioned(
                bottom: 5 + bottomPadding,
                left: 20,
                right: 20,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 1.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _floatingBarController,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: FadeTransition(
                    opacity: _floatingBarController,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Review Input Section (Stacked Column)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Type review...',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.send_rounded,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Action Buttons
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                _FloatingActionButton(
                                  icon: Icons.shopping_cart_outlined,
                                  color: const Color(0xFF1E1E1E),
                                  onTap: () {
                                    if (product.stockQuantity <= 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('This product is currently out of stock.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<CartCubit>().addToCart(
                                      product,
                                      qty: qty,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} added to cart'),
                                        backgroundColor: AppColors.primaryColor,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                _FloatingActionButton(
                                  icon: Icons.favorite_border,
                                  color: Colors.white,
                                  iconColor: AppColors.textPrimary,
                                  border: true,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 150),
            ],
          ),
        );
      },
    );
  }
}

class SliverToBoxAdapterThumbnails extends StatelessWidget {
  const SliverToBoxAdapterThumbnails({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    if (product.photos.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: product.photos.map<Widget>((photo) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
              image: DecorationImage(
                image: NetworkImage(photo),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final bool border;
  final VoidCallback onTap;

  const _FloatingActionButton({
    required this.icon,
    required this.color,
    this.iconColor = Colors.white,
    this.border = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border
              ? Border.all(color: Colors.grey.withOpacity(0.3))
              : null,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
