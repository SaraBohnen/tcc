import 'dart:math';
import 'package:app_chain_view/models/token.dart';
import 'package:flutter/material.dart';
import 'package:app_chain_view/models/metrics/performance_point.dart';
import 'package:app_chain_view/models/metrics/asset_slice.dart';
import 'package:app_chain_view/models/metrics/token_performance.dart';
import 'package:app_chain_view/models/transaction.dart';

class SampleDataGenerator {
  static final _random = Random();

  /// Gera um saldo total aleatório
  static double generateTotalBalance() {
    return 1000 + _random.nextDouble() * 9000;
  }

  /// Gera taxas aleatórias
  static double generateTotalFees() {
    return 0.01 + _random.nextDouble() * 1.99;
  }

  /// Série diária de 1 ano (365 dias) – random walk
  static List<PerformancePoint> generateOneYearDailySeries({
    double startBase = 1200.0,
    double dailyVolatility = 0.02,
    int days = 365,
  }) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final List<PerformancePoint> series = [];

    double value = startBase + _random.nextDouble() * 200;
    for (int i = 0; i < days; i++) {
      final drift = (_random.nextDouble() * 2 - 1) * dailyVolatility;
      value = (value * (1 + drift)).clamp(200.0, 100000.0);
      final pointDate = startDate.add(Duration(days: i));
      series.add(PerformancePoint(pointDate, value));
    }
    return series;
  }

  /// Tokens (cores fixas, valores aleatórios)
  static List<AssetSlice> generateTokenSummary() {
    return [
      AssetSlice(
        name: 'Bitcoin',
        value: 2000 + _random.nextDouble() * 8000,
        color: Colors.orange,
      ),
      AssetSlice(
        name: 'Ethereum',
        value: 1500 + _random.nextDouble() * 6000,
        color: Colors.indigo,
      ),
      AssetSlice(
        name: 'USDC',
        value: 1000 + _random.nextDouble() * 3000,
        color: Colors.green,
      ),
      AssetSlice(
        name: 'Solana',
        value: 500 + _random.nextDouble() * 2000,
        color: Colors.pinkAccent,
      ),
      AssetSlice(
        name: 'Cardano',
        value: 300 + _random.nextDouble() * 1200,
        color: Colors.blue,
      ),
      AssetSlice(
        name: 'XRP',
        value: 200 + _random.nextDouble() * 800,
        color: Colors.teal,
      ),
      AssetSlice(
        name: 'Others',
        value: 200 + _random.nextDouble() * 1500,
        color: Colors.blueGrey,
      ),
    ];
  }

  /// Redes (cores fixas, valores aleatórios)
  static List<AssetSlice> generateNetworkSummary() {
    return [
      AssetSlice(
        name: 'Ethereum',
        value: 2000 + _random.nextDouble() * 8000,
        color: Colors.indigo,
      ),
      AssetSlice(
        name: 'Bitcoin',
        value: 2000 + _random.nextDouble() * 7000,
        color: Colors.orange,
      ),
      AssetSlice(
        name: 'BSC',
        value: 1000 + _random.nextDouble() * 4000,
        color: Colors.amberAccent,
      ),
      AssetSlice(
        name: 'Solana',
        value: 500 + _random.nextDouble() * 2000,
        color: Colors.pinkAccent,
      ),
      AssetSlice(
        name: 'Polygon',
        value: 300 + _random.nextDouble() * 1500,
        color: Colors.deepPurple,
      ),
      AssetSlice(
        name: 'Avalanche',
        value: 300 + _random.nextDouble() * 1500,
        color: Colors.red,
      ),
      AssetSlice(
        name: 'Others',
        value: 200 + _random.nextDouble() * 1500,
        color: Colors.blueGrey,
      ),
    ];
  }

  /// Gera Top 5 com variações positivas
  static List<TokenPerformance> generateTopPerformers({int count = 5}) {
    final names = [
      'Solana',
      'Avalanche',
      'Toncoin',
      'Chainlink',
      'Bitcoin',
      'Ethereum',
      'Polkadot',
      'Near',
    ];
    final list = List<TokenPerformance>.generate(names.length, (i) {
      final price = 1 + _random.nextDouble() * 70000;
      final change = 5 + _random.nextDouble() * 25; // 5%..30%
      return TokenPerformance(
        name: names[i],
        price: double.parse(price.toStringAsFixed(2)),
        sevenDayChange: double.parse(change.toStringAsFixed(1)),
      );
    });
    list.sort((a, b) => b.sevenDayChange.compareTo(a.sevenDayChange));
    return list.take(count).toList();
  }

  /// Gera Worst 5 com variações negativas
  static List<TokenPerformance> generateWorstPerformers({int count = 5}) {
    final names = [
      'Chainlink',
      'Starknet',
      'Celestia',
      'Uniswap',
      'Ethereum',
      'Arbitrum',
      'Sui',
      'Aptos',
    ];
    final list = List<TokenPerformance>.generate(names.length, (i) {
      final price = 1 + _random.nextDouble() * 4000;
      final change = -(5 + _random.nextDouble() * 20); // -5%..-25%
      return TokenPerformance(
        name: names[i],
        price: double.parse(price.toStringAsFixed(2)),
        sevenDayChange: double.parse(change.toStringAsFixed(1)),
      );
    });
    list.sort((a, b) => a.sevenDayChange.compareTo(b.sevenDayChange));
    return list.take(count).toList();
  }

  // ---------------------------------------------------------------------------
  // ------------------------- TRANSAÇÕES (NOVO) -------------------------------
  // ---------------------------------------------------------------------------

  /// Página de transações aleatórias (timestamps em SEGUNDOS, sem microssegundos)
  static List<Transaction> generateTransactionsPage({
    required int page,
    required int pageSize,
  }) {
    final baseIndex = page * pageSize;
    return List<Transaction>.generate(pageSize, (i) {
      final idx = baseIndex + i;
      final isIn = _random.nextBool();
      final statusRoll = _random.nextInt(100);
      final status = statusRoll < 10
          ? TxStatus.pending
          : (statusRoll < 15 ? TxStatus.failed : TxStatus.confirmed);

      final amount = (0.01 + _random.nextDouble() * 5.0);
      final fee = double.parse(
        (_random.nextDouble() * 0.01).toStringAsFixed(6),
      );

      // Espalha timestamps nos últimos 30 dias
      final now = DateTime.now();
      final ts = now.subtract(
        Duration(
          days: _random.nextInt(30),
          hours: _random.nextInt(24),
          minutes: _random.nextInt(60),
          seconds: _random.nextInt(60),
        ),
      );
      final tsSeconds = DateTime.fromMillisecondsSinceEpoch(
        (ts.millisecondsSinceEpoch ~/ 1000) * 1000,
        isUtc: false,
      );

      return Transaction(
        id: 'tx_$idx',
        hash: '0x${_hex32()}${_hex32()}',
        timestamp: tsSeconds,
        tokenSymbol: _randomToken(),
        network: _randomNetwork(),
        amount: double.parse(amount.toStringAsFixed(6)),
        fee: fee,
        direction: isIn ? TxDirection.inbound : TxDirection.outbound,
        status: status,
      );
    });
  }

  /// Página de tokens para a carteira (dados aleatórios, determinísticos por página)
  static List<Token> generateTokensPage({
    required int page,
    required int pageSize,
  }) {
    // RNG determinístico por página para estabilidade visual
    final rng = Random(1337 + page);

    const universe = <String>[
      'BTC',
      'ETH',
      'USDT',
      'USDC',
      'BNB',
      'SOL',
      'XRP',
      'ADA',
      'DOGE',
      'AVAX',
      'MATIC',
      'DOT',
      'LINK',
    ];

    const iconBySymbol = <String, String>{
      'BTC': 'assets/images/btc.png',
      'ETH': 'assets/images/eth.png',
      'USDT': 'assets/images/usdt.png',
      'USDC': 'assets/images/usdc.png',
      'BNB': 'assets/images/bnb.png',
      'SOL': 'assets/images/sol.png',
      'XRP': 'assets/images/xrp.png',
      'ADA': 'assets/images/ada.png',
      'DOGE': 'assets/images/doge.png',
      'AVAX': 'assets/images/avax.png',
      'MATIC': 'assets/images/matic.png',
      'DOT': 'assets/images/dot.png',
      'LINK': 'assets/images/link.png',
    };

    const fallbackIcon = 'assets/images/coin.png';

    double priceHint(String s) {
      switch (s) {
        case 'BTC':
          return 65000;
        case 'ETH':
          return 3200;
        case 'BNB':
          return 570;
        case 'SOL':
          return 160;
        case 'XRP':
          return 0.6;
        case 'ADA':
          return 0.45;
        case 'DOGE':
          return 0.14;
        case 'AVAX':
          return 30;
        case 'MATIC':
          return 0.8;
        case 'DOT':
          return 6.2;
        case 'LINK':
          return 13.0;
        case 'USDT':
        case 'USDC':
          return 1.0;
        default:
          return 1.0;
      }
    }

    double randomInRange(double min, double max) =>
        min + (max - min) * rng.nextDouble();

    final List<Token> out = List.generate(pageSize, (i) {
      final symbol = universe[(page * pageSize + i) % universe.length];

      // Quantidade aleatória coerente para diferentes faixas
      final qty = randomInRange(0.001, 2500.0);
      final base = priceHint(symbol);
      // Variação +/- 8%
      final price = base * (0.92 + rng.nextDouble() * 0.16);

      return Token(
        symbol: symbol,
        quantity: double.parse(qty.toStringAsFixed(6)),
        price: double.parse(price.toStringAsFixed(4)),
        iconPath: iconBySymbol[symbol] ?? fallbackIcon,
      );
    });

    // Ordena por valor USD desc para consistência com a UI
    out.sort((a, b) => b.usdValue.compareTo(a.usdValue));
    return out;
  }
  // -------------------------- Helpers privados -------------------------------

  static String _randomToken() {
    const tokens = ['ETH', 'USDC', 'BTC', 'MATIC', 'SOL', 'ARB', 'OP', 'DAI'];
    return tokens[_random.nextInt(tokens.length)];
  }

  static String _randomNetwork() {
    const nets = ['Ethereum', 'Polygon', 'Arbitrum', 'Optimism', 'Solana'];
    return nets[_random.nextInt(nets.length)];
  }

  static String _hex32() =>
      (_random.nextInt(1 << 32)).toRadixString(16).padLeft(8, '0');
}
