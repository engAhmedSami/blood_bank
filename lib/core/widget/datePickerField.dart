// import 'package:blood_bank/core/widget/custom_request_text_field.dart';
// import 'package:flutter/material.dart';

// Widget datePickerField({
//   required BuildContext context,
//   required String label,
//   required DateTime? selectedDate,
//   required Function(DateTime) onDateSelected,
//   required bool isNextDonationDate,
// }) {
//   return FormField<DateTime>(
//     initialValue: selectedDate,
//     validator: (value) {
//       if (value == null) {
//         return 'Please select a date';
//       }
//       return null;
//     },
//     builder: (formFieldState) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomRequestTextField(
//             controller: TextEditingController(
//               text: selectedDate != null
//                   ? selectedDate.toLocal().toString().split(' ')[0]
//                   : '',
//             ),
//             hintText: label,
//             suffixIcon: const Icon(Icons.calendar_today),
//             readOnly: true,
//             onTap: () async {
//               final date = await showDatePicker(
//                 context: context,
//                 initialDate: selectedDate ?? DateTime.now(),
//                 firstDate: isNextDonationDate ? DateTime.now() : DateTime(2000),
//                 lastDate: isNextDonationDate
//                     ? DateTime.now().add(const Duration(days: 365 * 11))
//                     : DateTime.now(),
//               );
//               if (date != null) {
//                 onDateSelected(date);
//                 formFieldState.didChange(date);
//               }
//             },
//           ),
//           if (formFieldState.hasError)
//             Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: Text(
//                 formFieldState.errorText!,
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//         ],
//       );
//     },
//   );
// }

import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final BuildContext context;
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final bool isNextDonationDate;

  const DatePickerField({
    super.key,
    required this.context,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    required this.isNextDonationDate,
  });

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedDate != null
          ? widget.selectedDate!.toLocal().toString().split(' ')[0]
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: widget.selectedDate,
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
              controller: _controller,
              hintText: widget.label,
              suffixIcon: const Icon(Icons.calendar_today),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: widget.context,
                  initialDate: widget.selectedDate ?? DateTime.now(),
                  firstDate: widget.isNextDonationDate
                      ? DateTime.now()
                      : DateTime(2000),
                  lastDate: widget.isNextDonationDate
                      ? DateTime.now().add(const Duration(days: 365 * 11))
                      : DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _controller.text = date.toLocal().toString().split(' ')[0];
                  });
                  widget.onDateSelected(date);
                  formFieldState.didChange(date);
                }
              },
            ),
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  formFieldState.errorText!,
                  style: const TextStyle(
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
}
