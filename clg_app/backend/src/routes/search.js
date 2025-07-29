const express = require('express');
const router = express.Router();
const db = require('../utils/firebase');

// GET /search/advanced
router.get('/advanced', async (req, res) => {
  try {
    const {
      query,
      branch,
      city,
      state,
      type,
      minFees,
      maxFees,
      minRank,
      maxRank,
      sortBy = 'rank',
      sortOrder = 'asc',
      page = 1,
      limit = 20
    } = req.query;

    let collegesRef = db.collection('colleges');

    // Apply filters
    if (branch) {
      collegesRef = collegesRef.where('courses', 'array-contains', branch);
    }
    if (city) {
      collegesRef = collegesRef.where('city', '==', city);
    }
    if (state) {
      collegesRef = collegesRef.where('state', '==', state);
    }
    if (type) {
      collegesRef = collegesRef.where('type', '==', type);
    }
    if (minFees) {
      collegesRef = collegesRef.where('fees', '>=', parseInt(minFees));
    }
    if (maxFees) {
      collegesRef = collegesRef.where('fees', '<=', parseInt(maxFees));
    }
    if (minRank) {
      collegesRef = collegesRef.where('rank', '>=', parseInt(minRank));
    }
    if (maxRank) {
      collegesRef = collegesRef.where('rank', '<=', parseInt(maxRank));
    }

    // Apply sorting
    const sortDirection = sortOrder === 'desc' ? 'desc' : 'asc';
    collegesRef = collegesRef.orderBy(sortBy, sortDirection);

    // Apply pagination
    const offset = (parseInt(page) - 1) * parseInt(limit);
    collegesRef = collegesRef.limit(parseInt(limit));

    const snapshot = await collegesRef.get();
    const colleges = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    // Apply text search if query provided
    let filteredColleges = colleges;
    if (query) {
      const searchLower = query.toLowerCase();
      filteredColleges = colleges.filter(college => 
        college.name.toLowerCase().includes(searchLower) ||
        college.city.toLowerCase().includes(searchLower) ||
        college.type.toLowerCase().includes(searchLower) ||
        (college.courses && college.courses.some(course => 
          course.toLowerCase().includes(searchLower)
        ))
      );
    }

    res.json({
      data: filteredColleges,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: filteredColleges.length,
        hasMore: filteredColleges.length === parseInt(limit)
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /search/suggestions
router.get('/suggestions', async (req, res) => {
  try {
    const { query } = req.query;
    
    if (!query || query.length < 2) {
      return res.json({ data: [] });
    }

    const searchLower = query.toLowerCase();
    const snapshot = await db.collection('colleges').get();
    
    const suggestions = [];
    const seen = new Set();

    snapshot.docs.forEach(doc => {
      const college = doc.data();
      
      // College name suggestions
      if (college.name.toLowerCase().includes(searchLower) && !seen.has(college.name)) {
        suggestions.push({
          type: 'college',
          value: college.name,
          id: doc.id
        });
        seen.add(college.name);
      }
      
      // City suggestions
      if (college.city && college.city.toLowerCase().includes(searchLower) && !seen.has(college.city)) {
        suggestions.push({
          type: 'city',
          value: college.city
        });
        seen.add(college.city);
      }
      
      // Course suggestions
      if (college.courses) {
        college.courses.forEach(course => {
          if (course.toLowerCase().includes(searchLower) && !seen.has(course)) {
            suggestions.push({
              type: 'course',
              value: course
            });
            seen.add(course);
          }
        });
      }
    });

    // Limit suggestions and sort by relevance
    const limitedSuggestions = suggestions.slice(0, 10);
    
    res.json({ data: limitedSuggestions });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /search/stats
router.get('/stats', async (req, res) => {
  try {
    const snapshot = await db.collection('colleges').get();
    const colleges = snapshot.docs.map(doc => doc.data());

    const stats = {
      totalColleges: colleges.length,
      byType: {},
      byCity: {},
      byState: {},
      feeRange: {
        min: Math.min(...colleges.map(c => c.fees || 0)),
        max: Math.max(...colleges.map(c => c.fees || 0)),
        average: Math.round(colleges.reduce((sum, c) => sum + (c.fees || 0), 0) / colleges.length)
      },
      rankRange: {
        min: Math.min(...colleges.map(c => c.rank || 0)),
        max: Math.max(...colleges.map(c => c.rank || 0)),
        average: Math.round(colleges.reduce((sum, c) => sum + (c.rank || 0), 0) / colleges.length)
      }
    };

    // Count by type
    colleges.forEach(college => {
      const type = college.type || 'Unknown';
      stats.byType[type] = (stats.byType[type] || 0) + 1;
    });

    // Count by city
    colleges.forEach(college => {
      const city = college.city || 'Unknown';
      stats.byCity[city] = (stats.byCity[city] || 0) + 1;
    });

    // Count by state
    colleges.forEach(college => {
      const state = college.state || 'Unknown';
      stats.byState[state] = (stats.byState[state] || 0) + 1;
    });

    res.json({ data: stats });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router; 