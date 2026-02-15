import 'package:afric/core/theme/design_tokens.dart';
import 'package:afric/presentation/blocs/auth/auth_bloc.dart';
import 'package:afric/presentation/blocs/auth/auth_event.dart';
import 'package:afric/presentation/blocs/auth/auth_state.dart';
import 'package:afric/presentation/pages/dashboard_page.dart';
import 'package:afric/presentation/pages/register_page.dart';
import 'package:afric/presentation/widgets/custom_button.dart';
import 'package:afric/presentation/widgets/custom_text_field.dart';
import 'package:afric/presentation/widgets/glass_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(context),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      AppSizes.p48,
                ),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login successful! Welcome back.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const DashboardPage(),
                        ),
                      );
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInDown(
                          child: Text(
                            'Welcome Back',
                            style: AppTextStyles.headlineLarge,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p8),
                        FadeInDown(
                          delay: const Duration(milliseconds: 200),
                          child: Text(
                            'Login to manage your banking account',
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p48),
                        FadeInUp(
                          child: GlassContainerWidget(
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: 'Email Address',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: AppSizes.p16),
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: true,
                                ),
                                const SizedBox(height: AppSizes.p32),
                                CustomButton(
                                  label: 'Login',
                                  isLoading: state is AuthLoading,
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                      AuthLoginRequested(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.p24),
                        Center(
                          child: FadeInUp(
                            delay: const Duration(milliseconds: 400),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: AppTextStyles.bodyMedium,
                                  children: const [
                                    TextSpan(
                                      text: 'Register',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.15),
            ),
          ),
        ),
      ],
    );
  }
}
