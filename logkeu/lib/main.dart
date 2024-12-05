import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/settings.dart';
import 'theme_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(isDarkMode: isDarkMode),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_membership_rounded),
            label: 'Dompet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications_outlined),
            label: 'Pengaturan',
          ),
        ],
        selectedLabelStyle: TextStyle(
          fontFamily: 'Lato', // Ganti dengan font yang Anda inginkan
          fontWeight: FontWeight.bold, // Misalnya, menambahkan ketebalan font
          fontSize: 14, // Ukuran font label ketika dipilih
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Lato', // Ganti dengan font yang Anda inginkan
          fontSize: 12, // Ukuran font label ketika tidak dipilih
        ),
      ),
    );
  }
}
