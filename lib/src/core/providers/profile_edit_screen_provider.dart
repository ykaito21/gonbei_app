import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../providers/base_provider.dart';
import '../services/api_path.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';

class ProfileEditScreenProvider extends BaseProvider {
  final UserModel user;
  ProfileEditScreenProvider({
    @required this.user,
  }) : assert(user != null) {
    _usernameController.text = user.name;
  }

  final _dbService = DatabaseService.instance;
  final _storageService = StorageService.instance;
  final _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;
  File _avatarImageFile;
  File get avatarImageFile => _avatarImageFile;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> pickAvatarImage(ImageSource source) async {
    try {
      if (source != null) {
        final selectedAvatar = await ImagePicker.pickImage(
          source: source,
          maxWidth: 512,
        );
        if (selectedAvatar != null) {
          _avatarImageFile = selectedAvatar;
          notifyListeners();
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> saveProfile() async {
    setViewState(ViewState.Busy);
    try {
      String avatarImageFileUrl;

      if (_avatarImageFile == null) {
        avatarImageFileUrl = user.imageUrl;
      } else {
        avatarImageFileUrl = await _uploadAvatar(_avatarImageFile);
      }
      final updatedUser = UserModel(
        id: user.id,
        name: _usernameController.text,
        imageUrl: avatarImageFileUrl,
      );

      await _updateUser(updatedUser);

      if (_avatarImageFile != null) await _avatarImageFile.delete();
      _usernameController.clear();
      setViewState(ViewState.Retrieved);
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
      rethrow;
    }
  }

  Future<void> resetProfile() async {
    setViewState(ViewState.Busy);
    try {
      if (user.imageUrl.isNotEmpty) await _deleteAvatar(user.imageUrl);
      final resetdUser = UserModel(
        id: user.id,
        name: '',
        imageUrl: '',
      );
      await _updateUser(resetdUser);

      if (_avatarImageFile != null) await _avatarImageFile.delete();
      _usernameController.clear();
      setViewState(ViewState.Retrieved);
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
      rethrow;
    }
  }

  Future<String> _uploadAvatar(File file) async {
    try {
      return await _storageService.uploadFile(
        file: file,
        path: ApiPath.userAvatar(userId: user.id),
        contentType: 'image/jpeg',
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> _deleteAvatar(String avatarImageUrl) async {
    try {
      await _storageService.deleteFile(avatarImageUrl);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> _updateUser(UserModel user) async {
    try {
      await _dbService.updateDocument(
        path: ApiPath.user(userId: user.id),
        data: user.toMapForFirestore(),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
