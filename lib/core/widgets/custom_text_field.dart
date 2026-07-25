import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CustomTextField
// ─────────────────────────────────────────────────────────────────────────────

/// A themed text input field consistent with the Nari Suraksha design system.
///
/// Wraps [TextFormField] and wires up the ambient [InputDecorationTheme]
/// defined in [AppTheme].  All colours and text styles are sourced from
/// [AppColors] and [AppTextStyles] — no hardcoded values.
///
/// ```dart
/// CustomTextField(
///   label: 'Email address',
///   hint: 'you@example.com',
///   prefixIcon: Icons.email_outlined,
///   keyboardType: TextInputType.emailAddress,
///   validator: (v) => v!.isEmpty ? 'Required' : null,
/// )
/// ```
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.helperText,
    this.errorText,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
  });

  /// Floating label shown above the field when focused.
  final String label;

  /// Placeholder text inside the field.
  final String? hint;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Icon displayed at the left edge of the field.
  final IconData? prefixIcon;

  /// Widget displayed at the right edge of the field.
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// Validation callback for use inside a [Form].
  final FormFieldValidator<String>? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Maximum number of visible lines (1 = single-line).
  final int maxLines;
  final int? minLines;
  final int? maxLength;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  /// Small helper text below the field.
  final String? helperText;

  /// Error text below the field (overrides [helperText]).
  final String? errorText;

  final TextCapitalization textCapitalization;

  /// Pre-populated value when the field has no controller.
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      initialValue: initialValue,
      style: AppTextStyles.bodyLarge.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        labelStyle: AppTextStyles.inputLabel.copyWith(color: cs.onSurfaceVariant),
        hintStyle: AppTextStyles.inputHint,
        helperStyle: AppTextStyles.caption,
        errorStyle: AppTextStyles.errorText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
