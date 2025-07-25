import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CollegeApp());
}

class CollegeApp extends StatelessWidget {
  const CollegeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Campus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  static final List<Widget> _screens = <Widget>[
    HomeScreen(),
    SearchScreen(),
    CompareScreen(),
    ExamsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Exams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient App Bar Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.apartment, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'College Campus',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.notifications_none, color: Colors.white),
                          SizedBox(width: 16),
                          Icon(Icons.person_outline, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search colleges, courses, exams...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.blue),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Filter Chips
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildChip('Engineering'),
                      _buildChip('MBA'),
                      _buildChip('Medical'),
                      _buildChip('Arts'),
                    ],
                  ),
                ],
              ),
            ),
            // Compare & Predictor Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: _HomeCard(
                      icon: Icons.compare_arrows,
                      iconColor: Colors.blue,
                      title: 'Compare',
                      subtitle: 'Colleges',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _HomeCard(
                      icon: Icons.lightbulb_outline,
                      iconColor: Colors.orange,
                      title: 'Predictor',
                      subtitle: 'Find colleges',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            // Find Colleges Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Find Colleges', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, size: 18, color: Colors.blue),
                    label: Text('Filters', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                children: [
                  _buildFilterChip('All Courses', true),
                  _buildFilterChip('Location', false),
                  _buildFilterChip('Fees', false),
                  _buildFilterChip('Ranking', false),
                ],
              ),
            ),
            SizedBox(height: 28),
            Center(child: Text('No colleges found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15))),
            SizedBox(height: 28),
            // Recommended for You
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Recommended for You', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Card(
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    child: ListTile(
                      leading: Icon(Icons.lightbulb_outline, color: Colors.blue),
                      title: Text('College Predictor', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Find colleges based on your JEE Main score'),
                      trailing: TextButton(
                        onPressed: () {},
                        child: Text('Try Now', style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Card(
                    color: Colors.orange[50],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    child: ListTile(
                      leading: Icon(Icons.event, color: Colors.orange),
                      title: Text('Exam Calendar', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('JEE Advanced registration starts in 2 days'),
                      trailing: TextButton(
                        onPressed: () {},
                        child: Text('View', style: TextStyle(color: Colors.orange)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return ActionChip(
      label: Text(label, style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w500)),
      backgroundColor: Colors.blue[100],
      elevation: 0,
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return FilterChip(
      label: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      selected: selected,
      onSelected: (_) {},
      selectedColor: Colors.blue.shade100,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      checkmarkColor: Colors.blue,
      labelStyle: TextStyle(color: selected ? Colors.blue : Colors.black87),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 34, color: iconColor),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  String _selectedSort = 'Rank';
  String? _selectedType; // Engineering, MBA, Medical, Arts
  final List<String> _types = ['Engineering', 'MBA', 'Medical', 'Arts'];
  final List<String> _sortOptions = ['Rank', 'Fees', 'City'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.apartment, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Search Colleges',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.notifications_none, color: Colors.white),
                    SizedBox(width: 16),
                    Icon(Icons.person_outline, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          // Search Bar
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search colleges, courses, locations...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          // Sort by and Filters Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('Sort by:', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedSort,
                  items: _sortOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSort = newValue;
                      });
                    }
                  },
                  underline: SizedBox(),
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedType = null;
                    });
                  },
                  icon: Icon(Icons.filter_list, size: 18),
                  label: Text('Clear Filters'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: _types.map((type) => FilterChip(
                label: Text(type),
                selected: _selectedType == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = selected ? type : null;
                  });
                },
              )).toList(),
            ),
          ),
          // Firestore Colleges List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('colleges').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading colleges'));
                }
                final docs = snapshot.data?.docs ?? [];
                // In-memory filtering and sorting
                List<Map<String, dynamic>> colleges = docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                if (_searchText.isNotEmpty) {
                  colleges = colleges.where((c) {
                    return (c['name'] ?? '').toString().toLowerCase().contains(_searchText) ||
                           (c['city'] ?? '').toString().toLowerCase().contains(_searchText) ||
                           (c['type'] ?? '').toString().toLowerCase().contains(_searchText);
                  }).toList();
                }
                if (_selectedType != null) {
                  colleges = colleges.where((c) => (c['type'] ?? '') == _selectedType).toList();
                }
                if (_selectedSort == 'Rank') {
                  colleges.sort((a, b) => (a['rank'] ?? 99999).compareTo(b['rank'] ?? 99999));
                } else if (_selectedSort == 'Fees') {
                  colleges.sort((a, b) => (a['fees'] ?? 0).compareTo(b['fees'] ?? 0));
                } else if (_selectedSort == 'City') {
                  colleges.sort((a, b) => (a['city'] ?? '').toString().compareTo((b['city'] ?? '').toString()));
                }
                if (colleges.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text('No colleges found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Try adjusting your search criteria or filters', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: colleges.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final data = colleges[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 1,
                      child: ListTile(
                        leading: Icon(Icons.school, color: Colors.blue, size: 32),
                        title: Text(data['name'] ?? '', style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${data['city'] ?? ''} • ${data['type'] ?? ''}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Rank: ${data['rank'] ?? '-'}', style: TextStyle(fontSize: 13)),
                            Text('₹${data['fees'] ?? '-'}', style: TextStyle(fontSize: 13, color: Colors.green)),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SortDropdown extends StatefulWidget {
  @override
  State<_SortDropdown> createState() => _SortDropdownState();
}

class _SortDropdownState extends State<_SortDropdown> {
  String _selected = 'Rank';
  final List<String> _options = ['Rank', 'Fees', 'City', 'Popularity'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selected,
      items: _options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selected = newValue;
          });
        }
      },
      underline: SizedBox(),
      style: TextStyle(fontSize: 15, color: Colors.black),
      borderRadius: BorderRadius.circular(8),
    );
  }
}

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  // For now, just simulate selected colleges with a list of strings
  List<String> selectedColleges = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.compare_arrows, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Compare Colleges',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.notifications_none, color: Colors.white),
                    SizedBox(width: 16),
                    Icon(Icons.person_outline, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          // Instruction/Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select up to 4 colleges to compare', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search and add colleges...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty && selectedColleges.length < 4) {
                      setState(() {
                        selectedColleges.add(value);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          // Selected Colleges Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(4, (index) {
                if (index < selectedColleges.length) {
                  return Expanded(
                    child: Card(
                      color: Colors.blue[50],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.school, color: Colors.blue, size: 32),
                                SizedBox(height: 8),
                                Text(selectedColleges[index], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedColleges.removeAt(index);
                                });
                              },
                              child: Icon(Icons.close, size: 18, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.grey, size: 32),
                            SizedBox(height: 8),
                            Text('Add College', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
          SizedBox(height: 24),
          // Compare Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedColleges.length < 2 ? null : () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.blue[100],
                ),
                child: Text('Compare'),
              ),
            ),
          ),
          SizedBox(height: 32),
          // Empty State or Comparison Placeholder
          if (selectedColleges.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.compare, size: 64, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text('No colleges selected', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Search and add colleges to compare', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                  ],
                ),
              ),
            ),
          if (selectedColleges.isNotEmpty)
            Expanded(
              child: Center(
                child: Text('Comparison Table Placeholder', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }
}

class ExamsScreen extends StatelessWidget {
  final List<Map<String, String>> exams = [
    {
      'name': 'JEE Main',
      'date': 'Registration ends in 3 days',
      'type': 'Engineering',
      'icon': 'engineering',
    },
    {
      'name': 'NEET',
      'date': 'Exam on 5th May',
      'type': 'Medical',
      'icon': 'medical',
    },
    {
      'name': 'CAT',
      'date': 'Results in 1 week',
      'type': 'MBA',
      'icon': 'mba',
    },
  ];

  ExamsScreen({super.key});

  IconData _getExamIcon(String type) {
    switch (type) {
      case 'Engineering':
        return Icons.engineering;
      case 'Medical':
        return Icons.local_hospital;
      case 'MBA':
        return Icons.business_center;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.event_note, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Entrance Exams 2024',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.notifications_none, color: Colors.white),
                    SizedBox(width: 16),
                    Icon(Icons.person_outline, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          // Exams List or Empty State
          if (exams.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text('No exams found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Check back later for upcoming exams', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: exams.length,
                separatorBuilder: (_, __) => SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(_getExamIcon(exam['type'] ?? ''), color: Colors.blue, size: 32),
                      title: Text(exam['name'] ?? '', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(exam['date'] ?? ''),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.notifications_none, color: Colors.white),
                    SizedBox(width: 16),
                    Icon(Icons.settings, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          // User Info Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.blue[100],
                      child: Icon(Icons.person, size: 36, color: Colors.blue),
                    ),
                    SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 4),
                        Text('john.doe@email.com', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Aspirant: Engineering', style: TextStyle(color: Colors.blue, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ProfileStat(icon: Icons.remove_red_eye, label: 'Viewed', value: '12'),
                _ProfileStat(icon: Icons.favorite, label: 'Favorites', value: '5'),
                _ProfileStat(icon: Icons.compare_arrows, label: 'Compared', value: '3'),
              ],
            ),
          ),
          SizedBox(height: 18),
          // Preferences Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 10,
              children: [
                Chip(label: Text('Engineering'), backgroundColor: Colors.blue[100]),
                Chip(label: Text('Bangalore'), backgroundColor: Colors.blue[100]),
                Chip(label: Text('Budget: <2L'), backgroundColor: Colors.blue[100]),
              ],
            ),
          ),
          SizedBox(height: 18),
          // Favorites & History Section (Placeholder)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Favorites & History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Expanded(
            child: Center(
              child: Text('No favorites or history yet.', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
            ),
          ),
          // Settings Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.settings),
                label: Text('Account Settings'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(icon, color: Colors.blue),
        ),
        SizedBox(height: 6),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
      ],
    );
  }
}

