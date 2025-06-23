import 'package:flutter/material.dart';
import 'ParentPortal_Features/DoctorDetailsScreen.dart';

// Doctor data
final List<Map<String, String>> doctors = [
  {
    'name': 'Dr. JOHN DOE',
    'specialty': 'Pediatrician',
    'image': 'assets/doctor1.png',
  },
  {
    'name': 'Dr. JANE SMITH',
    'specialty': 'Cardiologist',
    'image': 'assets/doctor2.png',
  },
  {
    'name': 'Dr. PAVAN U',
    'specialty': 'Orthopedic Surgeon',
    'image': 'assets/images/pavan.jpg',
  },
  {
    'name': 'Dr. JAMES',
    'specialty': 'Pediatrician',
    'image': 'assets/doctor3.png',
  },
  {
    'name': 'Dr. SMITH',
    'specialty': 'Neurologist',
    'image': 'assets/doctor4.png',
  },
  {
    'name': 'Dr. KUMAR S',
    'specialty': 'Pediatric Cardiologist',
    'image': 'assets/doctor2.png',
  },
  {
    'name': 'Dr. JOHNSON',
    'specialty': 'Dermatologist',
    'image': 'assets/doctor5.png',
  },
  {
    'name': 'Dr. WILLIAMS',
    'specialty': 'Allergist',
    'image': 'assets/doctor6.png',
  },
  {
    'name': 'Dr. BROWN',
    'specialty': 'Endocrinologist',
    'image': 'assets/doctor7.png',
  },
  {
    'name': 'Dr. JONES',
    'specialty': 'Gastroenterologist',
    'image': 'assets/doctor8.png',
  },
];

class ParentAppointmentsTab extends StatelessWidget {
  const ParentAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F8), // Matching background color
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find a Doctor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return Card(
                    color: Colors.white, // Consistent with other pages
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(doctor['image']!),
                        radius: 30,
                      ),
                      title: Text(
                        doctor['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(doctor['specialty']!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DoctorDetailsScreen(
                                  name: doctor['name']!,
                                  specialty: doctor['specialty']!,
                                  image: doctor['image']!,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
