import 'package:afric/core/theme/design_tokens.dart';
import 'package:afric/presentation/blocs/auth/auth_bloc.dart';
import 'package:afric/presentation/blocs/auth/auth_event.dart';
import 'package:afric/presentation/blocs/auth/auth_state.dart';
import 'package:afric/presentation/pages/dashboard_page.dart';
import 'package:afric/presentation/widgets/custom_button.dart';
import 'package:afric/presentation/widgets/custom_text_field.dart';
import 'package:afric/presentation/widgets/glass_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedCurrency = 'XAF';

  final List<String> _currencies = [
    'XAF',
    'USD',
    'EUR',
    'CAD',
    'GBP',
    'ZAR',
    'NGN',
    'EGP',
    'KES',
    'GHS',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(context),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p24),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account created successfully! Welcome.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                      (route) => false,
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BackButton(color: Colors.white),
                      const SizedBox(height: AppSizes.p20),
                      FadeInDown(
                        child: Text(
                          'Create Account',
                          style: AppTextStyles.headlineLarge,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p8),
                      FadeInDown(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          'Start your journey with us today',
                          style: AppTextStyles.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p48),
                      FadeInUp(
                        child: GlassContainerWidget(
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _nameController,
                                hintText: 'Full Name',
                                prefixIcon: Icons.person_outline,
                              ),
                              const SizedBox(height: AppSizes.p16),
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
                              const SizedBox(height: AppSizes.p16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCurrency,
                                    dropdownColor: AppColors.surface,
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    style: AppTextStyles.bodyLarge,
                                    items: _currencies.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedCurrency = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.p32),
                              CustomButton(
                                label: 'Register',
                                isLoading: state is AuthLoading,
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    AuthRegisterRequested(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      currency: _selectedCurrency,
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
                            onPressed: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: AppTextStyles.bodyMedium,
                                children: const [
                                  TextSpan(
                                    text: 'Login',
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
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
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
