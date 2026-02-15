import 'package:afric/core/theme/design_tokens.dart';
import 'package:afric/data/models/account_model.dart';
import 'package:afric/presentation/blocs/account/account_bloc.dart';
import 'package:afric/presentation/blocs/account/account_event.dart';
import 'package:afric/presentation/blocs/account/account_state.dart';
import 'package:afric/presentation/blocs/auth/auth_bloc.dart';
import 'package:afric/presentation/blocs/auth/auth_event.dart';
import 'package:afric/presentation/blocs/auth/auth_state.dart';
import 'package:afric/presentation/pages/login_page.dart';
import 'package:afric/presentation/widgets/custom_button.dart';
import 'package:afric/presentation/widgets/glass_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(AccountFetchRequested());
  }

  String name = '';
  String email = '';
  String balance = '\$0.00';
  String accountNumber = '---- ---- ----';
  String currency = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: AppTextStyles.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.read<AccountBloc>().add(AccountReset());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          context.read<AccountBloc>().add(AccountFetchRequested());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      name = state.user.user!.name ?? '';
                      email = state.user.user!.email ?? '';
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $name ',
                          style: AppTextStyles.headlineMedium,
                        ),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.p24),
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, state) {
                    // Capture previous data if available to prevent flicker
                    final prevAccount =
                        (context.read<AccountBloc>().state is AccountSuccess)
                        ? (context.read<AccountBloc>().state as AccountSuccess)
                              .account
                        : null;

                    if (state is AccountSuccess) {
                      balance =
                          NumberFormat.currency(
                            symbol: state.account.currency == 'USD' ? '\$' : '',
                          ).format(
                            double.tryParse(state.account.balance ?? '0') ??
                                0.0,
                          );
                      accountNumber =
                          state.account.accountNumber ?? '---- ---- ----';
                      currency = state.account.currency ?? '';
                    } else if (prevAccount != null) {
                      balance =
                          NumberFormat.currency(
                            symbol: prevAccount.currency == 'USD' ? '\$' : '',
                          ).format(
                            double.tryParse(prevAccount.balance ?? '0') ?? 0.0,
                          );
                      accountNumber =
                          prevAccount.accountNumber ?? '---- ---- ----';
                      currency = prevAccount.currency ?? '';
                    }

                    return GlassContainerWidget(
                      height: 220,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Balance ${currency.isNotEmpty ? "($currency)" : ""}',
                                style: AppTextStyles.bodyLarge,
                              ),
                              const SizedBox(height: AppSizes.p8),
                              Text(
                                balance,
                                style: AppTextStyles.headlineLarge.copyWith(
                                  fontSize: 40,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    accountNumber,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      letterSpacing: 2,
                                      color: Colors.white38,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.credit_card,
                                    color: Colors.white38,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (state is AccountLoading)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.p32),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Quick Actions',
                  style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: AppSizes.p16),
              Row(
                children: [
                  Expanded(
                    child: FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      child: _ActionCard(
                        icon: Icons.add_circle_outline,
                        label: 'Credit',
                        color: AppColors.success,
                        onTap: () => _showTransactionDialog(context, 'Credit'),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.p16),
                  Expanded(
                    child: FadeInRight(
                      delay: const Duration(milliseconds: 300),
                      child: _ActionCard(
                        icon: Icons.remove_circle_outline,
                        label: 'Debit',
                        color: AppColors.accent,
                        onTap: () => _showTransactionDialog(context, 'Debit'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p32),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'Recent Transactions',
                  style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: AppSizes.p16),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, state) {
                    final prevState = context.read<AccountBloc>().state;
                    final prevTransactions = (prevState is AccountSuccess)
                        ? prevState.transactions
                        : <AccountJournal>[];

                    final transactions = (state is AccountSuccess)
                        ? state.transactions
                        : prevTransactions;

                    if (transactions.isNotEmpty) {
                      return Column(
                        children: transactions.map((tx) {
                          final direction = tx.direction ?? 'Transaction';
                          final isCredit = direction == 'CREDIT';
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSizes.p12,
                            ),
                            child: GlassContainerWidget(
                              padding: const EdgeInsets.all(AppSizes.p16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isCredit
                                        ? AppColors.success.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.accent.withValues(
                                            alpha: 0.2,
                                          ),
                                    child: Icon(
                                      isCredit
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: isCredit
                                          ? AppColors.success
                                          : AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.p16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          direction,
                                          style: AppTextStyles.bodyLarge
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          'Before: ${tx.balanceBefore ?? '0'} | After: ${tx.balanceAfter ?? '0'}',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(color: Colors.white38),
                                        ),
                                        Text(
                                          DateFormat.yMMMd().add_jm().format(
                                            DateTime.tryParse(
                                                  tx.createdAt ?? '',
                                                ) ??
                                                DateTime.now(),
                                          ),
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: Colors.white38,
                                                fontSize: 10,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                      symbol: '',
                                    ).format(tx.amount ?? 0),
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: isCredit
                                          ? AppColors.success
                                          : AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return GlassContainerWidget(
                      child: Center(
                        child: Text(
                          'No recent transactions',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDialog(BuildContext context, String type) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          '$type Account',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter amount',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.bodyMedium),
          ),
          SizedBox(
            width: 120,
            child: CustomButton(
              label: 'Confirm',
              onPressed: () {
                final amount = double.tryParse(controller.text) ?? 0.0;
                if (type == 'Credit') {
                  context.read<AccountBloc>().add(
                    AccountCreditRequested(amount),
                  );
                } else {
                  context.read<AccountBloc>().add(
                    AccountDebitRequested(amount),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: GlassContainerWidget(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
