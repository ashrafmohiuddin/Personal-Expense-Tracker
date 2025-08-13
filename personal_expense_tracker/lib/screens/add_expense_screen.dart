import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';
import '../utils/animations.dart';

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
              Theme.of(context).colorScheme.background,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Transaction Type Selection
                AppAnimations.fadeIn(
                  child: Card(
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
                              Icon(Icons.category, color: Theme.of(context).colorScheme.primary, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                'Transaction Type',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: TransactionType.values.map((type) {
                              return Expanded(
                                child: _buildTypeButton(type),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Transaction Details
                AppAnimations.slideInFromBottom(
                  child: Card(
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
                                'Transaction Details',
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
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        _selectedType == TransactionType.expense 
                                          ? AppTheme.primaryOrange 
                                          : AppTheme.primaryGreen,
                                        _selectedType == TransactionType.expense 
                                          ? AppTheme.primaryOrange.withOpacity(0.8) 
                                          : AppTheme.primaryGreen.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (_selectedType == TransactionType.expense 
                                          ? AppTheme.primaryOrange 
                                          : AppTheme.primaryGreen).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _saveTransaction,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              _selectedType == TransactionType.expense 
                                                ? Icons.remove_circle 
                                                : Icons.add_circle,
                                              color: AppTheme.white,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Save ${_selectedType.displayName}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
       ),
     );
   }

  Widget _buildTypeButton(TransactionType type) {
    final isSelected = _selectedType == type;
    final color = type == TransactionType.expense ? AppTheme.primaryOrange : AppTheme.primaryGreen;
    final icon = type == TransactionType.expense ? Icons.remove_circle : Icons.add_circle;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _updateCategories();
        });
      },
      child: AnimatedContainer(
        duration: AppTheme.animationFast,
        curve: AppTheme.animationCurveFast,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected 
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withOpacity(0.8)],
              )
            : null,
          color: isSelected ? null : AppTheme.lightGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppTheme.mediumGray.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.white : color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              type.displayName,
              style: TextStyle(
                color: isSelected ? AppTheme.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 