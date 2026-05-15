import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
import 'package:fgtagro_mobile/models/seller.dart';
import 'package:fgtagro_mobile/modules/business/widgets/kpi_card.dart';
import 'package:fgtagro_mobile/modules/business/widgets/pending_action_tile.dart';
import 'package:fgtagro_mobile/modules/business/widgets/revenue_chart.dart';
import 'package:fgtagro_mobile/modules/business/widgets/product_mini_card.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.state.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BusinessCubit>().fetchProfile();
    context.read<BusinessCubit>().fetchStores();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, state) {
        final seller = state.profile;
        final String businessName = seller?.businessName ?? 'Chargement...';
        final String trustLevel = seller?.trustLevel.toUpperCase() ?? 'NEW';

        final isSeller = state.appMode == AppMode.seller;

        return Scaffold(
          backgroundColor: AppColors.bgCanvas,
          floatingActionButton: isSeller
              ? FloatingActionButton.extended(
                  onPressed: () =>
                      context.router.push(const ProductPublicationRoute()),
                  backgroundColor: AppColors.primaryColor,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          body: CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryTint.withOpacity(
                            0.3,
                          ),
                          child: const Icon(
                            Icons.storefront,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                businessName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '$trustLevel PARTNER',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB8860B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.secondaryColor,
                              ),
                              onPressed: () {},
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KPI Row
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Aujourd'hui",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          clipBehavior: Clip.none,
                          children: [
                            BusinessKPICard(
                              label: "Ventes Totales",
                              value: seller?.totalSales.toString() ?? "0",
                              icon: Icons.shopping_bag_outlined,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 16),
                            BusinessKPICard(
                              label: "Note Moyenne",
                              value:
                                  seller?.averageRating.toStringAsFixed(1) ??
                                  "0.0",
                              icon: Icons.star_outline_rounded,
                              color: const Color(0xFF10b981),
                            ),
                            const SizedBox(width: 16),
                            BusinessKPICard(
                              label: "Avis Clients",
                              value: seller?.totalReviews.toString() ?? "0",
                              icon: Icons.rate_review_outlined,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 16),
                            BlocBuilder<ProductCubit, ProductState>(
                              builder: (context, pState) => BusinessKPICard(
                                label: "Produits Actifs",
                                value: pState.products.length.toString(),
                                icon: Icons.inventory_2_outlined,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Pending Actions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Actions en attente",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            PendingActionTile(
                              title: "3 Commandes à préparer",
                              subtitle:
                                  "Date limite de préparation : Aujourd'hui",
                              actionLabel: "Voir tout",
                              icon: Icons.inventory_2,
                              onTap: () {},
                            ),
                            PendingActionTile(
                              title: "Produit refusé",
                              subtitle:
                                  "Engrais NPK 15-15-15 nécessite correction",
                              actionLabel: "Corriger",
                              icon: Icons.warning_amber_rounded,
                              color: Colors.redAccent,
                              onTap: () {},
                            ),
                            PendingActionTile(
                              title: "Stock faible",
                              subtitle: "Semences de Maïs (2 unités restantes)",
                              actionLabel: "Réapprov.",
                              icon: Icons.low_priority_rounded,
                              color: Colors.orange,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Revenue Chart
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Performance Revenus",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: '30 jours',
                                  underline: const SizedBox(),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                  items: ['7 jours', '30 jours', '3 mois']
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const RevenueChart(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Top Products
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          "Top Produits (Ce mois)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, productState) {
                          final products = productState.products
                              .take(5)
                              .toList();
                          if (products.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return SizedBox(
                            height: 85,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) => ProductMiniCard(
                                product: products[index],
                                unitsSold: 120 - (index * 15),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),
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
