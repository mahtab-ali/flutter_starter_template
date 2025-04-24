# Flutter Starter Template

A comprehensive Flutter starter template that implements Clean Architecture with a modular approach, featuring authentication, localization, theming, BLoC state management, and beautiful UI components.

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
- 🏗️ **Clean Architecture** - Well-defined separation of concerns
- 💉 **Dependency Injection** - Service locator pattern for better testability

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

### 2. Rename the project (Optional)

This template includes an interactive utility script to rename the project for your own use:

```bash
# Make the script executable (if needed)
chmod +x rename_project.sh

# Run the script (no arguments needed)
./rename_project.sh
```

The script will:
- Show your current project name and bundle ID
- Prompt you to enter a new project name
- Display what will change before asking for confirmation
- Update the package name in pubspec.yaml
- Modify app_config.dart with your project name
- Update all import statements in Dart files
- Configure Android and iOS package names and bundle identifiers

After running the script:
```bash
# Clean the project to rebuild with new name
flutter clean
# Get dependencies
flutter pub get
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Configure environment variables

Create a `.env` file in the project root with your Supabase details:

```
SUPABASE_URL=https://your-supabase-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
```

### 5. Run the app

```bash
flutter run
```

## 🏗️ Clean Architecture Overview

This template follows Clean Architecture principles to create a maintainable, testable, and scalable application. The architecture is divided into three main layers:

### 1. Presentation Layer
- Contains UI components, screens, widgets
- Handles user interaction and displays data
- Implements BLoC pattern for state management
- Location: `lib/presentation/`

### 2. Domain Layer
- Contains business logic and rules
- Defines entities, use cases, and repository interfaces
- Pure Dart code with no dependencies on external frameworks
- Location: `lib/domain/`

### 3. Data Layer
- Implements repositories defined in the domain layer
- Manages data sources (remote API, local storage)
- Handles data transformation between entities and models
- Location: `lib/data/`

### Flow Between Layers

1. **User Interaction Flow**:
   - User interacts with the UI (Presentation Layer)
   - BLoC dispatches events and converts them to use case calls
   - Use cases execute business logic (Domain Layer)
   - Repositories retrieve/manipulate data (Data Layer)
   - Data flows back up through the layers to update the UI

2. **Dependency Direction**:
   - Outer layers depend on inner layers (Presentation → Domain ← Data)
   - Domain layer has no dependencies on other layers
   - This ensures the business logic remains isolated and testable

## 📁 Project Structure

```
lib/
├── config/                # App configuration
│   ├── app_config.dart    # Global app configuration
│   ├── routes.dart        # Route definitions
│   ├── localization/      # Localization configuration
│   └── themes/            # Theme configuration
├── core/                  # Core functionality
│   ├── constants/         # App constants
│   ├── di/                # Dependency injection
│   ├── errors/            # Error handling
│   ├── network/           # Network utilities
│   ├── services/          # App-wide services
│   └── utils/             # Utility functions
├── data/                  # Data layer
│   ├── datasources/       # Data sources
│   │   ├── local/         # Local storage sources
│   │   └── remote/        # Remote API sources
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic use cases
├── presentation/          # Presentation layer
│   ├── app.dart           # Main app widget
│   ├── auth/              # Authentication features
│   │   ├── bloc/          # Authentication BLoC
│   │   ├── pages/         # Authentication screens
│   │   └── widgets/       # Authentication widgets
│   ├── common/            # Shared UI components
│   ├── home/              # Home screen features
│   ├── onboarding/        # Onboarding features
│   ├── profile/           # User profile features
│   ├── settings/          # App settings features
│   └── navigation/        # Navigation services
└── main.dart              # App entry point
```

## 🧪 Adding a New Module

A module is a self-contained feature with its own presentation, domain, and data components. Follow these steps to add a new module:

### 1. Plan Your Module

First, define what your module will do and identify:
- The UI components needed
- The entities and models required
- The business logic operations (use cases)
- Data sources needed (API endpoints, local storage)

### 2. Create Domain Layer Components

```dart
// 1. Create entity in domain/entities/
class MyEntity extends Equatable {
  final String id;
  final String name;
  
  const MyEntity({required this.id, required this.name});
  
  @override
  List<Object> get props => [id, name];
}

// 2. Define repository interface in domain/repositories/
abstract class MyRepository {
  Future<Either<Failure, List<MyEntity>>> getAllItems();
  Future<Either<Failure, MyEntity>> getItemById(String id);
  Future<Either<Failure, void>> saveItem(MyEntity item);
}

// 3. Create use cases in domain/usecases/my_module/
class GetAllItemsUseCase {
  final MyRepository repository;
  
  GetAllItemsUseCase(this.repository);
  
  Future<Either<Failure, List<MyEntity>>> call() {
    return repository.getAllItems();
  }
}
```

### 3. Implement Data Layer

```dart
// 1. Create data models in data/models/
class MyModel extends MyEntity {
  const MyModel({required String id, required String name})
      : super(id: id, name: name);
  
  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'],
      name: json['name'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
  
  factory MyModel.fromEntity(MyEntity entity) {
    return MyModel(id: entity.id, name: entity.name);
  }
}

// 2. Create data sources in data/datasources/
abstract class MyRemoteDataSource {
  Future<List<MyModel>> getAllItems();
  Future<MyModel> getItemById(String id);
  Future<void> saveItem(MyModel item);
}

class MyRemoteDataSourceImpl implements MyRemoteDataSource {
  final SupabaseClient supabaseClient;
  
  MyRemoteDataSourceImpl(this.supabaseClient);
  
  @override
  Future<List<MyModel>> getAllItems() async {
    final response = await supabaseClient.from('my_table').select().execute();
    return (response.data as List)
        .map((item) => MyModel.fromJson(item))
        .toList();
  }
  
  // ... implement other methods
}

// 3. Implement repository in data/repositories/
class MyRepositoryImpl implements MyRepository {
  final MyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  MyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<MyEntity>>> getAllItems() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllItems();
        return Right(result);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  
  // ... implement other methods
}
```

### 4. Create Presentation Layer

```dart
// 1. Define BLoC events
abstract class MyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAllItemsEvent extends MyEvent {}

// 2. Define BLoC states
abstract class MyState extends Equatable {
  @override
  List<Object> get props => [];
}

class MyInitial extends MyState {}
class MyLoading extends MyState {}
class MyLoaded extends MyState {
  final List<MyEntity> items;
  
  MyLoaded(this.items);
  
  @override
  List<Object> get props => [items];
}
class MyError extends MyState {
  final String message;
  
  MyError(this.message);
  
  @override
  List<Object> get props => [message];
}

// 3. Implement BLoC
class MyBloc extends Bloc<MyEvent, MyState> {
  final GetAllItemsUseCase getAllItemsUseCase;
  
  MyBloc({required this.getAllItemsUseCase}) : super(MyInitial()) {
    on<FetchAllItemsEvent>(_onFetchAllItems);
  }
  
  Future<void> _onFetchAllItems(
    FetchAllItemsEvent event,
    Emitter<MyState> emit,
  ) async {
    emit(MyLoading());
    final result = await getAllItemsUseCase();
    result.fold(
      (failure) => emit(MyError(_mapFailureToMessage(failure))),
      (items) => emit(MyLoaded(items)),
    );
  }
  
  String _mapFailureToMessage(Failure failure) {
    // Map failures to user-friendly messages
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again.';
      case NetworkFailure:
        return 'No internet connection. Please check your connection.';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}

// 4. Create UI pages and widgets
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyBloc>()..add(FetchAllItemsEvent()),
      child: Scaffold(
        appBar: CustomAppBar(title: 'My Module'),
        body: BlocBuilder<MyBloc, MyState>(
          builder: (context, state) {
            if (state is MyLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MyLoaded) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(title: Text(item.name));
                },
              );
            } else if (state is MyError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('Press the button to load items'));
          },
        ),
      ),
    );
  }
}
```

### 5. Register Dependencies

Update the dependency injection container in `lib/core/di/injection_container.dart`:

```dart
// Add at the initialization function or in a separate function
Future<void> _initMyModule() async {
  // BLoC
  sl.registerFactory(() => MyBloc(getAllItemsUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAllItemsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MyRepository>(
    () => MyRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MyRemoteDataSource>(
    () => MyRemoteDataSourceImpl(sl()),
  );
}
```

### 6. Add to Navigation Routes

Update `lib/config/routes.dart` to include your new module:

```dart
// Add route constant
static const String myModule = '/my-module';

// Add to route generator
static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    // ... existing routes
    case myModule:
      return MaterialPageRoute(builder: (_) => MyPage());
    // ...
  }
}
```

## 🤝 Module Integration Flow

The template uses a dependency injection system (powered by get_it) to connect all the layers:

1. **Register Dependencies**: All components are registered in the service locator
2. **BLoCs Access Use Cases**: Presentation layer BLoCs receive required use cases
3. **Use Cases Access Repositories**: Domain layer use cases receive repository implementations
4. **Repositories Access Data Sources**: Data layer repositories receive data source implementations

This flow ensures loose coupling between components and facilitates testing and modifiability.

### Flow Visualization

```
UI → BLoC → UseCase → Repository Interface ← Repository Implementation → DataSource
                        (Domain Layer)         (Data Layer)
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
1. Create a new screen in the appropriate module under `lib/presentation/` directory
2. Add routes in `lib/config/routes.dart`

### Adding New Languages
1. Create a new JSON file in `assets/i18n/` (e.g., `fr.json`)
2. Add the locale to `supportedLocales` in `lib/presentation/app.dart` and in the `LocalizationRepositoryImpl` initialization

### Modifying Theme
1. Edit the theme definitions in `lib/config/themes/theme_data.dart`
2. Customize colors in a theme colors file
3. Update gradients in a theme gradients file

### Adding New UI Components
1. Create a new file in the appropriate directory under `lib/presentation/common/` or in your module's `widgets/` directory
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
4. Create Firebase data sources implementing the existing interfaces
5. Update the dependency injection to use Firebase implementations instead of Supabase

### 2. State Management Alternatives

While this template uses BLoC, you can easily switch to other state management solutions:

- **Provider**: Replace BLoC classes with ChangeNotifier implementations
- **Riverpod**: Create providers and consumers to replace BLoC pattern
- **GetX**: Convert BLoC logic to GetX controllers

### 3. API Integration

The template is structured to easily integrate with any backend:

1. Create API client classes in the `data/datasources/remote/` directory
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
- [get_it](https://pub.dev/packages/get_it) - Dependency injection
- [dartz](https://pub.dev/packages/dartz) - Functional programming utilities
