import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  const AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.colorHex,
    this.icon = 'wallet',
  });

  final int? id;
  final String name;
  final String type;
  final double balance;
  final String colorHex;
  final String icon;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'color_hex': colorHex,
      'icon': icon,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      balance: (map['balance'] as num).toDouble(),
      colorHex: map['color_hex'] as String,
      icon: map['icon'] as String? ?? 'wallet',
    );
  }

  @override
  List<Object?> get props => [id, name, type, balance, colorHex, icon];
}
