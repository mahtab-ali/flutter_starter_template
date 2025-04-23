import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../blocs/onboarding/onboarding_bloc.dart';
import '../../blocs/onboarding/onboarding_event.dart';
import '../../blocs/onboarding/onboarding_state.dart';
import '../../config/routes.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/universal_constants.dart';
import '../../utils/helper.dart';
import '../../widgets/app_bar_actions.dart';
import '../../widgets/onboarding/onboarding_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: UniversalConstants.animationDurationSlow,
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
    _animationController.reset();
    _animationController.forward();
  }

  void _completeOnboarding() {
    context.read<OnboardingBloc>().add(OnboardingCompleted());
    AppRoutes.navigateAndRemoveUntil(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);
    final isRTL = i18n.isRtl;

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingInProgress) {
          final currentPage = state.currentPage;
          final totalPages = state.totalPages;

          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            extendBodyBehindAppBar: true,
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
            body: Stack(
              children: [
                // Decorative background elements
                Positioned(
                  top: -100,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withAlpha(10),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -30,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withAlpha(8),
                    ),
                  ),
                ),

                // Main content with SafeArea
                SafeArea(
                  // Use column for the main layout structure
                  child: Column(
                    children: [
                      const SizedBox(height: UniversalConstants.spacingLarge),

                      // Page content with smooth slide transition - takes available space
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          physics: const BouncingScrollPhysics(),
                          reverse: isRTL,
                          itemCount: totalPages,
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double value = 1.0;

                                if (_pageController.position.haveDimensions) {
                                  value = _pageController.page! - index;
                                  value = (1 - (value.abs() * 0.5)).clamp(
                                    0.0,
                                    1.0,
                                  );
                                }

                                return Transform.translate(
                                  offset: Offset(0, 30 * (1 - value)),
                                  child: Opacity(opacity: value, child: child),
                                );
                              },
                              child: _getOnboardingPage(
                                index,
                                currentPage,
                                theme,
                                i18n,
                              ),
                            );
                          },
                        ),
                      ),

                      // Page indicators - fixed at bottom of content area
                      _buildPageIndicators(currentPage, totalPages, theme),

                      // Navigation area - always stays at bottom
                      _buildNavigationArea(
                        currentPage,
                        totalPages,
                        theme,
                        i18n,
                        isRTL,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // For any other state, return an empty container
        return Container();
      },
    );
  }

  // Returns the appropriate onboarding page content
  Widget _getOnboardingPage(
    int index,
    int currentPage,
    ThemeData theme,
    AppLocalizations i18n,
  ) {
    return OnboardingCard(
      icon:
          index == 0
              ? LineIcons.rocket
              : index == 1
              ? LineIcons.alternateShield
              : LineIcons.paintBrush,
      title: i18n.translate(
        index == 0
            ? 'onboarding_welcome_title'
            : index == 1
            ? 'onboarding_auth_title'
            : 'onboarding_customize_title',
      ),
      description: i18n.translate(
        index == 0
            ? 'onboarding_welcome_description'
            : index == 1
            ? 'onboarding_auth_description'
            : 'onboarding_customize_description',
      ),
      index: index,
      currentIndex: currentPage,
    );
  }

  // Builds page indicators that stay fixed at the bottom
  Widget _buildPageIndicators(
    int currentPage,
    int totalPages,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: UniversalConstants.spacingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0.0,
              end: currentPage == index ? 1.0 : 0.0,
            ),
            duration: UniversalConstants.animationDurationMedium,
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: UniversalConstants.spacingXSmall,
                ),
                height: 6,
                width: 6 + (value * 18), // Animates from 6 to 24
                decoration: BoxDecoration(
                  color: Color.lerp(
                    theme.colorScheme.primary.withAlpha(75),
                    theme.colorScheme.primary,
                    value,
                  ),
                  borderRadius: BorderRadius.circular(
                    UniversalConstants.borderRadiusFull,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Builds the navigation area that stays fixed at the bottom
  Widget _buildNavigationArea(
    int currentPage,
    int totalPages,
    ThemeData theme,
    AppLocalizations i18n,
    bool isRTL,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
      child: Row(
        children: [
          // Next/Get Started button without arrow
          Expanded(
            child: AnimatedContainer(
              duration: UniversalConstants.animationDurationMedium,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withAlpha(230),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(
                  UniversalConstants.borderRadiusFull,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    UniversalConstants.borderRadiusFull,
                  ),
                  onTap: () {
                    if (currentPage < totalPages - 1) {
                      _pageController.nextPage(
                        duration: UniversalConstants.animationDurationSlow,
                        curve: Curves.easeInOutCubic,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  child: Center(
                    child: Text(
                      currentPage < totalPages - 1
                          ? i18n.translate('next')
                          : i18n.translate('get_started'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Skip button as circular button with arrow
          const SizedBox(width: UniversalConstants.spacingMedium),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _completeOnboarding,
              borderRadius: BorderRadius.circular(28),
              child: AnimatedContainer(
                duration: UniversalConstants.animationDurationMedium,
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface,
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha(50),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Helper.getDirectionalIcon(
                      context,
                      LineIcons.alternateLongArrowRight,
                      LineIcons.alternateLongArrowLeft,
                    ),
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
