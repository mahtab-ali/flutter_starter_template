# 🌟 Flutter Starter Template – Full-Featured & Beautiful

Create a **Flutter Starter Template** with:

- 🔐 Supabase Auth (Login, Register, Forgot Password)
- 🌍 Localization (Default: English 🇺🇸 & Arabic 🇸🇦 with RTL)
- 🎨 Clean minimal UI with **frosted glass and colorful gradients**
- 🧠 Bloc-based architecture (Auth, Theme, Localization)
- 🧱 Reusable styled widgets
- 📲 iOS-style Bottom Sheets + Custom Alerts
- ⚙️ Essential plugins preconfigured (Hive, SharedPrefs, Toasts, .env, Icons)

---

## 📁 Folder Structure

```
lib/
├── blocs/                 # Theme, Auth, Localization
├── config/                # Constants, env, app setup
├── i18n/                  # en.json, ar.json
├── models/
├── screens/
├── services/              # Supabase, Storage, LocalDB
├── themes/                # app_colors, gradients, text styles
├── ui/                    # widgets, components, layout
├── utils/                 # helpers, extensions
├── app.dart
└── main.dart
```

---

## 🔐 Authentication (Supabase)

- Fully integrated `supabase_flutter` auth
- Register/Login/Forgot Password flows
- AuthBloc with `AuthState`, `AuthEvent`
- Toasts for success & error (using `fluttertoast`)
- Field validation, loading states
- Session auto-restore + route guards

---

## 🌍 Localization

- **No custom localization plugins will be used.**
- Only Flutter's default localization options:
  - `flutter_localizations` (official Flutter package)
  - `LocalizationsDelegates`
- JSON format for translations:
  ```json
  {
    "@@locale": "en",
    "login": "Login",
    "welcome_message": "Welcome, {name}!"
  }
  ```
- Bloc for locale switching
- RTL support (Arabic)
- Animation transitions between languages
- Device-locale detection + language selector

---

## 🎨 Theme & Design System

- `ThemeBloc` for light/dark switching
- Frosted glass UI using `BackdropFilter`
- Colorful gradients
- Unified design system:

  ```
  themes/
  ├── app_colors.dart
  ├── app_gradients.dart
  ├── app_text_styles.dart
  ```
- **Universal constants file for spacing, padding, etc.**  
  Create a single file (e.g. `lib/themes/universal_constants.dart`) to define all spacing, padding, and sizing constants.
- **Hook constants to `BuildContext`**  
  Extend `BuildContext` to access constants directly, e.g. `context.universalPadding`, `context.spacingSmall`, etc.
- **Option to use custom fonts** (configure in design system)
- `line_icons` (1000+ icons)

---

## 🧩 Preconfigured Plugins

- `flutter_bloc`
- `supabase_flutter`
- `flutter_dotenv`
- `fluttertoast`
- `hive` + `hive_flutter`
- `shared_preferences`
- `line_icons`
- `responsive_framework`
- `flutter_localizations`
- `intl`

---

## 🧠 BLoC Integration

- `AuthBloc`, `ThemeBloc`, `LocalizationBloc`
- **Only use BLoC (not Cubit) for state management**
- Centralized state management
- Ready-to-extend event/state definitions
- Proper route control via state

---

## 🧱 Pre-Styled Components

- Buttons: `PrimaryButton`, `IconButton`, `GradientButton`
- Cards: `AppCard`, `GlassCard`, `ExpandableCard`
- Inputs: `CustomTextField`, `TextArea`, `SearchField`
- Lists: `SectionList`, `GridCardList`, `CustomListTile`
- Navigation: `CustomAppBar`, `CustomBottomNavBar`, `Drawer`
- Feedback: `Toast`, `Snackbar`, `ProgressIndicator`
- Toggles: `CustomSwitch`, `CheckboxGroup`, `RadioButtonGroup`
- Other: `Tags`, `Badges`, `ExpandableSections`

---

## ⚠️ Custom Alerts & Bottom Sheets

### ✅ Alert Dialogs
- `CustomAlertDialog` base class:
  - `InfoDialog`, `ErrorDialog`, `ConfirmDialog`, `SuccessDialog`
  - All with relevant icons, optional action buttons
  - Frosted, gradient backgrounds
  - Rounded corners + shadow + vibration effect

### 🧊 iOS-Style Bottom Sheets

- **Pushes app slightly back (like iOS native modals)**
- Uses `showModalBottomSheet` with:
  - `isScrollControlled: true`
  - Custom animated transition
  - Background blur/scale of parent screen
  - Configurable sizes (half, full, fixed)
  - Rounded top corners, draggable indicator
  - Stack-like modal feel (like iOS action sheets)
  - Optional gradient backgrounds and icon titles

---

## 🏠 Pages

- `SplashScreen`: handles session boot
- `WelcomeScreen`: intro + Get Started
- `LoginScreen`, `RegisterScreen`, `ForgotPasswordScreen`
- `HomeScreen`: base authenticated page
- Optional: Profile, Settings (language/theme toggle)

---

## 🌈 Gradients & Design Tokens

- `app_colors.dart` – primary, surface, background, accent
- `app_gradients.dart` – multiple presets: diagonal, radial, vibrant
- `app_text_styles.dart` – defined for all headings/subtitles
- `app_icons.dart` – LineIcons, exported from a central file
- **No need for `app_dimensions.dart` – use the universal constants file instead**

---

## ⚙️ Environment Config

Use `.env.local` for secrets:

```env
SUPABASE_URL=https://xyzproject.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

- Loaded via `flutter_dotenv`
- Hooked in at startup

---

## ✅ Final Expectations

A Flutter app template that is:

- 🔥 Ready to scale
- 🧪 Ideal for fast prototyping
- 🌐 Localized with RTL support
- 🎨 Beautiful by default (frosted glass + gradients)
- 👨‍💻 Developer-friendly with prebuilt components
- 🧠 Well-architected (Bloc pattern)
- 🛠 Extensible with a UI/UX system


