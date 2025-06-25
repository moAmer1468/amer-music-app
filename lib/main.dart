import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'services/localization_service.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MohamedAlaaMusic());
}

class MohamedAlaaMusic extends StatefulWidget {
  const MohamedAlaaMusic({super.key});

  @override
  State<MohamedAlaaMusic> createState() => _MohamedAlaaMusicState();
}

class _MohamedAlaaMusicState extends State<MohamedAlaaMusic> {
  final StorageService _storageService = StorageService();
  String _currentLanguage = 'en';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final language = await _storageService.getLanguage();
    final darkMode = await _storageService.isDarkMode();
    
    if (mounted) {
      setState(() {
        _currentLanguage = language;
        _isDarkMode = darkMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLocalizationNotifier>(
      create: (_) => AppLocalizationNotifier(_currentLanguage, _isDarkMode),
      child: Consumer<AppLocalizationNotifier>(
        builder: (context, localization, child) {
          return MaterialApp(
            title: 'Mohamed Alaa Music',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: localization.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: Locale(localization.languageCode),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocalizationService.supportedLocales,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return Directionality(
                textDirection: LocalizationService.getTextDirection(localization.languageCode),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

class AppLocalizationNotifier extends ChangeNotifier {
  String _languageCode;
  bool _isDarkMode;

  AppLocalizationNotifier(this._languageCode, this._isDarkMode);

  String get languageCode => _languageCode;
  bool get isDarkMode => _isDarkMode;

  void updateLanguage(String newLanguageCode) {
    if (_languageCode != newLanguageCode) {
      _languageCode = newLanguageCode;
      notifyListeners();
    }
  }

  void updateTheme(bool isDark) {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      notifyListeners();
    }
  }
}