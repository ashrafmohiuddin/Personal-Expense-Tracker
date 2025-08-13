import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';
import '../../domain/models/transaction.dart';
import '../../data/repositories/transaction_repository.dart';
import '../widgets/category_picker.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateForm);
    _merchantController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        _selectedCategory.isNotEmpty;
    
    if (isValid != _isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectCategory() async {
    final category = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => const CategoryPicker(),
    );
    if (category != null) {
      setState(() {
        _selectedCategory = category;
        _validateForm();
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final transaction = Transaction(
      type: _type,
      amount: amount,
      category: _selectedCategory,
      merchant: _merchantController.text.isNotEmpty ? _merchantController.text : null,
      date: _selectedDate,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
    );

    try {
      final repository = ref.read(transactionRepositoryProvider.notifier);
      await repository.addTransaction(transaction);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction saved')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.spacing16),
          children: [
            // Transaction Type Toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTokens.spacing8),
                child: SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text('Expense'),
                      icon: Icon(Icons.remove),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text('Income'),
                      icon: Icon(Icons.add),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (Set<TransactionType> selection) {
                    setState(() {
                      _type = selection.first;
                    });
                  },
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.3),
            const SizedBox(height: AppTokens.spacing24),

            // Amount Input
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ).animate().fadeIn().slideY(begin: 0.3),
            const SizedBox(height: AppTokens.spacing16),

            // Date Picker
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(AppTokens.radius),
              child: Container(
                padding: const EdgeInsets.all(AppTokens.spacing16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(AppTokens.radius),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: AppTokens.spacing12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          Formatters.formatDate(_selectedDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.3),
            const SizedBox(height: AppTokens.spacing16),

            // Category Picker
            InkWell(
              onTap: _selectCategory,
              borderRadius: BorderRadius.circular(AppTokens.radius),
              child: Container(
                padding: const EdgeInsets.all(AppTokens.spacing16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(AppTokens.radius),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category),
                    const SizedBox(width: AppTokens.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            _selectedCategory.isEmpty ? 'Select category' : _selectedCategory,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: _selectedCategory.isEmpty
                                      ? Theme.of(context).colorScheme.onSurfaceVariant
                                      : null,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.3),
            const SizedBox(height: AppTokens.spacing16),

            // Merchant Input
            TextFormField(
              controller: _merchantController,
              decoration: const InputDecoration(
                labelText: 'Merchant (Optional)',
                icon: Icon(Icons.store),
              ),
            ).animate().fadeIn().slideY(begin: 0.3),
            const SizedBox(height: AppTokens.spacing16),

            // Note Input
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Note (Optional)',
                icon: Icon(Icons.note),
              ),
            ).animate().fadeIn().slideY(begin: 0.3),
            const SizedBox(height: AppTokens.spacing32),

            // Save Button
            FilledButton(
              onPressed: _isValid ? _saveTransaction : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                _type == TransactionType.income ? 'Add Income' : 'Add Expense',
              ),
            ).animate().fadeIn().slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }
}
