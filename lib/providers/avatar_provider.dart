import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AvatarNotifier extends Notifier<String?> {
  @override
  String? build() {
    _loadAvatar();
    return null;
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('user_avatar');
    if (path != null && File(path).existsSync()) {
      state = path;
    }
  }

  Future<void> setAvatar(String cachePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(cachePath);
      final savedImage = await File(cachePath).copy('${appDir.path}/$fileName');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_avatar', savedImage.path);
      state = savedImage.path;
    } catch (e) {
      print("Error saving avatar: $e");
    }
  }

  Future<void> removeAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('user_avatar');
    if (path != null) {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    await prefs.remove('user_avatar');
    state = null;
  }
}

final avatarProvider = NotifierProvider<AvatarNotifier, String?>(AvatarNotifier.new);

