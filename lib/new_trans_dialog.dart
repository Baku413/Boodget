import 'package:boodget/trans_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:intl/intl.dart';

import 'category_ref.dart';

class NewTransDialog extends StatefulWidget {
  const NewTransDialog({super.key});

  @override
  State<StatefulWidget> createState() => _NewTransDialogState();
}

// ignore: must_be_immutable
class _NewTransDialogState extends State<NewTransDialog> {
  // Date picker controller
  Key dialogKey = const Key("NewDialog");

  TextEditingController vendorInput = TextEditingController();
  TextEditingController amountInput = TextEditingController();
  TextEditingController categoryInput = TextEditingController();
  TextEditingController dateInput = TextEditingController(
      text: DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()));

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    vendorInput.dispose();
    amountInput.dispose();
    categoryInput.dispose();
    dateInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: dialogKey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      insetPadding: const EdgeInsets.all(16),
      elevation: 1,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(child: Container(
        padding:
            const EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 16),
        // margin: const EdgeInsets.only(top: avatarRadius),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.post_add,
              size: 36.0,
              color: Color(0xFF80A47B),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'New Transaction',
              style: TextStyle(
                  color: Color(0xFF80A47B),
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 250,
              child: ListView.separated(
                itemCount: 4,
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 0.5,
                    color: Color(0xFF656565),
                  );
                },
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return ListItem(
                        controller: vendorInput,
                        hintText: 'Where\'d you get it?',
                        icon: Icons.storefront,
                      );
                    case 1:
                      return ListItem(
                        controller: amountInput,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        hintText: 'What\'d it cost?',
                        icon: Icons.attach_money,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        ],
                      );
                    case 2:
                      return DropdownMenu<Category>(
                        controller: categoryInput,
                        textStyle: const TextStyle(color: Color(0xFF80A47B), fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w500),
                        menuStyle: const MenuStyle(
                          shadowColor: MaterialStatePropertyAll(Colors.black),
                          backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF80A47B)),
                          elevation: MaterialStatePropertyAll(4.0)
                        ),
                        leadingIcon: const Icon(Icons.local_offer),
                        initialSelection: Category.other,
                        dropdownMenuEntries: CategoryDropDown.getList,
                        inputDecorationTheme: const InputDecorationTheme(
                          prefixIconColor: Color(0xFF80A47B),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xFF80A47B), fontFamily: 'Roboto', fontSize: 14),
                        ),
                        trailingIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF80A47B),),
                        selectedTrailingIcon: const Icon(Icons.arrow_drop_up, color: Color(0xFF80A47B),),
                    );
                    case 3:
                      return ListItem(
                          controller: dateInput,
                          readOnly: true,
                          icon: Icons.calendar_today,
                          onTap: () async {
                            picker.DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              currentTime: DateTime.now(), 
                              locale: picker.LocaleType.en,
                              minTime: DateTime(2022, 1, 1),
                              theme: const picker.DatePickerTheme(
                                headerColor: Color(0xFF80A47B),
                                backgroundColor: Color(0xFFF4F4F4),
                                itemStyle: TextStyle(color: Color(0xFF808782), fontWeight: FontWeight.bold, fontSize: 18),
                                doneStyle: TextStyle(color: Color(0xFFD1FFD7), fontSize: 16, fontWeight: FontWeight.w500)),
                              // onChanged: (date) {
                              //   print('change $date in time zone ' +
                              //   date.timeZoneOffset.inHours.toString());
                              // }, 
                              onConfirm: (date) {
                                String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(date);
                                dateInput.text = formattedDate;
                              }
                            );
                          });
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Color(0xFF80A47B),
                            fontSize: 14,
                            fontFamily: 'Roboto'),
                      )),
                  TextButton(
                      onPressed: () {
                        Purchase newItem = Purchase(
                            vendor: vendorInput.text,
                            amount: double.parse(amountInput.text),
                            category: categoryInput.text,
                            addedDate: DateTime.parse(dateInput.text),
                            userName: 'Dan');
                        
                        Navigator.pop(context, newItem);
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                            color: Color(0xFF80A47B),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w900),
                      )),
                ],
              ),
            ),
          ],
        ),
      ), // bottom part
    ),).animate().scale();
  }
}

// ignore: must_be_immutable
class ListItem extends TextField {
  String? hintText;
  IconData? icon;

  ListItem(
      {super.key,
      super.controller,
      super.onTap,
      super.readOnly,
      super.keyboardType,
      super.inputFormatters,
      this.hintText,
      this.icon});

  @override
  TextCapitalization get textCapitalization => TextCapitalization.words;

  @override
  Color? get cursorColor => const Color(0xFF80A47B);
  @override
  TextStyle? get style => const TextStyle(
      color: Color(0xFF80A47B), fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w500);
  @override
  bool get enableSuggestions => true;
  @override
  InputDecoration? get decoration => InputDecoration(
        prefixIcon: Icon(icon),
        prefixIconColor: const Color(0xFF80A47B),
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color(0xFF80A47B), fontFamily: 'Roboto', fontSize: 14),
      );
}
