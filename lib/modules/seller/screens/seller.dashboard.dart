import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/seller/cubit/seller.cubit.dart';
import 'package:fgtagro_mobile/modules/seller/cubit/seller.state.dart';
import 'package:fgtagro_mobile/models/seller.dart';
import 'package:fgtagro_mobile/modules/seller/widgets/seller_action_card.dart';
import 'package:fgtagro_mobile/modules/seller/widgets/seller_stat_card.dart';
import 'package:fgtagro_mobile/modules/seller/widgets/store_list_item.dart';
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
    final sellerCubit = context.read<SellerCubit>();
    sellerCubit.fetchProfile();
    sellerCubit.fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerCubit, SellerState>(
      builder: (context, state) {
        final SellerProfileModel? seller = state.profile;
        final List<StoreModel> stores = state.stores;
        const String firstName = 'Jean'; // Ideally from AuthCubit

        Color getStatusColor() {
          if (seller?.status == 'validated') return const Color(0xFF10b981); // green
          if (seller?.status == 'pending') return const Color(0xFFd97706); // orange
          if (seller?.status == 'rejected') return Colors.red;
          return Colors.grey;
        }

        String getStatusLabel() {
          if (seller?.status == 'validated') return 'Validé ✓';
          if (seller?.status == 'pending') return 'En attente de validation';
          if (seller?.status == 'rejected') return 'Rejeté';
          return 'Suspendu';
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFBF8FD),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBF8FD),
                    border: Border(bottom: BorderSide(color: Color.fromRGBO(228, 226, 230, 0.2))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.secondaryColor), onPressed: () => context.router.pop()),
                      const Text('Espace Vendeur', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.secondaryColor)),
                      IconButton(icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryColor, size: 26), onPressed: () {}),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<SellerCubit>().fetchProfile();
                      context.read<SellerCubit>().fetchStores();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Bonjour, $firstName 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.secondaryColor)),
                                  const SizedBox(height: 2),
                                  Text(seller?.businessName ?? 'Mon espace vendeur', style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getStatusColor().withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(getStatusLabel(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: getStatusColor())),
                              )
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Pending Alert
                          if (seller?.status == 'pending')
                            Container(
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFBEB),
                                border: Border.all(color: const Color(0xFFFDE68A)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(Icons.schedule, size: 18, color: Color(0xFFd97706)),
                                  SizedBox(width: 8),
                                  Expanded(child: Text('Votre compte est en cours de validation par notre équipe.', style: TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.3, fontWeight: FontWeight.w500))),
                                ],
                              ),
                            ),

                          // Stats
                          SizedBox(
                            height: 110,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              children: [
                                SellerStatCard(title: 'Boutiques', value: '${stores.length}', icon: Icons.storefront, color: AppColors.secondaryColor, dark: true),
                                const SizedBox(width: 12),
                                SellerStatCard(title: 'Produits', value: '${stores.fold(0, (sum, s) => sum + s.productsCount)}', icon: Icons.inventory_2_outlined, color: AppColors.primaryColor),
                                const SizedBox(width: 12),
                                SellerStatCard(title: 'Note', value: seller?.averageRating?.toStringAsFixed(1) ?? '–', icon: Icons.star_outline, color: const Color(0xFFd97706)),
                                const SizedBox(width: 12),
                                SellerStatCard(title: 'Ventes', value: '${seller?.totalSales ?? 0}', icon: Icons.shopping_bag_outlined, color: const Color(0xFF10b981)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Stores Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Mes boutiques', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.secondaryColor)),
                              InkWell(
                                onTap: () {},
                                child: const Text('+ Ajouter', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryColor)),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (stores.isEmpty && !state.genLoading)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5EE),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1.5),
                              ),
                              child: Column(
                                children: const [
                                  Icon(Icons.storefront_outlined, size: 32, color: AppColors.primaryColor),
                                  SizedBox(height: 8),
                                  Text('Créer votre première boutique', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.secondaryColor)),
                                  SizedBox(height: 4),
                                  Text('Configurez votre point de vente pour commencer à vendre', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.3)),
                                ],
                              ),
                            )
                          else if (state.genLoading && stores.isEmpty)
                            const Center(child: CircularProgressIndicator())
                          else
                            ...stores.map((store) => StoreListItem(store: store)).toList(),

                          const SizedBox(height: 24),

                          // Quick Actions
                          const Text('Actions rapides', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.secondaryColor)),
                          const SizedBox(height: 12),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                            children: [
                              SellerActionCard(label: 'Nouveau produit', icon: Icons.add_circle_outline, bg: const Color(0xFFFFF0E6), iconColor: AppColors.primaryColor),
                              SellerActionCard(label: 'Mes produits', icon: Icons.inventory_2_outlined, bg: const Color(0xFFEEF0FF), iconColor: AppColors.secondaryColor),
                              SellerActionCard(label: 'Messages', icon: Icons.chat_bubble_outline, bg: const Color(0xFFE6FFF0), iconColor: const Color(0xFF10b981)),
                              SellerActionCard(label: 'Statistiques', icon: Icons.bar_chart_outlined, bg: const Color(0xFFFFF8E6), iconColor: const Color(0xFFd97706)),
                            ],
                          ),

                          const SizedBox(height: 24),
                          
                          // Settings row
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.settings_outlined, size: 20, color: Colors.grey),
                                SizedBox(width: 12),
                                Expanded(child: Text('Paramètres du compte vendeur', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500))),
                                Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
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
