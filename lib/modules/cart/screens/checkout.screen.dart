import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/modules/cart/widgets/checkout_step_indicator.dart';
import 'package:fgtagro_mobile/modules/cart/widgets/checkout_summary_row.dart';
import 'package:fgtagro_mobile/modules/cart/widgets/payment_option_card.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _activeStep = 0;
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Validation', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondaryColor),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cart = state.cart;
          if (cart == null) return const Center(child: CircularProgressIndicator());

          return Column(
            children: [
              CheckoutStepIndicator(activeStep: _activeStep),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _activeStep == 0
                      ? _buildDeliveryForm()
                      : _activeStep == 1
                          ? _buildPaymentMethods()
                          : _buildSummary(cart),
                ),
              ),

              // Footer Button
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_activeStep < 2) {
                        setState(() => _activeStep++);
                      } else {
                        // TODO: Finalize order
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      _activeStep == 2 ? 'CONFIRMER LA COMMANDE' : 'CONTINUER',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDeliveryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Adresse de livraison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
        const SizedBox(height: 20),
        _buildTextField('Adresse complète', _addressController, icon: Icons.location_on_outlined),
        const SizedBox(height: 16),
        _buildTextField('Numéro de téléphone', _phoneController, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
        const SizedBox(height: 24),
        const Text('Note pour le livreur (Optionnel)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Ex: Entrée face à la station Total...',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mode de paiement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
        const SizedBox(height: 20),
        PaymentOptionCard(
          title: 'Mobile Money',
          subtitle: 'Orange / MTN',
          icon: Icons.phone_android,
          selected: true,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        PaymentOptionCard(
          title: 'Paiement à la livraison',
          subtitle: 'Espèces',
          icon: Icons.payments_outlined,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        PaymentOptionCard(
          title: 'Carte Bancaire',
          subtitle: 'Visa / Mastercard',
          icon: Icons.credit_card_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSummary(dynamic cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Résumé de la commande', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              CheckoutSummaryRow(label: 'Sous-total', value: '${cart.subTotal.toStringAsFixed(0)} FCFA'),
              const SizedBox(height: 8),
              CheckoutSummaryRow(label: 'Livraison', value: '2 500 FCFA'),
              const Divider(height: 24),
              CheckoutSummaryRow(label: 'Total', value: '${(cart.grandTotal + 2500).toStringAsFixed(0)} FCFA', isTotal: true),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Destination', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(_addressController.text.isEmpty ? 'Non renseignée' : _addressController.text, style: const TextStyle(fontSize: 15, color: AppColors.secondaryColor)),
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {IconData? icon, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, size: 20, color: Colors.grey) : null,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }
}
