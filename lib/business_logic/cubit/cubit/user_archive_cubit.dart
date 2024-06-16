import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_archive_state.dart';

class UserArchiveCubit extends Cubit<UserArchiveState> {
  UserArchiveCubit() : super(UserArchiveInitial());
}
