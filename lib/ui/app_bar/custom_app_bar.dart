import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';

import '../../i18n/app_localizations.dart';
import '../../themes/universal_constants.dart';
import '../../widgets/app_bar_actions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? elevation;
  final VoidCallback? onBackPressed;
  final bool showActions;

  const CustomAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.elevation,
    this.onBackPressed,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);
    // Get the text direction to handle RTL/LTR properly
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      title: title != null ? Text(title!) : null,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      systemOverlayStyle: systemOverlayStyle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading:
          leading ??
          (automaticallyImplyLeading && Navigator.of(context).canPop()
              ? IconButton(
                icon: Icon(
                  // Use the appropriate directional icon based on text direction
                  isRtl ? LineIcons.alternateLongArrowRight : LineIcons.alternateLongArrowLeft,
                  size: UniversalConstants.iconSizeLarge,
                ),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                tooltip: i18n.translate('back'),
              )
              : null),
      actions: showActions ? actions ?? const [AppBarActions()] : actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
