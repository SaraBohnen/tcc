import 'package:app_chain_view/models/wallet.dart';

class User {
  final int id;
  final String nome;
  final String email;
  final String senha;
  final List<Wallet> listaCarteiras;
  final String prefMoeda; // ex.: "BRL", "USD"

  const User({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.listaCarteiras = const [],
    required this.prefMoeda,
  });
}
