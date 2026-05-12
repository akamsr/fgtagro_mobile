import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/category_item.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/flash_sale_banner.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/product_card.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.state.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String activeFilter = 'Featured';

  final List<String> filters = ['Featured', 'New & Popular', 'Snacks', 'Offers'];

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
                // ─── TOP NAVIGATION ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Logo
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

                      // Language Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderStrong),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              'FR',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Favorite Icon
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.favorite_border,
                          color: AppColors.textPrimary,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Cart Icon
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          final count = cartState.cart?.items.length ?? 0;
                          return InkWell(
                            onTap: () => context.router.push(const CartRoute()),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: AppColors.textPrimary,
                                  size: 26,
                                ),
                                if (count > 0)
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                          minWidth: 16, minHeight: 16),
                                      child: Text(
                                        '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
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

                // ─── SCROLLABLE CONTENT ───
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
                          // Search Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.bgSubtle,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (v) => setState(() => searchQuery = v),
                                      onSubmitted: (v) {
                                        context.read<ProductCubit>().fetchProducts(search: v);
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Rechercher un produit...',
                                        hintStyle: TextStyle(color: AppColors.textPlaceholder, fontSize: 14),
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
                                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, index) {
                                      final cat = state.categories[index];
                                      bool active = activeCategoryId == cat.id;
                                      final style = catStyles[cat.slug.toLowerCase()] ?? catStyles['promotions']!;
                                      
                                      return CategoryItem(
                                        category: cat,
                                        active: active,
                                        style: style,
                                        onTap: () {
                                          setState(() => activeCategoryId = cat.id);
                                          // Implement filtering by category if needed
                                        },
                                      );
                                    },
                                  ),
                          ),

                          // Latest Products
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              'Nouveautés de la semaine',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          
                          SizedBox(
                            height: 240,
                            child: state.genLoading && state.featuredProducts.isEmpty
                                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: state.featuredProducts.length,
                                    itemBuilder: (context, index) {
                                      final p = state.featuredProducts[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 12.0),
                                        child: ProductCard(
                                          product: p,
                                          width: cardW,
                                          categoryStyle: catStyles[p.category.slug.toLowerCase()] ?? catStyles['promotions']!,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 16),

                          // Promotional Banner
                          const FlashSaleBanner(),
                          const SizedBox(height: 20),

                          // Best offer for you
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Meilleures offres pour vous',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Filter Chips
                          SizedBox(
                            height: 36,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: filters.length,
                              itemBuilder: (context, index) {
                                final filter = filters[index];
                                final isActive = activeFilter == filter;
                                return GestureDetector(
                                  onTap: () => setState(() => activeFilter = filter),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isActive ? AppColors.primaryColor : AppColors.bgSubtle,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                        color: isActive ? Colors.white : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Filtered Products Grid
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: state.genLoading && state.products.isEmpty
                                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                                : GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemCount: state.products.length,
                                    itemBuilder: (context, index) {
                                      final p = state.products[index];
                                      return ProductCard(
                                        product: p,
                                        width: cardW,
                                        categoryStyle: catStyles[p.category.slug.toLowerCase()] ?? catStyles['promotions']!,
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 24),
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

