import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(DoctorPortal());
}

// Models
class Patient {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int age;
  final String gender;
  final String address;
  final String medicalHistory;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.age,
    required this.gender,
    required this.address,
    required this.medicalHistory,
  });
}

class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final DateTime dateTime;
  final String type;
  final String status;
  final String notes;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.dateTime,
    required this.type,
    required this.status,
    required this.notes,
  });
}

class Prescription {
  final String id;
  final String patientId;
  final String patientName;
  final String medication;
  final String dosage;
  final String frequency;
  final String duration;
  final DateTime prescribedDate;

  Prescription({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.prescribedDate,
  });
}

// Sample Data Service
class DataService {
  static List<Patient> patients = [
    Patient(
      id: '1',
      name: 'John Doe',
      phone: '+1-555-0123',
      email: 'john.doe@email.com',
      age: 35,
      gender: 'Male',
      address: '123 Main St, City, State',
      medicalHistory: 'Hypertension, Diabetes Type 2',
    ),
    Patient(
      id: '2',
      name: 'Jane Smith',
      phone: '+1-555-0456',
      email: 'jane.smith@email.com',
      age: 28,
      gender: 'Female',
      address: '456 Oak Ave, City, State',
      medicalHistory: 'Asthma, Allergies',
    ),
    Patient(
      id: '3',
      name: 'Bob Johnson',
      phone: '+1-555-0789',
      email: 'bob.johnson@email.com',
      age: 42,
      gender: 'Male',
      address: '789 Pine Rd, City, State',
      medicalHistory: 'Heart Disease, High Cholesterol',
    ),
    Patient(
      id: '4',
      name: 'Alice Brown',
      phone: '+1-555-0321',
      email: 'alice.brown@email.com',
      age: 31,
      gender: 'Female',
      address: '321 Elm St, City, State',
      medicalHistory: 'Migraine, Anxiety',
    ),
  ];

  static List<Appointment> appointments = [
    Appointment(
      id: '1',
      patientId: '1',
      patientName: 'John Doe',
      dateTime: DateTime.now().add(Duration(hours: 2)),
      type: 'Consultation',
      status: 'Scheduled',
      notes: 'Follow-up for diabetes management',
    ),
    Appointment(
      id: '2',
      patientId: '2',
      patientName: 'Jane Smith',
      dateTime: DateTime.now().add(Duration(days: 1)),
      type: 'Check-up',
      status: 'Scheduled',
      notes: 'Routine asthma check',
    ),
    Appointment(
      id: '3',
      patientId: '3',
      patientName: 'Bob Johnson',
      dateTime: DateTime.now().add(Duration(days: 2)),
      type: 'Emergency',
      status: 'Urgent',
      notes: 'Chest pain evaluation',
    ),
  ];

  static List<Prescription> prescriptions = [
    Prescription(
      id: '1',
      patientId: '1',
      patientName: 'John Doe',
      medication: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice daily',
      duration: '30 days',
      prescribedDate: DateTime.now().subtract(Duration(days: 7)),
    ),
    Prescription(
      id: '2',
      patientId: '2',
      patientName: 'Jane Smith',
      medication: 'Albuterol Inhaler',
      dosage: '90mcg',
      frequency: 'As needed',
      duration: '30 days',
      prescribedDate: DateTime.now().subtract(Duration(days: 14)),
    ),
  ];

  static Patient? getPatientById(String id) {
    try {
      return patients.firstWhere((patient) => patient.id == id);
    } catch (e) {
      return null;
    }
  }
}

class DoctorPortal extends StatelessWidget {
  DoctorPortal({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder:
            (context, state, child) =>
                DashboardScreen(child: child, location: state.uri.toString()),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeTab()),
          GoRoute(
            path: '/appointments',
            builder: (context, state) => const AppointmentsTab(),
          ),
          GoRoute(
            path: '/patients',
            builder: (context, state) => const PatientsTab(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileTab(),
          ),
          // Additional routes for detailed screens
          GoRoute(
            path: '/patient/:id',
            builder: (context, state) {
              final patientId = state.pathParameters['id']!;
              final patient = DataService.getPatientById(patientId);
              return PatientDetailsScreen(patient: patient!);
            },
          ),
          GoRoute(
            path: '/telemedicine/:id',
            builder: (context, state) {
              final patientId = state.pathParameters['id']!;
              final patient = DataService.getPatientById(patientId);
              return TelemedicineScreen(patient: patient!);
            },
          ),
          GoRoute(
            path: '/prescribe/:id',
            builder: (context, state) {
              final patientId = state.pathParameters['id']!;
              final patient = DataService.getPatientById(patientId);
              return PrescriptionScreen(patient: patient);
            },
          ),
          GoRoute(
            path: '/prescriptions',
            builder: (context, state) => PrescriptionScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Doctor Portal',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 152, 94, 135),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final Widget child;
  final String location;

  const DashboardScreen({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(location),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/appointments')) return 1;
    if (location.startsWith('/patients') || location.startsWith('/patient/'))
      return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/appointments');
        break;
      case 2:
        context.go('/patients');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}

// Updated Tab Widgets
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Dr. Smith',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildStatsCards(),
            SizedBox(height: 20),
            _buildQuickActions(context),
            SizedBox(height: 20),
            _buildTodaysAppointments(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Patients',
            '${DataService.patients.length}',
            Icons.people,
            Colors.blue,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Today\'s Appointments',
            '${DataService.appointments.where((a) => _isToday(a.dateTime)).length}',
            Icons.calendar_today,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/patients'),
                    icon: Icon(Icons.people),
                    label: Text('View Patients'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/prescriptions'),
                    icon: Icon(Icons.medication),
                    label: Text('Prescriptions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysAppointments(BuildContext context) {
    final todaysAppointments =
        DataService.appointments.where((a) => _isToday(a.dateTime)).toList();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Appointments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            if (todaysAppointments.isEmpty)
              Text(
                'No appointments scheduled for today',
                style: TextStyle(color: Colors.grey[600]),
              )
            else
              ...todaysAppointments.map(
                (appointment) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(appointment.status),
                    child: Text(appointment.patientName.substring(0, 1)),
                  ),
                  title: Text(appointment.patientName),
                  subtitle: Text(
                    '${appointment.type} - ${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: Text(appointment.status),
                  onTap: () => context.go('/appointments'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'urgent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});

  @override
  _AppointmentsTabState createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showNewAppointmentDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: DataService.appointments.length,
        itemBuilder: (context, index) {
          final appointment = DataService.appointments[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(appointment.status),
                child: Icon(Icons.event, color: Colors.white),
              ),
              title: Text(
                appointment.patientName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${appointment.type} • ${appointment.status}'),
                  Text(
                    '${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year} at ${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}',
                  ),
                  if (appointment.notes.isNotEmpty)
                    Text(
                      appointment.notes,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'reschedule',
                        child: Text('Reschedule'),
                      ),
                      PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                      PopupMenuItem(
                        value: 'complete',
                        child: Text('Mark Complete'),
                      ),
                    ],
                onSelected:
                    (value) => _handleAppointmentAction(value, appointment),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'urgent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _handleAppointmentAction(String action, Appointment appointment) {
    setState(() {
      // Handle appointment actions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$action appointment for ${appointment.patientName}'),
        ),
      );
    });
  }

  void _showNewAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('New Appointment'),
            content: Text('Appointment booking form would go here.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Book Appointment'),
              ),
            ],
          ),
    );
  }
}

class PatientsTab extends StatefulWidget {
  const PatientsTab({super.key});

  @override
  _PatientsTabState createState() => _PatientsTabState();
}

class _PatientsTabState extends State<PatientsTab> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredPatients =
        DataService.patients
            .where(
              (patient) =>
                  patient.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  patient.phone.contains(searchQuery),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Patients'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddPatientDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 152, 94, 135),
                      child: Text(
                        patient.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      patient.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.phone),
                        Text(
                          '${patient.age} years • ${patient.gender}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () => context.go('/patient/${patient.id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add New Patient'),
            content: Text('Patient registration form would go here.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Add Patient'),
              ),
            ],
          ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color.fromARGB(255, 152, 94, 135),
              child: Icon(Icons.person, size: 50, color: Colors.blue[800]),
            ),
            SizedBox(height: 16),
            Text(
              'Dr. Sarah Smith',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Cardiologist',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            _buildProfileSection('Contact Information', [
              _buildProfileItem('Email', 'dr.smith@hospital.com'),
              _buildProfileItem('Phone', '+1-555-0100'),
              _buildProfileItem('Office', 'Room 304, Main Building'),
            ]),
            SizedBox(height: 16),
            _buildProfileSection('Professional Details', [
              _buildProfileItem('License Number', 'MD12345'),
              _buildProfileItem('Specialization', 'Cardiology'),
              _buildProfileItem('Experience', '15 years'),
            ]),
            SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 12),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.edit),
            label: Text('Edit Profile'),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.settings),
            label: Text('Settings'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}

// Patient Details Screen
class PatientDetailsScreen extends StatelessWidget {
  final Patient patient;

  PatientDetailsScreen({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [IconButton(icon: Icon(Icons.edit), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Personal Information', [
              _buildInfoRow('Name', patient.name),
              _buildInfoRow('Age', '${patient.age} years'),
              _buildInfoRow('Gender', patient.gender),
              _buildInfoRow('Phone', patient.phone),
              _buildInfoRow('Email', patient.email),
              _buildInfoRow('Address', patient.address),
            ]),
            SizedBox(height: 16),
            _buildInfoCard('Medical History', [
              Text(patient.medicalHistory, style: TextStyle(fontSize: 16)),
            ]),
            SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 241, 120, 229),
              ),
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.go('/telemedicine/${patient.id}'),
            icon: Icon(Icons.video_call),
            label: Text('Video Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 152, 94, 135),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.go('/prescribe/${patient.id}'),
            icon: Icon(Icons.medication),
            label: Text('Prescribe'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 152, 94, 135),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Telemedicine Screen
class TelemedicineScreen extends StatelessWidget {
  final Patient patient;

  TelemedicineScreen({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telemedicine'),
        backgroundColor: const Color.fromARGB(255, 152, 94, 135),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green[100],
                      child: Text(
                        patient.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(patient.phone),
                          Text('Status: Available for consultation'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Video call will appear here',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () => context.pop(),
                  backgroundColor: const Color.fromARGB(255, 152, 94, 135),
                  child: Icon(Icons.call_end, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: const Color.fromARGB(255, 146, 115, 144),
                  child: Icon(Icons.mic, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: const Color.fromARGB(255, 208, 162, 237),
                  child: Icon(Icons.videocam, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: const Color.fromARGB(255, 227, 147, 222),
                  child: Icon(Icons.chat, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionScreen extends StatefulWidget {
  final Patient? patient;

  PrescriptionScreen({this.patient});

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final _medicationController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.patient != null
              ? 'Prescribe for ${widget.patient!.name}'
              : 'Prescriptions',
        ),
        backgroundColor: const Color.fromARGB(255, 233, 176, 195),
        foregroundColor: Colors.white,
      ),
      body:
          widget.patient != null
              ? _buildPrescriptionForm()
              : _buildPrescriptionsList(),
    );
  }

  Widget _buildPrescriptionForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Name: ${widget.patient!.name}'),
                  Text('Age: ${widget.patient!.age} years'),
                  Text('Medical History: ${widget.patient!.medicalHistory}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Prescription',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _medicationController,
                    decoration: InputDecoration(
                      labelText: 'Medication Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _dosageController,
                    decoration: InputDecoration(
                      labelText: 'Dosage',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _frequencyController,
                    decoration: InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _savePrescription,
                      child: Text('Save Prescription'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: DataService.prescriptions.length,
      itemBuilder: (context, index) {
        final prescription = DataService.prescriptions[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: Icon(Icons.medication, color: Colors.orange[800]),
            ),
            title: Text(
              prescription.patientName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${prescription.medication} - ${prescription.dosage}'),
                Text('${prescription.frequency} for ${prescription.duration}'),
                Text(
                  'Prescribed: ${prescription.prescribedDate.day}/${prescription.prescribedDate.month}/${prescription.prescribedDate.year}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.print),
              onPressed: () async {
                // For example, printing a prescription string using the 'printing' package

                // 1. Add printing package to pubspec.yaml:
                //    printing: ^5.10.0

                // 2. Import it:
                // import 'package:printing/printing.dart';

                // 3. Define the prescription text (replace with your actual data)
                final prescriptionText = '''
Prescription

Patient: John Doe
Medication: Paracetamol 500mg
Dosage: 2 tablets daily after meals
Duration: 5 days

Doctor: Dr. Smith
''';

                // 4. Use Printing package to print or share PDF
                await Printing.layoutPdf(
                  onLayout: (format) async {
                    final pdf = pw.Document();

                    pdf.addPage(
                      pw.Page(
                        build:
                            (context) =>
                                pw.Center(child: pw.Text(prescriptionText)),
                      ),
                    );

                    return pdf.save();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _savePrescription() {
    if (_medicationController.text.isNotEmpty &&
        _dosageController.text.isNotEmpty &&
        _frequencyController.text.isNotEmpty &&
        _durationController.text.isNotEmpty) {
      // Save prescription logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prescription saved successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }
  }
}

// Navigation Drawer
Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue[700]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.local_hospital,
                  size: 30,
                  color: Colors.blue[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Dr. Medical System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Patient Management',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Patients'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PatientListScreen()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text('Appointments'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentManagementScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.medication),
          title: Text('Prescriptions'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrescriptionScreen()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
////////////////////////////////////////////////////////////////

// PATIENT LIST SCREEN
class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredPatients =
        DataService.patients.where((patient) {
          return patient.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              patient.phone.contains(searchQuery);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        backgroundColor: const Color.fromARGB(255, 233, 176, 195),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        patient.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      patient.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.phone),
                        Text(
                          '${patient.age} years • ${patient.gender}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PatientDetailsScreen(patient: patient),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientDialog(context),
        backgroundColor: const Color.fromARGB(255, 233, 176, 195),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Patient'),
            content: const Text('Patient registration form would go here.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Add Patient'),
              ),
            ],
          ),
    );
  }
}

// PLACEHOLDER: PATIENT DETAILS SCREEN

// APPOINTMENT MANAGEMENT SCREEN
class AppointmentManagementScreen extends StatefulWidget {
  @override
  _AppointmentManagementScreenState createState() =>
      _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState
    extends State<AppointmentManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: const Color.fromARGB(255, 233, 176, 195),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: DataService.appointments.length,
        itemBuilder: (context, index) {
          final appointment = DataService.appointments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(appointment.status),
                child: const Icon(Icons.event, color: Colors.white),
              ),
              title: Text(
                appointment.patientName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${appointment.type} • ${appointment.status}'),
                  Text(
                    '${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year} at ${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (appointment.notes.isNotEmpty)
                    Text(
                      appointment.notes,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected:
                    (value) => _handleAppointmentAction(value, appointment),
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'reschedule',
                        child: Text('Reschedule'),
                      ),
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Text('Cancel'),
                      ),
                      const PopupMenuItem(
                        value: 'complete',
                        child: Text('Mark Complete'),
                      ),
                    ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewAppointmentDialog(context),
        backgroundColor: const Color.fromARGB(255, 233, 176, 195),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _handleAppointmentAction(String action, Appointment appointment) {
    setState(() {
      // Add real logic here
      debugPrint('$action appointment for ${appointment.patientName}');
    });
  }

  void _showNewAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('New Appointment'),
            content: const Text('Appointment booking form would go here.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Book Appointment'),
              ),
            ],
          ),
    );
  }
}
