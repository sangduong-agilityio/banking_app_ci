import 'package:banking_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/setting/presentation/blocs/optimistic_cubit.dart';
import 'package:banking_app/features/setting/presentation/blocs/optimistic_state.dart';
import 'package:banking_app/features/setting/data/models/post.dart';
import 'package:intl/intl.dart';

/// Social Media Feed Demo with Optimistic UI Pattern
class OptimisticUIDemo extends StatefulWidget {
  const OptimisticUIDemo({super.key});

  @override
  State<OptimisticUIDemo> createState() => _OptimisticUIDemoState();
}

class _OptimisticUIDemoState extends State<OptimisticUIDemo> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OptimisticCubit(),
      child: BAScaffold(
        appBar: BAAppBar(
          title: 'Optimistic UI Demo',
          titleColor: context.colorScheme.onPrimary,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.secondary,
        ),
        body: BlocConsumer<OptimisticCubit, OptimisticState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            // Show error message when API call fails
            if (state.status == OptimisticStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: context.colorScheme.error,
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'OK',
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<OptimisticCubit>().clearError();
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Post feed
                Expanded(child: _buildPostFeed(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Build info header explaining Optimistic UI pattern

  /// Build post feed with list of posts
  Widget _buildPostFeed(BuildContext context, OptimisticState state) {
    if (state.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.post_add,
              size: 64,
              color: context.colorScheme.secondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No posts yet',
              style: context.titleMedium?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final post = state.posts[index];
        final isPending = state.pendingPostIds.contains(post.id);
        return _buildPostCard(context, post, isPending);
      },
    );
  }

  /// Build single post card with author, content, image, reactions
  Widget _buildPostCard(BuildContext context, Post post, bool isPending) {
    // All posts have natural appearance
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.secondary.withOpacity(0.1),
            width: 8,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header without badge
          _buildPostHeader(context, post),
          const SizedBox(height: 16),

          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              post.content,
              style: context.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: 16),

          // Post image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildPostImage(post.imageUrl),
          ),
          const SizedBox(height: 16),

          // Reaction counts and stats
          _buildPostStats(context, post),
          const SizedBox(height: 12),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 1,
              color: context.colorScheme.secondary.withOpacity(0.15),
            ),
          ),
          const SizedBox(height: 12),

          // Action buttons: Like, Comment, Share
          _buildActionButtons(context, post, isPending),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Build post header with avatar, author name and timestamp
  Widget _buildPostHeader(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Avatar with gradient
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                post.author[0].toUpperCase(),
                style: context.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Author info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author,
                  style: context.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(post.timestamp),
                  style: context.bodySmall?.copyWith(
                    color: context.colorScheme.secondary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          // More options button
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            color: context.colorScheme.secondary.withOpacity(0.5),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  /// Build post image with rounded corners
  Widget _buildPostImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 240,
            decoration: BoxDecoration(
              color: context.colorScheme.secondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 240,
            decoration: BoxDecoration(
              color: context.colorScheme.secondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 48,
                  color: context.colorScheme.secondary.withOpacity(0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: context.bodySmall?.copyWith(
                    color: context.colorScheme.secondary.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build post stats with styled containers
  Widget _buildPostStats(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Reaction icons + count
          if (post.likeCount > 0) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colorScheme.primary,
                    context.colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.thumb_up, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              post.likeCount.toString(),
              style: context.labelMedium?.copyWith(
                color: context.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const Spacer(),
          // Comments
          if (post.commentCount > 0) ...[
            Icon(
              Icons.chat_bubble_outline,
              size: 14,
              color: context.colorScheme.secondary.withOpacity(0.6),
            ),
            const SizedBox(width: 4),
            Text(
              '${post.commentCount}',
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
          ],
          // Shares
          if (post.shareCount > 0) ...[
            Icon(
              Icons.share_outlined,
              size: 14,
              color: context.colorScheme.secondary.withOpacity(0.6),
            ),
            const SizedBox(width: 4),
            Text(
              '${post.shareCount}',
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build action buttons with gradient background when active
  Widget _buildActionButtons(BuildContext context, Post post, bool isPending) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Like button with reaction picker
          Expanded(child: _buildReactionButton(context, post, isPending)),
          const SizedBox(width: 8),
          // Comment button
          Expanded(
            child: _buildActionButton(
              context: context,
              icon: Icons.chat_bubble_outline,
              label: 'Comment',
              isActive: false,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          // Share button
          Expanded(
            child: _buildActionButton(
              context: context,
              icon: Icons.share_outlined,
              label: 'Share',
              isActive: false,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  /// Build reaction button with gradient when active and loading state
  Widget _buildReactionButton(BuildContext context, Post post, bool isPending) {
    final hasReaction = post.userReaction != null;

    return InkWell(
      onTap: () {
        if (isPending) return;
        final newReaction = hasReaction ? null : ReactionType.like;
        context.read<OptimisticCubit>().toggleReaction(post.id, newReaction);
      },
      onLongPress: () {
        if (isPending) return;
        _showReactionPicker(context, post);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: hasReaction
              ? LinearGradient(
                  colors: [
                    context.colorScheme.primary.withOpacity(0.15),
                    context.colorScheme.primary.withOpacity(0.08),
                  ],
                )
              : null,
          color: isPending
              ? context.colorScheme.secondary.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isPending)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.colorScheme.primary,
                  ),
                ),
              )
            else if (hasReaction)
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  post.userReaction!.emoji,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            else
              Icon(
                Icons.thumb_up_outlined,
                size: 18,
                color: context.colorScheme.secondary.withOpacity(0.6),
              ),
            const SizedBox(width: 6),
            Text(
              hasReaction ? post.userReaction!.label : 'Like',
              style: context.bodyMedium?.copyWith(
                color: hasReaction
                    ? context.colorScheme.primary
                    : context.colorScheme.secondary.withOpacity(0.7),
                fontWeight: hasReaction ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build simple action button with hover effect
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? context.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? context.colorScheme.primary
                  : context.colorScheme.secondary.withOpacity(0.6),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: context.bodyMedium?.copyWith(
                color: isActive
                    ? context.colorScheme.primary
                    : context.colorScheme.secondary.withOpacity(0.7),
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show reaction picker modal with premium design
  void _showReactionPicker(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Title with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mood,
                    color: context.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Choose your reaction',
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Reaction options with gradient
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: ReactionType.values.map((reaction) {
                  final isSelected = post.userReaction == reaction;
                  return InkWell(
                    onTap: () {
                      Navigator.pop(modalContext);
                      final newReaction = isSelected ? null : reaction;
                      context.read<OptimisticCubit>().toggleReaction(
                        post.id,
                        newReaction,
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  context.colorScheme.primary.withOpacity(0.2),
                                  context.colorScheme.primary.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected
                            ? null
                            : context.colorScheme.secondary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? context.colorScheme.primary
                              : context.colorScheme.secondary.withOpacity(0.1),
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: context.colorScheme.primary
                                      .withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            reaction.emoji,
                            style: TextStyle(fontSize: isSelected ? 36 : 32),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            reaction.label,
                            style: context.labelSmall?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? context.colorScheme.primary
                                  : context.colorScheme.secondary.withOpacity(
                                      0.7,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  /// Format timestamp to readable text (e.g., "2 hours ago")
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }
}
