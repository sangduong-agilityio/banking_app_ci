# GraphQL Demo Feature

## Quick Start

### Access the Demo
1. Run the app
2. Navigate to **Settings** tab
3. Tap on **"GraphQL Benefits Demo"**

### What You'll Learn

#### Tab 1: Queries
- ✅ Fetch all posts from GraphQL API
- ✅ Search posts by title/content
- ✅ View post details with nested data
- ✅ Like posts (optimistic UI update)

**GraphQL Concept**: Request exactly what you need
```graphql
query {
  posts {
    id
    title
    likesCount
  }
}
```

#### Tab 2: Mutations
- ✅ Create new posts
- ✅ Update post status (publish/unpublish)
- ✅ Delete posts
- ✅ Add comments

**GraphQL Concept**: Modify data with mutations
```graphql
mutation {
  createPost(title: "New Post", body: "Content") {
    id
    title
  }
}
```

#### Tab 3: Schema
- ✅ View GraphQL type definitions
- ✅ Understand schema structure
- ✅ Learn about relationships
- ✅ See GraphQL benefits

## Architecture

```
graphql_demo/
├── domain/
│   ├── entities/          # Business objects
│   └── repositories/      # Abstract interfaces
├── data/
│   ├── models/           # JSON serializable
│   ├── datasources/      # Mock GraphQL API
│   └── repositories/     # Implementation
└── presentation/
    ├── blocs/            # BLoC state management
    └── widgets/          # UI components
```

## Key Features

### 1. Clean Architecture
- Separation of concerns
- Testable code
- Easy to maintain

### 2. BLoC Pattern
```dart
// Event
context.read<GraphQLBloc>().add(CreatePostEvent(...));

// State Update
BlocBuilder<GraphQLBloc, GraphQLState>(
  builder: (context, state) => buildUI(state),
)
```

### 3. GraphQL Benefits Demonstrated

| Feature | REST | GraphQL |
|---------|------|---------|
| Endpoints | Multiple | Single |
| Data Fetching | Fixed | Flexible |
| Typing | Weak | Strong |
| Nested Data | Multiple requests | Single request |

## Why GraphQL?

### Problem: REST Over-fetching
```json
GET /posts/1
{
  "id": 1,
  "title": "...",
  "body": "...",
  "author": {...},      // Not needed
  "category": {...},    // Not needed
  "tags": [...]         // Not needed
}
```

### Solution: GraphQL Precise Fetching
```graphql
query {
  post(id: 1) {
    id
    title
  }
}
```

## Code Examples

### Query Example
```dart
// Fetch posts
context.read<GraphQLBloc>().add(FetchPostsEvent());

// Handle state
BlocConsumer<GraphQLBloc, GraphQLState>(
  listener: (context, state) {
    state.status.when(
      loading: () => showLoader(),
      success: () => showSuccess(),
      failure: () => showError(),
    );
  },
)
```

### Mutation Example
```dart
// Create post
context.read<GraphQLBloc>().add(
  CreatePostEvent(
    title: 'My Post',
    body: 'Content',
    userId: '1',
  ),
);

// Optimistic update
emit(state.copyWith(
  posts: [newPost, ...state.posts],
));
```

## Testing

### Run Unit Tests
```bash
flutter test test/features/graphql_demo/
```

### Test Coverage
- ✅ BLoC events and states
- ✅ Repository methods
- ✅ Model serialization
- ✅ Entity equality

## Documentation

For detailed documentation, see [docs/graphql_demo.md](../docs/graphql_demo.md)

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.1.0
  equatable: ^2.0.7
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
```

## Implementation Checklist

- [x] Domain layer (entities, repositories)
- [x] Data layer (models, datasources, repository impl)
- [x] Presentation layer (BLoC, UI)
- [x] Service locator registration
- [x] Router configuration
- [x] Documentation
- [x] Code generation
- [x] Error handling
- [x] Loading states
- [x] Optimistic updates

## Future Enhancements

- [ ] Real GraphQL server integration
- [ ] Subscriptions (real-time updates)
- [ ] Pagination
- [ ] Caching strategies
- [ ] Offline support
- [ ] File uploads
- [ ] Authentication

## Support

For questions or issues, please refer to:
- Full documentation: `docs/graphql_demo.md`
- GraphQL official docs: https://graphql.org
- BLoC documentation: https://bloclibrary.dev
