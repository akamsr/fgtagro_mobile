import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
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
import 'package:fgtagro_mobile/utils/functions/navigate.dart';

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
        final String businessName =
            seller?.businessName ?? S.of(context).loading;
        final String trustLevel = seller?.trustLevel.toUpperCase() ?? 'NEW';

        final isSeller = state.appMode == AppMode.seller;

        return Scaffold(
          backgroundColor: AppColors.bgCanvas,
          floatingActionButton: isSeller
              ? FloatingActionButton.extended(
                  onPressed: () =>
                      CustomNavigate.push(const ProductPublicationRoute()),
                  backgroundColor: AppColors.primaryColor,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    S.of(context).addProduct,
                    style: const TextStyle(
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
                      // Seller Performance Score
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CircularProgressIndicator(
                                      value: 0.92,
                                      backgroundColor: Colors.grey.shade100,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.green,
                                          ),
                                      strokeWidth: 6,
                                    ),
                                    const Center(
                                      child: Text(
                                        '92',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Excellent Performance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.secondaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Your performance score is based on response times, cancellation rates, and buyer reviews.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // KPI Row
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          S.of(context).today,
                          style: const TextStyle(
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
                              label: S.of(context).totalSales,
                              value: seller?.totalSales.toString() ?? "0",
                              icon: Icons.shopping_bag_outlined,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 16),
                            BusinessKPICard(
                              label: S.of(context).averageRating,
                              value:
                                  seller?.averageRating.toStringAsFixed(1) ??
                                  "0.0",
                              icon: Icons.star_outline_rounded,
                              color: const Color(0xFF10b981),
                            ),
                            const SizedBox(width: 16),
                            BusinessKPICard(
                              label: S.of(context).customerReviews,
                              value: seller?.totalReviews.toString() ?? "0",
                              icon: Icons.rate_review_outlined,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 16),
                            BlocBuilder<ProductCubit, ProductState>(
                              builder: (context, pState) => BusinessKPICard(
                                label: S.of(context).activeProducts,
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
                            Text(
                              S.of(context).pendingActions,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            PendingActionTile(
                              title: S.of(context).ordersToPrepare(3),
                              subtitle: S
                                  .of(context)
                                  .preparationDeadline(S.of(context).today),
                              actionLabel: S.of(context).viewAll,
                              icon: Icons.inventory_2,
                              onTap: () => CustomNavigate.push(
                                const SellerOrderListRoute(),
                              ),
                            ),
                            PendingActionTile(
                              title: '2 New Rental Requests',
                              subtitle: 'Requires immediate approval',
                              actionLabel: S.of(context).viewAll,
                              icon: Icons.agriculture,
                              color: AppColors.primaryColor,
                              onTap: () => CustomNavigate.push(
                                const SellerRentalListRoute(),
                              ),
                            ),
                            PendingActionTile(
                              title: S.of(context).productRejected,
                              subtitle: S
                                  .of(context)
                                  .productCorrectionNeeded(
                                    "Engrais NPK 15-15-15",
                                  ),
                              actionLabel: S.of(context).correct,
                              icon: Icons.warning_amber_rounded,
                              color: Colors.redAccent,
                              onTap: () {},
                            ),
                            PendingActionTile(
                              title: S.of(context).lowStock,
                              subtitle: S
                                  .of(context)
                                  .stockRemaining("Semences de Maïs", 2),
                              actionLabel: S.of(context).restock,
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
                                Text(
                                  S.of(context).revenuePerformance,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: S.of(context).days30,
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
                                  items:
                                      [
                                            S.of(context).days7,
                                            S.of(context).days30,
                                            S.of(context).months3,
                                          ]
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
                        child: Text(
                          S.of(context).topProductsMonth,
                          style: const TextStyle(
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
