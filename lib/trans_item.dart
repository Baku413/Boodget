// ignore_for_file: must_be_immutable

import 'package:boodget/home_screen.dart';
import 'package:boodget/category_ref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:intl/intl.dart';

// Transaction item list tile
@immutable
class TransItem extends StatelessWidget {
  TransItem(this.purchase, this.docId,
      {super.key, required this.onDeletePurchase}) {
    categoryIcon = CategoryIconMap.categoryIconMap.entries
        .where((element) => element.key == purchase.category)
        .firstOrNull
        ?.value;
    
  }
  IconData? categoryIcon;
  final DeleteCallback onDeletePurchase;

  final Purchase purchase;
  final String docId;

  Widget get vendor {
    return Text(
      purchase.vendor as String,
      style: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget get amount {
    return Text(
      NumberFormat('\$#,##0.00').format(purchase.amount),
      style: const TextStyle(
          color: Color(0xFFD1FFD7), fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget get date {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        DateFormat('MM/dd/yyyy hh:mma').format(purchase.addedDate as DateTime),
        style: const TextStyle(
            color: Color(0xFF808782),
            fontSize: 14,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget get chips {
    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: <Widget>[
        _buildCategoryChip(purchase.category as String),
        _buildUserChip(purchase.userName as String),
      ],
    );
  }

  Widget get transCard {
    Icon icon = Icon(
        (categoryIcon != null) ? categoryIcon : Icons.attach_money,
        color: Colors.white,
        size: 24.0);

    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFA6D3A0), width: 2.0),
          borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFD9D9D9),
      child: RoundedExpansionTile(
        leading: icon,
        noTrailing: true,
        tileColor: const Color(0xFF808782),
        contentPadding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        childrenPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(milliseconds: 250),
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(child: vendor),
              const VerticalDivider(
                color: Color(0xFF656565),
                thickness: 3,
              ),
              amount,
            ],
          ),
        ),
        children: <Widget>[
          Row(
            children: [
              Expanded(child: chips),
              IconButton(
                icon: const Icon(Icons.delete),
                color: const Color(0xFF656565),
                onPressed: () => onDeletePurchase(this),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    Icon icon = Icon(
        (categoryIcon != null) ? categoryIcon : Icons.attach_money,
        color: const Color(0xFFDFFFE3));

    return Chip(
      labelPadding: const EdgeInsets.all(3),
      avatar: icon,
      label: Text(
        category,
        style: const TextStyle(
            color: Color(0xFFDFFFE3),
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w300),
      ),
      backgroundColor: const Color(0xFFA6D3A0),
      elevation: 6,
      shadowColor: Colors.black,
      padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      side: const BorderSide(color: Color(0xFFA6D3A0), width: 0),
    );
  }

  Widget _buildUserChip(String user) {
    return Chip(
      labelPadding: const EdgeInsets.all(3),
      avatar: const Icon(
        Icons.person,
        color: Color(0xFF656565),
      ),
      label: RichText(
        text: TextSpan(
          text: 'Added by: ',
          style: const TextStyle(
              color: Color(0xFF656565),
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text: user,
                style: const TextStyle(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      elevation: 6,
      shadowColor: Colors.black,
      padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      side: const BorderSide(color: Color(0xFFA6D3A0), width: 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: date,
          ),
          transCard,
        ],
      ),
    );
  }
}

class Purchase {
  String? vendor;
  double? amount;
  DateTime? addedDate;
  String? category;
  String? userName;

  Purchase(
      {required this.vendor,
      required this.amount,
      required this.addedDate,
      required this.category,
      this.userName});

  Purchase.fromJson(Map<String, Object?> json)
      : this(
          vendor: json['vendor']! as String,
          amount: json['amount'] as double,
          category: json['category'] as String,
          userName: json['createdBy'] as String,
          addedDate: (json['created'] as Timestamp).toDate(),
        );

  Map<String, Object?> toJson() {
    return {
      'vendor': vendor,
      'amount': amount,
      'category': category,
      'createdBy': userName,
      'created': addedDate,
    };
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Vendor: $vendor /Amount: $amount /Category: $category /AddedDate: $addedDate';
  }
}
