import 'package:flutter/material.dart';

enum GenderEnum { male, female }

class GenderCard extends StatelessWidget {
  final GenderEnum selectedGender;
  final ValueChanged<GenderEnum> onGenderChanged;

  const GenderCard({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isMale = selectedGender == GenderEnum.male;
    return GestureDetector(
      onTap: () {
        onGenderChanged(isMale ? GenderEnum.female : GenderEnum.male);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 14),
        decoration: BoxDecoration(
          color: isMale
              ? Theme.of(context).colorScheme.primary.withAlpha(25)
              : Colors.pink.withAlpha(25),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isMale
                ? Theme.of(context).colorScheme.primary.withAlpha(25)
                : Colors.pink.withAlpha(25),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMale ? Icons.male : Icons.female,
              color: isMale
                  ? Theme.of(context).colorScheme.primary
                  : Colors.pink,
              size: 24,
            ),
            SizedBox(width: 6),
            Text(
              selectedGender.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                color: isMale
                    ? Theme.of(context).colorScheme.primary
                    : Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final InputDecoration? decoration;

  const DatePickerField({
    super.key,
    required this.controller,
    this.hintText = "Birth Date",
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration:
          (decoration ??
                  InputDecoration(
                    hintText: hintText,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondary.withAlpha(128),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ))
              .copyWith(
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary.withAlpha(128),
                ),
              ),
      style: TextStyle(fontSize: 14),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: this.controller.text.isNotEmpty
          ? DateTime.parse(controller.text)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }
}
