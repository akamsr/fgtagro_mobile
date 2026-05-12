import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/category_item.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/dashboard_dropdown_item.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/flash_sale_banner.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/product_card.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/product_card_wide.dart';
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
  final bool isAuthenticated = false; // Toggle to true to see profile icon
  String? activeCategoryId;
  bool menuOpen = false;
  bool filterOpen = false;
  String activeSort = 'relevance';
  String searchQuery = '';

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
        final double cardW = (MediaQuery.of(context).size.width - 32 - 12) / 2;

        return Scaffold(
          backgroundColor: const Color(0xFFFBF8FD),
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    // ─── HEADER ───
                    Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(251, 248, 253, 0.97),
                        border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.09), width: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(18))), // Logo Placeholder
                          const Spacer(),
                          
                          // Cart Icon
                          BlocBuilder<CartCubit, CartState>(
                            builder: (context, cartState) {
                              final count = cartState.cart?.items.length ?? 0;
                              return InkWell(
                                onTap: () => context.router.push(const CartRoute()),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    const Icon(Icons.shopping_cart_outlined, color: AppColors.secondaryColor, size: 24),
                                    if (count > 0)
                                      Positioned(
                                        top: -5,
                                        right: -5,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                          child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          
                          // Language
                          Container(
                            width: 44, height: 32,
                            decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(36, 44, 88, 0.18), width: 1.5), borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.center,
                            child: const Text('FR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryColor, letterSpacing: 0.8)),
                          ),
                          const SizedBox(width: 8),

                          // Auth Button
                          isAuthenticated
                              ? Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(16)), alignment: Alignment.center, child: const Icon(Icons.person, size: 16, color: Colors.white))
                              : InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 96, height: 32, decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    alignment: Alignment.center, child: const Text('Connexion', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                                  ),
                                ),
                          const SizedBox(width: 8),

                          // Hamburger
                          IconButton(
                            icon: const Icon(Icons.menu, size: 24, color: AppColors.secondaryColor),
                            onPressed: () => setState(() => menuOpen = true),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
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
                              // Location
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                                child: Row(
                                  children: const [
                                    Icon(Icons.location_on, size: 14, color: AppColors.primaryColor),
                                    SizedBox(width: 5),
                                    Expanded(child: Text('Livrer à Douala, Cameroun', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondaryColor))),
                                    Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.secondaryColor),
                                  ],
                                ),
                              ),

                              // Search Bar
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 46,
                                        decoration: BoxDecoration(color: const Color(0xFFF5F3F8), borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.search, size: 18, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Expanded(child: TextField(
                                              onChanged: (v) => setState(() => searchQuery = v),
                                              onSubmitted: (v) {
                                                context.read<ProductCubit>().fetchProducts(search: v);
                                              },
                                              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Rechercher un produit...', hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () => setState(() => filterOpen = true),
                                      child: Container(
                                        width: 46, height: 46, decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: AppColors.secondaryColor.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))]),
                                        alignment: Alignment.center, child: const Icon(Icons.tune, size: 20, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              // Categories Scroll
                              SizedBox(
                                height: 100,
                                child: state.genLoading && state.categories.isEmpty
                                    ? const Center(child: CircularProgressIndicator())
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
                                            },
                                          );
                                        },
                                      ),
                              ),

                              // Promotional Banner
                              const FlashSaleBanner(),

                              // Section Products
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Produits Populaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.secondaryColor)),
                                            Container(width: 32, height: 3, margin: const EdgeInsets.only(top: 4), decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(2))),
                                          ],
                                        ),
                                        const Text('VOIR TOUT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryColor, letterSpacing: 0.5)),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Product Grid
                                    if (state.genLoading && state.products.isEmpty)
                                      const Center(child: CircularProgressIndicator())
                                    else if (state.products.length >= 2)
                                      Row(
                                        children: [
                                          ProductCard(
                                            product: state.products[0],
                                            width: cardW,
                                            categoryStyle: catStyles[state.products[0].category.slug.toLowerCase()] ?? catStyles['promotions']!,
                                          ),
                                          const SizedBox(width: 12),
                                          ProductCard(
                                            product: state.products[1],
                                            width: cardW,
                                            categoryStyle: catStyles[state.products[1].category.slug.toLowerCase()] ?? catStyles['promotions']!,
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 12),
                                    // Featured Section
                                    if (state.featuredProducts.isNotEmpty)
                                      ...state.featuredProducts.take(3).map((p) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: ProductCardWide(
                                          product: p,
                                          categoryStyle: catStyles[p.category.slug.toLowerCase()] ?? catStyles['promotions']!,
                                        ),
                                      )).toList(),
                                  ],
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
              
              // ─── OVERLAYS ───
              if (menuOpen)
                GestureDetector(
                  onTap: () => setState(() => menuOpen = false),
                  child: Container(
                    color: Colors.black.withOpacity(0.18),
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 58 + 4,
                          right: 16,
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DashboardDropdownItem(icon: Icons.grid_view, label: 'Catégories'),
                                DashboardDropdownItem(icon: Icons.chat_bubble_outline, label: 'Messages'),
                                const Divider(height: 8, color: Colors.black12),
                                DashboardDropdownItem(icon: Icons.login, label: 'Se connecter'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              if (filterOpen)
                GestureDetector(
                  onTap: () => setState(() => filterOpen = false),
                  child: Container(
                    color: Colors.black.withOpacity(0.18),
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 58 + 60, // approximate
                          right: 16,
                          child: Container(
                            width: 220,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('TRIER PAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 0.8))),
                                DashboardDropdownItem(icon: Icons.star_outline, label: 'Pertinence', active: activeSort == 'relevance', onTap: () => setState(() { activeSort = 'relevance'; filterOpen = false; })),
                                DashboardDropdownItem(icon: Icons.trending_up, label: 'Prix croissant', active: activeSort == 'price_asc', onTap: () => setState(() { activeSort = 'price_asc'; filterOpen = false; })),
                                DashboardDropdownItem(icon: Icons.trending_down, label: 'Prix décroissant', active: activeSort == 'price_desc', onTap: () => setState(() { activeSort = 'price_desc'; filterOpen = false; })),
                              ],
                            ),
                          ),
                        )
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
