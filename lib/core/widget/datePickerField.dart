import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:flutter/material.dart';

Widget datePickerField({
  required BuildContext context,
  required String label,
  required DateTime? selectedDate,
  required Function(DateTime) onDateSelected,
  required bool isNextDonationDate,
}) {
  return FormField<DateTime>(
    initialValue: selectedDate,
    validator: (value) {
      if (value == null) {
        return 'Please select a date';
      }
      return null;
    },
    builder: (formFieldState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomRequestTextField(
            controller: TextEditingController(
              text: selectedDate != null
                  ? selectedDate.toLocal().toString().split(' ')[0]
                  : '',
            ),
            hintText: label,
            suffixIcon: const Icon(Icons.calendar_today),
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: isNextDonationDate ? DateTime.now() : DateTime(2000),
                lastDate: isNextDonationDate
                    ? DateTime.now().add(const Duration(days: 365 * 11))
                    : DateTime.now(),
              );
              if (date != null) {
                onDateSelected(date);
                formFieldState.didChange(date);
              }
            },
          ),
          if (formFieldState.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                formFieldState.errorText!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    },
  );
}
