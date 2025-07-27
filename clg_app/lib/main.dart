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
    // Mock/sample data for new sections
    final recentVisits = [
      {'name': 'Christ University', 'city': 'Bangalore'},
      {'name': 'BMS College', 'city': 'Bangalore'},
    ];
    final specializations = [
      'Engineering', 'MBA', 'BCA', 'Medical', 'Arts', 'Law', 'Science', 'Commerce'
    ];
    final topStudyPlaces = ['Bangalore', 'Delhi', 'Mumbai', 'Chennai', 'Hyderabad'];
    final topExams = ['JEE Main', 'NEET', 'CAT', 'KCET', 'COMEDK'];
    final trendingTags = ['Placement', 'Campus', 'Hostel', 'Interview', 'Fee Structure', 'Internship'];
    final news = [
      {'title': 'NIRF 2025 Rankings Released', 'date': '26 Jun, 2025', 'details': 'NIRF 2025 rankings are out! Christ University retains top spot.'},
      {'title': 'Admissions Open for 2025', 'date': '15 May, 2025', 'details': 'Admissions for 2025 batch are now open. Apply before 30th June.'},
    ];

    void goToCollegeDetails(BuildContext context, Map<String, dynamic> college) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollegeDetailsScreen(college: college),
        ),
      );
    }

    void filterSearchBySpecialization(BuildContext context, String specialization) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchScreenWithFilter(specialization: specialization),
      ));
    }

    void showNewsDetails(BuildContext context, Map<String, String> newsItem) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(newsItem['title'] ?? ''),
          content: Text(newsItem['details'] ?? 'No details available.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
        ),
      );
    }

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
            SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('colleges').orderBy('rank').limit(10).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading colleges'));
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(child: Text('No colleges found'));
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final c = docs[index].data() as Map<String, dynamic>;
                    return CollegeListCard(college: c);
                  },
                );
              },
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
            // Recent Visits
            if (recentVisits.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Your Recent Visits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 10,
                  children: recentVisits.map((c) => Chip(label: Text('${c['name']} (${c['city']})'))).toList(),
                ),
              ),
            ],
            // Top Colleges Near You (from Firestore)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Top Colleges Near You', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            SizedBox(
              height: 110,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('colleges').orderBy('rank').limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading colleges'));
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(child: Text('No colleges found'));
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final c = docs[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () => goToCollegeDetails(context, c),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: Container(
                            width: 160,
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${c['name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('${c['city']}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.orange, size: 16),
                                    SizedBox(width: 4),
                                    Text('${c['rating'] ?? c['rank'] ?? '-'}', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Top Specializations (interactive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Top Specializations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                children: specializations.map((s) => ActionChip(
                  label: Text(s),
                  onPressed: () => filterSearchBySpecialization(context, s),
                )).toList(),
              ),
            ),
            // Trending Tags (interactive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Trending Tags', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                children: trendingTags.map((tag) => ActionChip(
                  label: Text(tag),
                  onPressed: () => filterSearchBySpecialization(context, tag),
                )).toList(),
              ),
            ),
            // Top Colleges for a Stream (mock, interactive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Top Colleges for BCA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 2,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final c = [
                    {'name': 'RV College', 'city': 'Bangalore', 'rating': 4.3},
                    {'name': 'MSRIT', 'city': 'Bangalore', 'rating': 4.2},
                  ][index];
                  return GestureDetector(
                    onTap: () => goToCollegeDetails(context, c),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Container(
                        width: 160,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${c['name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('${c['city']}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.orange, size: 16),
                                SizedBox(width: 4),
                                Text('${c['rating']}', style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // College Rankings (mock)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('BCA College Ranking 2025', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
                child: ListTile(
                  leading: Icon(Icons.emoji_events, color: Colors.amber),
                  title: Text('Christ University Bangalore'),
                  subtitle: Text('Ranked 1 for BCA in India'),
                  trailing: Text('2025'),
                ),
              ),
            ),
            // Top Study Places
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Top Study Places for BCA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                children: topStudyPlaces.map((city) => Chip(label: Text(city))).toList(),
              ),
            ),
            // Explore Courses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Explore Computer Applications Courses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                children: [
                  Chip(label: Text('BCA General')),
                  Chip(label: Text('BCA Data Science')),
                  Chip(label: Text('BCA Cloud Computing')),
                  Chip(label: Text('BCA Cyber Security')),
                ],
              ),
            ),
            // Top Exams
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Top BCA Exams', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                children: topExams.map((exam) => Chip(label: Text(exam))).toList(),
              ),
            ),
            // Trending News (interactive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Latest News & Stats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ...news.map((n) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
                child: ListTile(
                  leading: Icon(Icons.newspaper, color: Colors.blue),
                  title: Text(n['title'] ?? ''),
                  subtitle: Text(n['date'] ?? ''),
                  onTap: () => showNewsDetails(context, n),
                ),
              ),
            )),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollegeDetailsScreen(college: data),
                            ),
                          );
                        },
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
  List<Map<String, dynamic>> selectedColleges = [];
  String searchText = '';
  final FocusNode _searchFocus = FocusNode();

  void _addCollege(Map<String, dynamic> college) {
    if (selectedColleges.length < 4 && !selectedColleges.any((c) => c['name'] == college['name'])) {
      setState(() {
        selectedColleges.add(college);
        searchText = '';
      });
      _searchFocus.unfocus();
    }
  }

  void _removeCollege(int index) {
    setState(() {
      selectedColleges.removeAt(index);
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
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
          // Search and Add College
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select up to 4 colleges to compare', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                SizedBox(height: 12),
                TextField(
                  focusNode: _searchFocus,
                  decoration: InputDecoration(
                    hintText: 'Search and add colleges...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value.trim().toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 8),
                if (searchText.isNotEmpty)
                  SizedBox(
                    height: 180,
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
                        final results = docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .where((c) => (c['name'] ?? '').toString().toLowerCase().contains(searchText) ||
                                         (c['city'] ?? '').toString().toLowerCase().contains(searchText) ||
                                         (c['type'] ?? '').toString().toLowerCase().contains(searchText))
                            .toList();
                        if (results.isEmpty) {
                          return Center(child: Text('No colleges found'));
                        }
                        return ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final college = results[index];
                            final alreadyAdded = selectedColleges.any((c) => c['name'] == college['name']);
                            return ListTile(
                              leading: Icon(Icons.school, color: Colors.blue),
                              title: Text(college['name'] ?? ''),
                              subtitle: Text('${college['city'] ?? ''} • ${college['type'] ?? ''}'),
                              trailing: alreadyAdded
                                  ? Icon(Icons.check, color: Colors.green)
                                  : IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () => _addCollege(college),
                                    ),
                            );
                          },
                        );
                      },
                    ),
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
                  final c = selectedColleges[index];
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
                                Text(c['name'], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: InkWell(
                              onTap: () => _removeCollege(index),
                              child: Icon(Icons.close, size: 18, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_searchFocus);
                      },
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
          // Comparison Table
          if (selectedColleges.length >= 2)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Field', style: TextStyle(fontWeight: FontWeight.bold))),
                    ...selectedColleges.map((c) => DataColumn(label: Text(c['name'] ?? ''))),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('City')),
                      ...selectedColleges.map((c) => DataCell(Text(c['city'] ?? ''))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Type')),
                      ...selectedColleges.map((c) => DataCell(Text(c['type'] ?? ''))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Fees')),
                      ...selectedColleges.map((c) => DataCell(Text('₹${c['fees'] ?? '-'}'))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Rank')),
                      ...selectedColleges.map((c) => DataCell(Text('${c['rank'] ?? '-'}'))),
                    ]),
                  ],
                ),
              ),
            ),
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

class CollegeDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> college;
  const CollegeDetailsScreen({required this.college, super.key});

  @override
  State<CollegeDetailsScreen> createState() => _CollegeDetailsScreenState();
}

class _CollegeDetailsScreenState extends State<CollegeDetailsScreen> with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  bool loadingFavorite = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _checkFavorite();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkFavorite() async {
    final fav = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.college['name'])
        .get();
    setState(() {
      isFavorite = fav.exists;
      loadingFavorite = false;
    });
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      loadingFavorite = true;
    });
    final favRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.college['name']);
    if (isFavorite) {
      await favRef.delete();
    } else {
      await favRef.set(widget.college);
    }
    await _checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.college;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero section with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.blue[600],
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.blue[600]),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: Colors.blue[600]),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Hero image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: c['imageUrl'] != null && c['imageUrl'] != ''
                            ? NetworkImage(c['imageUrl'])
                            : AssetImage('assets/college_placeholder.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // College logo and name
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.school,
                            color: Colors.blue[600],
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            '${c['name']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tab bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue[600],
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.blue[600],
                isScrollable: true,
                labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 12),
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Courses'),
                  Tab(text: 'Fees'),
                  Tab(text: 'Placements'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),
          // Tab content
          SliverToBoxAdapter(
            child: Container(
              height: 800, // Adjust based on content
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(c),
                  _buildCoursesTab(c),
                  _buildFeesTab(c),
                  _buildPlacementsTab(c),
                  _buildReviewsTab(c),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> c) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Rankings row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('#${c['rank'] ?? 'N/A'}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('in World', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('#${(c['rank'] ?? 0) + 3}', style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold)),
                      Text('in Country', style: TextStyle(color: Colors.orange[800], fontSize: 12)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('#1', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
                      Text('in State', style: TextStyle(color: Colors.green[800], fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Acceptance Rate and Tuition row
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Acceptance Rate', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                value: 0.2,
                                strokeWidth: 6,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                              ),
                            ),
                            Text('20%', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Average Tuition', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('₹${c['fees'] ?? 'N/A'}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[600])),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.blue[600], shape: BoxShape.circle)),
                            SizedBox(width: 4),
                            Text('Similar colleges', style: TextStyle(fontSize: 12, color: Colors.blue[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Facilities
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Facilities', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildFacilityItem(Icons.bed, 'Hostel'),
                      SizedBox(width: 16),
                      _buildFacilityItem(Icons.library_books, 'Library'),
                      SizedBox(width: 16),
                      _buildFacilityItem(Icons.sports_soccer, 'Sports'),
                      SizedBox(width: 16),
                      _buildFacilityItem(Icons.restaurant, 'Dining'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Contact buttons
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.phone, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text('Call', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.language, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text('Website', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.directions, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text('Directions', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Rank History
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rank History', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Container(
                    height: 150,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: RankHistoryPainter(),
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

  Widget _buildFacilityItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[600]),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCoursesTab(Map<String, dynamic> c) {
    return Center(child: Text('Courses content coming soon...'));
  }

  Widget _buildFeesTab(Map<String, dynamic> c) {
    return Center(child: Text('Fees content coming soon...'));
  }

  Widget _buildPlacementsTab(Map<String, dynamic> c) {
    return Center(child: Text('Placements content coming soon...'));
  }

  Widget _buildReviewsTab(Map<String, dynamic> c) {
    return Center(child: Text('Reviews content coming soon...'));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class RankHistoryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[600]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.25, size.height * 0.6);
    path.lineTo(size.width * 0.5, size.height * 0.4);
    path.lineTo(size.width * 0.75, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.2);

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.blue[600]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(0, size.height * 0.8), 4, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.6), 4, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 4, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.3), 4, pointPaint);
    canvas.drawCircle(Offset(size.width, size.height * 0.2), 4, pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Helper SearchScreenWithFilter for specialization/tag filtering
class SearchScreenWithFilter extends StatelessWidget {
  final String specialization;
  const SearchScreenWithFilter({required this.specialization, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search: $specialization'), backgroundColor: Colors.blue),
      body: SearchScreenFiltered(specialization: specialization),
    );
  }
}

class SearchScreenFiltered extends StatefulWidget {
  final String specialization;
  const SearchScreenFiltered({required this.specialization, super.key});

  @override
  State<SearchScreenFiltered> createState() => _SearchScreenFilteredState();
}

class _SearchScreenFilteredState extends State<SearchScreenFiltered> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('colleges').where('type', isEqualTo: widget.specialization).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading colleges'));
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(child: Text('No colleges found for ${widget.specialization}'));
        }
        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => SizedBox(height: 14),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CollegeDetailsScreen(college: data),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CollegeListCard extends StatefulWidget {
  final Map<String, dynamic> college;
  const CollegeListCard({required this.college, super.key});

  @override
  State<CollegeListCard> createState() => _CollegeListCardState();
}

class _CollegeListCardState extends State<CollegeListCard> {
  bool isFavorite = false;
  bool loadingFavorite = true;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final fav = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.college['name'])
        .get();
    setState(() {
      isFavorite = fav.exists;
      loadingFavorite = false;
    });
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      loadingFavorite = true;
    });
    final favRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.college['name']);
    if (isFavorite) {
      await favRef.delete();
    } else {
      await favRef.set(widget.college);
    }
    await _checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.college;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // College image or placeholder
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: c['imageUrl'] != null && c['imageUrl'] != ''
                    ? NetworkImage(c['imageUrl'])
                    : AssetImage('assets/college_placeholder.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${c['name']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 2),
                  Text('${c['city'] ?? ''} • ${c['type'] ?? ''}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 2),
                      Text('${c['rating'] ?? c['rank'] ?? '-'}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                      SizedBox(width: 12),
                      Icon(Icons.currency_rupee, size: 14, color: Colors.green),
                      Text('${c['fees'] ?? '-'}', style: TextStyle(fontSize: 13, color: Colors.green)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.reviews, size: 14, color: Colors.blueGrey),
                      SizedBox(width: 2),
                      Text('${c['reviews'] ?? 0} reviews', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollegeDetailsScreen(college: c),
                            ),
                          );
                        },
                        child: Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          textStyle: TextStyle(fontSize: 13),
                        ),
                      ),
                      SizedBox(width: 8),
                      loadingFavorite
                          ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                          : IconButton(
                              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                              onPressed: _toggleFavorite,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

