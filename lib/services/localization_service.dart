import 'package:flutter/material.dart';

class LocalizationService {
  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      // Navigation
      'home': 'Home',
      'nowPlaying': 'Now Playing',
      'library': 'Music Library',
      'settings': 'Settings',
      
      // Home Screen
      'goodMorning': 'Good Morning',
      'goodAfternoon': 'Good Afternoon',
      'goodEvening': 'Good Evening',
      'recentlyPlayed': 'Recently Played',
      'mostPlayed': 'Most Played',
      'favorites': 'Favorites',
      'quickActions': 'Quick Actions',
      'browseLibrary': 'Browse Library',
      'playRandom': 'Play Random',
      'noRecentTracks': 'No recent tracks',
      'noFavoriteTracks': 'No favorite tracks',
      'startListening': 'Start listening to see your favorite tracks here',
      
      // Now Playing
      'nowPlayingTitle': 'Now Playing',
      'unknownArtist': 'Unknown Artist',
      'unknownAlbum': 'Unknown Album',
      'shuffleOff': 'Shuffle Off',
      'shuffleOn': 'Shuffle On',
      'repeatOff': 'Repeat Off',
      'repeatOne': 'Repeat One',
      'repeatAll': 'Repeat All',
      
      // Music Library
      'searchMusic': 'Search music, artists, albums...',
      'allSongs': 'All Songs',
      'sortBy': 'Sort by',
      'title': 'Title',
      'artist': 'Artist',
      'album': 'Album',
      'duration': 'Duration',
      'noMusicFound': 'No music found',
      'checkPermissions': 'Please check your storage permissions and try refreshing your library.',
      'refreshLibrary': 'Refresh Library',
      'scanningMusic': 'Scanning for music files...',
      'foundSongs': 'Found {} songs',
      
      // Settings
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'darkModeDesc': 'Switch between light and dark themes',
      'language': 'Language / اللغة',
      'languageDesc': 'Choose your preferred language',
      'musicLibrary': 'Music Library',
      'libraryInfo': 'Library Information',
      'totalSongs': 'Total Songs',
      'favoriteSongs': 'Favorite Songs',
      'recentlyPlayedSongs': 'Recently Played',
      'about': 'About',
      'appVersion': 'App Version',
      'madeWith': 'Made with ❤️ for music lovers',
      
      // Common
      'cancel': 'Cancel',
      'ok': 'OK',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'play': 'Play',
      'pause': 'Pause',
      'next': 'Next',
      'previous': 'Previous',
      'close': 'Close',
    },
    'ar': {
      // Navigation
      'home': 'الرئيسية',
      'nowPlaying': 'قيد التشغيل',
      'library': 'مكتبة الموسيقى',
      'settings': 'الإعدادات',
      
      // Home Screen
      'goodMorning': 'صباح الخير',
      'goodAfternoon': 'مساء الخير',
      'goodEvening': 'مساء الخير',
      'recentlyPlayed': 'المشغلة مؤخراً',
      'mostPlayed': 'الأكثر تشغيلاً',
      'favorites': 'المفضلة',
      'quickActions': 'إجراءات سريعة',
      'browseLibrary': 'تصفح المكتبة',
      'playRandom': 'تشغيل عشوائي',
      'noRecentTracks': 'لا توجد مقاطع حديثة',
      'noFavoriteTracks': 'لا توجد مقاطع مفضلة',
      'startListening': 'ابدأ الاستماع لرؤية مقاطعك المفضلة هنا',
      
      // Now Playing
      'nowPlayingTitle': 'قيد التشغيل الآن',
      'unknownArtist': 'فنان غير معروف',
      'unknownAlbum': 'ألبوم غير معروف',
      'shuffleOff': 'التشغيل العشوائي متوقف',
      'shuffleOn': 'التشغيل العشوائي مفعل',
      'repeatOff': 'التكرار متوقف',
      'repeatOne': 'تكرار واحد',
      'repeatAll': 'تكرار الكل',
      
      // Music Library
      'searchMusic': 'البحث في الموسيقى والفنانين والألبومات...',
      'allSongs': 'جميع الأغاني',
      'sortBy': 'ترتيب حسب',
      'title': 'العنوان',
      'artist': 'الفنان',
      'album': 'الألبوم',
      'duration': 'المدة',
      'noMusicFound': 'لم يتم العثور على موسيقى',
      'checkPermissions': 'يرجى التحقق من أذونات التخزين ومحاولة تحديث مكتبتك.',
      'refreshLibrary': 'تحديث المكتبة',
      'scanningMusic': 'البحث عن ملفات الموسيقى...',
      'foundSongs': 'تم العثور على {} أغنية',
      
      // Settings
      'appearance': 'المظهر',
      'darkMode': 'الوضع المظلم',
      'darkModeDesc': 'التبديل بين الأوضاع الفاتحة والمظلمة',
      'language': 'اللغة / Language',
      'languageDesc': 'اختر لغتك المفضلة',
      'musicLibrary': 'مكتبة الموسيقى',
      'libraryInfo': 'معلومات المكتبة',
      'totalSongs': 'إجمالي الأغاني',
      'favoriteSongs': 'الأغاني المفضلة',
      'recentlyPlayedSongs': 'المشغلة مؤخراً',
      'about': 'حول',
      'appVersion': 'إصدار التطبيق',
      'madeWith': 'صُنع بـ ❤️ لعشاق الموسيقى',
      
      // Common
      'cancel': 'إلغاء',
      'ok': 'موافق',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'retry': 'إعادة المحاولة',
      'play': 'تشغيل',
      'pause': 'إيقاف مؤقت',
      'next': 'التالي',
      'previous': 'السابق',
      'close': 'إغلاق',
    },
  };

  static String translate(String key, String languageCode) {
    return _localizedStrings[languageCode]?[key] ?? 
           _localizedStrings['en']?[key] ?? 
           key;
  }

  static String translateWithPlaceholder(String key, String languageCode, String placeholder) {
    String translation = translate(key, languageCode);
    return translation.replaceAll('{}', placeholder);
  }

  static bool isRTL(String languageCode) {
    return languageCode == 'ar';
  }

  static TextDirection getTextDirection(String languageCode) {
    return isRTL(languageCode) ? TextDirection.rtl : TextDirection.ltr;
  }

  static List<Locale> get supportedLocales => const [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];
}