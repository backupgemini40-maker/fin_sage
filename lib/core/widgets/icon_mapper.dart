import 'package:flutter/material.dart';

const List<String> kSelectableIconNames = [
  'wallet',
  'restaurant',
  'shopping_cart',
  'directions_car',
  'home',
  'health_and_safety',
  'school',
  'work',
  'flight',
  'subscriptions',
  'savings',
  'credit_card',
  'receipt_long',
  'account_balance_wallet',
  'pie_chart',
];

IconData mapStringToIconData(String iconName) {
  switch (iconName) {
    case 'wallet':
      return Icons.wallet;
    case 'restaurant':
      return Icons.restaurant;
    case 'shopping_cart':
      return Icons.shopping_cart;
    case 'directions_car':
      return Icons.directions_car;
    case 'home':
      return Icons.home;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'school':
      return Icons.school;
    case 'work':
      return Icons.work;
    case 'flight':
      return Icons.flight;
    case 'subscriptions':
      return Icons.subscriptions;
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
      return Icons.category;
  }
}

String readableIconName(String iconName) {
  return iconName.replaceAll('_', ' ');
}
