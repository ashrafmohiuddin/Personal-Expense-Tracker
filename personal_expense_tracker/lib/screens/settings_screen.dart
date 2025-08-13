import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../models/currency.dart';
import '../models/transaction.dart';
import '../models/asset.dart';
import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Currency _selectedCurrency = Currency.getDefault();
  String _selectedThemeMode = 'system';
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final savedCurrencyCode = await AppConstants.getCurrencyCode();
    final savedThemeMode = await AppConstants.getThemeMode();
    
    if (savedCurrencyCode != null) {
      final currency = Currency.fromCode(savedCurrencyCode);
      if (currency != null) {
        setState(() {
          _selectedCurrency = currency;
        });
      }
    }
    
    if (savedThemeMode != null) {
      setState(() {
        _selectedThemeMode = savedThemeMode;
      });
    }
  }

  void _saveSettings() async {
    await AppConstants.setCurrencyCode(_selectedCurrency.code);
    
    // Update theme through provider
    final themeProvider = context.read<ThemeProvider>();
    await themeProvider.setThemeMode(_selectedThemeMode);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Settings saved successfully!'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    }
  }

  Future<void> _exportData() async {
    setState(() {
      _isExporting = true;
    });

    try {
      final provider = context.read<ExpenseProvider>();
      final transactions = await provider.getAllTransactions();
      final assets = await provider.getAllAssets();

      final exportData = {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'transactions': transactions.map((t) => t.toJson()).toList(),
        'assets': assets.map((a) => a.toJson()).toList(),
      };

      final jsonString = jsonEncode(exportData);
      final bytes = utf8.encode(jsonString);

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'expense_tracker_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported to: ${file.path}'),
            backgroundColor: AppTheme.primaryGreen,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: AppTheme.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  Future<void> _importData() async {
    setState(() {
      _isImporting = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final importData = jsonDecode(jsonString);

        if (importData['version'] != null) {
          final provider = context.read<ExpenseProvider>();
          
          // Clear existing data
          await provider.clearAllData();

          // Import transactions
          if (importData['transactions'] != null) {
            for (final transactionData in importData['transactions']) {
              final transaction = Transaction.fromJson(transactionData);
              await provider.addTransaction(transaction);
            }
          }

          // Import assets
          if (importData['assets'] != null) {
            for (final assetData in importData['assets']) {
              final asset = Asset.fromJson(assetData);
              await provider.addAsset(asset);
            }
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Data imported successfully!'),
                backgroundColor: AppTheme.primaryGreen,
              ),
            );
          }
        } else {
          throw Exception('Invalid backup file format');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Theme Settings
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.white,
                        AppTheme.lightGray,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.palette, color: Theme.of(context).colorScheme.primary, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Theme',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          _buildThemeOption('system', 'System Default', Icons.brightness_auto),
                          _buildThemeOption('light', 'Light Mode', Icons.light_mode),
                          _buildThemeOption('dark', 'Dark Mode', Icons.dark_mode),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Currency Settings
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.white,
                        AppTheme.lightGray,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Currency',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<Currency>(
                        value: _selectedCurrency,
                        decoration: const InputDecoration(
                          labelText: 'Select Currency',
                          border: OutlineInputBorder(),
                        ),
                        items: Currency.availableCurrencies.map((currency) {
                          return DropdownMenuItem<Currency>(
                            value: currency,
                            child: Text('${currency.code} - ${currency.name}'),
                          );
                        }).toList(),
                        onChanged: (Currency? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCurrency = newValue;
                            });
                            _saveSettings();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Data Management
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.white,
                        AppTheme.lightGray,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.storage, color: AppTheme.primaryGreen, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Data Management',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.deepBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isExporting ? null : _exportData,
                              icon: _isExporting 
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.upload),
                              label: Text(_isExporting ? 'Exporting...' : 'Export Data'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                foregroundColor: AppTheme.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isImporting ? null : _importData,
                              icon: _isImporting 
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.download),
                              label: Text(_isImporting ? 'Importing...' : 'Import Data'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryOrange,
                                foregroundColor: AppTheme.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGray.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: AppTheme.mediumGray, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Your data is stored locally and never uploaded to any cloud service.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.mediumGray,
                                ),
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

              // App Info
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.white,
                        AppTheme.lightGray,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: AppTheme.primaryGreen, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'App Information',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.deepBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow('App Name', AppConstants.appName),
                      _buildInfoRow('Version', AppConstants.appVersion),
                      _buildInfoRow('Current Currency', _selectedCurrency.code),
                      _buildInfoRow('Theme Mode', _selectedThemeMode),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(String value, String label, IconData icon) {
    final isSelected = _selectedThemeMode == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedThemeMode = value;
        });
        _saveSettings();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen.withOpacity(0.1) : AppTheme.lightGray.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.mediumGray.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryGreen : AppTheme.mediumGray,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.deepBlack,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.deepBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
