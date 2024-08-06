import 'package:bloc/bloc.dart';
import 'package:hr_management_app/data/web_services/database_web_services.dart';
import 'package:hr_management_app/data/web_services/transactions_web_services.dart';
import 'package:meta/meta.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsWebServices transactionsWebServices;
  DatabaseWebServices databaseWebServices = DatabaseWebServices();
  TransactionsCubit({required this.transactionsWebServices})
      : super(TransactionsInitial());
  void emitInitial() {
    emit(TransactionsInitial());
  }

  void newTransaction(String transaction, Map<String, dynamic> data) async {
    emit(MakingTransaction());
    try {
      final response =
          await transactionsWebServices.newTransaction(transaction, data);
      if (transaction == "vacations") {
        final employeeData =
            await databaseWebServices.getEmployee(id: data['employeeID']);
        databaseWebServices.updateEmployee(employeeData: {
          "vacationBalance": employeeData["vacationBalance"] - data["duration"]
        });
      }
      emit(TransactionDone(message: 'تمت العملية'));
    } catch (e) {
      emit(TransactionError(message: 'error adding a transaction: $e'));
    }
  }
}
