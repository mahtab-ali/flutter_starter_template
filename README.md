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
- 🔄 **RTL Support** - Automatic right-to-left layout for Arabic
- 🎭 **Smart Icon Direction** - Icons automatically flip in RTL mode
- 🔤 **Dynamic Typography** - Font family changes based on language
- 👤 **Profile Management** - Comprehensive user profile with editing capabilities
- 🔒 **Security Features** - Password change functionality and secure data handling
- 🛠️ **Error Handling** - Toast notifications and form validations

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
│   ├── app/               # App state management
│   ├── auth/              # Authentication BLoC
│   ├── localization/      # Language BLoC  
│   ├── onboarding/        # Onboarding BLoC
│   └── theme/             # Theme BLoC
├── config/                # App configuration
│   ├── app_config.dart    # Global app configuration
│   └── routes.dart        # Route definitions
├── core/                  # Core functionality
│   └── dependency_injection.dart  # Service locator
├── i18n/                  # Localization
│   └── app_localizations.dart     # Translation utilities
├── models/                # Data models
│   └── user_model.dart    # User data model
├── screens/               # All app screens
│   ├── auth/              # Authentication screens
│   ├── home/              # Home screens
│   ├── onboarding/        # Onboarding screens
│   ├── profile/           # User profile screen
│   ├── settings/          # Settings screen
│   └── splash/            # Splash screen
├── services/              # Services and API clients
├── themes/                # Theme definitions
│   ├── app_colors.dart    # Color definitions
│   ├── app_gradients.dart # Gradient definitions
│   ├── app_text_styles.dart # Typography system
│   ├── theme_data.dart    # Theme configuration
│   └── universal_constants.dart # Spacing, sizing constants
├── ui/                    # Reusable UI components
│   ├── app_bar/           # Custom app bars
│   ├── bottom_sheets/     # Bottom sheet components
│   ├── buttons/           # Button components
│   ├── cards/             # Card components
│   ├── dialogs/           # Dialog components
│   └── inputs/            # Input field components
├── utils/                 # Utility classes
│   ├── helper.dart        # Helper functions
│   ├── keyboard_util.dart # Keyboard utilities
│   ├── toast_util.dart    # Toast notifications
│   └── validators.dart    # Form validation logic
├── widgets/               # Complex widgets
└── main.dart              # App entry point
```

## 🧩 UI Components

### Buttons

#### 1. PrimaryButton
A versatile button component with three variants:

```dart
// Standard button
PrimaryButton(
  text: 'Button Text',
  onPressed: () {},
  isLoading: false,
  backgroundColor: Colors.blue, // Optional
  borderRadius: BorderRadius.circular(8), // Optional
)

// Outline variant
PrimaryButton.outline(
  text: 'Outline Button',
  onPressed: () {},
  borderColor: Colors.blue, // Optional
)

// Text variant
PrimaryButton.text(
  text: 'Text Button',
  onPressed: () {},
)
```

#### 2. GradientButton
A button with gradient background and icon support:

```dart
GradientButton(
  text: 'Gradient Button',
  onPressed: () {},
  gradient: AppGradients.primaryDiagonal(isDark: false),
  icon: Icons.arrow_forward, // Optional
  iconPosition: IconPosition.right, // left or right
)
```

### Cards

#### AppCard
A customizable card with gradient support:

```dart
AppCard(
  gradient: AppGradients.glassLight(), // Optional
  child: YourContent(),
)
```

### Input Fields

#### CustomTextField
A fully-featured text input with built-in validation:

```dart
CustomTextField(
  label: 'Email',
  hint: 'Enter your email',
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icon(LineIcons.envelope),
  validator: (value) => Validators.validateEmail(value),
  obscureText: false, // For password fields
)
```

### Dialog Boxes

#### CustomAlertDialog
Stylish alert dialogs with multiple types:

```dart
// Success dialog
CustomAlertDialog.showSuccess(
  context,
  title: 'Success',
  message: 'Operation completed successfully',
);

// Error dialog
CustomAlertDialog.showError(
  context,
  title: 'Error',
  message: 'Something went wrong',
);

// Confirmation dialog
CustomAlertDialog.showConfirmation(
  context,
  title: 'Confirm',
  message: 'Are you sure?',
  onConfirm: () {
    // Action on confirmation
  },
);

// Custom form dialog
CustomAlertDialog.showCustomForm(
  context,
  title: 'Edit Profile',
  formContent: YourFormWidget(),
  actions: [YourActions],
  customIcon: Icon(LineIcons.userEdit, size: 60.0),
);
```

### Bottom Sheets

#### AppBottomSheet
iOS-style bottom sheets:

```dart
showAppBottomSheet(
  context: context,
  child: AppBottomSheetContent(
    title: 'Sheet Title',
    child: YourContent(),
    actions: [YourActions],
  ),
);
```

### App Bar

#### CustomAppBar
Consistent app bar with RTL support:

```dart
CustomAppBar(
  title: 'Screen Title',
  centerTitle: true,
  automaticallyImplyLeading: true, // Show back button
)
```

## 🎭 Typography System

The template includes a comprehensive typography system that automatically adjusts based on the selected language.

### Font Families

- Latin script (English): **Varela Round**
- Arabic script: **Noto Kufi Arabic**

### Text Styles

Access consistent text styles throughout the app:

```dart
// For light theme
AppTextStyles.headingLargeLight(locale: locale)
AppTextStyles.headingMediumLight(locale: locale)
AppTextStyles.headingSmallLight(locale: locale)
AppTextStyles.bodyLargeLight(locale: locale)
AppTextStyles.bodyMediumLight(locale: locale)
AppTextStyles.bodySmallLight(locale: locale)

// For dark theme
AppTextStyles.headingLargeDark(locale: locale)
AppTextStyles.headingMediumDark(locale: locale)
AppTextStyles.headingSmallDark(locale: locale)
AppTextStyles.bodyLargeDark(locale: locale)
AppTextStyles.bodyMediumDark(locale: locale)
AppTextStyles.bodySmallDark(locale: locale)
```

## 🔄 Consistent Spacing System

A universal spacing system ensures consistent UI across the app:

```dart
// Spacing constants
UniversalConstants.spacingXXSmall  // 2.0
UniversalConstants.spacingXSmall   // 4.0
UniversalConstants.spacingSmall    // 8.0
UniversalConstants.spacingMedium   // 16.0
UniversalConstants.spacingLarge    // 24.0
UniversalConstants.spacingXLarge   // 32.0
UniversalConstants.spacingXXLarge  // 48.0

// Border radius constants
UniversalConstants.borderRadiusSmall    // 4.0
UniversalConstants.borderRadiusMedium   // 8.0
UniversalConstants.borderRadiusLarge    // 16.0
UniversalConstants.borderRadiusXLarge   // 24.0
UniversalConstants.borderRadiusCircular // 100.0
```

## 🎨 Gradient System

Beautiful gradients are available through the AppGradients utility:

```dart
// Directional gradients
AppGradients.primaryDiagonal(isDark: isDark)
AppGradients.primaryVertical(isDark: isDark)
AppGradients.primaryHorizontal(isDark: isDark)

// Accent gradients
AppGradients.accentDiagonal(isDark: isDark)
AppGradients.accentVertical(isDark: isDark)

// Special effects
AppGradients.vibrant(isDark: isDark)
AppGradients.radial(isDark: isDark)

// Glass effects
AppGradients.glassLight(opacity: 0.5)
AppGradients.glassDark(opacity: 0.5)
```

## 🌍 Internationalization (i18n)

### Using Translations

```dart
// Get the App Localizations instance
final i18n = AppLocalizations.of(context);

// Basic translation
Text(i18n.translate('key_name'))

// Translation with arguments
Text(i18n.translateWithArgs('welcome_message', {'name': userName}))

// Check if current locale is RTL
if (i18n.isRtl) {
  // Handle RTL-specific layout
}
```

### RTL Support

The template automatically handles right-to-left layouts for Arabic language:

1. Text alignment and layout direction change automatically
2. Icons are flipped appropriately using the Helper.getDirectionalIcon utility
3. Font families switch based on language

## 👤 Profile Management

The template includes a comprehensive user profile management system with the following features:

### Profile Screen

A beautifully designed profile screen with:

- **Profile Picture** - Auto-generated avatar based on user initials 
- **Account Information** - Display of account creation date and last login
- **Personal Information** - User's full name with edit functionality
- **Security Settings** - Password management and permissions info

### Profile Editing

Users can edit their profile information:

```dart
// Access the profile screen
Navigator.of(context).pushNamed('/profile');

// Edit profile dialog
CustomAlertDialog.showCustomForm(
  context,
  title: i18n.translate('edit_profile'),
  formContent: yourFormWidget,
  actions: yourActions,
);
```

### Password Management

Secure password changing functionality:

- Current password validation
- New password requirements check
- Confirmation password matching
- Success/error feedback via toast notifications

### User Data Model

The UserModel class provides a structured way to handle user data:

```dart
final user = UserModel(
  id: 'user-id',
  email: 'user@example.com',
  displayName: 'User Name',
  lastLogin: DateTime.now(),
  createdAt: DateTime.now(),
);

// Convert from Supabase User
final userFromSupabase = UserModel.fromSupabaseUser(supabaseUser);
```

## 🧠 BLoC Architecture

### Working with BLoC Components

```dart
// Access a BLoC
final themeBloc = BlocProvider.of<ThemeBloc>(context);

// Listen to BLoC state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // Handle authenticated state
    }
  },
  child: YourWidget(),
)

// Build UI based on BLoC state
BlocBuilder<ThemeBloc, ThemeState>(
  builder: (context, state) {
    final isDark = state.isDarkMode == true;
    return YourWidget(isDark: isDark);
  },
)

// Dispatch events to BLoC
context.read<ThemeBloc>().add(ThemeChanged(isDarkMode: true));
```

## 🔒 Authentication System

The template includes a complete authentication flow with Supabase:

- User registration with email/password
- Login with email/password
- Password reset flow
- Session persistence
- Secure profile management

## 🛠️ Error Handling System

The template includes a robust error handling system:

### Toast Notifications

Consistent user feedback through toast messages:

```dart
// Success toast
ToastUtil.showSuccess(context, 'Operation successful');

// Error toast
ToastUtil.showError(context, 'An error occurred');

// Info toast
ToastUtil.showInfo(context, 'Information message');
```

### Form Validation

Built-in form validation with:

- Required field validation
- Email format validation
- Password strength validation
- Password matching validation

### BLoC Error Handling

Centralized error handling through the BLoC pattern:

```dart
BlocListener<AppAuthBloc, AppAuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      ToastUtil.showError(context, state.message);
    }
  },
  child: YourWidget(),
)
```

## 🛠️ Customization

### Adding New Screens
1. Create a new screen in the `lib/screens/` directory
2. Add routes in `lib/config/routes.dart`

### Adding New Languages
1. Create a new JSON file in `assets/i18n/` (e.g., `fr.json`)
2. Add the locale to `supportedLocales` in `lib/config/app_config.dart`

### Modifying Theme
1. Edit the theme definitions in `lib/themes/theme_data.dart`
2. Customize colors in `lib/themes/app_colors.dart`
3. Update gradients in `lib/themes/app_gradients.dart`

### Adding New UI Components
1. Create a new file in the appropriate directory under `lib/ui/`
2. Follow the existing component patterns for consistency
3. Use the universal constants for spacing and sizing

## 📱 Project Integration Guide

### 1. Firebase Integration
To add Firebase to this template:

1. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
2. Configure Firebase: `flutterfire configure`
3. Add Firebase packages to pubspec.yaml:
   ```yaml
   firebase_core: ^latest_version
   firebase_auth: ^latest_version
   cloud_firestore: ^latest_version
   ```
4. Update the auth BLoC to use Firebase Auth instead of Supabase

### 2. State Management Alternatives

While this template uses BLoC, you can easily switch to other state management solutions:

- **Provider**: Replace BLoC classes with ChangeNotifier implementations
- **Riverpod**: Create providers and consumers to replace BLoC pattern
- **GetX**: Convert BLoC logic to GetX controllers

### 3. API Integration

The template is structured to easily integrate with any backend:

1. Create API client classes in the `services/` directory
2. Use repositories to abstract data access for BLoCs
3. Handle loading states and errors consistently using the provided UI components

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI toolkit
- [Supabase](https://supabase.io/) - Backend as a Service
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management
- [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html) - Localization support
- [line_icons](https://pub.dev/packages/line_icons) - Beautiful line icons
