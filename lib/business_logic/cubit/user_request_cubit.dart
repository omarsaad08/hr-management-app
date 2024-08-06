import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hr_management_app/data/web_services/requests_web_services.dart';
import 'package:meta/meta.dart';

part 'user_request_state.dart';

class UserRequestCubit extends Cubit<UserRequestState> {
  RequestsWebServices requestsWebServices;
  UserRequestCubit({required this.requestsWebServices})
      : super(UserRequestInitial());
  void emitInitial() {
    emit(UserRequestInitial());
  }

  void makeRequest(Map data) async {
    emit(MakingUserRequest());
    try {
      final result = await requestsWebServices.makeRequest(data);
      if (result == -1) {
        throw Exception(result);
      }
      emit(UserRequestMade(data: 'تم الارسال'));
    } catch (e) {
      emit(UserRequestError(message: '$e'));
    }
  }
}
