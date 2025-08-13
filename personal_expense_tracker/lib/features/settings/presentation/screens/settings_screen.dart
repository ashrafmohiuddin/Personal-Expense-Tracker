import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../design/tokens.dart';
import '../../../../design/app_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isDarkMode = false;
  bool _reducedMotion = false;
  String _selectedCurrency = '₹';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Settings'),
            floating: true,
            snap: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Appearance Section
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().fadeIn().slideX(begin: -0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                AppCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Use dark theme'),
                        value: _isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                          // TODO: Implement theme switching
                        },
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Reduced Motion'),
                        subtitle: const Text('Reduce animations for accessibility'),
                        value: _reducedMotion,
                        onChanged: (value) {
                          setState(() {
                            _reducedMotion = value;
                          });
                          // TODO: Implement reduced motion
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(begin: 0.3),
                const SizedBox(height: AppTokens.spacing24),

                // Currency Section
                Text(
                  'Currency',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().fadeIn().slideX(begin: -0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                AppCard(
                  child: ListTile(
                    title: const Text('Currency'),
                    subtitle: Text('Currently using $_selectedCurrency'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: _showCurrencyPicker,
                  ),
                ).animate().fadeIn().slideX(begin: 0.3),
                const SizedBox(height: AppTokens.spacing24),

                // Data Management Section
                Text(
                  'Data Management',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().fadeIn().slideX(begin: -0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                AppCard(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Export Data'),
                        subtitle: const Text('Export transactions to CSV'),
                        leading: const Icon(Icons.download),
                        onTap: _exportData,
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Import Data'),
                        subtitle: const Text('Import transactions from CSV'),
                        leading: const Icon(Icons.upload),
                        onTap: _importData,
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Clear All Data'),
                        subtitle: const Text('Delete all transactions and assets'),
                        leading: const Icon(Icons.delete_forever),
                        onTap: _clearAllData,
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(begin: 0.3),
                const SizedBox(height: AppTokens.spacing24),

                // About Section
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().fadeIn().slideX(begin: -0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                AppCard(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Version'),
                        subtitle: const Text('1.0.0'),
                        leading: const Icon(Icons.info),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Privacy Policy'),
                        leading: const Icon(Icons.privacy_tip),
                        onTap: _showPrivacyPolicy,
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Terms of Service'),
                        leading: const Icon(Icons.description),
                        onTap: _showTermsOfService,
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(begin: 0.3),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTokens.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Currency',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTokens.spacing16),
            Wrap(
              spacing: AppTokens.spacing8,
              children: [
                _buildCurrencyChip('₹', 'INR'),
                _buildCurrencyChip('\$', 'USD'),
                _buildCurrencyChip('€', 'EUR'),
                _buildCurrencyChip('£', 'GBP'),
                _buildCurrencyChip('¥', 'JPY'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyChip(String symbol, String code) {
    final isSelected = _selectedCurrency == symbol;
    
    return FilterChip(
      label: Text('$symbol $code'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedCurrency = symbol;
          });
          Navigator.pop(context);
        }
      },
    );
  }

  void _exportData() {
    // TODO: Implement data export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }

  void _importData() {
    // TODO: Implement data import
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import functionality coming soon')),
    );
  }

  void _clearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your transactions and assets. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Implement clear all data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    // TODO: Show privacy policy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy Policy coming soon')),
    );
  }

  void _showTermsOfService() {
    // TODO: Show terms of service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of Service coming soon')),
    );
  }
}
