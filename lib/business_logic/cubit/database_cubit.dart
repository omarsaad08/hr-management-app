import 'package:bloc/bloc.dart';
import 'package:hr_management_app/data/web_services/database_web_services.dart';
import 'package:meta/meta.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseWebServices databaseWebServices;
  DatabaseCubit({required this.databaseWebServices}) : super(DatabaseInitial());

  void getAllemployees() async {
    emit(DatabaseEmployeesLoading());
    try {
      final data = await databaseWebServices.getAllEmployees();
      emit(DatabaseEmployeesLoaded(data: data));
    } catch (e) {
      emit(DatabaseGettingEmployeesError(
          message: 'fetching employees failed: $e'));
    }
  }

  void getEmployee({required String id}) async {
    emit(DatabaseEmployeeLoading());
    try {
      final data = await databaseWebServices.getEmployee(id: id);
      emit(DatabaseEmployeeLoaded(data: data));
    } catch (e) {
      emit(DatabaseGettingEmployeeError(
          message: 'fetching employee failed: $e'));
    }
  }

  Future<void> addEmployee({required Map<String, dynamic> employeeData}) async {
    emit(DatabaseAddingEmployee());

    try {
      print('going to add');
      final data =
          await databaseWebServices.addEmployee(employeeData: employeeData);
      print('data: $data');
      emit(DatabaseAddedEmployee(data: data));
    } catch (e) {
      emit(DatabaseAddingEmployeeError(message: '$e'));
    }
  }

  void deleteEmployee({required String id}) async {
    emit(DatabaseDeletingEmployee());
    try {
      final data = await databaseWebServices.deleteEmployee(id: id);
      emit(DatabaseDeletedEmployee(data: data));
    } catch (e) {
      emit(DatabaseDeletingEmployeeError(message: '$e'));
    }
  }
}
