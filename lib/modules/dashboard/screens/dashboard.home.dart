import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/category_item.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/flash_sale_banner.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/product_card.dart';
import 'package:fgtagro_mobile/modules/favourites/cubit/favourites.cubit.dart';
import 'package:fgtagro_mobile/modules/favourites/cubit/favourites.state.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.state.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:fgtagro_mobile/modules/notifications/cubit/notification.cubit.dart';

const catStyles = {
  'engrais': {'bg': Color(0xFFFFF8E7), 'icon': Icons.eco},
  'riz': {'bg': Color(0xFFFFFBEB), 'icon': Icons.restaurant_menu},
  'tracteurs': {'bg': Color(0xFFE8F4FD), 'icon': Icons.directions_car},
  'semences': {'bg': Color(0xFFFFF0F0), 'icon': Icons.local_florist},
  'pesticides': {'bg': Color(0xFFF0FFF0), 'icon': Icons.science},
  'outils': {'bg': Color(0xFFEFF6FF), 'icon': Icons.build},
  'sucre': {'bg': Color(0xFFFDE8E8), 'icon': Icons.inventory_2},
  'promotions': {'bg': Color(0xFFFFF8E7), 'icon': Icons.local_offer},
};

@RoutePage()
class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({Key? key}) : super(key: key);

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  String? activeCategoryId;
  String searchQuery = '';
  String activeFilter = '';

  @override
  void initState() {
    super.initState();
    final productCubit = context.read<ProductCubit>();
    productCubit.fetchCategories();
    productCubit.fetchFeaturedProducts();
    productCubit.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final double cardW = (MediaQuery.of(context).size.width - 48) / 2;

        return Scaffold(
          backgroundColor: AppColors.bgCanvas,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/icons/logo.jpeg',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Spacer(),

                      // Notifications Icon
                      BlocBuilder<NotificationCubit, NotificationState>(
                        builder: (context, state) {
                          final count = state.unreadCount;
                          return _HeaderIcon(
                            icon: 'assets/icons/notification.svg',
                            count: count,
                            onTap: () =>
                                context.router.push(const NotificationsRoute()),
                          );
                        },
                      ),
                      const SizedBox(width: 12),

                      // Favorite Icon
                      BlocBuilder<FavouritesCubit, FavouritesState>(
                        builder: (context, favState) {
                          return _HeaderIcon(
                            icon: 'assets/icons/favourite.svg',
                            count: favState.items.length,
                            onTap: () =>
                                context.router.push(const FavouritesRoute()),
                          );
                        },
                      ),

                      const SizedBox(width: 12),

                      // Cart Icon
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          final count = cartState.cart?.totalItems ?? 0;
                          return _HeaderIcon(
                            icon: 'assets/icons/cart.svg',
                            count: count,
                            onTap: () => context.router.push(const CartRoute()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductCubit>().fetchCategories();
                      context.read<ProductCubit>().fetchFeaturedProducts();
                      context.read<ProductCubit>().fetchProducts();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.bgSubtle,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    size: 20,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (v) =>
                                          setState(() => searchQuery = v),
                                      onSubmitted: (v) {
                                        context
                                            .read<ProductCubit>()
                                            .fetchProducts(search: v);
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: S
                                            .of(context)
                                            .searchProductHint,
                                        hintStyle: const TextStyle(
                                          color: AppColors.textPlaceholder,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Categories Scroll
                          SizedBox(
                            height: 100,
                            child: state.genLoading && state.categories.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, index) {
                                      final cat = state.categories[index];
                                      bool active = activeCategoryId == cat.id;
                                      final style =
                                          catStyles[cat.slug.toLowerCase()] ??
                                          catStyles['promotions']!;

                                      return CategoryItem(
                                        category: cat,
                                        active: active,
                                        style: style,
                                        onTap: () {
                                          setState(
                                            () => activeCategoryId = cat.id,
                                          );
                                          // Implement filtering by category if needed
                                        },
                                      );
                                    },
                                  ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              S.of(context).newsOfTheWeek,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 260,
                            child:
                                state.genLoading &&
                                    state.featuredProducts.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    itemCount: state.featuredProducts.length,
                                    itemBuilder: (context, index) {
                                      final p = state.featuredProducts[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        child: ProductCard(
                                          product: p,
                                          width: cardW,
                                          categoryStyle:
                                              catStyles[p.category.slug
                                                  .toLowerCase()] ??
                                              catStyles['promotions']!,
                                        ),
                                      );
                                    },
                                  ),
                          ),

                          const SizedBox(height: 16),
                          const FlashSaleBanner(),
                          const SizedBox(height: 20),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              S.of(context).bestOffersForYou,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Filter Chips
                          () {
                            final List<String> filters = [
                              S.of(context).featured,
                              S.of(context).newAndPopular,
                              S.of(context).snacks,
                              S.of(context).offers,
                            ];
                            if (activeFilter.isEmpty) {
                              activeFilter = filters[0];
                            }
                            return SizedBox(
                              height: 36,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: filters.length,
                                itemBuilder: (context, index) {
                                  final filter = filters[index];
                                  final isActive = activeFilter == filter;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => activeFilter = filter),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? AppColors.primaryColor
                                            : AppColors.bgSubtle,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        filter,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isActive
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: isActive
                                              ? Colors.white
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }(),
                          const SizedBox(height: 16),

                          // Filtered Products Grid
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: state.genLoading && state.products.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                          childAspectRatio: 0.7,
                                        ),
                                    itemCount: state.products.length,
                                    itemBuilder: (context, index) {
                                      final p = state.products[index];
                                      return ProductCard(
                                        product: p,
                                        width: cardW,
                                        categoryStyle:
                                            catStyles[p.category.slug
                                                .toLowerCase()] ??
                                            catStyles['promotions']!,
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final String icon;
  final int count;
  final VoidCallback onTap;

  const _HeaderIcon({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasData = count > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                hasData ? AppColors.primaryColor : AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            if (hasData)
              Positioned(
                top: 5,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
