import 'transaction.dart';
import 'token.dart';

class Wallet {
  final String endereco;
  final String nomeCarteira;
  final String tipoCarteira; // "selfCustody", "custodial", "exchange"...

  final List<Transaction> listaTransacoes;
  final List<Token> listaTokens;

  const Wallet({
    required this.endereco,
    required this.nomeCarteira,
    required this.tipoCarteira,
    this.listaTransacoes = const [],
    this.listaTokens = const [],
  });
}
