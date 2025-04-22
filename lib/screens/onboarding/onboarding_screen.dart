import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import '../../blocs/onboarding/onboarding_bloc.dart';
import '../../blocs/onboarding/onboarding_event.dart';
import '../../blocs/onboarding/onboarding_state.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/app_gradients.dart';
import '../../themes/universal_constants.dart';
import '../../ui/buttons/gradient_button.dart';
import '../../widgets/onboarding/onboarding_card.dart';
import '../../widgets/app_bar_actions.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for subtle animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<OnboardingBloc>().add(OnboardingPageChanged(pageIndex: index));

    // Reset and forward animation for new page content
    _animationController.reset();
    _animationController.forward();
  }

  void _completeOnboarding() {
    context.read<OnboardingBloc>().add(OnboardingCompleted());
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final i18n = AppLocalizations.of(context);
    final isRTL = i18n.isRtl;

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingInProgress) {
          final currentPage = state.currentPage;
          final totalPages = state.totalPages;

          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                // Language toggle button on the right
                const AppBarActions(
                  showThemeToggle: false,
                  showLanguageSelector: true,
                  groupActions: false,
                ),
              ],
              leading: const AppBarActions(
                // Theme toggle button on the left
                showThemeToggle: true,
                showLanguageSelector: false,
                groupActions: false,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Page content
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: [
                        // First onboarding page
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: OnboardingCard(
                            icon: LineIcons.rocket,
                            title: i18n.translate('onboarding_welcome_title'),
                            description: i18n.translate(
                              'onboarding_welcome_description',
                            ),
                            index: 0,
                            currentIndex: currentPage,
                          ),
                        ),

                        // Second onboarding page
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: OnboardingCard(
                            icon: LineIcons.alternateShield,
                            title: i18n.translate('onboarding_auth_title'),
                            description: i18n.translate(
                              'onboarding_auth_description',
                            ),
                            index: 1,
                            currentIndex: currentPage,
                          ),
                        ),

                        // Third onboarding page
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: OnboardingCard(
                            icon: LineIcons.paintBrush,
                            title: i18n.translate('onboarding_customize_title'),
                            description: i18n.translate(
                              'onboarding_customize_description',
                            ),
                            index: 2,
                            currentIndex: currentPage,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Page indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: UniversalConstants.spacingMedium,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        totalPages,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                            horizontal: UniversalConstants.spacingXSmall,
                          ),
                          height: 8,
                          width: currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color:
                                currentPage == index
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary.withAlpha(75),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Navigation buttons
                  Padding(
                    padding: const EdgeInsets.all(
                      UniversalConstants.spacingLarge,
                    ),
                    child: Row(
                      children: [
                        // Expanded space for full width next button
                        Expanded(
                          child: GradientButton(
                            text:
                                currentPage < totalPages - 1
                                    ? i18n.translate('next')
                                    : i18n.translate('get_started'),
                            borderRadius: BorderRadius.circular(
                              UniversalConstants.borderRadiusFull,
                            ),
                            onPressed: () {
                              if (currentPage < totalPages - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _completeOnboarding();
                              }
                            },
                            gradient: AppGradients.primaryDiagonal(
                              isDark: isDark,
                            ),
                          ),
                        ),

                        // Skip circular button
                        const SizedBox(width: UniversalConstants.spacingMedium),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              isRTL
                                  ? LineIcons.alternateLongArrowLeft
                                  : LineIcons.alternateLongArrowRight,
                              color: theme.colorScheme.primary,
                              size: UniversalConstants.iconSizeMedium,
                            ),
                            onPressed: _completeOnboarding,
                            tooltip: i18n.translate('skip'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // For any other state, return an empty container
        // This will typically not be visible as we'll navigate away
        return Container();
      },
    );
  }
}
