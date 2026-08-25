import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'log_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
          surface: Color(0xFF141C2E),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1220),
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF141C2E),
          indicatorColor: Colors.white.withOpacity(0.15),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tabIndex = 0;
  final _storage = StorageService();
  List<FitnessEntry> _entries = [];
  UserProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await _storage.loadEntries();
    final profile = await _storage.loadProfile();
    setState(() {
      _entries = entries;
      _profile = profile;
      _loading = false;
    });
  }

  Future<void> _addEntry(FitnessEntry entry) async {
    setState(() {
      _entries.add(entry);
    });
    await _storage.saveEntries(_entries);
  }

  Future<void> _saveProfile(UserProfile profile) async {
    setState(() {
      _profile = profile;
    });
    await _storage.saveProfile(profile);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = [
      DashboardScreen(entries: _entries),
      LogScreen(entries: _entries, onAdd: _addEntry),
      ProfileScreen(profile: _profile, onSave: _saveProfile),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _profile != null && _profile!.name.isNotEmpty
              ? "Hi, ${_profile!.name} 👋"
              : 'Fitness Tracker',
        ),
      ),
      body: screens[_tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          NavigationDestination(icon: Icon(Icons.list), label: "Activity Log"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
