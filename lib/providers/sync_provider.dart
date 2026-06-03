import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';

final syncServiceProvider = Provider((ref) => SyncService());

final syncStateProvider = NotifierProvider<SyncNotifier, bool>(() {
  return SyncNotifier();
});

class SyncNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<bool> syncData() async {
    state = true;
    final syncService = ref.read(syncServiceProvider);
    final success = await syncService.syncAll();
    state = false;
    return success;
  }
}
