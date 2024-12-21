import 'dart:developer';
import 'package:blood_bank/core/widget/governorate_drop_down.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'blood_group_selector.dart';
import 'units_dropdown.dart';
import 'package:blood_bank/core/widget/custom_button.dart';

class FindDonors extends StatefulWidget {
  const FindDonors({super.key});

  @override
  State<FindDonors> createState() => _FindDonorsState();
}

class _FindDonorsState extends State<FindDonors> {
  String? selectedBloodGroup;
  int selectedUnits = 1;
  String? location;
  bool isLoading = false;
  List<Map<String, dynamic>> donors = [];

  Future<void> findDonors() async {
    log("Selected Blood Group: $selectedBloodGroup");
    log("Location: $location");

    if (selectedBloodGroup == null || location == null || location!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('donerRequest')
          .where('bloodType', isEqualTo: selectedBloodGroup)
          .where('address', isEqualTo: location)
          .get();

      final fetchedDonors = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      setState(() {
        donors = fetchedDonors;
      });
    } catch (e) {
      log("Error fetching donors: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch donors: $e"),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Choose Blood Group",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              BloodGroupSelector(
                selectedBloodGroup: selectedBloodGroup,
                onSelect: (value) {
                  log("Blood Group Selected: $value");
                  setState(() {
                    selectedBloodGroup = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Blood Unit Needed",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  UnitsDropdown(
                    selectedUnits: selectedUnits,
                    onChanged: (value) {
                      setState(() {
                        selectedUnits = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Enter your location",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              GovernorateDropdown(
                selectedGovernorate: location,
                onChanged: (value) {
                  setState(() {
                    location = value;
                  });
                },
              ),
              const SizedBox(height: 60),
              CustomButton(
                onPressed: findDonors,
                text: 'Find Donors',
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (donors.isNotEmpty)
                Column(
                  children: donors.map((donor) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(donor['name'] ?? "Unknown"),
                        subtitle: Text(
                            'Location: ${donor['address'] ?? "Unknown"}, Blood Group: ${donor['bloodType'] ?? "Unknown"}'), // التفاصيل
                        trailing: Text('${donor['units'] ?? "0"} units'),
                      ),
                    );
                  }).toList(),
                )
              else
                const Center(
                  child: Text("No donors found for your criteria."),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text(
      "Find Donors",
      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => Navigator.pop(context),
    ),
  );
}
