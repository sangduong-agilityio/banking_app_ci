class SupabaseConfig {
  static const String supabaseUrl = 'https://rpxekfvpfeuksyvcbqvf.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJweGVrZnZwZmV1a3N5dmNicXZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjA3NjgwMjQsImV4cCI6MjAzNjM0NDAyNH0.uG3EflKgW2yKh82OJns3oqxVzCGQqjt_YHjkxoKgXlM';
  static const String basedUrl = '';
}

class DioExceptionMessages {
  static const String unauthenticated = 'Unauthenticated';
  static const String connectionTimeout = 'Connection request timeout';
  static const String sendTimeout =
      'Send timeout in connection with API server';
  static const String receiveTimeout =
      'Send timeout in connection with API server';
  static const String cancel = 'Request Cancelled';
  static const String connectionError = 'No internet connection';
  static const String unexpectedErrorOccurred = 'Unexpected error occurred';
}
