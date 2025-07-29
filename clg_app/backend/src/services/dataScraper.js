const axios = require('axios');
const cheerio = require('cheerio');

class DataScraper {
  constructor() {
    this.baseUrls = {
      nirf: 'https://www.nirfindia.org',
      collegeDunia: 'https://www.collegedunia.com',
      shiksha: 'https://www.shiksha.com',
      careers360: 'https://www.careers360.com'
    };
  }

  // Fetch NIRF rankings
  async getNIRFRankings() {
    try {
      // Mock NIRF data (in real implementation, you'd scrape from nirfindia.org)
      const nirfRankings = [
        { name: 'IIT Bombay', rank: 1, score: 90.5, category: 'Engineering' },
        { name: 'IIT Delhi', rank: 2, score: 89.2, category: 'Engineering' },
        { name: 'IIT Madras', rank: 3, score: 88.7, category: 'Engineering' },
        { name: 'IIT Kanpur', rank: 4, score: 87.9, category: 'Engineering' },
        { name: 'IIT Kharagpur', rank: 5, score: 87.1, category: 'Engineering' },
        { name: 'IIT Roorkee', rank: 6, score: 86.3, category: 'Engineering' },
        { name: 'IIT Guwahati', rank: 7, score: 85.8, category: 'Engineering' },
        { name: 'NIT Trichy', rank: 8, score: 84.2, category: 'Engineering' },
        { name: 'NIT Surathkal', rank: 9, score: 83.7, category: 'Engineering' },
        { name: 'NIT Warangal', rank: 10, score: 83.1, category: 'Engineering' }
      ];
      return nirfRankings;
    } catch (error) {
      console.error('Error fetching NIRF rankings:', error);
      return [];
    }
  }

  // Fetch college details from CollegeDunia
  async getCollegeDetails(collegeName) {
    try {
      // Mock college details (in real implementation, you'd scrape from collegedunia.com)
      const collegeDetails = {
        name: collegeName,
        basicInfo: {
          established: this.getRandomYear(1950, 2020),
          type: this.getRandomType(),
          ownership: this.getRandomOwnership(),
          accreditation: ['AICTE', 'UGC', 'NAAC'],
          campusSize: `${this.getRandomNumber(50, 500)} acres`
        },
        contactInfo: {
          phone: this.generatePhoneNumber(),
          email: `${collegeName.toLowerCase().replace(/\s+/g, '')}@edu.in`,
          website: `https://www.${collegeName.toLowerCase().replace(/\s+/g, '')}.edu.in`,
          address: this.generateAddress()
        },
        academicInfo: {
          courses: this.getRandomCourses(),
          totalStudents: this.getRandomNumber(2000, 10000),
          facultyCount: this.getRandomNumber(100, 500),
          studentFacultyRatio: `${this.getRandomNumber(10, 20)}:1`
        },
        facilities: this.getRandomFacilities(),
        placement: {
          averagePackage: this.getRandomNumber(8, 25),
          highestPackage: this.getRandomNumber(30, 80),
          placementPercentage: this.getRandomNumber(70, 95),
          topRecruiters: this.getRandomRecruiters()
        }
      };
      return collegeDetails;
    } catch (error) {
      console.error('Error fetching college details:', error);
      return null;
    }
  }

  // Fetch admission data
  async getAdmissionData(collegeName) {
    try {
      const currentYear = new Date().getFullYear();
      const admissionData = {
        currentYear: currentYear,
        applicationDeadline: `${currentYear}-05-30`,
        examDates: {
          'JEE Main': `${currentYear}-04-15`,
          'JEE Advanced': `${currentYear}-06-02`,
          'GATE': `${currentYear}-02-03`,
          'CAT': `${currentYear}-11-25`
        },
        cutoffRanks: {
          '2023': {
            'Computer Science': this.getRandomNumber(100, 500),
            'Information Technology': this.getRandomNumber(150, 600),
            'Mechanical Engineering': this.getRandomNumber(500, 1500),
            'Civil Engineering': this.getRandomNumber(800, 2000),
            'Electrical Engineering': this.getRandomNumber(300, 800)
          },
          '2022': {
            'Computer Science': this.getRandomNumber(120, 550),
            'Information Technology': this.getRandomNumber(180, 650),
            'Mechanical Engineering': this.getRandomNumber(550, 1600),
            'Civil Engineering': this.getRandomNumber(850, 2100),
            'Electrical Engineering': this.getRandomNumber(350, 850)
          }
        },
        fees: {
          'Computer Science': this.getRandomNumber(150000, 300000),
          'Information Technology': this.getRandomNumber(140000, 280000),
          'Mechanical Engineering': this.getRandomNumber(120000, 250000),
          'Civil Engineering': this.getRandomNumber(110000, 240000),
          'Electrical Engineering': this.getRandomNumber(130000, 260000)
        }
      };
      return admissionData;
    } catch (error) {
      console.error('Error fetching admission data:', error);
      return null;
    }
  }

  // Fetch placement statistics
  async getPlacementStats(collegeName) {
    try {
      const placementStats = {
        currentYear: new Date().getFullYear(),
        overall: {
          totalStudents: this.getRandomNumber(500, 2000),
          placedStudents: this.getRandomNumber(400, 1800),
          placementPercentage: this.getRandomNumber(75, 95),
          averagePackage: this.getRandomNumber(8, 25),
          highestPackage: this.getRandomNumber(30, 80)
        },
        byBranch: {
          'Computer Science': {
            placed: this.getRandomNumber(80, 120),
            averagePackage: this.getRandomNumber(12, 30),
            highestPackage: this.getRandomNumber(40, 100)
          },
          'Information Technology': {
            placed: this.getRandomNumber(70, 110),
            averagePackage: this.getRandomNumber(10, 25),
            highestPackage: this.getRandomNumber(35, 90)
          },
          'Mechanical Engineering': {
            placed: this.getRandomNumber(60, 100),
            averagePackage: this.getRandomNumber(8, 20),
            highestPackage: this.getRandomNumber(25, 60)
          }
        },
        topRecruiters: this.getRandomRecruiters(),
        salaryDistribution: {
          '0-5 LPA': this.getRandomNumber(10, 30),
          '5-10 LPA': this.getRandomNumber(20, 50),
          '10-15 LPA': this.getRandomNumber(30, 80),
          '15-20 LPA': this.getRandomNumber(20, 60),
          '20+ LPA': this.getRandomNumber(10, 40)
        }
      };
      return placementStats;
    } catch (error) {
      console.error('Error fetching placement stats:', error);
      return null;
    }
  }

  // Fetch infrastructure details
  async getInfrastructureDetails(collegeName) {
    try {
      const infrastructure = {
        campus: {
          size: `${this.getRandomNumber(50, 500)} acres`,
          buildings: this.getRandomNumber(10, 50),
          classrooms: this.getRandomNumber(50, 200),
          labs: this.getRandomNumber(20, 100)
        },
        hostel: {
          capacity: this.getRandomNumber(1000, 5000),
          rooms: this.getRandomNumber(500, 2500),
          facilities: ['WiFi', 'AC', 'Mess', 'Laundry', 'Gym', 'Medical']
        },
        library: {
          books: this.getRandomNumber(50000, 200000),
          journals: this.getRandomNumber(100, 500),
          digitalResources: this.getRandomNumber(50, 200),
          seatingCapacity: this.getRandomNumber(200, 1000)
        },
        sports: {
          grounds: this.getRandomNumber(5, 20),
          indoorFacilities: ['Badminton', 'Table Tennis', 'Gym', 'Swimming Pool'],
          outdoorFacilities: ['Cricket', 'Football', 'Basketball', 'Tennis', 'Volleyball']
        },
        labs: {
          computerLabs: this.getRandomNumber(5, 20),
          researchLabs: this.getRandomNumber(10, 50),
          equipment: this.getRandomNumber(100, 1000)
        },
        wifi: {
          coverage: '100%',
          speed: `${this.getRandomNumber(50, 200)} Mbps`
        }
      };
      return infrastructure;
    } catch (error) {
      console.error('Error fetching infrastructure details:', error);
      return null;
    }
  }

  // Generate sample college data
  async generateSampleColleges(count = 50) {
    const colleges = [];
    const collegeNames = [
      'IIT Bombay', 'IIT Delhi', 'IIT Madras', 'IIT Kanpur', 'IIT Kharagpur',
      'IIT Roorkee', 'IIT Guwahati', 'IIT Hyderabad', 'IIT Indore', 'IIT Jodhpur',
      'NIT Trichy', 'NIT Surathkal', 'NIT Warangal', 'NIT Calicut', 'NIT Rourkela',
      'NIT Jaipur', 'NIT Allahabad', 'NIT Bhopal', 'NIT Durgapur', 'NIT Hamirpur',
      'BITS Pilani', 'BITS Goa', 'BITS Hyderabad', 'Manipal Institute of Technology',
      'VIT Vellore', 'VIT Chennai', 'SRM Institute', 'Amrita University',
      'Thapar University', 'PES University', 'RVCE Bangalore', 'MS Ramaiah Institute',
      'PESIT Bangalore', 'BMS College', 'Christ University', 'St. Joseph\'s College',
      'St. Xavier\'s College', 'Loyola College', 'Presidency College',
      'Delhi Technological University', 'Netaji Subhas University',
      'Jadavpur University', 'Calcutta University', 'Bombay University',
      'Pune University', 'Anna University', 'Osmania University',
      'Andhra University', 'Kerala University', 'Gujarat University'
    ];

    for (let i = 0; i < Math.min(count, collegeNames.length); i++) {
      const collegeName = collegeNames[i];
      const details = await this.getCollegeDetails(collegeName);
      const admission = await this.getAdmissionData(collegeName);
      const placement = await this.getPlacementStats(collegeName);
      const infrastructure = await this.getInfrastructureDetails(collegeName);

      const college = {
        id: `college_${i + 1}`,
        name: collegeName,
        city: this.getRandomCity(),
        state: this.getRandomState(),
        type: details.basicInfo.type,
        ownership: details.basicInfo.ownership,
        establishedYear: details.basicInfo.established,
        rank: i + 1,
        rating: (Math.random() * 2 + 3).toFixed(1), // 3.0 to 5.0
        fees: admission.fees['Computer Science'],
        totalFees: admission.fees['Computer Science'] * 4, // 4 years
        courses: details.academicInfo.courses,
        totalCourses: details.academicInfo.courses.length,
        btechCourses: details.academicInfo.courses.filter(c => c.includes('Engineering')).length,
        medianSalary: placement.overall.averagePackage,
        highestSalary: placement.overall.highestPackage,
        placementRating: (Math.random() * 2 + 3).toFixed(1),
        infrastructureRating: (Math.random() * 2 + 3).toFixed(1),
        facultyRating: (Math.random() * 2 + 3).toFixed(1),
        campusRating: (Math.random() * 2 + 3).toFixed(1),
        valueRating: (Math.random() * 2 + 3).toFixed(1),
        reviews: this.getRandomNumber(100, 1000),
        nirfRank: i + 1,
        indiaTodayRank: this.getRandomNumber(1, 100),
        facilities: details.facilities,
        website: details.contactInfo.website,
        phone: details.contactInfo.phone,
        email: details.contactInfo.email,
        address: details.contactInfo.address,
        imageUrl: `https://source.unsplash.com/400x300/?university,${collegeName.toLowerCase().replace(/\s+/g, '')}`,
        lastUpdated: new Date().toISOString(),
        // Enhanced data
        admissionData: admission,
        placementStats: placement,
        infrastructure: infrastructure,
        socialMedia: {
          facebook: `https://facebook.com/${collegeName.toLowerCase().replace(/\s+/g, '')}`,
          twitter: `https://twitter.com/${collegeName.toLowerCase().replace(/\s+/g, '')}`,
          linkedin: `https://linkedin.com/school/${collegeName.toLowerCase().replace(/\s+/g, '')}`,
          instagram: `https://instagram.com/${collegeName.toLowerCase().replace(/\s+/g, '')}`
        }
      };

      colleges.push(college);
    }

    return colleges;
  }

  // Helper methods
  getRandomNumber(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  getRandomYear(min, max) {
    return this.getRandomNumber(min, max);
  }

  getRandomType() {
    const types = ['Government', 'Private', 'Deemed University', 'Autonomous'];
    return types[Math.floor(Math.random() * types.length)];
  }

  getRandomOwnership() {
    const ownerships = ['Government', 'Private', 'Public-Private Partnership'];
    return ownerships[Math.floor(Math.random() * ownerships.length)];
  }

  getRandomCity() {
    const cities = [
      'Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Hyderabad', 'Kolkata',
      'Pune', 'Ahmedabad', 'Jaipur', 'Lucknow', 'Kanpur', 'Nagpur',
      'Indore', 'Bhopal', 'Vadodara', 'Surat', 'Patna', 'Ranchi',
      'Guwahati', 'Bhubaneswar', 'Thiruvananthapuram', 'Kochi'
    ];
    return cities[Math.floor(Math.random() * cities.length)];
  }

  getRandomState() {
    const states = [
      'Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu', 'Telangana', 'West Bengal',
      'Gujarat', 'Rajasthan', 'Uttar Pradesh', 'Madhya Pradesh', 'Bihar',
      'Jharkhand', 'Assam', 'Odisha', 'Kerala', 'Andhra Pradesh'
    ];
    return states[Math.floor(Math.random() * states.length)];
  }

  getRandomCourses() {
    const allCourses = [
      'Computer Science Engineering', 'Information Technology', 'Mechanical Engineering',
      'Civil Engineering', 'Electrical Engineering', 'Electronics & Communication',
      'Chemical Engineering', 'Biotechnology', 'Aerospace Engineering',
      'Automobile Engineering', 'Industrial Engineering', 'Textile Engineering',
      'Agricultural Engineering', 'Mining Engineering', 'Metallurgical Engineering'
    ];
    const count = this.getRandomNumber(5, 12);
    const courses = [];
    for (let i = 0; i < count; i++) {
      const course = allCourses[Math.floor(Math.random() * allCourses.length)];
      if (!courses.includes(course)) {
        courses.push(course);
      }
    }
    return courses;
  }

  getRandomFacilities() {
    const allFacilities = [
      'WiFi Campus', 'AC Classrooms', 'Digital Library', 'Computer Labs',
      'Research Labs', 'Sports Complex', 'Gymnasium', 'Swimming Pool',
      'Auditorium', 'Conference Hall', 'Cafeteria', 'Medical Center',
      'Bank & ATM', 'Post Office', 'Transportation', 'Hostel',
      'Guest House', 'Shopping Complex', 'Parking', 'Security'
    ];
    const count = this.getRandomNumber(10, 18);
    const facilities = [];
    for (let i = 0; i < count; i++) {
      const facility = allFacilities[Math.floor(Math.random() * allFacilities.length)];
      if (!facilities.includes(facility)) {
        facilities.push(facility);
      }
    }
    return facilities;
  }

  getRandomRecruiters() {
    const allRecruiters = [
      'Google', 'Microsoft', 'Amazon', 'Apple', 'Meta', 'Netflix',
      'TCS', 'Infosys', 'Wipro', 'HCL', 'Tech Mahindra', 'Cognizant',
      'Accenture', 'IBM', 'Oracle', 'SAP', 'Adobe', 'Intel',
      'Qualcomm', 'NVIDIA', 'AMD', 'Cisco', 'Juniper', 'VMware'
    ];
    const count = this.getRandomNumber(5, 12);
    const recruiters = [];
    for (let i = 0; i < count; i++) {
      const recruiter = allRecruiters[Math.floor(Math.random() * allRecruiters.length)];
      if (!recruiters.includes(recruiter)) {
        recruiters.push(recruiter);
      }
    }
    return recruiters;
  }

  generatePhoneNumber() {
    const prefixes = ['91', '44', '22', '33', '40', '80'];
    const prefix = prefixes[Math.floor(Math.random() * prefixes.length)];
    const number = Math.floor(Math.random() * 9000000000) + 1000000000;
    return `+${prefix} ${number}`;
  }

  generateAddress() {
    const cities = ['Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Hyderabad'];
    const city = cities[Math.floor(Math.random() * cities.length)];
    const street = Math.floor(Math.random() * 999) + 1;
    return `${street} Main Street, ${city}, India - ${Math.floor(Math.random() * 900000) + 100000}`;
  }
}

module.exports = DataScraper; 