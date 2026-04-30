import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';

import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/core/utils/validators.dart';
import 'package:jastar_hub_community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:jastar_hub_community/shared/widgets/app_button.dart';
import 'package:jastar_hub_community/shared/widgets/app_text_field.dart';

/// Login page with premium glassmorphism design.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.darkGradient : null,
            color: isDark ? null : AppColors.backgroundLight,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // Back to onboarding or logo
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.hub_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Title
                        Text(
                          context.tr('welcome_back'),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.tr('sign_in_subtitle'),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AppTextField(
                                label: context.tr('email'),
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validators.email(
                                  value,
                                  emptyMsg: context.tr('email_required'),
                                  invalidMsg: context.tr('email_invalid'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                label: context.tr('password'),
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: true,
                                controller: _passwordController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _onLogin(),
                                validator: (value) => Validators.password(
                                  value,
                                  emptyMsg: context.tr('password_required'),
                                  shortMsg:
                                      context.tr('password_too_short'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.push('/forgot-password'),
                            child: Text(
                              context.tr('forgot_password'),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AppButton(
                              text: context.tr('sign_in'),
                              isLoading: state is AuthLoading,
                              onPressed: _onLogin,
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDark
                                    ? AppColors.dividerDark
                                    : AppColors.dividerLight,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textTertiaryDark
                                      : AppColors.textTertiaryLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark
                                    ? AppColors.dividerDark
                                    : AppColors.dividerLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Register link
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.tr('dont_have_account'),
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/register'),
                                child: Text(
                                  context.tr('sign_up_link'),
                                  style: GoogleFonts.inter(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
