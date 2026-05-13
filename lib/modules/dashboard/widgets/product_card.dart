import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

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
  bool _inCart = false;
  bool _isFavorite = false;

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
    setState(() => _inCart = !_inCart);
    if (_inCart) {
      _cartController.forward();
    } else {
      _cartController.reverse();
    }
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    if (_isFavorite) {
      _favController.forward(from: 0.0);
    } else {
      _favController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return InkWell(
      onTap: () =>
          context.router.push(ProductDetailRoute(id: widget.product.id)),
      child: Container(
        width: widget.width,
        padding: EdgeInsets.all(5),
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
                  child: GestureDetector(
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
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedBuilder(
                          animation: _favController,
                          builder: (context, child) {
                            return Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 23,
                              color: Color.lerp(
                                AppColors.textPlaceholder,
                                AppColors.primaryColor,
                                _favController.value,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.product.seller.businessName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),

                // const SizedBox(height: 10),
              ],
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _toggleCart,
                  child: AnimatedBuilder(
                    animation: _cartController,
                    builder: (context, child) {
                      final t = _cartController.value;
                      double stretchFactor = 1.0;
                      if (t > 0.1 && t < 0.9) {
                        stretchFactor = 1.15 - (t - 0.5).abs() * 0.3;
                      }

                      final baseWidth = 110.0 - (110.0 - 44.0) * t;
                      final stretchWidth = (baseWidth * stretchFactor).clamp(
                        44.0,
                        150.0,
                      );

                      return Container(
                        width: stretchWidth,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            AppColors.secondaryPressed,
                            AppColors.primaryColor,
                            t,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Text Label (fades out)
                            Opacity(
                              opacity: (1 - t * 2).clamp(0.0, 1.0),
                              child: Transform.scale(
                                scale: (1 - t),
                                child: Text(
                                  s.addToCart,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            // Cart Icon (fades in)
                            Opacity(
                              opacity: (t * 2 - 1).clamp(0.0, 1.0),
                              child: Transform.scale(
                                scale: t,
                                child: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 20,
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
          ],
        ),
      ),
    );
  }
}
