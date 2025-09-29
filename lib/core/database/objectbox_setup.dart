import 'package:banking_app/objectbox.g.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ObjectBoxManager {
  static Store? _store;

  static Future<Store> getStore() async {
    if (_store != null) return _store!;

    try {
      // Get app directory
      final docsDir = await getApplicationDocumentsDirectory();
      final dbDir = path.join(docsDir.path, 'objectbox');

      // Open ObjectBox store
      _store = await openStore(directory: dbDir);
      return _store!;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> closeStore() async {
    _store?.close();
    _store = null;
  }
}
