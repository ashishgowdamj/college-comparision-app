const express = require('express');
const router = express.Router();
const db = require('../utils/firebase');
const axios = require('axios');

// GET /colleges - Get all colleges with enhanced data
router.get('/', async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 20, 
      search, 
      city, 
      type, 
      minRank, 
      maxRank, 
      minFees, 
      maxFees,
      course,
      sortBy = 'rank',
      sortOrder = 'asc'
    } = req.query;

    let query = db.collection('colleges');

    // Apply filters
    if (city) {
      query = query.where('city', '==', city);
    }
    if (type) {
      query = query.where('type', '==', type);
    }
    if (course) {
      query = query.where('courses', 'array-contains', course);
    }
    if (minRank) {
      query = query.where('rank', '>=', parseInt(minRank));
    }
    if (maxRank) {
      query = query.where('rank', '<=', parseInt(maxRank));
    }
    if (minFees) {
      query = query.where('fees', '>=', parseInt(minFees));
    }
    if (maxFees) {
      query = query.where('fees', '<=', parseInt(maxFees));
    }

    // Apply sorting
    if (sortBy === 'rank') {
      query = query.orderBy('rank', sortOrder);
    } else if (sortBy === 'fees') {
      query = query.orderBy('fees', sortOrder);
    } else if (sortBy === 'rating') {
      query = query.orderBy('rating', sortOrder);
    } else if (sortBy === 'name') {
      query = query.orderBy('name', sortOrder);
    }

    const snapshot = await query.get();
    let colleges = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    // Apply search filter if provided
    if (search) {
      const searchLower = search.toLowerCase();
      colleges = colleges.filter(college => 
        college.name?.toLowerCase().includes(searchLower) ||
        college.city?.toLowerCase().includes(searchLower) ||
        college.type?.toLowerCase().includes(searchLower)
      );
    }

    // Apply pagination
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedColleges = colleges.slice(startIndex, endIndex);

    // Enhance with real-time data
    const enhancedColleges = await Promise.all(
      paginatedColleges.map(async (college) => {
        return await enhanceCollegeData(college);
      })
    );

    res.json({
      data: enhancedColleges,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: colleges.length,
        totalPages: Math.ceil(colleges.length / limit)
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /colleges/:id - Get detailed college information
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const collegeDoc = await db.collection('colleges').doc(id).get();
    
    if (!collegeDoc.exists) {
      return res.status(404).json({ error: 'College not found' });
    }

    const college = { id: collegeDoc.id, ...collegeDoc.data() };
    const enhancedCollege = await enhanceCollegeData(college);

    res.json({ data: enhancedCollege });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /colleges/stats/overview - Get overall statistics
router.get('/stats/overview', async (req, res) => {
  try {
    const snapshot = await db.collection('colleges').get();
    const colleges = snapshot.docs.map(doc => doc.data());

    const stats = {
      totalColleges: colleges.length,
      byType: {},
      byCity: {},
      feeRange: {
        min: Math.min(...colleges.map(c => c.fees || 0)),
        max: Math.max(...colleges.map(c => c.fees || 0)),
        average: Math.round(colleges.reduce((sum, c) => sum + (c.fees || 0), 0) / colleges.length)
      },
      rankRange: {
        min: Math.min(...colleges.map(c => c.rank || 0)),
        max: Math.max(...colleges.map(c => c.rank || 0)),
        average: Math.round(colleges.reduce((sum, c) => sum + (c.rank || 0), 0) / colleges.length)
      },
      ratingStats: {
        average: Math.round((colleges.reduce((sum, c) => sum + (parseFloat(c.rating) || 0), 0) / colleges.length) * 10) / 10,
        distribution: {
          '4.5+': colleges.filter(c => (parseFloat(c.rating) || 0) >= 4.5).length,
          '4.0-4.5': colleges.filter(c => (parseFloat(c.rating) || 0) >= 4.0 && (parseFloat(c.rating) || 0) < 4.5).length,
          '3.5-4.0': colleges.filter(c => (parseFloat(c.rating) || 0) >= 3.5 && (parseFloat(c.rating) || 0) < 4.0).length,
          '3.0-3.5': colleges.filter(c => (parseFloat(c.rating) || 0) >= 3.0 && (parseFloat(c.rating) || 0) < 3.5).length,
          '<3.0': colleges.filter(c => (parseFloat(c.rating) || 0) < 3.0).length
        }
      }
    };

    // Calculate type distribution
    colleges.forEach(college => {
      const type = college.type || 'Unknown';
      stats.byType[type] = (stats.byType[type] || 0) + 1;
    });

    // Calculate city distribution
    colleges.forEach(college => {
      const city = college.city || 'Unknown';
      stats.byCity[city] = (stats.byCity[city] || 0) + 1;
    });

    res.json({ data: stats });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /colleges/trending/real-time - Get real-time trending colleges
router.get('/trending/real-time', async (req, res) => {
  try {
    const { limit = 10 } = req.query;
    
    // Get colleges with recent updates or high activity
    const snapshot = await db.collection('colleges')
      .orderBy('lastUpdated', 'desc')
      .limit(parseInt(limit))
      .get();

    const trendingColleges = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    
    // Enhance with real-time data
    const enhancedTrending = await Promise.all(
      trendingColleges.map(async (college) => {
        return await enhanceCollegeData(college);
      })
    );

    res.json({ data: enhancedTrending });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Helper function to enhance college data with real-time information
async function enhanceCollegeData(college) {
  try {
    const enhanced = { ...college };

    // Add real-time ranking data (mock for now, can be replaced with actual API calls)
    enhanced.realTimeRankings = {
      nirf: await getNIRFRanking(college.name),
      qs: await getQSWorldRanking(college.name),
      timesHigher: await getTimesHigherRanking(college.name)
    };

    // Add current year admission data
    enhanced.admissionData = {
      currentYear: new Date().getFullYear(),
      applicationDeadline: await getApplicationDeadline(college.name),
      examDates: await getExamDates(college.name),
      cutoffTrends: await getCutoffTrends(college.name)
    };

    // Add placement statistics
    enhanced.placementStats = {
      currentYear: await getCurrentYearPlacements(college.name),
      topRecruiters: await getTopRecruiters(college.name),
      averagePackage: await getAveragePackage(college.name),
      highestPackage: await getHighestPackage(college.name)
    };

    // Add infrastructure updates
    enhanced.infrastructure = {
      facilities: college.facilities || [],
      hostelCapacity: await getHostelCapacity(college.name),
      libraryBooks: await getLibraryBooks(college.name),
      labEquipment: await getLabEquipment(college.name)
    };

    // Add social media presence
    enhanced.socialMedia = {
      website: college.website,
      facebook: await getSocialMediaLink(college.name, 'facebook'),
      twitter: await getSocialMediaLink(college.name, 'twitter'),
      linkedin: await getSocialMediaLink(college.name, 'linkedin'),
      instagram: await getSocialMediaLink(college.name, 'instagram')
    };

    return enhanced;
  } catch (error) {
    console.error('Error enhancing college data:', error);
    return college; // Return original data if enhancement fails
  }
}

// Mock functions for real-time data (replace with actual API calls)
async function getNIRFRanking(collegeName) {
  // Mock NIRF ranking data
  const rankings = {
    'IIT Bombay': 1,
    'IIT Delhi': 2,
    'IIT Madras': 3,
    'IIT Kanpur': 4,
    'IIT Kharagpur': 5
  };
  return rankings[collegeName] || Math.floor(Math.random() * 100) + 1;
}

async function getQSWorldRanking(collegeName) {
  // Mock QS World ranking data
  const rankings = {
    'IIT Bombay': 172,
    'IIT Delhi': 185,
    'IIT Madras': 255,
    'IIT Kanpur': 264,
    'IIT Kharagpur': 280
  };
  return rankings[collegeName] || Math.floor(Math.random() * 1000) + 200;
}

async function getTimesHigherRanking(collegeName) {
  // Mock Times Higher Education ranking data
  const rankings = {
    'IIT Bombay': 201,
    'IIT Delhi': 250,
    'IIT Madras': 301,
    'IIT Kanpur': 350,
    'IIT Kharagpur': 400
  };
  return rankings[collegeName] || Math.floor(Math.random() * 500) + 200;
}

async function getApplicationDeadline(collegeName) {
  // Mock application deadline data
  const deadlines = {
    'IIT Bombay': '2024-05-15',
    'IIT Delhi': '2024-05-20',
    'IIT Madras': '2024-05-18',
    'IIT Kanpur': '2024-05-22',
    'IIT Kharagpur': '2024-05-25'
  };
  return deadlines[collegeName] || '2024-05-30';
}

async function getExamDates(collegeName) {
  // Mock exam dates data
  return {
    'JEE Main': '2024-04-15',
    'JEE Advanced': '2024-06-02',
    'GATE': '2024-02-03'
  };
}

async function getCutoffTrends(collegeName) {
  // Mock cutoff trends data
  return {
    '2023': { 'CS': 100, 'IT': 150, 'ME': 500, 'CE': 800 },
    '2022': { 'CS': 120, 'IT': 180, 'ME': 550, 'CE': 850 },
    '2021': { 'CS': 140, 'IT': 200, 'ME': 600, 'CE': 900 }
  };
}

async function getCurrentYearPlacements(collegeName) {
  // Mock placement data
  return {
    'totalStudents': Math.floor(Math.random() * 500) + 200,
    'placedStudents': Math.floor(Math.random() * 400) + 150,
    'placementPercentage': Math.floor(Math.random() * 20) + 80
  };
}

async function getTopRecruiters(collegeName) {
  // Mock top recruiters data
  const recruiters = [
    'Google', 'Microsoft', 'Amazon', 'Apple', 'Meta',
    'TCS', 'Infosys', 'Wipro', 'HCL', 'Tech Mahindra'
  ];
  return recruiters.slice(0, Math.floor(Math.random() * 5) + 3);
}

async function getAveragePackage(collegeName) {
  // Mock average package data
  return Math.floor(Math.random() * 10) + 15; // 15-25 LPA
}

async function getHighestPackage(collegeName) {
  // Mock highest package data
  return Math.floor(Math.random() * 20) + 40; // 40-60 LPA
}

async function getHostelCapacity(collegeName) {
  // Mock hostel capacity data
  return Math.floor(Math.random() * 2000) + 1000;
}

async function getLibraryBooks(collegeName) {
  // Mock library books data
  return Math.floor(Math.random() * 50000) + 100000;
}

async function getLabEquipment(collegeName) {
  // Mock lab equipment data
  return Math.floor(Math.random() * 500) + 100;
}

async function getSocialMediaLink(collegeName, platform) {
  // Mock social media links
  const baseUrl = collegeName.toLowerCase().replace(/\s+/g, '');
  return `https://${platform}.com/${baseUrl}`;
}

module.exports = router; 