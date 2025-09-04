import 'token.dart';

class Transaction {
  final int id;
  final int tipo; // 0=entrada, 1=saída, 2=transferência
  final String rede;
  final String hashTransacao;
  final double fee;
  final String deOnde;
  final String paraOnde;
  final Token token;
  final DateTime dataHora;
  final double qtdToken;

  const Transaction({
    required this.id,
    required this.tipo,
    required this.rede,
    required this.hashTransacao,
    required this.fee,
    required this.deOnde,
    required this.paraOnde,
    required this.token,
    required this.dataHora,
    required this.qtdToken,
  });
}
