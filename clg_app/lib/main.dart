import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'models/college.dart';
import 'services/api_service.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> selectedColleges = [];
  Map<String, List<College>> trendingColleges = {};
  bool isLoadingTrending = true;

  @override
  void initState() {
    super.initState();
    _loadSampleSelectedColleges();
    _loadTrendingColleges();
  }

  void _loadSampleSelectedColleges() async {
    try {
      final query = await FirebaseFirestore.instance.collection('colleges').limit(2).get();
    setState(() {
        selectedColleges = query.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Error loading sample colleges: $e');
    }
  }

  void _loadTrendingColleges() async {
    try {
      print('Loading trending colleges...');
      final trending = await ApiService.getTrendingColleges();
      print('Trending data received: ${trending.keys}');
      print('Top ranked count: ${trending['topRanked']?.length}');
      print('Top rated count: ${trending['topRated']?.length}');
      print('Most expensive count: ${trending['mostExpensive']?.length}');
      
      setState(() {
        trendingColleges = trending;
        isLoadingTrending = false;
      });
    } catch (e) {
      print('Error loading trending colleges: $e');
      // Fallback to sample data for testing
      setState(() {
        trendingColleges = {
          'topRanked': [
            College(
              id: 'sample1',
              name: 'IIT Bombay',
              city: 'Mumbai',
              type: 'Government',
              rank: 1,
              fees: 250000,
              imageUrl: 'https://images.unsplash.com/photo-1562774053-701939374585?w=400',
              rating: 4.8,
              website: 'https://www.iitb.ac.in',
            ),
            College(
              id: 'sample2',
              name: 'DTU',
              city: 'Delhi',
              type: 'Government',
              rank: 15,
              fees: 150000,
              imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9a1?w=400',
              rating: 4.5,
              website: 'https://www.dtu.ac.in',
            ),
          ],
          'topRated': [
            College(
              id: 'sample3',
              name: 'Manipal Institute',
              city: 'Manipal',
              type: 'Private',
              rank: 20,
              fees: 250000,
              imageUrl: 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400',
              rating: 4.6,
              website: 'https://www.manipal.edu',
            ),
          ],
          'mostExpensive': [
            College(
              id: 'sample4',
              name: 'BITS Pilani',
              city: 'Pilani',
              type: 'Private',
              rank: 28,
              fees: 350000,
              imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9a1?w=400',
              rating: 4.4,
              website: 'https://www.bits-pilani.ac.in',
            ),
          ],
        };
        isLoadingTrending = false;
      });
    }
  }

  void _navigateToSearch() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchScreen(),
    ));
  }

  void _navigateToCompare() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CompareScreen(),
    ));
  }

  void _navigateToExams() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExamsScreen(),
    ));
  }

  void _navigateToProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProfileScreen(),
    ));
  }

  void _navigateToCollegeDetails(Map<String, dynamic> college) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollegeDetailsScreen(college: college),
      ),
    );
  }

  void _navigateToSearchWithFilter(String filter) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchScreenWithFilter(specialization: filter),
    ));
  }

  void _removeCollegeFromComparison(int index) {
    setState(() {
      selectedColleges.removeAt(index);
    });
  }

  void _addCollegeToComparison() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _buildAddCollegeDialog(),
    );
    if (result != null && selectedColleges.length < 4) {
      setState(() {
        selectedColleges.add(result);
      });
    }
  }

  Widget _buildAddCollegeDialog() {
    String searchText = '';
    List<Map<String, dynamic>> searchResults = [];
    bool searching = false;

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text('Add College to Compare'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search colleges...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) async {
                setState(() {
                  searchText = value;
                  searching = true;
                });
                if (value.isNotEmpty) {
                  try {
                    final query = await FirebaseFirestore.instance
                        .collection('colleges')
                        .where('name', isGreaterThanOrEqualTo: value)
                        .where('name', isLessThan: '$value\uf8ff')
                        .limit(10)
                        .get();
                    setState(() {
                      searchResults = query.docs.map((doc) => doc.data()).toList();
                      searching = false;
                    });
                  } catch (e) {
                    setState(() {
                      searching = false;
                    });
                  }
                } else {
                  setState(() {
                    searchResults = [];
                    searching = false;
                  });
                }
              },
            ),
            SizedBox(height: 12),
            if (searching)
              Center(child: CircularProgressIndicator())
            else if (searchResults.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final college = searchResults[index];
                    return ListTile(
                      leading: CollegeImage(
                        imageUrl: college['imageUrl'],
                        height: 40,
                        width: 40,
                        borderRadius: 20,
                      ),
                      title: Text(college['name'] ?? ''),
                      subtitle: Text(college['city'] ?? ''),
                      onTap: () => Navigator.pop(context, college),
                    );
                  },
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'View All',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCollegeCard(Map<String, dynamic> college, {bool showRemoveButton = false, int? index}) {
    // Safely extract values with proper type conversion
    final name = college['name']?.toString() ?? '';
    final city = college['city']?.toString() ?? '';
    final imageUrl = college['imageUrl']?.toString();
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        width: 160,
        height: 120, // Fixed height to prevent overflow
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CollegeImage(
                  imageUrl: imageUrl,
                  height: 50, // Constrain image height
                  width: double.infinity,
                  borderRadius: 8,
                  fit: BoxFit.cover,
                ),
                if (showRemoveButton && index != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeCollegeFromComparison(index),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              city,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            SizedBox(
              height: 24,
              child: ElevatedButton(
                onPressed: () => _navigateToCollegeDetails(college),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  minimumSize: Size(0, 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'View',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseChip(String course) {
    return ActionChip(
      label: Text(course),
      onPressed: () => _navigateToSearchWithFilter(course),
      backgroundColor: Colors.blue[50],
      labelStyle: TextStyle(color: Colors.blue[700]),
    );
  }

  Widget _buildExamCard(String exam, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        width: 120,
        height: 100, // Fixed height
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.blue),
            SizedBox(height: 6),
            Flexible(
              child: Text(
                exam,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            SizedBox(
              height: 20,
              child: ElevatedButton(
                onPressed: () => _navigateToExams(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                  minimumSize: Size(0, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'View',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(String title, String date) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        width: 180,
        height: 90, // Fixed height
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.article, size: 18, color: Colors.grey[400]),
              ),
            ),
            SizedBox(height: 4),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    if (selectedColleges.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'Add colleges to compare',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    final metrics = [
      {'label': 'City', 'key': 'city'},
      {'label': 'Type', 'key': 'type'},
      {'label': 'Fees', 'key': 'fees'},
      {'label': 'Rank', 'key': 'rank'},
      {'label': 'Placements', 'key': 'placements'},
    ];

    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(120),
              border: TableBorder(horizontalInside: BorderSide(color: Colors.grey[300]!)),
              children: [
                TableRow(
                  children: [
                    Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...selectedColleges.map((c) => Text(
                      c['name'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
                ...metrics.map((metric) => TableRow(
                  children: [
                    Text(metric['label']!, style: TextStyle(fontWeight: FontWeight.w600)),
                    ...selectedColleges.map((c) => Text(
                      c[metric['key']]?.toString() ?? '-',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar with Search
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search colleges, exams, courses',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onTap: _navigateToSearch,
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.filter_list, color: Colors.grey[600]),
                  ],
                ),
              ),

              // Personalized Greeting
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello Ashish,',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Here\'s a great personalized experience for you.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Top Colleges Near You
              _buildSectionHeader('Top Colleges Near You', () => _navigateToSearch()),
              SizedBox(
                height: 140,
                child: isLoadingTrending
                    ? Center(child: CircularProgressIndicator())
                    : trendingColleges['topRanked']?.isNotEmpty == true
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: trendingColleges['topRanked']!.length,
                            separatorBuilder: (_, __) => SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final college = trendingColleges['topRanked']![index];
                              return _buildCollegeCard(college.toMap());
                            },
                          )
                        : Center(child: Text('No trending colleges found')),
              ),

              // Explore Courses
              _buildSectionHeader('Explore Courses', () => _navigateToSearch()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildCourseChip('Engineering'),
                    _buildCourseChip('MBA'),
                    _buildCourseChip('Medical'),
                    _buildCourseChip('Arts'),
                    _buildCourseChip('Law'),
                    _buildCourseChip('Science'),
                    _buildCourseChip('Commerce'),
                  ],
                ),
              ),

              // Top Exams
              _buildSectionHeader('Top Exams', () => _navigateToExams()),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 5,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final exams = [
                      {'name': 'JEE Main', 'icon': Icons.school},
                      {'name': 'NEET', 'icon': Icons.medical_services},
                      {'name': 'CAT', 'icon': Icons.business},
                      {'name': 'KCET', 'icon': Icons.school},
                      {'name': 'COMEDK', 'icon': Icons.school},
                    ];
                    return _buildExamCard(exams[index]['name'] as String, exams[index]['icon'] as IconData);
                  },
                ),
              ),

              // Latest News & Stats
              _buildSectionHeader('Latest News & Stats', () {}),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final news = [
                      {'title': 'Top 10 Engineering Colleges in India', 'date': '26 Jun, 2025'},
                      {'title': 'NIRF 2025 Rankings Released', 'date': '15 May, 2025'},
                      {'title': 'Admissions Open for 2025', 'date': '10 May, 2025'},
                    ];
                    return _buildNewsCard(news[index]['title']!, news[index]['date']!);
                  },
                ),
              ),

              // Compare Colleges - Remove this section from home page
              // _buildSectionHeader('Compare Colleges', () => _navigateToCompare()),
              // if (selectedColleges.isNotEmpty) ...[
              //   SizedBox(
              //     height: 140,
              //     child: ListView.separated(
              //       scrollDirection: Axis.horizontal,
              //       padding: EdgeInsets.symmetric(horizontal: 16),
              //       itemCount: selectedColleges.length + 1,
              //       separatorBuilder: (_, __) => SizedBox(width: 12),
              //       itemBuilder: (context, index) {
              //         if (index == selectedColleges.length) {
              //           return Card(
              //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //             elevation: 2,
              //             child: Container(
              //               width: 160,
              //               padding: EdgeInsets.all(12),
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Icon(Icons.add, size: 32, color: Colors.blue),
              //                   SizedBox(height: 8),
              //                   Text(
              //                     'Add College',
              //                     style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.blue,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           );
              //         }
              //         return _buildCollegeCard(
              //           selectedColleges[index],
              //           showRemoveButton: true,
              //           index: index,
              //         );
              //       },
              //     ),
              //   ),
              //   _buildComparisonTable(),
              // ] else ...[
              //   Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 16),
              //     child: Card(
              //       child: SizedBox(
              //         height: 100,
              //         child: Center(
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Icon(Icons.compare_arrows, size: 32, color: Colors.grey[400]),
              //               SizedBox(height: 8),
              //               Text(
              //                 'Add colleges to compare',
              //                 style: TextStyle(color: Colors.grey[600]),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ],

              // Top Specializations
              _buildSectionHeader('Top Specializations', () => _navigateToSearch()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildCourseChip('Computer Science'),
                    _buildCourseChip('Mechanical Engineering'),
                    _buildCourseChip('Civil Engineering'),
                    _buildCourseChip('Electrical Engineering'),
                    _buildCourseChip('Information Technology'),
                    _buildCourseChip('Electronics'),
                    _buildCourseChip('Chemical Engineering'),
                    _buildCourseChip('Biotechnology'),
                  ],
                ),
              ),

              // Top Colleges for a Stream
              _buildSectionHeader('Top Colleges for a Stream', () => _navigateToSearch()),
              SizedBox(
                height: 140,
                child: isLoadingTrending
                    ? Center(child: CircularProgressIndicator())
                    : trendingColleges['topRated']?.isNotEmpty == true
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: trendingColleges['topRated']!.length,
                            separatorBuilder: (_, __) => SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final college = trendingColleges['topRated']![index];
                              return _buildCollegeCard(college.toMap());
                            },
                          )
                        : Center(child: Text('No top rated colleges found')),
              ),

              // Most Expensive Colleges
              _buildSectionHeader('Most Expensive Colleges', () => _navigateToSearch()),
              SizedBox(
                height: 140,
                child: isLoadingTrending
                    ? Center(child: CircularProgressIndicator())
                    : trendingColleges['mostExpensive']?.isNotEmpty == true
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: trendingColleges['mostExpensive']!.length,
                            separatorBuilder: (_, __) => SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final college = trendingColleges['mostExpensive']![index];
                              return _buildCollegeCard(college.toMap());
                            },
                          )
                        : Center(child: Text('No expensive colleges found')),
              ),

              // College Rankings
              _buildSectionHeader('College Rankings', () => _navigateToSearch()),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 4,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final rankings = [
                      {'name': 'NIRF Ranking', 'icon': Icons.emoji_events, 'url': 'https://www.nirfindia.org'},
                      {'name': 'QS World Ranking', 'icon': Icons.public, 'url': 'https://www.topuniversities.com'},
                      {'name': 'Times Higher Education', 'icon': Icons.school, 'url': 'https://www.timeshighereducation.com'},
                      {'name': 'India Today', 'icon': Icons.newspaper, 'url': 'https://www.indiatoday.in'},
                    ];
                                          return GestureDetector(
                        onTap: () async {
                          try {
                            final url = rankings[index]['url'] as String;
                            final Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch $url';
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not open ranking website')),
                            );
                          }
                        },
                      child: _buildExamCard(rankings[index]['name'] as String, rankings[index]['icon'] as IconData),
                    );
                  },
                ),
              ),

              // Top Study Places
              _buildSectionHeader('Top Study Places', () => _navigateToSearch()),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 4,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final places = [
                      {'name': 'Bangalore', 'icon': Icons.location_city, 'colleges': 45},
                      {'name': 'Delhi', 'icon': Icons.location_city, 'colleges': 38},
                      {'name': 'Mumbai', 'icon': Icons.location_city, 'colleges': 32},
                      {'name': 'Chennai', 'icon': Icons.location_city, 'colleges': 28},
                    ];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to search with city filter
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(initialCity: places[index]['name'] as String),
                          ),
                        );
                      },
                      child: _buildExamCard(places[index]['name'] as String, places[index]['icon'] as IconData),
                    );
                  },
                ),
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }


}

class SearchScreen extends StatefulWidget {
  final String? initialCity;
  const SearchScreen({super.key, this.initialCity});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  String _selectedSort = 'Rank';
  String? _selectedType; // Engineering, MBA, Medical, Arts
  String? _selectedCity;
  final List<String> _types = ['Engineering', 'MBA', 'Medical', 'Arts'];
  final List<String> _sortOptions = ['Rank', 'Fees', 'City'];
  
  @override
  void initState() {
    super.initState();
    if (widget.initialCity != null) {
      _selectedCity = widget.initialCity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    icon: Icon(Icons.clear, size: 18),
                    label: Text('Clear Filters'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  List<Map<String, dynamic>> searchResults = [];
  bool searching = false;
  Map<String, bool> expandedSections = {
    'institute': true,
    'course': true,
    'placement': true,
    'fees': true,
    'admission': true,
    'cutoff': true,
    'seats': true,
    'accreditation': true,
    'infrastructure': true,
    'reviews': true,
    'ranking': true,
  };

  @override
  void initState() {
    super.initState();
    // Don't load any colleges by default - let user select
  }

  void _addCollege(Map<String, dynamic> college) {
    if (selectedColleges.length < 4 && !selectedColleges.any((c) => c['name'] == college['name'])) {
      setState(() {
        selectedColleges.add(college);
        searchText = '';
        searchResults = [];
        searching = false;
      });
    }
  }

  void _removeCollege(int index) {
    setState(() {
      selectedColleges.removeAt(index);
    });
  }

  void _toggleSection(String section) {
    setState(() {
      expandedSections[section] = !(expandedSections[section] ?? false);
    });
  }

  Widget _buildCollegeHeader() {
    if (selectedColleges.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.compare_arrows, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Add colleges to compare',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Compare colleges on the basis of their fees, placements, cut off, reviews, seats, courses and other details.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // College names with VS
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    selectedColleges[0]['name'] ?? '',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'B.E. in Mechanical Engineering',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    selectedColleges.length > 1 ? selectedColleges[1]['name'] ?? '' : '',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'B.Tech. in Mechanical Engineering',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Divider(),
      ],
    );
  }

  Widget _buildComparisonSection(String title, String sectionKey, Widget Function(Map<String, dynamic>) contentBuilder) {
    final isExpanded = expandedSections[sectionKey] ?? false;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
            onTap: () => _toggleSection(sectionKey),
          ),
          if (isExpanded) ...[
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: contentBuilder(selectedColleges[0]),
                  ),
                  Container(
                    width: 1,
                    height: 120,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: selectedColleges.length > 1 
                      ? contentBuilder(selectedColleges[1])
                      : _buildEmptyComparisonSide(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInstituteInfo(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Established Year', college['establishedYear'] ?? '1963'),
        _buildInfoRow('Ownership', college['ownership'] ?? 'Private, Autonomous'),
        _buildInfoRow('Total Courses', '${college['totalCourses'] ?? 34}'),
        _buildInfoRow('B.Tech', '${college['btechCourses'] ?? 17} Courses'),
        SizedBox(height: 8),
        Text(
          'Compare >',
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDetails(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Course Credential', 'Degree'),
        _buildInfoRow('Course Level', 'UG'),
        _buildInfoRow('Duration', '4 years'),
      ],
    );
  }

  Widget _buildPlacementInfo(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Median Salary', 'INR ${college['medianSalary'] ?? '10.00'} Lakh'),
        _buildInfoRow('Highest Salary', 'INR ${college['highestSalary'] ?? '62.00'} Lakh'),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Placement details for ${college['name']?.toString() ?? ''}')),
            );
          },
          child: Text(
            'View Placement Details >',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeesInfo(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Total Fees', 'INR ${college['totalFees'] ?? '1.28'} Lakh'),
        Text(
          '(for 4 years)',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Fee details for ${college['name']?.toString() ?? ''}')),
            );
          },
          child: Text(
            'Get Fee Details >',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdmissionInfo(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Accepted Exams', college['acceptedExams'] ?? 'JEE Main, COMEDK, UGET, KCET'),
      ],
    );
  }

  Widget _buildCutoffInfo(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Cut off is for Final Round, All India and General category',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 8),
        _buildInfoRow('COMEDK UGET', 'Round 3 | Rank ${college['comedkRank'] ?? '7489'}'),
        _buildInfoRow('KCET', 'Round 2 | Rank ${college['kcetRank'] ?? '821'}'),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cut off details for ${college['name']?.toString() ?? ''}')),
            );
          },
          child: Text(
            'View Cut off >',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatsInfo(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${college['totalSeats'] ?? '120'}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAccreditationInfo(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          college['accreditation'] ?? 'Approved by AICTE',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfrastructureInfo(Map<String, dynamic> college) {
    final facilities = (college['facilities'] as List<dynamic>?) ?? ['Library', 'Cafeteria', 'Hostel', 'Sports Complex'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: facilities.map<Widget>((facility) => Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(_getFacilityIcon(facility.toString()), size: 16, color: Colors.grey[600]),
            SizedBox(width: 8),
            Text(
              facility.toString(),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildReviewsInfo(Map<String, dynamic> college) {
    final rating = double.tryParse(college['rating']?.toString() ?? '4.1') ?? 4.1;
    final reviews = college['reviews'] ?? 36;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$rating',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            ...List.generate(5, (index) => Icon(
              index < rating.floor() ? Icons.star : 
              index < rating.ceil() ? Icons.star_half : Icons.star_border,
              color: Colors.orange,
              size: 16,
            )),
          ],
        ),
        Text(
          'Based on $reviews verified reviews',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 8),
        _buildCategoryRating('Placements', college['placementRating'] ?? 4.3),
        _buildCategoryRating('Infrastructure', college['infrastructureRating'] ?? 3.9),
        _buildCategoryRating('Faculty', college['facultyRating'] ?? 4.0),
        _buildCategoryRating('Crowd & Campus', college['campusRating'] ?? 4.3),
        _buildCategoryRating('Value for Money', college['valueRating'] ?? 4.2),
        SizedBox(height: 8),
        Text(
          'View All Reviews >',
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRankingInfo(Map<String, dynamic> college) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('NIRF \'24', college['nirfRank'] ?? '99'),
        _buildInfoRow('India Today \'23', college['indiaTodayRank'] ?? '--'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRating(String category, dynamic rating) {
    final ratingValue = double.tryParse(rating?.toString() ?? '0.0') ?? 0.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text(
            category,
            style: TextStyle(fontSize: 12),
          ),
          Spacer(),
          Text(
            '$ratingValue',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 4),
          Icon(Icons.star, size: 12, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildEmptyComparisonSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_circle_outline, size: 48, color: Colors.grey[400]),
        SizedBox(height: 8),
        Text(
          'Select another college',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          'to compare',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  IconData _getFacilityIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'library': return Icons.library_books;
      case 'cafeteria': return Icons.restaurant;
      case 'hostel': return Icons.bed;
      case 'sports complex': return Icons.sports;
      case 'gym': return Icons.fitness_center;
      case 'hospital': return Icons.local_hospital;
      case 'wifi': return Icons.wifi;
      case 'shuttle': return Icons.directions_bus;
      case 'auditorium': return Icons.event_seat;
      case 'music room': return Icons.music_note;
             case 'dance room': return Icons.music_note;
      case 'store': return Icons.store;
      case 'labs': return Icons.science;
      default: return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare Colleges'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              final result = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (context) => _buildAddCollegeDialog(),
              );
              if (result != null) _addCollege(result);
            },
            child: Text('Add College', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // College Header
            Container(
              padding: EdgeInsets.all(16),
              child: _buildCollegeHeader(),
            ),
            
            // Comparison Sections
            if (selectedColleges.isNotEmpty) ...[
              _buildComparisonSection('Institute Information', 'institute', _buildInstituteInfo),
              _buildComparisonSection('Course Details', 'course', _buildCourseDetails),
              _buildComparisonSection('Placement', 'placement', _buildPlacementInfo),
              _buildComparisonSection('Course Fees', 'fees', _buildFeesInfo),
              _buildComparisonSection('Admission Info', 'admission', _buildAdmissionInfo),
              _buildComparisonSection('Cut Off', 'cutoff', _buildCutoffInfo),
              _buildComparisonSection('Total Seats', 'seats', _buildSeatsInfo),
              _buildComparisonSection('Accreditation and Approval', 'accreditation', _buildAccreditationInfo),
              _buildComparisonSection('Infrastructure & Facilities', 'infrastructure', _buildInfrastructureInfo),
              _buildComparisonSection('Student Rating & Reviews', 'reviews', _buildReviewsInfo),
              _buildComparisonSection('Ranking', 'ranking', _buildRankingInfo),
              
              // Download PDF Section
              Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Download this Comparison as PDF to read offline.',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading PDF...')),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Download PDF'),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Popular Comparisons
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular comparisons with ${selectedColleges.isNotEmpty ? selectedColleges[0]['name'] : ''}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  CollegeImage(
                                    imageUrl: selectedColleges.isNotEmpty ? selectedColleges[0]['imageUrl'] : null,
                                    height: 40,
                                    width: 40,
                                    borderRadius: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Comparison ${index + 1}',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      'VS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
              ),
            ],
            
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCollegeDialog() {
    String searchText = '';
    List<Map<String, dynamic>> searchResults = [];
    bool searching = false;

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text('Add College to Compare'),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search colleges by name, city, or type...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) async {
                  setState(() {
                    searchText = value;
                    searching = true;
                  });
                  if (value.isNotEmpty) {
                    try {
                      // Search by name, city, or type
                      final query = await FirebaseFirestore.instance
                          .collection('colleges')
                          .get();
                      
                      final allColleges = query.docs.map((doc) => doc.data()).toList();
                      final filtered = allColleges.where((college) {
                        final name = (college['name'] ?? '').toString().toLowerCase();
                        final city = (college['city'] ?? '').toString().toLowerCase();
                        final type = (college['type'] ?? '').toString().toLowerCase();
                        final searchLower = value.toLowerCase();
                        
                        return name.contains(searchLower) || 
                               city.contains(searchLower) || 
                               type.contains(searchLower);
                      }).take(10).toList();
                      
                      setState(() {
                        searchResults = filtered;
                        searching = false;
                      });
                    } catch (e) {
                      setState(() {
                        searching = false;
                      });
                    }
                  } else {
                    setState(() {
                      searchResults = [];
                      searching = false;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              if (searching)
                Center(child: CircularProgressIndicator())
              else if (searchResults.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    itemCount: searchResults.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final college = searchResults[index];
                      return ListTile(
                        leading: CollegeImage(
                          imageUrl: college['imageUrl'],
                          height: 40,
                          width: 40,
                          borderRadius: 20,
                        ),
                        title: Text(
                          college['name'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          '${college['city'] ?? ''} • ${college['type'] ?? ''}',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
            Text(
                              'Rank: ${college['rank'] ?? '-'}',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                            Text(
                              '₹${college['fees'] ?? '-'}',
                              style: TextStyle(fontSize: 11, color: Colors.green),
            ),
          ],
        ),
                        onTap: () => Navigator.pop(context, college),
                      );
                    },
                  ),
                )
              else if (searchText.isNotEmpty && !searching)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        SizedBox(height: 8),
                        Text(
                          'No colleges found',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Try searching with different keywords',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 48, color: Colors.grey[400]),
                        SizedBox(height: 8),
                        Text(
                          'Search for colleges to compare',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Type college name, city, or type',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
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

// Helper function to launch URLs
Future<void> _launchURL(String url) async {
  try {
    // Ensure URL has proper scheme
    String finalUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://') && !url.startsWith('tel:') && !url.startsWith('mailto:')) {
      if (url.startsWith('www.')) {
        finalUrl = 'https://$url';
      } else {
        finalUrl = 'https://www.$url';
      }
    }
    
    final Uri uri = Uri.parse(finalUrl);
    
    // Try multiple approaches for web URLs
    if (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('www.')) {
      bool launched = false;
      
      // Try external application first
      if (await canLaunchUrl(uri)) {
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          launched = true;
        } catch (e) {
          print('External application failed: $e');
        }
      }
      
      // If external failed, try platform default
      if (!launched) {
        try {
          await launchUrl(uri);
          launched = true;
        } catch (e) {
          print('Platform default failed: $e');
        }
      }
      
      // If still failed, try in-app browser as last resort
      if (!launched) {
        try {
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
          launched = true;
        } catch (e) {
          print('In-app browser failed: $e');
        }
      }
      
      if (!launched) {
        throw 'Could not launch $finalUrl';
      }
    } else {
      // For phone and email, use default behavior
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $finalUrl';
      }
    }
  } catch (e) {
    throw 'Error launching URL: $e';
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
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _checkFavorite();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 300 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
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
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              mini: true,
              backgroundColor: Colors.blue[600],
              child: Icon(Icons.arrow_upward, color: Colors.white),
              onPressed: () {
                _scrollController.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.easeOut);
              },
            )
          : null,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 260,
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
                fit: StackFit.expand,
                children: [
                  CollegeImage(
                    imageUrl: c['imageUrl'],
                    height: 260,
                    width: double.infinity,
                  ),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Text(
                            c['name']?.toString() ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        ],
        body: TabBarView(
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
                      Text('#${c['rank']?.toString() ?? 'N/A'}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      Text('#${(int.tryParse(c['rank']?.toString() ?? '0') ?? 0) + 3}', style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold)),
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
                        Text('₹${c['fees']?.toString() ?? 'N/A'}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[600])),
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
                child: GestureDetector(
                  onTap: () {
                    final phone = c['contact']?['phone'] ?? c['phone'] ?? '+91 1234567890';
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Call'),
                        content: Text('Call $phone?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('No'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                // Try multiple phone number formats
                                final phoneUrl1 = 'tel:$phone';
                                final phoneUrl2 = 'tel:${phone.replaceAll(' ', '').replaceAll('-', '').replaceAll('(', '').replaceAll(')', '')}';
                                
                                bool launched = false;
                                
                                // Try original format
                                try {
                                  final Uri uri = Uri.parse(phoneUrl1);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                    launched = true;
                                  }
                                } catch (e) {
                                  print('Phone dialer failed with original format: $e');
                                }
                                
                                // Try cleaned format
                                if (!launched) {
                                  try {
                                    final Uri uri = Uri.parse(phoneUrl2);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                      launched = true;
                                    }
                                  } catch (e) {
                                    print('Phone dialer failed with cleaned format: $e');
                                  }
                                }
                                
                                Navigator.pop(context);
                                
                                if (!launched) {
                                  // Show phone number in snackbar for easy copying
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Phone number: $phone'),
                                      duration: Duration(seconds: 5),
                                      action: SnackBarAction(
                                        label: 'Copy',
                                        onPressed: () {
                                          // You can add clipboard functionality here
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Number copied to clipboard')),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Could not open phone dialer')),
                                );
                              }
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
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
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final website = c['website'] ?? c['contact']?['website'] ?? 'https://www.google.com';
                    try {
                      await _launchURL(website);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Open Website'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Could not open website automatically.'),
                              SizedBox(height: 8),
                              Text('URL: $website', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('URL copied to clipboard: $website')),
                                );
                              },
                              child: Text('Copy URL'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
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
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final address = c['address'] ?? c['location'] ?? '${c['name']}, ${c['city']}';
                    try {
                      final encodedAddress = Uri.encodeComponent(address);
                      await _launchURL('https://maps.google.com/?q=$encodedAddress');
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Open Maps'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Could not open maps automatically.'),
                              SizedBox(height: 8),
                              Text('Address: $address', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Address copied: $address')),
                                );
                              },
                              child: Text('Copy Address'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
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
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // About Section
          if (c['about'] != null)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 12),
                    Text(c['about'].toString(), style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5)),
                  ],
                ),
              ),
            ),
          SizedBox(height: 16),
          
          // Contact Information
          if (c['contact'] != null)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 12),
                    _buildContactItem(Icons.phone, 'Phone', c['contact']?['phone'] ?? '+91 22 2572 2545'),
                    _buildContactItem(Icons.email, 'Email', c['contact']?['email'] ?? 'admissions@iitb.ac.in'),
                    _buildContactItem(Icons.language, 'Website', c['contact']?['website'] ?? c['website'] ?? 'https://www.google.com'),
                  ],
                ),
              ),
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
                  SizedBox(
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

  Widget _buildContactItem(IconData icon, String label, String value) {
    return GestureDetector(
              onTap: () async {
          try {
            print('Attempting to launch: $label - $value');
            if (label == 'Phone') {
                            // Simple call confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Call'),
                  content: Text('Call $value?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('No'),
                    ),
                                              ElevatedButton(
                            onPressed: () async {
                              try {
                                // Try multiple phone number formats
                                final phoneUrl1 = 'tel:$value';
                                final phoneUrl2 = 'tel:${value.replaceAll(' ', '').replaceAll('-', '').replaceAll('(', '').replaceAll(')', '')}';
                                
                                bool launched = false;
                                
                                // Try original format
                                try {
                                  final Uri uri = Uri.parse(phoneUrl1);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                    launched = true;
                                  }
                                } catch (e) {
                                  print('Phone dialer failed with original format: $e');
                                }
                                
                                // Try cleaned format
                                if (!launched) {
                                  try {
                                    final Uri uri = Uri.parse(phoneUrl2);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                      launched = true;
                                    }
                                  } catch (e) {
                                    print('Phone dialer failed with cleaned format: $e');
                                  }
                                }
                                
                                Navigator.pop(context);
                                
                                if (!launched) {
                                  // Show phone number in snackbar for easy copying
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Phone number: $value'),
                                      duration: Duration(seconds: 5),
                                      action: SnackBarAction(
                                        label: 'Copy',
                                        onPressed: () {
                                          // You can add clipboard functionality here
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Number copied to clipboard')),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Could not open phone dialer')),
                                );
                              }
                            },
                            child: Text('Yes'),
                          ),
                  ],
                ),
              );
            } else if (label == 'Email') {
              // Launch email client
              final emailUrl = 'mailto:$value';
              await _launchURL(emailUrl);
            } else if (label == 'Website') {
              // Launch website
              await _launchURL(value);
            }
          } catch (e) {
            print('Error launching $label: $e');
          // Show dialog with URL that user can copy
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Open $label'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Could not open $label automatically.'),
                  SizedBox(height: 8),
                  Text('URL: $value', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Copy URL to clipboard
                    // You can add clipboard functionality here
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('URL copied to clipboard: $value')),
                    );
                  },
                  child: Text('Copy URL'),
                ),
              ],
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue[600], size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text(
                    value, 
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab(Map<String, dynamic> c) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available Courses
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  if (c['courses'] != null && c['courses'] is List)
                    ...(c['courses'] as List).map((course) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.school, color: Colors.blue[600], size: 20),
                          SizedBox(width: 8),
                          Expanded(child: Text(course.toString(), style: TextStyle(fontSize: 16))),
                        ],
                      ),
                    ))
                  else
                    Text('No course information available', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Entrance Exams
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Entrance Exams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  if (c['entranceExams'] != null && c['entranceExams'] is List)
                    ...(c['entranceExams'] as List).map((exam) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.assignment, color: Colors.orange[600], size: 20),
                          SizedBox(width: 8),
                          Expanded(child: Text(exam.toString(), style: TextStyle(fontSize: 16))),
                        ],
                      ),
                    ))
                  else
                    Text('No entrance exam information available', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Cutoff Information
          if (c['cutoff'] != null)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cutoff Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.green[600], size: 20),
                        SizedBox(width: 8),
                        Expanded(child: Text(c['cutoff'].toString(), style: TextStyle(fontSize: 16))),
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

  Widget _buildFeesTab(Map<String, dynamic> c) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fee Structure
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fee Structure', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Fees', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            SizedBox(height: 4),
                            Text('₹${c['fees']?.toString() ?? 'N/A'}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[600])),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: c['type'] == 'Government' ? Colors.green[100] : Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          c['type'] ?? 'Private',
                          style: TextStyle(
                            color: c['type'] == 'Government' ? Colors.green[800] : Colors.orange[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 8),
                  Text('Fee Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 12),
                                  _buildFeeItem('Tuition Fee', '₹${((int.tryParse(c['fees']?.toString() ?? '0') ?? 0) * 0.7).round()}', Icons.school),
                _buildFeeItem('Hostel Fee', '₹${((int.tryParse(c['fees']?.toString() ?? '0') ?? 0) * 0.2).round()}', Icons.bed),
                _buildFeeItem('Other Charges', '₹${((int.tryParse(c['fees']?.toString() ?? '0') ?? 0) * 0.1).round()}', Icons.receipt),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Payment Options
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  _buildPaymentOption('One-time Payment', 'Full amount at admission'),
                  _buildPaymentOption('Installments', 'Pay in 2-4 installments'),
                  _buildPaymentOption('Education Loan', 'Available through banks'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeItem(String title, String amount, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600], size: 18),
          SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(fontSize: 14))),
          Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.payment, color: Colors.green[600], size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacementsTab(Map<String, dynamic> c) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placement Statistics
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Placement Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  if (c['placements'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c['placements'].toString(), style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPlacementStat('Average Package', '₹12 LPA', Colors.blue),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildPlacementStat('Highest Package', '₹45 LPA', Colors.green),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPlacementStat('Placement Rate', '85%', Colors.orange),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildPlacementStat('Companies Visited', '150+', Colors.purple),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Text('Placement information not available', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Top Recruiters
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Recruiters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Google', 'Microsoft', 'Amazon', 'TCS', 'Infosys', 'Wipro',
                      'HCL', 'IBM', 'Accenture', 'Cognizant', 'Tech Mahindra'
                    ].map((company) => Chip(
                      label: Text(company),
                      backgroundColor: Colors.blue[50],
                      labelStyle: TextStyle(color: Colors.blue[700]),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Placement Process
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Placement Process', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  _buildProcessStep('1', 'Registration', 'Students register for placements'),
                  _buildProcessStep('2', 'Company Visits', 'Companies conduct pre-placement talks'),
                  _buildProcessStep('3', 'Written Tests', 'Aptitude and technical tests'),
                  _buildProcessStep('4', 'Interviews', 'Technical and HR rounds'),
                  _buildProcessStep('5', 'Offer Letters', 'Selected students receive offers'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacementStat(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String step, String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(step, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(Map<String, dynamic> c) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall Rating
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('${c['rating']?.toString() ?? '4.0'}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange[600])),
                          Row(
                            children: List.generate(5, (index) => Icon(
                              index < double.parse(c['rating']?.toString() ?? '4.0').floor() ? Icons.star : Icons.star_border,
                              color: Colors.orange[600],
                              size: 20,
                            )),
                          ),
                          SizedBox(height: 4),
                          Text('${c['rating']?.toString() ?? '4.0'} out of 5', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRatingBar('Infrastructure', 4.5),
                            _buildRatingBar('Faculty', 4.3),
                            _buildRatingBar('Placements', 4.2),
                            _buildRatingBar('Value for Money', 4.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Student Reviews
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Student Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  _buildReviewItem('Rahul Kumar', '4.5', 'Great infrastructure and faculty. Placements are excellent!'),
                  _buildReviewItem('Priya Sharma', '4.0', 'Good college with decent placements. Campus life is enjoyable.'),
                  _buildReviewItem('Amit Patel', '4.2', 'Quality education and good opportunities for growth.'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Write Review Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement review writing functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Review feature coming soon!')),
                );
              },
              icon: Icon(Icons.rate_review),
              label: Text('Write a Review'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String category, double rating) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(category, style: TextStyle(fontSize: 12))),
          Expanded(
            child: LinearProgressIndicator(
              value: rating / 5,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]!),
            ),
          ),
          SizedBox(width: 8),
          Text(rating.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String rating, String comment) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue[100],
                child: Text(name[0], style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < double.parse(rating).floor() ? Icons.star : Icons.star_border,
                        color: Colors.orange[600],
                        size: 14,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(comment, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Divider(height: 16),
        ],
      ),
    );
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c['name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF2D1B4E),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.deepPurple, size: 18),
                          SizedBox(width: 4),
                          Text(
                            c['city'] ?? '',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                CollegeImage(
                  imageUrl: c['imageUrl'],
                  height: 48,
                  width: 48,
                  borderRadius: 12,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(height: 24, thickness: 1.1),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Courses Offered', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    SizedBox(height: 2),
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Show all courses for ${c['name']?.toString() ?? ''}')),
                      ),
                      child: Text(
                        '${c['coursesCount']?.toString() ?? c['courses']?.length?.toString() ?? '--'} courses',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total Fees Range', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    SizedBox(height: 2),
                    Text(
                      c['feesRange'] ?? c['fees'] ?? '--',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text(
                  '${c['rating']?.toString() ?? '--'}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                loadingFavorite
                    ? SizedBox(width: 36, height: 36, child: CircularProgressIndicator(strokeWidth: 2))
                    : OutlinedButton(
                        onPressed: _toggleFavorite,
                        style: OutlinedButton.styleFrom(
                          shape: CircleBorder(),
                          side: BorderSide(color: Colors.deepPurple),
                          padding: EdgeInsets.all(8),
                        ),
                        child: Icon(
                          isFavorite ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.deepPurple,
                        ),
                      ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () async {
                    final websiteUrl = c['website'] ?? c['officialWebsite'] ?? 'https://example.com';
                    try {
                      await _launchURL(websiteUrl);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not open website: $websiteUrl')),
                      );
                    }
                  },
                  icon: Icon(Icons.language, color: Colors.white, size: 20),
                  label: Text('Website', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 1. Add a helper widget for robust image loading with placeholder
class CollegeImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final BoxFit fit;
  const CollegeImage({this.imageUrl, this.height = 180, this.width = double.infinity, this.borderRadius = 0, this.fit = BoxFit.cover, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              height: height,
              width: width,
              fit: fit,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/college_placeholder.png',
                height: height,
                width: width,
                fit: fit,
              ),
            )
          : Image.asset(
              'assets/college_placeholder.png',
              height: height,
              width: width,
              fit: fit,
            ),
    );
  }
}



