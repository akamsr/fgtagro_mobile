import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/modules/favourites/cubit/favourites.cubit.dart';
import 'package:fgtagro_mobile/modules/favourites/cubit/favourites.state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final double width;
  final Map<String, dynamic> categoryStyle;

  const ProductCard({
    super.key,
    required this.product,
    required this.width,
    required this.categoryStyle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late AnimationController _cartController;
  late AnimationController _favController;

  @override
  void initState() {
    super.initState();
    _cartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _favController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _cartController.dispose();
    _favController.dispose();
    super.dispose();
  }

  void _toggleCart() {
    if (widget.product.stockQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This product is currently out of stock.'),
        ),
      );
      return;
    }

    context.read<CartCubit>().toggleCart(widget.product);
  }

  void _toggleFavorite() {
    context.read<FavouritesCubit>().toggleFavourite(widget.product);
    _favController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return InkWell(
      onTap: () =>
          context.router.push(ProductDetailRoute(id: widget.product.id)),
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                Hero(
                  tag: 'product_${widget.product.id}',
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color:
                          widget.categoryStyle['bg'] as Color? ??
                          const Color(0xFFF5F3F8),
                      borderRadius: BorderRadius.circular(24),
                      image: widget.product.photos.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(widget.product.photos[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: widget.product.photos.isEmpty
                        ? Icon(
                            widget.categoryStyle['icon'] as IconData? ??
                                Icons.inventory_2,
                            size: 52,
                            color: Colors.black12,
                          )
                        : null,
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: BlocBuilder<FavouritesCubit, FavouritesState>(
                    builder: (context, state) {
                      final isFav = state.isFavourite(widget.product.id);
                      return GestureDetector(
                        onTap: _toggleFavorite,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                            CurvedAnimation(
                              parent: _favController,
                              curve: const Interval(
                                0.0,
                                0.5,
                                curve: Curves.elasticOut,
                              ),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/favourite.svg',
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                isFav
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade400,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  bottom: 5,
                  left: 15,
                  child: Text(
                    '${widget.product.unitPrice} FCFA',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPlaceholder,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.product.seller.businessName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                final inCart =
                    cartState.cart?.items.any(
                      (i) => i.productId == widget.product.id,
                    ) ??
                    false;

                if (inCart) {
                  _cartController.forward();
                } else {
                  _cartController.reverse();
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _toggleCart,
                        child: AnimatedBuilder(
                          animation: _cartController,
                          builder: (context, child) {
                            final t = _cartController.value;

                            final baseWidth = 100.0 - (100.0 - 32.0) * t;

                            return Container(
                              width: baseWidth,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color.lerp(
                                  AppColors.secondaryColor,
                                  AppColors.primaryColor,
                                  t,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (t < 0.5)
                                    Opacity(
                                      opacity: (1 - t * 2).clamp(0.0, 1.0),
                                      child: Text(
                                        s.addToCart,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (t > 0.5)
                                    Opacity(
                                      opacity: (t * 2 - 1).clamp(0.0, 1.0),
                                      child: SvgPicture.asset(
                                        'assets/icons/cart.svg',
                                        width: 16,
                                        height: 16,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
