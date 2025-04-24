import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../../../core/constants/universal_constants.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool showObscureTextToggle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.focusNode,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.showObscureTextToggle = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.borderColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use the provided border color or calculate a default one that matches the card border
    final borderColor =
        widget.borderColor ??
        (isDark ? Colors.white.withAlpha(25) : Colors.black.withAlpha(25));

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon:
            widget.prefixIcon != null
                ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UniversalConstants.spacingMedium,
                    vertical: UniversalConstants.spacingSmall,
                  ),
                  child: widget.prefixIcon,
                )
                : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 56,
          minHeight: 56,
        ),
        suffixIcon:
            widget.showObscureTextToggle
                ? IconButton(
                  icon: Icon(
                    _obscureText ? LineIcons.eyeSlash : LineIcons.eye,
                    color: theme.iconTheme.color,
                  ),
                  padding: const EdgeInsets.all(
                    UniversalConstants.spacingMedium,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            UniversalConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(color: borderColor, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            UniversalConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(color: borderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            UniversalConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            UniversalConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            UniversalConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UniversalConstants.spacingMedium,
          vertical: UniversalConstants.spacingMedium,
        ),
        filled: true,
        fillColor: isDark ? Colors.black12 : Colors.white,
      ),
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
    );
  }
}
