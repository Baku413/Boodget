import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

// Header at the top of the application.  Shows the current budget and month.
// ignore: must_be_immutable
class AppHeader extends Container {
  Budget budget;

  AppHeader({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 217,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/boodget_header_background.png"),
          fit: BoxFit.cover
        )
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BUDGET',
                  style: TextStyle(
                      color: Color(0xFF656565),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto'),
                ).animate().flipH(),
                Countup(
                  begin: budget.total,
                  end: budget.remaining,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  separator: ',',
                  prefix: "\$",
                  precision: 2,
                  style: const TextStyle(
                      color: Color(0xFFDFFFE3),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
                Text(NumberFormat('/\$#,##0.00').format(budget.total),
                    style: const TextStyle(
                        color: Color(0xFF808782),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto')
                ).animate().flipH()
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                budget.period as String,
                style: const TextStyle(
                    color: Color(0xFF80A47B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Color(0xFF656565),
                )),
          ),
        ],
      ),
    );
  }
}

class Budget {
  String? period;
  double remaining;
  double total;

  Budget({
    required this.period,
    required this.remaining,
    required this.total,
  });

  Budget.fromJson(Map<String, Object?> json)
      : this(
          period: json['period'] as String,
          remaining: double.parse(json['remaining'].toString()),
          total: double.parse(json['total'].toString()),
        );

  Map<String, Object?> toJson() {
    return {
      'period': period,
      'remaining': remaining,
      'total': total,
    };
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Period: $period /Remaining: $remaining /Total: $total';
  }
}
