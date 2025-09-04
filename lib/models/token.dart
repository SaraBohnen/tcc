class Token {
  final String contrato;
  final String nome;

  /// Ícone: deixar como URL por enquanto; se preferir bytes, troque para Uint8List.
  final String? iconeUrl;

  final double preco;
  final double mudancaPreco1D;
  final double mudancaPreco7D;
  final double mudancaPreco1M;
  final double mudancaPreco1A;
  final double mudancaPrecoTotal;
  final String blockchain;
  final double qtdToken; // quantidade que o usuário possui (na carteira)

  const Token({
    required this.contrato,
    required this.nome,
    this.iconeUrl,
    required this.preco,
    required this.mudancaPreco1D,
    required this.mudancaPreco7D,
    required this.mudancaPreco1M,
    required this.mudancaPreco1A,
    required this.mudancaPrecoTotal,
    required this.blockchain,
    required this.qtdToken,
  });
}
