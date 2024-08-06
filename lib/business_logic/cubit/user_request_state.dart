part of 'user_request_cubit.dart';

@immutable
sealed class UserRequestState {}

final class UserRequestInitial extends UserRequestState {}

final class MakingUserRequest extends UserRequestState {}

final class UserRequestMade extends UserRequestState {
  Object data;
  UserRequestMade({required this.data});
}

final class UserRequestError extends UserRequestState {
  String message;
  UserRequestError({required this.message});
}
