import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountSwitcherScreen extends StatefulWidget {
  const AccountSwitcherScreen({super.key});

  @override
  State<AccountSwitcherScreen> createState() => _AccountSwitcherScreenState();
}

class _AccountSwitcherScreenState extends State<AccountSwitcherScreen> {
  List<LoginResponse> _accounts = [];
  String? _activeAccountId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() => _isLoading = true);
    
    final accounts = await getIt<SharedPref>().getSavedAccounts();
    final activeId = getIt<SharedPref>().getActiveAccountId();
    
    setState(() {
      _accounts = accounts;
      _activeAccountId = activeId;
      _isLoading = false;
    });
  }

  Future<void> _switchAccount(LoginResponse account) async {
    if (account.userId == _activeAccountId) return;

    try {
      await getIt<SharedPref>().switchAccount(account.userId!);
      
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Switched to ${account.name?.firstName ?? "account"}',
          backgroundColor: Colors.green,
        );
        
        // Navigate to home and clear stack
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.mainLayout,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to switch account',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _removeAccount(LoginResponse account) async {
    await ConfirmationDialog.show(
      context: context,
      title: 'Remove Account',
      message: 'Are you sure you want to remove this account? You can add it back later by logging in again.',
      confirmText: 'Remove',
      isDestructive: true,
      onConfirm: () async {
      try {
        await getIt<SharedPref>().removeAccount(account.userId!);
        await _loadAccounts();
        
        if (mounted) {
          Fluttertoast.showToast(
            msg: 'Account removed',
            backgroundColor: Colors.green,
          );
          
          // If removed active account, go to login
          if (account.userId == _activeAccountId) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: 'Failed to remove account',
            backgroundColor: Colors.red,
          );
        }
      }
    },
    );

    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Account'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _accounts.isEmpty
              ? _buildEmptyState(theme, string)
              : Column(
                  children: [
                    // Accounts List
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(16.w),
                        itemCount: _accounts.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final account = _accounts[index];
                          final isActive = account.userId == _activeAccountId;
                          
                          return _buildAccountCard(
                            account: account,
                            isActive: isActive,
                            theme: theme,
                          );
                        },
                      ),
                    ),

                    // Add Account Button
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.login,
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add account'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          minimumSize: Size(double.infinity, 48.h),
                          side: BorderSide(color: theme.colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildAccountCard({
    required LoginResponse account,
    required bool isActive,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: () => _switchAccount(account),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primaryContainer.withOpacity(0.3)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24.r,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Text(
                (account.name?.firstName ?? 'U')[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Account Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        account.name?.firstName ?? 'User',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isActive) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    account.email ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    account.userType ?? 'User',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Remove Button
            if (_accounts.length > 1)
              IconButton(
                onPressed: () => _removeAccount(account),
                icon: Icon(
                  Icons.close,
                  color: Colors.red[700],
                  size: 20.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, S string) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No saved accounts',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add an account to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Account'),
          ),
        ],
      ),
    );
  }
}