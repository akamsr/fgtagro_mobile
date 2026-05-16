import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _quietHoursEnabled = false;
  bool _hasChanges = false;
  bool _isSaving = false;

  // Mock preferences state
  final Map<String, Map<String, bool>> _prefs = {
    'Payment confirmed': {
      'push': true,
      'sms': true,
      'email': true,
      'disabled': true,
    }, // disabled means cannot be turned off entirely
    'Order is being prepared': {'push': true, 'sms': false, 'email': false},
    'Driver assigned to your order': {
      'push': true,
      'sms': false,
      'email': false,
    },
    'Driver is nearby (< 5km)': {'push': true, 'sms': true, 'email': false},
    'Order delivered': {'push': true, 'sms': true, 'email': true},
    'Order cancelled': {'push': true, 'sms': true, 'email': true},
    'Pickup order ready at store': {'push': true, 'sms': true, 'email': true},
    'Pickup deadline reminder': {'push': true, 'sms': true, 'email': false},

    'Payment failed': {
      'push': true,
      'sms': true,
      'email': true,
      'disabled': true,
    },
    'Refund approved': {'push': true, 'sms': true, 'email': true},
    'Dispute update': {'push': true, 'sms': false, 'email': true},

    'Rental booking confirmed': {'push': true, 'sms': true, 'email': true},
    'Rental booking declined': {'push': true, 'sms': true, 'email': true},
    'Rental extension accepted/declined': {
      'push': true,
      'sms': true,
      'email': false,
    },
    'Equipment return confirmed': {'push': true, 'sms': true, 'email': true},
    'Deposit released': {'push': true, 'sms': true, 'email': true},
    'Geofence breach alert': {
      'push': true,
      'sms': true,
      'email': false,
      'disabled': true,
    },

    'New products near you': {'push': false, 'sms': false, 'email': false},
    'Special offers and promotions': {
      'push': false,
      'sms': false,
      'email': false,
    },
    'Agricultural news and tips': {'push': false, 'sms': false, 'email': false},
  };

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1)); // Mock API call
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences saved ✓'),
          backgroundColor: Colors.green,
        ),
      );
      context.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FD),
      appBar: AppBar(
        title: const Text(
          'Notification Preferences',
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondaryColor),
        actions: [
          TextButton(
            onPressed: _hasChanges && !_isSaving ? _savePreferences : null,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _hasChanges ? AppColors.primaryColor : Colors.grey,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuietHoursCard(),
            const SizedBox(height: 24),
            _buildCategorySection('Orders & Delivery', [
              'Payment confirmed',
              'Order is being prepared',
              'Driver assigned to your order',
              'Driver is nearby (< 5km)',
              'Order delivered',
              'Order cancelled',
              'Pickup order ready at store',
              'Pickup deadline reminder',
            ]),
            const SizedBox(height: 24),
            _buildCategorySection('Payments & Refunds', [
              'Payment failed',
              'Refund approved',
              'Dispute update',
            ]),
            const SizedBox(height: 24),
            _buildCategorySection('Equipment Rentals', [
              'Rental booking confirmed',
              'Rental booking declined',
              'Rental extension accepted/declined',
              'Equipment return confirmed',
              'Deposit released',
              'Geofence breach alert',
            ]),
            const SizedBox(height: 24),
            _buildCategorySection('Promotions & News', [
              'New products near you',
              'Special offers and promotions',
              'Agricultural news and tips',
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuietHoursCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Do not disturb',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Mute non-critical push notifications'),
            value: _quietHoursEnabled,
            activeColor: AppColors.primaryColor,
            onChanged: (val) {
              setState(() => _quietHoursEnabled = val);
              _markChanged();
            },
          ),
          if (_quietHoursEnabled) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start time',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '10:00 PM',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End time',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '07:00 AM',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Critical alerts (payment confirmation, delivery arrival) will still be sent during quiet hours.',
                    style: TextStyle(color: Colors.blue.shade800, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final key = items[index];
              final prefs = _prefs[key]!;
              final isDisabled = prefs['disabled'] == true;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (isDisabled)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Required',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildToggle(
                          key,
                          'push',
                          'Push',
                          prefs['push']!,
                          isDisabled,
                        ),
                        const SizedBox(width: 16),
                        _buildToggle(
                          key,
                          'sms',
                          'SMS',
                          prefs['sms']!,
                          isDisabled,
                        ),
                        const SizedBox(width: 16),
                        _buildToggle(
                          key,
                          'email',
                          'Email',
                          prefs['email']!,
                          isDisabled,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(
    String parentKey,
    String type,
    String label,
    bool value,
    bool isCategoryDisabled,
  ) {
    // If the category is required and this is the only active channel, we might want to disable toggling it off.
    // For simplicity, we just use the category disabled flag.
    final canToggle = !isCategoryDisabled;

    return GestureDetector(
      onTap: () {
        if (!canToggle) return;
        setState(() {
          _prefs[parentKey]![type] = !value;
        });
        _markChanged();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            value ? Icons.check_circle : Icons.radio_button_unchecked,
            color: value
                ? (canToggle ? AppColors.primaryColor : Colors.grey)
                : Colors.grey.shade300,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: value ? Colors.black87 : Colors.grey.shade500,
              fontSize: 12,
              fontWeight: value ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
