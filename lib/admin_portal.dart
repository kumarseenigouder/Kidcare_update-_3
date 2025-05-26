import 'package:flutter/material.dart';

// Main Admin Dashboard with Navigation
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    AnalyticsScreen(),
    UserManagementScreen(),
    DoctorApprovalScreen(),
    ContentManagementScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Analytics',
      icon: Icons.analytics,
      screen: 'AnalyticsScreen',
    ),
    NavigationItem(
      title: 'User Management',
      icon: Icons.people,
      screen: 'UserManagementScreen',
    ),
    NavigationItem(
      title: 'Doctor Approval',
      icon: Icons.medical_services,
      screen: 'DoctorApprovalScreen',
    ),
    NavigationItem(
      title: 'Content Management',
      icon: Icons.article,
      screen: 'ContentManagementScreen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavigationTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items:
            _navigationItems
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.title,
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[800]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 30,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  selected: _selectedIndex == index,
                  selectedTileColor: Colors.blue[50],
                  onTap: () {
                    _onNavigationTap(index);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              _showSettingsDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Settings'),
            content: Text('Settings panel coming soon...'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add logout logic here
                },
                child: Text('Logout'),
              ),
            ],
          ),
    );
  }
}

// Navigation Item Model
class NavigationItem {
  final String title;
  final IconData icon;
  final String screen;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
}

// User Management Screen
class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _initializeUsers();
  }

  void _initializeUsers() {
    _users = List.generate(10, (index) {
      return User(
        id: index + 1,
        name: 'User ${index + 1}',
        email: 'user${index + 1}@example.com',
        status: index % 2 == 0 ? 'Active' : 'Inactive',
        joinDate: DateTime.now().subtract(Duration(days: index * 30)),
        phone: '+1234567890${index}',
        role: index % 3 == 0 ? 'Admin' : 'User',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _getFilteredUsers();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _showAddUserDialog,
                icon: Icon(Icons.add),
                label: Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              DropdownButton<String>(
                value: _selectedFilter,
                items:
                    ['All', 'Active', 'Inactive', 'Pending']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(user.name[0]),
                    ),
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text('Status: ${user.status} • Role: ${user.role}'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              child: Text('View Details'),
                              value: 'view',
                              onTap: () => _showUserDetails(user),
                            ),
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                              onTap: () => _showEditUserDialog(user),
                            ),
                            PopupMenuItem(
                              child: Text(
                                user.status == 'Active'
                                    ? 'Deactivate'
                                    : 'Activate',
                              ),
                              value: 'toggle',
                              onTap: () => _toggleUserStatus(user),
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                              onTap: () => _deleteUser(user),
                            ),
                          ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<User> _getFilteredUsers() {
    return _users.where((user) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _selectedFilter == 'All' || user.status == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showAddUserDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    String _selectedRole = 'User';
    String _selectedStatus = 'Active';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add New User'),
            content: Container(
              width: double.maxFinite,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      StatefulBuilder(
                        builder:
                            (context, setDialogState) => Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  value: _selectedRole,
                                  decoration: InputDecoration(
                                    labelText: 'Role',
                                    prefixIcon: Icon(Icons.work),
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      ['User', 'Admin', 'Moderator']
                                          .map(
                                            (role) => DropdownMenuItem(
                                              value: role,
                                              child: Text(role),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setDialogState(() {
                                      _selectedRole = value!;
                                    });
                                  },
                                ),
                                SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedStatus,
                                  decoration: InputDecoration(
                                    labelText: 'Status',
                                    prefixIcon: Icon(Icons.toggle_on),
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      ['Active', 'Inactive', 'Pending']
                                          .map(
                                            (status) => DropdownMenuItem(
                                              value: status,
                                              child: Text(status),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setDialogState(() {
                                      _selectedStatus = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _nameController.dispose();
                  _emailController.dispose();
                  _phoneController.dispose();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addUser(
                      _nameController.text,
                      _emailController.text,
                      _phoneController.text,
                      _selectedRole,
                      _selectedStatus,
                    );
                    Navigator.of(context).pop();
                    _nameController.dispose();
                    _emailController.dispose();
                    _phoneController.dispose();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
                child: Text('Add User'),
              ),
            ],
          ),
    );
  }

  void _addUser(
    String name,
    String email,
    String phone,
    String role,
    String status,
  ) {
    setState(() {
      _users.add(
        User(
          id: _users.length + 1,
          name: name,
          email: email,
          status: status,
          joinDate: DateTime.now(),
          phone: phone,
          role: role,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User $name added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showEditUserDialog(User user) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: user.name);
    final _emailController = TextEditingController(text: user.email);
    final _phoneController = TextEditingController(text: user.phone);
    String _selectedRole = user.role;
    String _selectedStatus = user.status;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit User'),
            content: Container(
              width: double.maxFinite,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      StatefulBuilder(
                        builder:
                            (context, setDialogState) => Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  value: _selectedRole,
                                  decoration: InputDecoration(
                                    labelText: 'Role',
                                    prefixIcon: Icon(Icons.work),
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      ['User', 'Admin', 'Moderator']
                                          .map(
                                            (role) => DropdownMenuItem(
                                              value: role,
                                              child: Text(role),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setDialogState(() {
                                      _selectedRole = value!;
                                    });
                                  },
                                ),
                                SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedStatus,
                                  decoration: InputDecoration(
                                    labelText: 'Status',
                                    prefixIcon: Icon(Icons.toggle_on),
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      ['Active', 'Inactive', 'Pending']
                                          .map(
                                            (status) => DropdownMenuItem(
                                              value: status,
                                              child: Text(status),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setDialogState(() {
                                      _selectedStatus = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _nameController.dispose();
                  _emailController.dispose();
                  _phoneController.dispose();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateUser(
                      user,
                      _nameController.text,
                      _emailController.text,
                      _phoneController.text,
                      _selectedRole,
                      _selectedStatus,
                    );
                    Navigator.of(context).pop();
                    _nameController.dispose();
                    _emailController.dispose();
                    _phoneController.dispose();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
                child: Text('Update User'),
              ),
            ],
          ),
    );
  }

  void _updateUser(
    User user,
    String name,
    String email,
    String phone,
    String role,
    String status,
  ) {
    setState(() {
      user.name = name;
      user.email = email;
      user.phone = phone;
      user.role = role;
      user.status = status;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User $name updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('User Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Name:', user.name),
                _buildDetailRow('Email:', user.email),
                _buildDetailRow('Phone:', user.phone),
                _buildDetailRow('Role:', user.role),
                _buildDetailRow('Status:', user.status),
                _buildDetailRow(
                  'Joined:',
                  user.joinDate.toString().split(' ')[0],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showEditUserDialog(user);
                },
                child: Text('Edit'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _toggleUserStatus(User user) {
    Future.delayed(Duration.zero, () {
      setState(() {
        user.status = user.status == 'Active' ? 'Inactive' : 'Active';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.name} is now ${user.status}'),
          backgroundColor:
              user.status == 'Active' ? Colors.green : Colors.orange,
        ),
      );
    });
  }

  void _deleteUser(User user) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Delete User'),
              content: Text(
                'Are you sure you want to delete "${user.name}"? This action cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _users.remove(user);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user.name} deleted successfully!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  child: Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
      );
    });
  }
}

// User Model
class User {
  int id;
  String name;
  String email;
  String status;
  DateTime joinDate;
  String phone;
  String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.joinDate,
    required this.phone,
    required this.role,
  });
}

class DoctorApprovalScreen extends StatefulWidget {
  @override
  _DoctorApprovalScreenState createState() => _DoctorApprovalScreenState();
}

class _DoctorApprovalScreenState extends State<DoctorApprovalScreen> {
  List<Doctor> _pendingDoctors = [
    Doctor(
      id: 1,
      name: 'Dr. John Smith',
      email: 'john@example.com',
      specialty: 'Cardiology',
      status: 'Pending',
    ),
    Doctor(
      id: 2,
      name: 'Dr. Jane Doe',
      email: 'jane@example.com',
      specialty: 'Neurology',
      status: 'Pending',
    ),
    Doctor(
      id: 3,
      name: 'Dr. Mike Johnson',
      email: 'mike@example.com',
      specialty: 'Orthopedics',
      status: 'Pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Doctor Approval Requests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _pendingDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _pendingDoctors[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green[100],
                              child: Icon(
                                Icons.medical_services,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(doctor.email),
                                  Text('Specialty: ${doctor.specialty}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _rejectDoctor(index),
                              child: Text('Reject'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _approveDoctor(index),
                              child: Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _approveDoctor(int index) {
    setState(() {
      _pendingDoctors[index].status = 'Approved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_pendingDoctors[index].name} approved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    // Remove from pending list after a delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _pendingDoctors.removeAt(index);
      });
    });
  }

  void _rejectDoctor(int index) {
    setState(() {
      _pendingDoctors[index].status = 'Rejected';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_pendingDoctors[index].name} rejected.'),
        backgroundColor: Colors.red,
      ),
    );
    // Remove from pending list after a delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _pendingDoctors.removeAt(index);
      });
    });
  }
}

// Doctor Model
class Doctor {
  final int id;
  final String name;
  final String email;
  final String specialty;
  String status;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.status,
  });
}

// Analytics Screen (Updated with StatefulWidget for dynamic data)
class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, String> _analyticsData = {
    'Total Users': '1,234',
    'Active Doctors': '156',
    'Pending Approvals': '23',
    'Content Items': '456',
  };

  List<Activity> _recentActivities = [
    Activity('New user registration', '2 minutes ago'),
    Activity('Doctor approval request', '15 minutes ago'),
    Activity('Content updated', '1 hour ago'),
    Activity('System backup completed', '3 hours ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analytics Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _refreshData,
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh Data',
              ),
            ],
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildAnalyticsCard(
                'Total Users',
                _analyticsData['Total Users']!,
                Icons.people,
                Colors.blue,
              ),
              _buildAnalyticsCard(
                'Active Doctors',
                _analyticsData['Active Doctors']!,
                Icons.medical_services,
                Colors.green,
              ),
              _buildAnalyticsCard(
                'Pending Approvals',
                _analyticsData['Pending Approvals']!,
                Icons.pending,
                Colors.orange,
              ),
              _buildAnalyticsCard(
                'Content Items',
                _analyticsData['Content Items']!,
                Icons.article,
                Colors.purple,
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _recentActivities.length,
                        itemBuilder: (context, index) {
                          final activity = _recentActivities[index];
                          return _buildActivityItem(
                            activity.description,
                            activity.time,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    setState(() {
      // Simulate data refresh
      _analyticsData = {
        'Total Users': '${1234 + DateTime.now().millisecond}',
        'Active Doctors': '${156 + (DateTime.now().millisecond % 10)}',
        'Pending Approvals': '${23 - (DateTime.now().millisecond % 5)}',
        'Content Items': '${456 + (DateTime.now().millisecond % 20)}',
      };
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Data refreshed!')));
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _showCardDetails(title, value),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCardDetails(String title, String value) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(
              'Current value: $value\n\nDetailed analytics coming soon...',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Activity Model
class Activity {
  final String description;
  final String time;

  Activity(this.description, this.time);
}

// Content Management Screen (Updated with StatefulWidget)
class ContentManagementScreen extends StatefulWidget {
  @override
  _ContentManagementScreenState createState() =>
      _ContentManagementScreenState();
}

class _ContentManagementScreenState extends State<ContentManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<ContentItem> _contentItems = [];

  @override
  void initState() {
    super.initState();
    _initializeContent();
  }

  void _initializeContent() {
    final contentTypes = ['Article', 'Video', 'Image', 'PDF'];
    _contentItems = List.generate(8, (index) {
      final contentType = contentTypes[index % contentTypes.length];
      return ContentItem(
        id: index + 1,
        title: 'Content Item ${index + 1}',
        type: contentType,
        createdDate: DateTime.now().subtract(Duration(days: index)),
        status: index % 3 == 0 ? 'Published' : 'Draft',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredContent = _getFilteredContent();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Content Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _showAddContentDialog,
                icon: Icon(Icons.add),
                label: Text('Add Content'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search content...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              DropdownButton<String>(
                value: _selectedFilter,
                items:
                    ['All', 'Articles', 'Videos', 'Images', 'PDFs']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContent.length,
              itemBuilder: (context, index) {
                final content = filteredContent[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(_getContentIcon(content.type)),
                      backgroundColor: _getContentColor(content.type),
                    ),
                    title: Text(content.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type: ${content.type}'),
                        Text(
                          'Created: ${content.createdDate.toString().split(' ')[0]}',
                        ),
                        Text('Status: ${content.status}'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                              onTap: () => _editContent(content),
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                              onTap: () => _deleteContent(content),
                            ),
                            PopupMenuItem(
                              child: Text(
                                content.status == 'Published'
                                    ? 'Unpublish'
                                    : 'Publish',
                              ),
                              value: 'publish',
                              onTap: () => _togglePublishStatus(content),
                            ),
                          ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ContentItem> _getFilteredContent() {
    return _contentItems.where((item) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _selectedFilter == 'All' ||
          (_selectedFilter == 'Articles' && item.type == 'Article') ||
          (_selectedFilter == 'Videos' && item.type == 'Video') ||
          (_selectedFilter == 'Images' && item.type == 'Image') ||
          (_selectedFilter == 'PDFs' && item.type == 'PDF');
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showAddContentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add New Content'),
            content: Text('Content creation form coming soon...'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _addNewContent();
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  void _addNewContent() {
    setState(() {
      _contentItems.add(
        ContentItem(
          id: _contentItems.length + 1,
          title: 'New Content Item',
          type: 'Article',
          createdDate: DateTime.now(),
          status: 'Draft',
        ),
      );
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('New content added!')));
  }

  void _editContent(ContentItem content) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Edit ${content.title} - Feature coming soon!')),
      );
    });
  }

  void _deleteContent(ContentItem content) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Delete Content'),
              content: Text(
                'Are you sure you want to delete "${content.title}"?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _contentItems.remove(content);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${content.title} deleted!')),
                    );
                  },
                  child: Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
      );
    });
  }

  void _togglePublishStatus(ContentItem content) {
    Future.delayed(Duration.zero, () {
      setState(() {
        content.status = content.status == 'Published' ? 'Draft' : 'Published';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${content.title} ${content.status.toLowerCase()}!'),
        ),
      );
    });
  }

  IconData _getContentIcon(String type) {
    switch (type) {
      case 'Article':
        return Icons.article;
      case 'Video':
        return Icons.video_library;
      case 'Image':
        return Icons.image;
      case 'PDF':
        return Icons.picture_as_pdf;
      default:
        return Icons.description;
    }
  }

  Color _getContentColor(String type) {
    switch (type) {
      case 'Article':
        return Colors.blue[100]!;
      case 'Video':
        return Colors.red[100]!;
      case 'Image':
        return Colors.green[100]!;
      case 'PDF':
        return Colors.orange[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}

// Content Item Model
class ContentItem {
  final int id;
  String title;
  final String type;
  final DateTime createdDate;
  String status;

  ContentItem({
    required this.id,
    required this.title,
    required this.type,
    required this.createdDate,
    required this.status,
  });
}
