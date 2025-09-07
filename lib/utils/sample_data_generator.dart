// lib/utils/sample_data_generator.dart

import 'dart:math';
import 'package:app_chain_view/components/top_performers_table.dart';
import 'package:app_chain_view/models/token.dart';
import 'package:app_chain_view/models/transaction.dart';
import 'package:flutter/material.dart';
import '../components/performance_line_chart.dart';
import '../components/period_filter_dropdown.dart';
import '../components/pie_chart_component.dart';

/// Classe utilitária para gerar dados de exemplo
/// Quando o backend estiver pronto, substitua por chamadas reais
class SampleDataGenerator {

  /// Gera um valor de saldo total de exemplo
  static double generateTotalBalance() {
    // Valor placeholder - substitua por dados reais
    return 15.20;
  }

  //Gera um valor de total de taxas gastas
  static double generateTotalFees(){
    return 0.235;
}

  /// Gera dados de exemplo conforme o filtro selecionado
  static List<PerformanceData> generatePerformanceData(PeriodFilter filter) {
    final now = DateTime.now();

    DateTime monthStart(DateTime d) => DateTime(d.year, d.month, 1);

    final List<PerformanceData> data = [];

    switch (filter) {
      case PeriodFilter.last7Days: {
        final startDate = now.subtract(const Duration(days: 6));
        for (int i = 0; i < 7; i++) {
          final pointDate = startDate.add(Duration(days: i));
          final value = 1200.0 + (i * 20);
          data.add(PerformanceData(pointDate, value));
        }
        break;
      }

      case PeriodFilter.last1Month: {
        // 30 pontos diários
        final startDate = now.subtract(const Duration(days: 29));
        for (int i = 0; i < 30; i++) {
          final pointDate = startDate.add(Duration(days: i));
          final value = 1200.0 + (i * 20);
          data.add(PerformanceData(pointDate, value));
        }
        break;
      }

      case PeriodFilter.last3Months: {
        // Mantém diário (ou ajuste aqui para semanal se quiser)
        final startDate = DateTime(now.year, now.month - 3, now.day);
        final totalDays = now.difference(startDate).inDays;
        for (int i = 0; i <= totalDays; i++) {
          final pointDate = startDate.add(Duration(days: i));
          final value = 1200.0 + (i * 20);
          data.add(PerformanceData(pointDate, value));
        }
        break;
      }

      case PeriodFilter.last1Year: {
        // **AQUI O AJUSTE**: 12 pontos, um por mês (início de cada mês)
        final firstMonth = DateTime(now.year, now.month - 11, 1);
        for (int i = 0; i < 12; i++) {
          final pointDate = DateTime(firstMonth.year, firstMonth.month + i, 1);
          final value = 1200.0 + (i * 60); // variação mais espaçada para visão anual
          data.add(PerformanceData(pointDate, value));
        }
        break;
      }
    }

    return data;
  }

  /// Gera dados de exemplo para os tokens, já processados.
  static List<AssetData> generatePreProcessedTokenData() {
    return [
      AssetData(name: 'Bitcoin', value: 4500.0, color: Colors.orange),
      AssetData(name: 'Ethereum', value: 3000.0, color: Colors.indigo),
      AssetData(name: 'USDC', value: 2000.0, color: Colors.green),
      AssetData(name: 'Solana', value: 1200.0, color: Colors.pinkAccent),
      AssetData(name: 'Cardano', value: 800.0, color: Colors.blue),
      AssetData(name: 'XRP', value: 500.0, color: Colors.teal),
      AssetData(name: 'Others', value: 750.0, color: Colors.blueGrey),
    ];
  }

  /// Gera dados de exemplo para as redes, já processados.
  static List<AssetData> generatePreProcessedNetworkData() {
    return [
      AssetData(name: 'Ethereum', value: 5500.0, color: Colors.indigo),
      AssetData(name: 'Bitcoin', value: 4500.0, color: Colors.orange),
      AssetData(name: 'BSC', value: 2500.0, color: Colors.amberAccent.shade700),
      AssetData(name: 'Solana', value: 1200.0, color: Colors.pinkAccent),
      AssetData(name: 'Polygon', value: 700.0, color: Colors.deepPurple),
      AssetData(name: 'Avalanche', value: 600.0, color: Colors.red.shade700),
      AssetData(name: 'Others', value: 750.0, color: Colors.blueGrey),
    ];
  }

  /// Gera dados de exemplo para a tabela de Top 5 Performers.
  static List<TokenPerformanceData> generateTopPerformingTokens() {
    return [
      TokenPerformanceData(name: 'Solana', price: 172.5, sevenDayChange: 22.5),
      TokenPerformanceData(
        name: 'Avalanche',
        price: 38.1,
        sevenDayChange: 18.2,
      ),
      TokenPerformanceData(name: 'Toncoin', price: 7.85, sevenDayChange: 15.7),
      // Adicionei um valor negativo para testar a cor vermelha
      TokenPerformanceData(
        name: 'Chainlink',
        price: 18.92,
        sevenDayChange: -12.1,
      ),
      TokenPerformanceData(
        name: 'Bitcoin',
        price: 69543.10,
        sevenDayChange: 8.5,
      ),
    ];
  }

  /// Gera dados de exemplo para a tabela de Worst 5 Performers.
  static List<TokenPerformanceData> generateWorstPerformingTokens() {
    return [
      TokenPerformanceData(
        name: 'Chainlink',
        price: 18.92,
        sevenDayChange: -12.1,
      ),
      TokenPerformanceData(name: 'Starknet', price: 1.25, sevenDayChange: -9.8),
      TokenPerformanceData(
        name: 'Celestia',
        price: 10.50,
        sevenDayChange: -7.5,
      ),
      TokenPerformanceData(name: 'Uniswap', price: 10.11, sevenDayChange: -5.2),
      TokenPerformanceData(
        name: 'Ethereum',
        price: 3680.40,
        sevenDayChange: -2.3,
      ),
    ];
  }

  /// Gera histórico fake de transações para uma carteira
  static List<Transaction> generateTransactionHistory(PeriodFilter filter) {
    final now = DateTime.now();
    late DateTime startDate;

    switch (filter) {
      case PeriodFilter.last7Days:
        startDate = now.subtract(const Duration(days: 6));
        break;
      case PeriodFilter.last1Month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case PeriodFilter.last3Months:
        startDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case PeriodFilter.last1Year:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    final random = Random();
    final redes = ['Ethereum', 'Bitcoin', 'BSC', 'Polygon'];

    // Tokens fake
    final tokens = [
      Token(
        contrato: "0xbtc",
        nome: "Bitcoin",
        iconeUrl: null,
        preco: 69000,
        mudancaPreco1D: 1.2,
        mudancaPreco7D: 5.8,
        mudancaPreco1M: 10.3,
        mudancaPreco1A: 120.0,
        mudancaPrecoTotal: 35000,
        blockchain: "Bitcoin",
        qtdToken: 0.5,
      ),
      Token(
        contrato: "0xeth",
        nome: "Ethereum",
        iconeUrl: null,
        preco: 3500,
        mudancaPreco1D: -0.4,
        mudancaPreco7D: 2.2,
        mudancaPreco1M: 8.7,
        mudancaPreco1A: 80.0,
        mudancaPrecoTotal: 2000,
        blockchain: "Ethereum",
        qtdToken: 10,
      ),
      Token(
        contrato: "0xusdc",
        nome: "USDC",
        iconeUrl: null,
        preco: 1,
        mudancaPreco1D: 0,
        mudancaPreco7D: 0,
        mudancaPreco1M: 0,
        mudancaPreco1A: 0,
        mudancaPrecoTotal: 1,
        blockchain: "Ethereum",
        qtdToken: 5000,
      ),
      Token(
        contrato: "0xsol",
        nome: "Solana",
        iconeUrl: null,
        preco: 180,
        mudancaPreco1D: 3.2,
        mudancaPreco7D: 12.5,
        mudancaPreco1M: 20.1,
        mudancaPreco1A: 300.0,
        mudancaPrecoTotal: 90,
        blockchain: "Solana",
        qtdToken: 50,
      ),
    ];

    final List<Transaction> transactions = [];

    for (int i = 0; i < 20; i++) {
      final date = startDate.add(
        Duration(
          days: random.nextInt(now.difference(startDate).inDays + 1),
          hours: random.nextInt(24),
          minutes: random.nextInt(60),
        ),
      );

      final token = tokens[random.nextInt(tokens.length)];

      transactions.add(
        Transaction(
          id: i + 1,
          tipo: random.nextInt(3), // 0=entrada, 1=saída, 2=transferência
          rede: redes[random.nextInt(redes.length)],
          hashTransacao: "0x${random.nextInt(999999999).toRadixString(16)}",
          fee: double.parse((random.nextDouble() * 0.01).toStringAsFixed(6)),
          deOnde: "Carteira${random.nextInt(100)}",
          paraOnde: "Carteira${random.nextInt(100)}",
          token: token,
          dataHora: date,
          qtdToken: double.parse((random.nextDouble() * 5).toStringAsFixed(4)),
        ),
      );
    }

    // Ordenar por data decrescente (mais recente primeiro)
    transactions.sort((a, b) => b.dataHora.compareTo(a.dataHora));

    return transactions;
  }
}
