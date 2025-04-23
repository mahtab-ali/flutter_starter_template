import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../i18n/app_localizations.dart';
import '../../utils/helper.dart';
import '../../widgets/app_bar_actions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final bool elevation;
  final List<Widget>? actions;
  final Widget? leading;
  final bool hideActions;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;

  // Standard app bar size
  static const double _kAppBarHeight = kToolbarHeight;

  const CustomAppBar({
    super.key,
    required this.title,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation = false,
    this.actions,
    this.leading,
    this.hideActions = false,
    this.backgroundColor,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(_kAppBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);

    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      elevation: elevation ? 4.0 : 0.0,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      scrolledUnderElevation: 0,
      // If we have a custom leading widget, use it
      leading:
          leading ??
          // Otherwise, check if we should show the back button
          (automaticallyImplyLeading
              ? IconButton(
                icon: Icon(
                  Helper.getDirectionalIcon(
                    context,
                    LineIcons.alternateLongArrowLeft,
                    LineIcons.alternateLongArrowRight,
                  ),
                  color: theme.iconTheme.color,
                ),
                onPressed:
                    onBackPressed ??
                    () {
                      Navigator.pop(context);
                    },
                tooltip: i18n.translate('back'),
              )
              : null),
      // Use provided actions or default app bar actions unless hideActions is true
      actions: hideActions ? null : actions ?? const [AppBarActions()],
    );
  }
}
