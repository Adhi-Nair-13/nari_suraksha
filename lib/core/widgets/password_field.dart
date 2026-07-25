import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PasswordField
// ─────────────────────────────────────────────────────────────────────────────

/// A password text field with an animated show/hide toggle.
///
/// Extends [CustomTextField]'s design contract: uses the same
/// [AppColors], [AppTextStyles], [AppSpacing], and [AppRadius] tokens,
/// and inherits the focused/error border styles from the ambient
/// [InputDecorationTheme].
///
/// ```dart
/// PasswordField(
///   label: 'Password',
///   controller: _passwordController,
///   validator: (v) => v!.length < 8 ? 'Min 8 characters' : null,
/// )
/// ```
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.label = 'Password',
    this.hint,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.enabled = true,
    this.autofocus = false,
    this.helperText,
    this.errorText,
  });

  /// Floating label (defaults to `'Password'`).
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool autofocus;
  final String? helperText;
  final String? errorText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  void _toggle() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscured,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      style: AppTextStyles.bodyLarge.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        errorText: widget.errorText,
        labelStyle:
            AppTextStyles.inputLabel.copyWith(color: cs.onSurfaceVariant),
        hintStyle: AppTextStyles.inputHint,
        helperStyle: AppTextStyles.caption,
        errorStyle: AppTextStyles.errorText,
        prefixIcon: const Icon(Icons.lock_outline_rounded,
            color: AppColors.primary),
        // Animated eye toggle
        suffixIcon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: IconButton(
            key: ValueKey<bool>(_obscured),
            tooltip: _obscured ? 'Show password' : 'Hide password',
            icon: Icon(
              _obscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: cs.onSurfaceVariant,
            ),
            onPressed: widget.enabled ? _toggle : null,
          ),
        ),
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
          borderSide:
              BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
