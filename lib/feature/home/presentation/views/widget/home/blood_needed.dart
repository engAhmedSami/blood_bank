import 'package:blood_bank/feature/home/presentation/views/widget/home/blood_drop.dart';
import 'package:flutter/material.dart';

class BloodNeededWidget extends StatelessWidget {
  final List<String> bloodTypes = ['B+', 'O+', 'AB+', 'O-', 'AB-', 'A+'];
  final List<double> bloodFillPercentages = [1.0, 0.25, 0.75, 0.0, 0.25, 0.5];

  BloodNeededWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Blood Needed',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(bloodTypes.length, (index) {
              return BloodDropWidget(
                bloodType: bloodTypes[index],
                fillPercentage: bloodFillPercentages[index],
              );
            }),
          ),
        ],
      ),
    );
  }
}
