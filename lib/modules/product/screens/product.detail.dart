import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/modules/dashboard/screens/dashboard.home.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/product_card.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.state.dart';
import 'package:fgtagro_mobile/modules/product/widgets/product_hero_action.dart';
import 'package:fgtagro_mobile/modules/favourites/cubit/favourites.cubit.dart';
import 'package:fgtagro_mobile/modules/favourites/cubit/favourites.state.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  int _currentImageIndex = 0;
  late ScrollController _scrollController;
  late AnimationController _floatingBarController;
  late PageController _pageController;
  bool _isFloatingBarVisible = false;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProductById(widget.id);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _pageController = PageController();

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
    _pageController.dispose();
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
                            final inCart =
                                cartState.cart?.items.any(
                                  (i) => i.productId == product.id,
                                ) ??
                                false;
                            return ProductHeroAction(
                              icon: 'assets/icons/cart.svg',
                              onTap: () {
                                if (product.stockQuantity <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Produit en rupture de stock',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                context.read<CartCubit>().toggleCart(product);
                              },
                              // Custom style to show if in cart
                              color: inCart
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              iconColor: inCart
                                  ? Colors.white
                                  : AppColors.secondaryColor,
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
                          // Main Image with PageView
                          Stack(
                            children: [
                              Container(
                                height: 400,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: product.photos.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: PageView.builder(
                                          controller: _pageController,
                                          onPageChanged: (index) => setState(
                                            () => _currentImageIndex = index,
                                          ),
                                          itemCount: product.photos.length,
                                          itemBuilder: (context, index) =>
                                              Image.network(
                                                product.photos[index],
                                                fit: BoxFit.cover,
                                              ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.image,
                                        size: 80,
                                        color: Colors.black12,
                                      ),
                              ),
                              if (product.photos.length > 1)
                                Positioned(
                                  bottom: 16,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: product.photos
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          return Container(
                                            width: 8.0,
                                            height: 8.0,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4.0,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  _currentImageIndex ==
                                                      entry.key
                                                  ? AppColors.primaryColor
                                                  : Colors.white.withOpacity(
                                                      0.5,
                                                    ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Interactive Thumbnails
                          if (product.photos.length > 1)
                            SizedBox(
                              height: 70,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: product.photos.length,
                                itemBuilder: (context, index) {
                                  final isSelected =
                                      _currentImageIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primaryColor
                                              : Colors.grey.withOpacity(0.1),
                                          width: isSelected ? 2 : 1,
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            product.photos[index],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 20),

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
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Seller Profile Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.primaryTint
                                      .withOpacity(0.3),
                                  child: const Icon(
                                    Icons.storefront,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.seller.businessName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: AppColors.secondaryColor,
                                        ),
                                      ),
                                      const Text(
                                        'Vendeur Vérifié',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primaryColor,
                                    side: const BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Voir boutique'),
                                ),
                              ],
                            ),
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
                          GestureDetector(
                            onTap: () => setState(
                              () => _isDescriptionExpanded =
                                  !_isDescriptionExpanded,
                            ),
                            child: RichText(
                              maxLines: _isDescriptionExpanded ? null : 3,
                              overflow: _isDescriptionExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                                children: [
                                  TextSpan(text: product.description),
                                  if (!_isDescriptionExpanded)
                                    const TextSpan(
                                      text: ' ... Lire plus',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          const SizedBox(height: 32),

                          // Add Review Section
                          const Text(
                            'Add a Review',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Share your experience...',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Similar Products
                          _HorizontalProductList(
                            title: 'Similar Products',
                            categoryId: product.category.id,
                          ),
                          const SizedBox(height: 24),

                          // Recommended Products
                          const _HorizontalProductList(
                            title: 'Recommended for you',
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
                bottom: 10 + bottomPadding,
                left: 16,
                right: 16,
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
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Total Price Info
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${product.unitPrice} FCFA',
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Add to Cart Button
                          BlocBuilder<CartCubit, CartState>(
                            builder: (context, cartState) {
                              final inCart =
                                  cartState.cart?.items.any(
                                    (i) => i.productId == product.id,
                                  ) ??
                                  false;
                              return ElevatedButton.icon(
                                onPressed: () {
                                  if (product.stockQuantity <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Produit en rupture de stock',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  context.read<CartCubit>().toggleCart(product);
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/cart.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    inCart
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                label: Text(
                                  inCart ? 'Retirer' : 'Ajouter',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: inCart
                                      ? AppColors.primaryTint.withOpacity(0.3)
                                      : AppColors.primaryColor,
                                  foregroundColor: inCart
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),

                          // Favorite Action
                          BlocBuilder<FavouritesCubit, FavouritesState>(
                            builder: (context, favState) {
                              final isFav = favState.isFavourite(product.id);
                              return _FloatingActionButton(
                                icon: isFav
                                    ? 'assets/icons/favourite.svg'
                                    : 'assets/icons/heart-outlined.svg',
                                color: AppColors.primaryTint.withOpacity(0.3),
                                iconColor: isFav
                                    ? AppColors.primaryColor
                                    : AppColors.secondaryColor,
                                border: false,
                                onTap: () => context
                                    .read<FavouritesCubit>()
                                    .toggleFavourite(product),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 250),
            ],
          ),
        );
      },
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final String? categoryId;

  const _HorizontalProductList({required this.title, this.categoryId});

  @override
  Widget build(BuildContext context) {
    final double cardW = (MediaQuery.of(context).size.width - 48) / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.router.push(
                ProductListRoute(title: title, categoryId: categoryId),
              ),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            var products = state.products;
            if (categoryId != null) {
              products = products.where((p) => p.category.id == categoryId).toList();
            }
            products = products.take(5).toList();

            return Container(
              height: 260,
              color: AppColors.bgCanvas,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: products[index],
                    width: cardW,
                    categoryStyle:
                        catStyles[products[index].category.slug
                            .toLowerCase()] ??
                        catStyles['promotions']!,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  final dynamic icon;
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
        child: icon is String
            ? SvgPicture.asset(
                icon as String,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              )
            : Icon(icon as IconData, color: iconColor, size: 20),
      ),
    );
  }
}
