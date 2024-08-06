part of 'database_cubit.dart';

@immutable
sealed class DatabaseState {}

final class DatabaseInitial extends DatabaseState {}

class DatabaseEmployeesLoading extends DatabaseState {}

class DatabaseEmployeesLoaded extends DatabaseState {
  final List data;
  DatabaseEmployeesLoaded({required this.data});
}

class DatabaseGettingEmployeesError extends DatabaseState {
  final String message;
  DatabaseGettingEmployeesError({required this.message});
}

// -----------------------------

class DatabaseEmployeeLoading extends DatabaseState {}

class DatabaseEmployeeLoaded extends DatabaseState {
  final Map data;
  DatabaseEmployeeLoaded({required this.data});
}

class DatabaseGettingEmployeeError extends DatabaseState {
  final String message;
  DatabaseGettingEmployeeError({required this.message});
}

// -----------------------------
class DatabaseAddEmployeeInitial extends DatabaseState {}

class DatabaseAddingEmployee extends DatabaseState {}

class DatabaseAddedEmployee extends DatabaseState {
  DatabaseAddedEmployee();
}

class DatabaseAddingEmployeeError extends DatabaseState {
  final String message;
  DatabaseAddingEmployeeError({required this.message});
}

// ----------------------------
class DatabaseDeletingEmployee extends DatabaseState {}

class DatabaseDeletedEmployee extends DatabaseState {
  final String data;
  DatabaseDeletedEmployee({required this.data});
}

class DatabaseDeletingEmployeeError extends DatabaseState {
  final String message;
  DatabaseDeletingEmployeeError({required this.message});
}
