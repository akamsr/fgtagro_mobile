import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';

@RoutePage()
class SellerOnboardScreen extends StatefulWidget {
  const SellerOnboardScreen({Key? key}) : super(key: key);

  @override
  State<SellerOnboardScreen> createState() => _SellerOnboardScreenState();
}

class _SellerOnboardScreenState extends State<SellerOnboardScreen> {
  int step = 1;

  // Step 1
  String sellerType = 'individual';
  String businessName = '';
  String rccmNumber = '';
  String taxId = '';

  // Step 2
  String mmProvider = '';
  String mmPhoneCode = '+237';
  String mmPhoneNumber = '';

  bool get canNext1 => businessName.trim().length >= 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FD),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.secondaryColor,
                    ),
                    onPressed: () {
                      if (step == 1) {
                        CustomNavigate.back();
                      } else {
                        setState(() => step = 1);
                      }
                    },
                  ),
                  Text(
                    S.of(context).becomeSeller,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Step Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStepIndicator(1, S.of(context).informations),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStepIndicator(2, S.of(context).payment),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: step == 1 ? _buildStep1() : _buildStep2(),
              ),
            ),

            // CTA
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                max(16.0, MediaQuery.of(context).padding.bottom),
              ),
              child: step == 1
                  ? Opacity(
                      opacity: canNext1 ? 1.0 : 0.5,
                      child: ElevatedButton(
                        onPressed: canNext1
                            ? () => setState(() => step = 2)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).continueText,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 54),
                              side: const BorderSide(
                                color: Color.fromRGBO(228, 226, 230, 1),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              S.of(context).skip,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              S.of(context).submit,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int num, String label) {
    bool active = step >= num;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).stepLabel('0$num'),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: active ? AppColors.primaryColor : Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: active ? AppColors.secondaryColor : Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 3,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryColor : const Color(0xFFe4e2e6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: Text(
            S.of(context).sellerType,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                S.of(context).individual,
                Icons.person_outline,
                sellerType == 'individual',
                () => setState(() => sellerType = 'individual'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeCard(
                S.of(context).company,
                Icons.business_outlined,
                sellerType == 'company',
                () => setState(() => sellerType = 'company'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildField(
          S.of(context).shopNameLabel,
          businessName,
          (v) => setState(() => businessName = v),
          'ex: AGRO DISTRIB SARL',
        ),
        _buildField(
          S.of(context).rccmLabel,
          rccmNumber,
          (v) => setState(() => rccmNumber = v),
          'ex: RC/DLA/2024/B/01234',
        ),
        _buildField(
          S.of(context).taxIdLabel,
          taxId,
          (v) => setState(() => taxId = v),
          'ex: M081500003752F',
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            S.of(context).mobileMoneyOptional,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            S.of(context).mmMessage,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.3,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildProviderCard(
                'Orange Money',
                const Color(0xFFFF6600),
                mmProvider == 'orange',
                () => setState(
                  () => mmProvider = mmProvider == 'orange' ? '' : 'orange',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProviderCard(
                'MTN MoMo',
                const Color(0xFFFFCC00),
                mmProvider == 'mtn',
                () => setState(
                  () => mmProvider = mmProvider == 'mtn' ? '' : 'mtn',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (mmProvider.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 80,
                child: _buildField(
                  S.of(context).phoneCodeLabel,
                  mmPhoneCode,
                  (v) => setState(() => mmPhoneCode = v),
                  '+237',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  S.of(context).mmPhoneLabel,
                  mmPhoneNumber,
                  (v) => setState(() => mmPhoneNumber = v),
                  'ex: 690123456',
                ),
              ),
            ],
          ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF0FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 18,
                color: AppColors.secondaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  S.of(context).onboardingNote,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondaryColor,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard(
    String label,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF5EE) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primaryColor : const Color(0xFFe4e2e6),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? AppColors.primaryColor : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(
    String label,
    Color color,
    bool selected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : const Color(0xFFe4e2e6),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.secondaryColor : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String value,
    Function(String) onChanged,
    String placeholder,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color.fromRGBO(228, 226, 230, 0.4),
              ),
            ),
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryColor,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
