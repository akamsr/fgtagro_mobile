import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/cart.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/modules/cart/widgets/checkout_stepper.dart';
import 'package:fgtagro_mobile/modules/cart/widgets/step_delivery.dart';
import 'package:fgtagro_mobile/modules/cart/widgets/step_payment.dart';
import 'package:fgtagro_mobile/modules/cart/widgets/step_shipping.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  bool _ctaLoading = false;

  // Step 1 state
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _quarterCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String? _city;

  // Step 2 state
  ShippingMethod _shipping = ShippingMethod.homeDelivery;

  // Step 3 state
  PaymentMethod? _payment;
  bool _tcAccepted = false;

  // Page animation
  late PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _quarterCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue {
    switch (_step) {
      case 0:
        return _nameCtrl.text.trim().length >= 3 &&
            _phoneCtrl.text.trim().isNotEmpty &&
            _city != null &&
            _addressCtrl.text.trim().length >= 5;
      case 1:
        return true;
      case 2:
        return _payment != null && _tcAccepted;
      default:
        return false;
    }
  }

  void _next(Cart cart) async {
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez compléter tous les champs requis.'),
        ),
      );
      return;
    }
    if (_step < 2) {
      setState(() => _step++);
      _pageCtrl.animateToPage(
        _step,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Confirm order
      setState(() => _ctaLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _ctaLoading = false);
        context.read<CartCubit>().clearCart();
        _showSuccessDialog();
      }
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.animateToPage(
        _step,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      CustomNavigate.back();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.successBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.successFg,
                size: 56,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Commande confirmée !',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vous recevrez une confirmation par SMS et email.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.router.popUntilRoot();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Voir mes commandes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cart = state.cart;
        if (cart == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFBF8FD),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                _step == 0 ? Icons.close : Icons.arrow_back,
                color: AppColors.secondaryColor,
              ),
              onPressed: _back,
            ),
            title: const Text(
              'Validation de commande',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              CheckoutStepper(activeStep: _step),

              _OrderSummaryBar(
                cart: cart,
                shippingFee: _shipping == ShippingMethod.homeDelivery
                    ? 2500
                    : 0,
              ),

              const Divider(height: 1),

              Expanded(
                child: PageView(
                  controller: _pageCtrl,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: StepDelivery(
                        nameController: _nameCtrl,
                        phoneController: _phoneCtrl,
                        addressController: _addressCtrl,
                        quarterController: _quarterCtrl,
                        noteController: _noteCtrl,
                        selectedCity: _city,
                        onCityChanged: (v) => setState(() => _city = v),
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: StepShipping(
                        selected: _shipping,
                        grandTotal: cart.grandTotal,
                        onChanged: (v) => setState(() => _shipping = v),
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          StepPayment(
                            selected: _payment,
                            grandTotal:
                                cart.grandTotal +
                                (_shipping == ShippingMethod.homeDelivery
                                    ? 2500
                                    : 0),
                            allowCash: _shipping == ShippingMethod.storePickup,
                            onChanged: (v) => setState(() => _payment = v),
                          ),
                          _TcCheckbox(
                            value: _tcAccepted,
                            onChanged: (v) =>
                                setState(() => _tcAccepted = v ?? false),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              _CtaFooter(
                step: _step,
                loading: _ctaLoading,
                enabled: _canContinue,
                grandTotal:
                    cart.grandTotal +
                    (_shipping == ShippingMethod.homeDelivery ? 2500 : 0),
                onTap: () => _next(cart),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderSummaryBar extends StatefulWidget {
  final dynamic cart;
  final double shippingFee;
  const _OrderSummaryBar({required this.cart, required this.shippingFee});

  @override
  State<_OrderSummaryBar> createState() => _OrderSummaryBarState();
}

class _OrderSummaryBarState extends State<_OrderSummaryBar> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final total = widget.cart.grandTotal + widget.shippingFee;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${widget.cart.totalItems} article(s)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${total.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _SummaryDetails(
              cart: widget.cart,
              shippingFee: widget.shippingFee,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

class _SummaryDetails extends StatelessWidget {
  final dynamic cart;
  final double shippingFee;
  const _SummaryDetails({required this.cart, required this.shippingFee});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Column(
        children: [
          ...cart.items.map<Widget>(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${item.qty}x ',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Expanded(
                    child: Text(
                      item.productName ?? 'Produit',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    '${(item.finalPrice * item.qty).toStringAsFixed(0)} F',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Livraison',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                shippingFee == 0
                    ? 'Gratuit'
                    : '${shippingFee.toStringAsFixed(0)} F',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TcCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  const _TcCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'J\'ai lu et j\'accepte les Conditions Générales et la Politique de Confidentialité de FGT AGRO.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _CtaFooter extends StatelessWidget {
  final int step;
  final bool loading;
  final bool enabled;
  final double grandTotal;
  final VoidCallback onTap;

  const _CtaFooter({
    required this.step,
    required this.loading,
    required this.enabled,
    required this.grandTotal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      'Continuer vers l\'expédition',
      'Continuer vers le paiement',
      'Confirmer et payer',
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: AnimatedOpacity(
            opacity: enabled ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 200),
            child: ElevatedButton(
              onPressed: enabled && !loading ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: step == 2
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      step == 2
                          ? '${labels[step]}  •  ${grandTotal.toStringAsFixed(0)} FCFA'
                          : labels[step],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
