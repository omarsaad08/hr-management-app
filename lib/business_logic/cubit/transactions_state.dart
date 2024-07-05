part of 'transactions_cubit.dart';

@immutable
sealed class TransactionsState {}

class TransactionsInitial extends TransactionsState {}

class MakingTransaction extends TransactionsState {}

class TransactionError extends TransactionsState {
  String message;
  TransactionError({required this.message});
}

class TransactionDone extends TransactionsState {
  String message;
  TransactionDone({required this.message});
}
