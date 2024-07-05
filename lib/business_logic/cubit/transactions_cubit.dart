import 'package:bloc/bloc.dart';
import 'package:hr_management_app/data/web_services/transactions_web_services.dart';
import 'package:meta/meta.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsWebServices transactionsWebServices;
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
      emit(TransactionDone(message: 'تمت العملية'));
    } catch (e) {
      emit(TransactionError(message: 'error adding a transaction: $e'));
    }
  }
}
