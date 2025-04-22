# Flutter Starter Template

A comprehensive Flutter starter template with authentication, localization, themes, BLoC state management, and beautiful UI components.

## 🌟 Features

- 🔐 **Supabase Authentication** - Login, registration, password reset
- 🌍 **Localization** - English and Arabic with RTL support
- 🎨 **Beautiful UI** - Frosted glass components and colorful gradients
- 🌓 **Theme Switching** - Light/dark mode with persistence
- 🧠 **BLoC Architecture** - Organized state management
- 🧩 **Pre-built Components** - Buttons, cards, inputs, and more
- 📱 **Responsive Design** - Works on various screen sizes

## 📋 Prerequisites

- Flutter SDK (2.19.0 or newer)
- Dart SDK (3.7.0 or newer)
- A Supabase account and project

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/flutter_starter_template.git
cd flutter_starter_template
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure environment variables

Create a `.env` file in the project root with your Supabase details:

```
SUPABASE_URL=https://your-supabase-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
```

### 4. Run the app

```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── blocs/                 # BLoCs for state management
│   ├── auth/              # Authentication BLoC
│   ├── localization/      # Language BLoC  
│   └── theme/             # Theme BLoC
├── config/                # App configuration
├── i18n/                  # Localization
├── models/                # Data models
├── screens/               # App screens
│   ├── auth/              # Auth screens
│   ├── home_screen.dart   # Home screen
│   └── settings_screen.dart # Settings
├── services/              # Services (API, local storage)
├── themes/                # Theme definitions
├── ui/                    # UI components
│   ├── buttons/           # Button components
│   ├── cards/             # Card components
│   ├── dialogs/           # Dialog components
│   └── inputs/            # Input field components
├── utils/                 # Utility classes
└── main.dart              # App entry point
```

## 🧩 Components

### Authentication
- Login, Register, and Forgot Password screens
- User session persistence
- Secure authentication with Supabase

### Themes
- Light and dark theme support
- Theme persistence with SharedPreferences
- Custom colors, text styles, and dimensions

### Localization
- Multi-language support (English and Arabic)
- Automatic RTL layout for Arabic
- Easy to add more languages

### UI Components
- Custom buttons (Primary, Gradient)
- Cards with glass effects
- Custom text fields and form validation
- iOS-style bottom sheets
- Custom alerts and dialogs

## 🛠️ Customization

### Adding New Screens
1. Create a new screen in the `lib/screens/` directory
2. Add routes in your navigation system

### Adding New Languages
1. Create a new JSON file in `assets/i18n/` (e.g., `fr.json`)
2. Add the locale to `supportedLocales` in `lib/config/app_config.dart`

### Modifying Theme
1. Edit the theme definitions in `lib/themes/theme_data.dart`
2. Customize colors in `lib/themes/app_colors.dart`

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI toolkit
- [Supabase](https://supabase.io/) - Backend as a Service
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management
- [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html) - Localization support
