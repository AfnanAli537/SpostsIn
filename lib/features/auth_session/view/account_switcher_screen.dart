import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountSwitcherBottomSheet extends StatefulWidget {
  const AccountSwitcherBottomSheet({super.key});

  @override
  State<AccountSwitcherBottomSheet> createState() =>
      _AccountSwitcherBottomSheetState();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AccountSwitcherBottomSheet(),
    );
  }
}

class _AccountSwitcherBottomSheetState
    extends State<AccountSwitcherBottomSheet> {
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
    if (account.userId == _activeAccountId) {
      Navigator.pop(context); // Just close if already active
      return;
    }

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
    ConfirmationDialog.show(
      context: context,
      title: 'Remove Account',
      message:
          'Are you sure you want to remove this account? You can add it back later by logging in again.',
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Title
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Text(
                  string.switchAccount,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[300]),

          // Accounts list
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(32.r),
              child: const CircularProgressIndicator(),
            )
          else if (_accounts.isEmpty)
            _buildEmptyState(theme, string)
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: _accounts.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey[200], indent: 72.w),
                itemBuilder: (context, index) {
                  final account = _accounts[index];
                  final isActive = account.userId == _activeAccountId;

                  return _buildAccountTile(account, isActive, theme);
                },
              ),
            ),

          // Add account button
          Padding(
            padding: EdgeInsets.all(16.r),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.add),
              label: Text(string.addAccount),
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

          // Safe area bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildAccountTile(
    LoginResponse account,
    bool isActive,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () => _switchAccount(account),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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

            // Account info
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

            // Remove button (only if more than 1 account)
            if (_accounts.length > 1)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onError.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => _removeAccount(account),
                  icon: Icon(
                    Icons.close,
                    // color: Colors.red[700],
                    size: 20.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, S string) {
    return Padding(
      padding: EdgeInsets.all(32.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No saved accounts',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add an account to get started',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
