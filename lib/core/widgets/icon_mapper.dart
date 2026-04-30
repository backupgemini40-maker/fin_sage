import 'package:flutter/material.dart';

IconData mapStringToIconData(String iconName) {
  switch (iconName) {
    case 'wallet':
      return Icons.wallet;
    case 'account_balance_wallet':
      return Icons.account_balance_wallet;
    case 'savings':
      return Icons.savings;
    case 'credit_card':
      return Icons.credit_card;
    case 'receipt_long':
      return Icons.receipt_long;
    case 'pie_chart':
      return Icons.pie_chart;
    case 'insert_chart':
      return Icons.insert_chart;
    case 'settings':
      return Icons.settings;
    case 'dashboard':
      return Icons.dashboard;
    default:
      return Icons.category; // A sensible default
  }
}
