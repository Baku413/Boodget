import 'package:flutter/material.dart';

enum Category {
  groceries,
  food,
  entertainment,
  gas,
  electronics,
  home,
  subcription,
  clothes,
  gifts,
  other
}

extension on Category {
  String get name {
    switch (this) {
      case Category.groceries:
        return 'Groceries';
      case Category.food:
        return 'Food';
      case Category.entertainment:
        return 'Entertainment';
      case Category.gas:
        return 'Gas';
      case Category.electronics:
        return 'Electronics';
      case Category.home:
        return 'Home';
      case Category.subcription:
        return 'Subscription';
      case Category.clothes:
        return 'Clothes';
      case Category.gifts:
        return 'Gifts';
      default:
        return 'Other';
    }
  }

  Category type(String categoryString) {
    switch (categoryString) {
      case 'Groceries':
        return Category.groceries;
      case 'Food':
        return Category.food;
      case 'Entertainment':
        return Category.entertainment;
      case 'Gas':
        return Category.gas;
      case 'Electronics':
        return Category.electronics;
      case 'Home':
        return Category.home;
      case 'Subscription':
        return Category.subcription;
      case 'Clothes':
        return Category.clothes;
      case 'Gifts':
        return Category.gifts;
      case 'Other':
        return Category.other;
      default:
        return Category.other;
    }
  }
}

class CategoryDropDown {
  static List<DropdownMenuEntry<Category>> get getList {
    return [
      const DropdownMenuEntry(value: Category.groceries, label: 'Groceries'),
      const DropdownMenuEntry(value: Category.food, label: 'Food'),
      const DropdownMenuEntry(
          value: Category.entertainment, label: 'Entertainment'),
      const DropdownMenuEntry(value: Category.gas, label: 'Gas'),
      const DropdownMenuEntry(
          value: Category.electronics, label: 'Electronics'),
      const DropdownMenuEntry(value: Category.home, label: 'Home'),
      const DropdownMenuEntry(
          value: Category.subcription, label: 'Subscription'),
      const DropdownMenuEntry(
          value: Category.clothes, label: 'Clothes'),
      const DropdownMenuEntry(
          value: Category.gifts, label: 'Gifts'),
      const DropdownMenuEntry(value: Category.other, label: 'Other'),
    ];
  }
}

class CategoryIconMap {
  static Map<String, IconData> categoryIconMap = {
    'Groceries': Icons.local_grocery_store,
    'Food': Icons.fastfood,
    'Entertainment': Icons.local_movies,
    'Gas': Icons.local_gas_station,
    'Home': Icons.house,
    'Subscription': Icons.subscriptions,
    'Clothes': Icons.checkroom,
    'Gifts': Icons.redeem,
    'Other': Icons.attach_money
  };
}
