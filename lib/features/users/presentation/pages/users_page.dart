import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/shimmer.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/users/domain/entities/user_entity.dart';
import 'package:banking_app/features/users/presentation/bloc/users_bloc.dart';
import 'package:banking_app/features/users/presentation/bloc/users_event.dart';
import 'package:banking_app/features/users/presentation/bloc/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// Users Demo Page - Demonstrates GraphQL integration with BLoC
///
/// Flow: UI Action → Event → BLoC → Repository (GraphQL) → State → UI
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BAScaffold(
        appBar: BAAppBar(
          title: 'GraphQL Users Demo',
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocConsumer<UsersBloc, UsersState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            return Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Users List Section
                          _UsersListSection(state: state),
                        ],
                      ),
                    ),
                  ),
                ),

                // Action Buttons at bottom
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(0x1A),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: _ActionButtons(isLoading: state.isLoading),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, UsersState state) {
    // Handle loading overlay
    state.status.maybeWhen(
      loading: () => context.loaderOverlay.show(),
      success: () {
        if (context.mounted) context.loaderOverlay.hide();
      },
      failure: () {
        if (context.mounted) context.loaderOverlay.hide();
      },
      orElse: () {
        if (context.mounted) context.loaderOverlay.hide();
      },
    );

    // Show success message
    if (state.successMessage != null) {
      BASnackBar.buildSuccessSnackbar(context, state.successMessage!);
    }

    // Show error message
    if (state.errorMessage != null && state.hasError) {
      BASnackBar.buildErrorSnackbar(context, state.errorMessage!);
    }
  }
}

/// Action buttons for loading and adding users
class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BAElevatedButton(
          height: 50,
          padding: EdgeInsets.zero,
          text: 'Load Users',
          onPressed: isLoading
              ? null
              : () => context.read<UsersBloc>().add(const LoadUsersEvent()),
        ),
        const SizedBox(height: 12),
        BAElevatedButton(
          height: 50,
          padding: EdgeInsets.zero,
          text: 'Add User',
          onPressed: isLoading ? null : () => _showAddUserDialog(context),
        ),
      ],
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add New User',
          style: context.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.secondary,
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter user name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: context.colorScheme.secondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email address',
                  prefixIcon: Icon(
                    Icons.email,
                    color: context.colorScheme.secondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colorScheme.scrim),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<UsersBloc>().add(
                  AddUserEvent(
                    name: nameController.text,
                    email: emailController.text,
                  ),
                );
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(
              'Add User',
              style: TextStyle(color: context.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section displaying the list of users
class _UsersListSection extends StatelessWidget {
  const _UsersListSection({required this.state});

  final UsersState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people, size: 24, color: context.colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              'Users List',
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.secondary,
              ),
            ),
            const Spacer(),
            if (state.users.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${state.users.length}',
                  style: context.bodySmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _buildContent(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return state.status.when(
      initial: () => _buildEmptyState(context),
      loading: () => const _UsersListSkeleton(),
      success: () => state.users.isEmpty
          ? _buildEmptyState(context)
          : _buildUsersList(context),
      failure: () => _buildErrorState(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: context.colorScheme.scrim.withAlpha(0x80),
            ),
            const SizedBox(height: 16),
            Text(
              'No users yet',
              style: context.titleMedium?.copyWith(
                color: context.colorScheme.scrim,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Load Users" to fetch data via GraphQL query',
              textAlign: TextAlign.center,
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.scrim.withAlpha(0x99),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Card(
      elevation: 2,
      color: context.colorScheme.error.withAlpha(0x1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.colorScheme.error.withAlpha(0x4D),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load users',
              style: context.titleMedium?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.error.withAlpha(0xCC),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(BuildContext context) {
    return Column(
      children: state.users.map((user) {
        return _UserCard(user: user);
      }).toList(),
    );
  }
}

/// Individual user card
class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colorScheme.secondary.withAlpha(0x1A),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: context.titleMedium?.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: context.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.scrim,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 14,
                        color: context.colorScheme.scrim.withAlpha(0x99),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.email,
                          style: context.bodySmall?.copyWith(
                            color: context.colorScheme.scrim.withAlpha(0x99),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (user.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: context.colorScheme.scrim.withAlpha(0x80),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(user.createdAt!),
                          style: context.bodySmall?.copyWith(
                            color: context.colorScheme.scrim.withAlpha(0x80),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Delete Button
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: context.colorScheme.error,
              ),
              onPressed: () => _confirmDeleteUser(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete User',
          style: context.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.error,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${user.name}"?',
          style: context.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colorScheme.scrim),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.read<UsersBloc>().add(DeleteUserEvent(id: user.id));
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: context.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Skeleton loading for users list
class _UsersListSkeleton extends StatelessWidget {
  const _UsersListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => const _UserCardSkeleton()),
    );
  }
}

/// Skeleton loading for individual user card
class _UserCardSkeleton extends StatelessWidget {
  const _UserCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BAShimmerLoading(
          child: Row(
            children: [
              // Avatar Skeleton
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),

              // Info Skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
