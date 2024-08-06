import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_management_app/data/web_services/archive_web_services.dart';

abstract class UserArchiveState {}

// -----------------------------------
class UserArchiveInitial extends UserArchiveState {}

class UserArchiveLoading extends UserArchiveState {}

class UserArchiveLoaded extends UserArchiveState {
  final String data;
  UserArchiveLoaded({required this.data});
}

class UserArchiveError extends UserArchiveState {
  final String message;
  UserArchiveError({required this.message});
}

// -----------------------------------
class UserArchiveImagesLoading extends UserArchiveState {}

class UserArchiveImagesLoaded extends UserArchiveState {
  final List data;
  UserArchiveImagesLoaded({required this.data});
}

class UserArchiveImagesError extends UserArchiveState {
  final String message;
  UserArchiveImagesError({required this.message});
}

// -----------------------------------
class UserArchiveUserAdded extends UserArchiveState {}

class UserArchiveAddingUser extends UserArchiveState {}

class UserArchiveAddUserError extends UserArchiveState {
  final String message;
  UserArchiveAddUserError({required this.message});
}

// -----------------------------------
class UserArchiveImageAdded extends UserArchiveState {}

class UserArchiveImageAddingError extends UserArchiveState {
  final String message;
  UserArchiveImageAddingError({required this.message});
}

// -----------------------------------
class UserArchiveCubit extends Cubit<UserArchiveState> {
  ArchiveWebServices archiveWebServices;
  UserArchiveCubit({required this.archiveWebServices})
      : super(UserArchiveInitial());
  Future<void> emitUserSearchInitial(BuildContext context) async {
    emit(UserArchiveInitial());
  }

  void getDoc({required String id}) async {
    emit(UserArchiveLoading());
    try {
      final userName = await archiveWebServices.getDoc(id: id);
      print(userName);
      emit(UserArchiveLoaded(data: userName));
    } catch (e) {
      print('fetching doc failed');
      emit(UserArchiveError(message: 'Failed to load data: $e'));
    }
  }

  void getImages({required String doc, required String id}) async {
    emit(UserArchiveImagesLoading());
    try {
      final data = await archiveWebServices.getImages(doc: doc, id: id);
      emit(UserArchiveImagesLoaded(data: data));
    } catch (e) {
      print('fetching doc failed');
      emit(UserArchiveImagesError(message: 'Failed to load data: $e'));
    }
  }

  void addUser(String userId) async {
    emit(UserArchiveAddingUser());
    try {
      final data = await archiveWebServices.addUser(userId: userId);
      emit(UserArchiveUserAdded());
    } catch (e) {
      print('error adding user: $e');
      emit(UserArchiveAddUserError(message: 'failed to add user: $e'));
    }
  }

  void postImage(
      {required String userId,
      required String filetype,
      required String filePath,
      required String filename}) async {
    try {
      final data = await archiveWebServices.postImage(
          userId: userId,
          filetype: filetype,
          filePath: filePath,
          filename: filename);
      emit(UserArchiveImageAdded());
    } catch (e) {
      print('error adding an image: $e');
      emit(UserArchiveImageAddingError(message: 'failed to add the image $e'));
    }
  }
}
