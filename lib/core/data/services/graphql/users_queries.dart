/// GraphQL Queries for Users Module
///
/// This class contains all GraphQL query and mutation strings
/// for the Users feature.
class UsersQueries {
  UsersQueries._();

  /// Query to fetch all users
  ///
  /// Returns: List of users with id, name, email, createdAt
  static const String getUsers = '''
    query GetUsers {
      usersCollection {
        edges {
          node {
            id
            name
            email
            avatar_url
            created_at
          }
        }
      }
    }
  ''';

  /// Query to fetch a single user by ID
  ///
  /// Variables: \$id: UUID!
  /// Returns: Single user with id, name, email, createdAt
  static const String getUserById = '''
    query GetUserById(\$id: UUID!) {
      usersCollection(filter: { id: { eq: \$id } }) {
        edges {
          node {
            id
            name
            email
            avatar_url
            created_at
          }
        }
      }
    }
  ''';

  /// Mutation to create a new user
  ///
  /// Variables:
  ///   \$name: String!
  ///   \$email: String!
  ///   \$avatarUrl: String
  /// Returns: Created user with id, name, email
  static const String createUser = '''
    mutation CreateUser(\$name: String!, \$email: String!, \$avatarUrl: String) {
      insertIntousersCollection(objects: [
        { name: \$name, email: \$email, avatar_url: \$avatarUrl }
      ]) {
        records {
          id
          name
          email
          avatar_url
          created_at
        }
      }
    }
  ''';

  /// Mutation to update an existing user
  ///
  /// Variables:
  ///   \$id: UUID!
  ///   \$name: String
  ///   \$email: String
  /// Returns: Updated user
  static const String updateUser = '''
    mutation UpdateUser(\$id: UUID!, \$name: String, \$email: String) {
      updateusersCollection(
        filter: { id: { eq: \$id } }
        set: { name: \$name, email: \$email }
      ) {
        records {
          id
          name
          email
          avatar_url
          created_at
        }
      }
    }
  ''';

  /// Mutation to delete a user
  ///
  /// Variables: \$id: UUID!
  /// Returns: Deleted user
  static const String deleteUser = '''
    mutation DeleteUser(\$id: UUID!) {
      deleteFromusersCollection(filter: { id: { eq: \$id } }) {
        records {
          id
        }
      }
    }
  ''';
}
