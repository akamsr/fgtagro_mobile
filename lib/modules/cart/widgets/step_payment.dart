import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

enum PaymentMethod { orangeMoney, mtnMomo, card, bankTransfer, cashInStore }

class StepPayment extends StatefulWidget {
  final PaymentMethod? selected;
  final ValueChanged<PaymentMethod> onChanged;
  final bool allowCash; // only true when store pickup selected
  final double grandTotal;

  const StepPayment({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.grandTotal,
    this.allowCash = false,
  });

  @override
  State<StepPayment> createState() => _StepPaymentState();
}

class _StepPaymentState extends State<StepPayment>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _phoneController = TextEditingController();
  bool _saveDetails = true;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('Mode de paiement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
            const SizedBox(height: 4),
            const Text('Choisissez comment vous souhaitez payer.',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),

            _PaymentTile(
              icon: Icons.phone_android,
              title: 'Orange Money',
              subtitle: 'Paiement mobile sécurisé',
              color: Colors.orange,
              selected: widget.selected == PaymentMethod.orangeMoney,
              onTap: () => widget.onChanged(PaymentMethod.orangeMoney),
              expandedContent: widget.selected == PaymentMethod.orangeMoney
                  ? _mobileMoneyFields('Orange Money', '06X XXX XXXX')
                  : null,
            ),

            _PaymentTile(
              icon: Icons.phone_android,
              title: 'MTN Mobile Money',
              subtitle: 'Paiement mobile sécurisé',
              color: Colors.yellow.shade700,
              selected: widget.selected == PaymentMethod.mtnMomo,
              onTap: () => widget.onChanged(PaymentMethod.mtnMomo),
              expandedContent: widget.selected == PaymentMethod.mtnMomo
                  ? _mobileMoneyFields('MTN MoMo', '067 / 068 / 079 XXX XXXX')
                  : null,
            ),

            _PaymentTile(
              icon: Icons.credit_card,
              title: 'Carte Bancaire',
              subtitle: 'Visa / Mastercard – Sécurisé par Flutterwave',
              color: AppColors.secondaryColor,
              selected: widget.selected == PaymentMethod.card,
              onTap: () => widget.onChanged(PaymentMethod.card),
              expandedContent: widget.selected == PaymentMethod.card
                  ? _cardFields()
                  : null,
            ),

            _PaymentTile(
              icon: Icons.account_balance_outlined,
              title: 'Virement Bancaire',
              subtitle: 'Confirmation sous 24h',
              color: Colors.blueGrey,
              selected: widget.selected == PaymentMethod.bankTransfer,
              onTap: () => widget.onChanged(PaymentMethod.bankTransfer),
              expandedContent: widget.selected == PaymentMethod.bankTransfer
                  ? _bankTransferInfo()
                  : null,
            ),

            if (widget.allowCash)
              _PaymentTile(
                icon: Icons.payments_outlined,
                title: 'Paiement en boutique',
                subtitle: 'Espèces lors du retrait',
                color: Colors.green,
                selected: widget.selected == PaymentMethod.cashInStore,
                onTap: () => widget.onChanged(PaymentMethod.cashInStore),
                expandedContent: widget.selected == PaymentMethod.cashInStore
                    ? _cashInfo()
                    : null,
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _mobileMoneyFields(String name, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
            labelText: 'Numéro $name',
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.borderDefault)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.borderDefault)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryColor)),
          ),
        ),
        const SizedBox(height: 8),
        _saveRow(),
        const SizedBox(height: 8),
        const Text(
          'Vous recevrez une invite de paiement sur votre téléphone. Entrez votre PIN pour confirmer.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _cardFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cardInput('Numéro de carte', Icons.credit_card, TextInputType.number),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _cardInput('Expiration (MM/AA)', Icons.calendar_today, TextInputType.number)),
            const SizedBox(width: 8),
            Expanded(child: _cardInput('CVV', Icons.lock_outline, TextInputType.number)),
          ],
        ),
        const SizedBox(height: 8),
        _saveRow(),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.lock, size: 14, color: Colors.grey),
            SizedBox(width: 4),
            Expanded(
              child: Text('Sécurisé par Flutterwave. Vos données ne sont jamais stockées par FGT AGRO.',
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cardInput(String label, IconData icon, TextInputType type) {
    return TextField(
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.borderDefault)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.borderDefault)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryColor)),
      ),
    );
  }

  Widget _bankTransferInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Détails de virement', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.infoFg)),
          SizedBox(height: 8),
          Text('Banque: Société Générale Cameroun', style: TextStyle(fontSize: 13)),
          Text('Compte: FGT AGRO SARL', style: TextStyle(fontSize: 13)),
          Text('Référence: REF-FGT-CMD-XXXXXX', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('Votre commande sera confirmée sous 24h après réception du virement.',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _cashInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payez ${widget.grandTotal.toStringAsFixed(0)} FCFA en boutique lors du retrait.',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.successFg)),
          const SizedBox(height: 4),
          const Text('Votre commande sera réservée 48h. Un QR code vous sera fourni.',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _saveRow() {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _saveDetails,
            onChanged: (v) => setState(() => _saveDetails = v ?? false),
            activeColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Sauvegarder pour les prochains achats', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final Widget? expandedContent;

  const _PaymentTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.selected,
    required this.onTap,
    this.expandedContent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selected ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? color : AppColors.borderDefault,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: selected ? color : Colors.grey.shade300, width: 2),
                      color: selected ? color : Colors.transparent,
                    ),
                    child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                  ),
                ],
              ),
              if (expandedContent != null)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: expandedContent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
