import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/graphql_demo/presentation/blocs/graphql_bloc.dart';
import 'package:banking_app/features/graphql_demo/presentation/blocs/graphql_event.dart';
import 'package:banking_app/features/graphql_demo/presentation/blocs/graphql_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// GraphQL Demo Screen showcasing GraphQL concepts
class GraphQLDemo extends StatefulWidget {
  const GraphQLDemo({super.key});

  @override
  State<GraphQLDemo> createState() => _GraphQLDemoState();
}

class _GraphQLDemoState extends State<GraphQLDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _searchController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _searchController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<GraphQLBloc>()..add(const FetchPostsEvent()),
      child: BAScaffold(
        appBar: BAAppBar(
          title: 'GraphQL Demo',
          titleColor: context.colorScheme.onPrimary,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.secondary,
        ),
        body: BlocConsumer<GraphQLBloc, GraphQLState>(
          listener: (context, state) {
            state.status.when(
              initial: () {},
              loading: () {},
              success: () {
                // Show success message for mutations
              },
              failure: () {
                if (state.errorMessage != null) {
                  BASnackBar.buildErrorSnackbar(
                    context,
                    state.errorMessage!,
                  );
                }
              },
            );
          },
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 16),
                _buildTabBar(context),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildQueriesTab(context, state),
                      _buildMutationsTab(context, state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.secondary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: context.colorScheme.onPrimary,
        unselectedLabelColor: context.colorScheme.secondary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colorScheme.secondary,
              context.colorScheme.secondary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        tabs: const [
          Tab(text: 'Queries', icon: Icon(Icons.search, size: 20)),
          Tab(text: 'Mutations', icon: Icon(Icons.edit, size: 20)),
        ],
      ),
    );
  }

  Widget _buildQueriesTab(BuildContext context, GraphQLState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Query Examples'),
          const SizedBox(height: 16),
          _buildQueryCard(
            context,
            'Fetch All Posts',
            'query {\n  posts {\n    id\n    title\n    body\n    likesCount\n  }\n}',
            onExecute: () {
              context.read<GraphQLBloc>().add(const FetchPostsEvent());
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Posts',
              hintText: 'Enter search query...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_searchController.text.isNotEmpty) {
                    context.read<GraphQLBloc>().add(
                          SearchPostsEvent(_searchController.text),
                        );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (state.isSearching)
            const Center(child: CircularProgressIndicator())
          else if (state.searchResults.isNotEmpty)
            ...state.searchResults.map((post) => _buildPostCard(context, post))
          else if (state.posts.isNotEmpty)
            ...state.posts.map((post) => _buildPostCard(context, post)),
        ],
      ),
    );
  }

  Widget _buildMutationsTab(BuildContext context, GraphQLState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Mutation Examples'),
          const SizedBox(height: 16),
          _buildMutationCard(
            context,
            'Create Post',
            'mutation CreatePost(\$title: String!, \$body: String!) {\n'
                '  createPost(title: \$title, body: \$body) {\n'
                '    id\n    title\n    body\n  }\n}',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Post Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Post Body',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          BAElevatedButton(
            text: 'Create Post',
            onPressed: () {
              if (_titleController.text.isNotEmpty &&
                  _bodyController.text.isNotEmpty) {
                context.read<GraphQLBloc>().add(
                      CreatePostEvent(
                        title: _titleController.text,
                        body: _bodyController.text,
                        userId: '1',
                      ),
                    );
                _titleController.clear();
                _bodyController.clear();
                BASnackBar.buildSuccessSnackbar(
                  context,
                  'Post created successfully!',
                );
              }
            },
          ),
          const SizedBox(height: 24),
          if (state.posts.isNotEmpty) ...[
            _buildSectionTitle(context, 'Manage Posts'),
            const SizedBox(height: 16),
            ...state.posts.map((post) => _buildManagePostCard(context, post)),
          ],
        ],
      ),
    );
  }

 

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.titleLarge?.copyWith(
        color: context.colorScheme.secondary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQueryCard(
    BuildContext context,
    String title,
    String query, {
    VoidCallback? onExecute,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.secondary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onExecute != null)
                IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: context.colorScheme.secondary,
                  ),
                  onPressed: onExecute,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              query,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMutationCard(
    BuildContext context,
    String title,
    String mutation,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.secondary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              mutation,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

 

  Widget _buildPostCard(BuildContext context, post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.secondary.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  post.title,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: post.published
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  post.published ? 'Published' : 'Draft',
                  style: TextStyle(
                    fontSize: 12,
                    color: post.published ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.body,
            style: context.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.comment, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('${post.commentsCount}'),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  context.read<GraphQLBloc>().add(LikePostEvent(post.id));
                },
                child: Row(
                  children: [
                    Icon(Icons.favorite, size: 16, color: Colors.red[400]),
                    const SizedBox(width: 4),
                    Text('${post.likesCount}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagePostCard(BuildContext context, post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.secondary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.publish, size: 16),
                  label: Text(post.published ? 'Unpublish' : 'Publish'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.secondary,
                    foregroundColor: context.colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    context.read<GraphQLBloc>().add(
                          UpdatePostEvent(
                            id: post.id,
                            published: !post.published,
                          ),
                        );
                    BASnackBar.buildSuccessSnackbar(
                      context,
                      'Post ${post.published ? 'unpublished' : 'published'}!',
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<GraphQLBloc>().add(DeletePostEvent(post.id));
                  BASnackBar.buildSuccessSnackbar(
                    context,
                    'Post deleted!',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

 

    }
