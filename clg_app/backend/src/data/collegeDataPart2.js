const collegeDataPart2 = [
  // NITs (National Institutes of Technology)
  {
    id: 'nit_trichy',
    name: 'National Institute of Technology Tiruchirappalli',
    city: 'Tiruchirappalli',
    state: 'Tamil Nadu',
    type: 'Government',
    ownership: 'Government',
    establishedYear: 1964,
    rank: 6,
    rating: 4.5,
    fees: 180000,
    totalFees: 720000,
    courses: [
      'Computer Science Engineering',
      'Information Technology',
      'Electrical Engineering',
      'Mechanical Engineering',
      'Civil Engineering',
      'Chemical Engineering',
      'Electronics & Communication',
      'Production Engineering'
    ],
    totalCourses: 8,
    btechCourses: 8,
    medianSalary: 1200000,
    highestSalary: 2800000,
    placementRating: 4.6,
    infrastructureRating: 4.4,
    facultyRating: 4.5,
    campusRating: 4.3,
    valueRating: 4.4,
    reviews: 1876,
    nirfRank: 8,
    indiaTodayRank: 6,
    facilities: [
      'WiFi Campus', 'AC Classrooms', 'Digital Library', 'Computer Labs',
      'Research Labs', 'Sports Complex', 'Gymnasium', 'Auditorium',
      'Conference Hall', 'Cafeteria', 'Medical Center', 'Bank & ATM',
      'Transportation', 'Hostel', 'Guest House', 'Parking', 'Security'
    ],
    website: 'https://www.nitt.edu',
    phone: '+91-431-250-3000',
    email: 'director@nitt.edu',
    address: 'Tanjore Main Road, Tiruchirappalli, Tamil Nadu 620015',
    imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9e1?w=400&h=300&fit=crop',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 'nit_surathkal',
    name: 'National Institute of Technology Karnataka',
    city: 'Mangalore',
    state: 'Karnataka',
    type: 'Government',
    ownership: 'Government',
    establishedYear: 1960,
    rank: 7,
    rating: 4.5,
    fees: 175000,
    totalFees: 700000,
    courses: [
      'Computer Science Engineering',
      'Information Technology',
      'Electrical Engineering',
      'Mechanical Engineering',
      'Civil Engineering',
      'Chemical Engineering',
      'Electronics & Communication',
      'Mining Engineering'
    ],
    totalCourses: 8,
    btechCourses: 8,
    medianSalary: 1150000,
    highestSalary: 2700000,
    placementRating: 4.5,
    infrastructureRating: 4.3,
    facultyRating: 4.4,
    campusRating: 4.2,
    valueRating: 4.3,
    reviews: 1654,
    nirfRank: 9,
    indiaTodayRank: 7,
    facilities: [
      'WiFi Campus', 'AC Classrooms', 'Digital Library', 'Computer Labs',
      'Research Labs', 'Sports Complex', 'Gymnasium', 'Swimming Pool',
      'Auditorium', 'Conference Hall', 'Cafeteria', 'Medical Center',
      'Bank & ATM', 'Transportation', 'Hostel', 'Guest House', 'Parking'
    ],
    website: 'https://www.nitk.ac.in',
    phone: '+91-824-247-4000',
    email: 'director@nitk.ac.in',
    address: 'NH 66, Srinivasnagar, Mangalore, Karnataka 575025',
    imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&h=300&fit=crop',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 'nit_warangal',
    name: 'National Institute of Technology Warangal',
    city: 'Warangal',
    state: 'Telangana',
    type: 'Government',
    ownership: 'Government',
    establishedYear: 1959,
    rank: 8,
    rating: 4.4,
    fees: 170000,
    totalFees: 680000,
    courses: [
      'Computer Science Engineering',
      'Information Technology',
      'Electrical Engineering',
      'Mechanical Engineering',
      'Civil Engineering',
      'Chemical Engineering',
      'Electronics & Communication',
      'Metallurgical Engineering'
    ],
    totalCourses: 8,
    btechCourses: 8,
    medianSalary: 1100000,
    highestSalary: 2600000,
    placementRating: 4.4,
    infrastructureRating: 4.2,
    facultyRating: 4.3,
    campusRating: 4.1,
    valueRating: 4.2,
    reviews: 1432,
    nirfRank: 10,
    indiaTodayRank: 8,
    facilities: [
      'WiFi Campus', 'AC Classrooms', 'Digital Library', 'Computer Labs',
      'Research Labs', 'Sports Complex', 'Gymnasium', 'Auditorium',
      'Conference Hall', 'Cafeteria', 'Medical Center', 'Bank & ATM',
      'Transportation', 'Hostel', 'Guest House', 'Parking', 'Security'
    ],
    website: 'https://www.nitw.ac.in',
    phone: '+91-870-245-9191',
    email: 'director@nitw.ac.in',
    address: 'NIT Campus, Warangal, Telangana 506004',
    imageUrl: 'https://images.unsplash.com/photo-1562774053-701939374585?w=400&h=300&fit=crop',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 'bits_pilani',
    name: 'Birla Institute of Technology and Science Pilani',
    city: 'Pilani',
    state: 'Rajasthan',
    type: 'Private',
    ownership: 'Private',
    establishedYear: 1964,
    rank: 9,
    rating: 4.6,
    fees: 450000,
    totalFees: 1800000,
    courses: [
      'Computer Science Engineering',
      'Information Technology',
      'Electrical Engineering',
      'Mechanical Engineering',
      'Civil Engineering',
      'Chemical Engineering',
      'Electronics & Communication',
      'Biotechnology'
    ],
    totalCourses: 8,
    btechCourses: 8,
    medianSalary: 1400000,
    highestSalary: 3200000,
    placementRating: 4.7,
    infrastructureRating: 4.6,
    facultyRating: 4.5,
    campusRating: 4.4,
    valueRating: 4.3,
    reviews: 1987,
    nirfRank: 12,
    indiaTodayRank: 9,
    facilities: [
      'WiFi Campus', 'AC Classrooms', 'Digital Library', 'Computer Labs',
      'Research Labs', 'Sports Complex', 'Gymnasium', 'Swimming Pool',
      'Auditorium', 'Conference Hall', 'Cafeteria', 'Medical Center',
      'Bank & ATM', 'Transportation', 'Hostel', 'Guest House', 'Parking'
    ],
    website: 'https://www.bits-pilani.ac.in',
    phone: '+91-1596-242-210',
    email: 'director@pilani.bits-pilani.ac.in',
    address: 'Vidya Vihar, Pilani, Rajasthan 333031',
    imageUrl: 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&h=300&fit=crop',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 'vit_vellore',
    name: 'Vellore Institute of Technology',
    city: 'Vellore',
    state: 'Tamil Nadu',
    type: 'Private',
    ownership: 'Private',
    establishedYear: 1984,
    rank: 10,
    rating: 4.3,
    fees: 350000,
    totalFees: 1400000,
    courses: [
      'Computer Science Engineering',
      'Information Technology',
      'Electrical Engineering',
      'Mechanical Engineering',
      'Civil Engineering',
      'Chemical Engineering',
      'Electronics & Communication',
      'Biotechnology'
    ],
    totalCourses: 8,
    btechCourses: 8,
    medianSalary: 1000000,
    highestSalary: 2400000,
    placementRating: 4.4,
    infrastructureRating: 4.3,
    facultyRating: 4.2,
    campusRating: 4.1,
    valueRating: 4.0,
    reviews: 3245,
    nirfRank: 15,
    indiaTodayRank: 10,
    facilities: [
      'WiFi Campus', 'AC Classrooms', 'Digital Library', 'Computer Labs',
      'Research Labs', 'Sports Complex', 'Gymnasium', 'Swimming Pool',
      'Auditorium', 'Conference Hall', 'Cafeteria', 'Medical Center',
      'Bank & ATM', 'Transportation', 'Hostel', 'Guest House', 'Parking'
    ],
    website: 'https://www.vit.ac.in',
    phone: '+91-416-224-3091',
    email: 'admissions@vit.ac.in',
    address: 'VIT University, Vellore, Tamil Nadu 632014',
    imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9e1?w=400&h=300&fit=crop',
    lastUpdated: new Date().toISOString()
  }
];

module.exports = collegeDataPart2; 