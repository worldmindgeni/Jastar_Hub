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

/// Registration page with premium design.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthRegisterRequested(
            name: _nameController.text.trim(),
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
                        const SizedBox(height: 20),

                        // Back button
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          context.tr('create_account'),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.tr('register_subtitle'),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AppTextField(
                                label: context.tr('full_name'),
                                prefixIcon: Icons.person_outline_rounded,
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validators.name(
                                  value,
                                  emptyMsg: context.tr('name_required'),
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validators.password(
                                  value,
                                  emptyMsg:
                                      context.tr('password_required'),
                                  shortMsg:
                                      context.tr('password_too_short'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                label: context.tr('confirm_password'),
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: true,
                                controller: _confirmPasswordController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _onRegister(),
                                validator: (value) =>
                                    Validators.confirmPassword(
                                  value,
                                  _passwordController.text,
                                  mismatchMsg: context
                                      .tr('passwords_dont_match'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Register button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AppButton(
                              text: context.tr('sign_up'),
                              isLoading: state is AuthLoading,
                              onPressed: _onRegister,
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login link
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.tr('already_have_account'),
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: Text(
                                  context.tr('sign_in_link'),
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
