enum TxDirection { inbound, outbound }
enum TxStatus { pending, confirmed, failed }

class Transaction {
  final String id;
  final String hash;
  final DateTime timestamp;
  final String tokenSymbol;
  final String network;
  final double amount;
  final double fee;
  final TxDirection direction;
  final TxStatus status;

  const Transaction({
    required this.id,
    required this.hash,
    required this.timestamp,
    required this.tokenSymbol,
    required this.network,
    required this.amount,
    required this.fee,
    required this.direction,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      hash: json['hash'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tokenSymbol: json['tokenSymbol'] as String,
      network: json['network'] as String,
      amount: (json['amount'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      direction: (json['direction'] as String) == 'inbound'
          ? TxDirection.inbound
          : TxDirection.outbound,
      status: switch (json['status'] as String) {
        'pending' => TxStatus.pending,
        'failed' => TxStatus.failed,
        _ => TxStatus.confirmed,
      },
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hash': hash,
    'timestamp': timestamp.toIso8601String(),
    'tokenSymbol': tokenSymbol,
    'network': network,
    'amount': amount,
    'fee': fee,
    'direction': direction == TxDirection.inbound ? 'inbound' : 'outbound',
    'status': switch (status) {
      TxStatus.pending => 'pending',
      TxStatus.failed => 'failed',
      _ => 'confirmed',
    },
  };
}
