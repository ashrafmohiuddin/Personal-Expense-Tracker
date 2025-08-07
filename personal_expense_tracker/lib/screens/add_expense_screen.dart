import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tripController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = AppConstants.expenseCategories.first;
  String _selectedTrip = AppConstants.tripCategories.first;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _tripController.dispose();
    super.dispose();
  }

  void _updateCategories() {
    setState(() {
      if (_selectedType == TransactionType.expense) {
        _selectedCategory = AppConstants.expenseCategories.first;
      } else {
        _selectedCategory = AppConstants.incomeCategories.first;
      }
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final description = _descriptionController.text.trim();
    final trip = _selectedTrip == 'No Trip' ? null : _selectedTrip;

    final transaction = Transaction(
      amount: amount,
      description: description,
      category: _selectedCategory,
      trip: trip,
      date: _selectedDate,
      type: _selectedType,
    );

    try {
      await context.read<ExpenseProvider>().addTransaction(transaction);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedType.displayName} added successfully'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        
        // Clear form
        _formKey.currentState!.reset();
        _amountController.clear();
        _descriptionController.clear();
        _tripController.clear();
        setState(() {
          _selectedDate = DateTime.now();
          _selectedType = TransactionType.expense;
          _selectedCategory = AppConstants.expenseCategories.first;
          _selectedTrip = AppConstants.tripCategories.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding ${_selectedType.displayName.toLowerCase()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transaction Type Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Type',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: TransactionType.values.map((type) {
                          return Expanded(
                            child: RadioListTile<TransactionType>(
                              title: Text(type.displayName),
                              value: type,
                              groupValue: _selectedType,
                              onChanged: (TransactionType? value) {
                                setState(() {
                                  _selectedType = value!;
                                  _updateCategories();
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: (_selectedType == TransactionType.expense
                        ? AppConstants.expenseCategories
                        : AppConstants.incomeCategories)
                    .map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Trip Selection
              DropdownButtonFormField<String>(
                value: _selectedTrip,
                decoration: const InputDecoration(
                  labelText: 'Trip (Optional)',
                ),
                items: AppConstants.tripCategories.map((String trip) {
                  return DropdownMenuItem<String>(
                    value: trip,
                    child: Text(trip),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTrip = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date Selection
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Save ${_selectedType.displayName}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 