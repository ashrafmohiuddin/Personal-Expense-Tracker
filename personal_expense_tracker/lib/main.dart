import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'providers/expense_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/assets_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Initialize app constants
  await AppConstants.init();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final themeMode = await AppConstants.getThemeMode();
    if (themeMode != null) {
      setState(() {
        switch (themeMode) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          default:
            _themeMode = ThemeMode.system;
        }
      });
    }
  }

  void _updateThemeMode(String themeMode) async {
    await AppConstants.setThemeMode(themeMode);
    _loadThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()..loadThemeMode()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Personal Expense Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const MainScreen(),
            debugShowCheckedModeBanner: false,
            routes: {
              '/summary': (context) => const SummaryScreen(),
              '/assets': (context) => const AssetsScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AddExpenseScreen(),
    const TransactionsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().loadTransactions();
      context.read<ExpenseProvider>().loadAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
        ],
      ),
    );
  }
  

}
