const express = require('express');
const router = express.Router();
const db = require('../utils/firebase');

// POST /comparison/compare
router.post('/compare', async (req, res) => {
  try {
    const { collegeIds } = req.body;
    
    if (!collegeIds || !Array.isArray(collegeIds) || collegeIds.length < 2) {
      return res.status(400).json({ error: 'At least 2 college IDs are required' });
    }

    if (collegeIds.length > 4) {
      return res.status(400).json({ error: 'Maximum 4 colleges can be compared' });
    }

    const colleges = [];
    
    for (const collegeId of collegeIds) {
      const collegeDoc = await db.collection('colleges').doc(collegeId).get();
      if (collegeDoc.exists) {
        colleges.push({ id: collegeDoc.id, ...collegeDoc.data() });
      }
    }

    if (colleges.length < 2) {
      return res.status(400).json({ error: 'At least 2 valid colleges are required' });
    }

    // Generate comparison data
    const comparison = {
      colleges: colleges,
      summary: {
        totalColleges: colleges.length,
        averageFees: Math.round(colleges.reduce((sum, c) => sum + (c.fees || 0), 0) / colleges.length),
        averageRank: Math.round(colleges.reduce((sum, c) => sum + (c.rank || 0), 0) / colleges.length),
        averageRating: Math.round((colleges.reduce((sum, c) => sum + (parseFloat(c.rating) || 0), 0) / colleges.length) * 10) / 10,
        feeRange: {
          min: Math.min(...colleges.map(c => c.fees || 0)),
          max: Math.max(...colleges.map(c => c.fees || 0))
        },
        rankRange: {
          min: Math.min(...colleges.map(c => c.rank || 0)),
          max: Math.max(...colleges.map(c => c.rank || 0))
        }
      },
      comparison: {
        fees: colleges.map(c => ({ id: c.id, name: c.name, value: c.fees })),
        ranks: colleges.map(c => ({ id: c.id, name: c.name, value: c.rank })),
        ratings: colleges.map(c => ({ id: c.id, name: c.name, value: parseFloat(c.rating) || 0 })),
        types: colleges.map(c => ({ id: c.id, name: c.name, value: c.type })),
        cities: colleges.map(c => ({ id: c.id, name: c.name, value: c.city }))
      }
    };

    res.json({ data: comparison });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /comparison/recommendations/:collegeId
router.get('/recommendations/:collegeId', async (req, res) => {
  try {
    const { collegeId } = req.params;
    const { limit = 5 } = req.query;
    
    const collegeDoc = await db.collection('colleges').doc(collegeId).get();
    if (!collegeDoc.exists) {
      return res.status(404).json({ error: 'College not found' });
    }

    const college = collegeDoc.data();
    
    // Find similar colleges based on multiple criteria
    let recommendationsQuery = db.collection('colleges')
      .where('type', '==', college.type)
      .orderBy('rank')
      .limit(parseInt(limit) + 1); // +1 to exclude the original college

    const snapshot = await recommendationsQuery.get();
    let recommendations = snapshot.docs
      .map(doc => ({ id: doc.id, ...doc.data() }))
      .filter(c => c.id !== collegeId)
      .slice(0, parseInt(limit));

    // If not enough recommendations, add more based on city
    if (recommendations.length < parseInt(limit)) {
      const cityQuery = db.collection('colleges')
        .where('city', '==', college.city)
        .orderBy('rank')
        .limit(parseInt(limit) - recommendations.length + 1);

      const citySnapshot = await cityQuery.get();
      const cityRecommendations = citySnapshot.docs
        .map(doc => ({ id: doc.id, ...doc.data() }))
        .filter(c => c.id !== collegeId && !recommendations.find(r => r.id === c.id));

      recommendations = [...recommendations, ...cityRecommendations];
    }

    // If still not enough, add random colleges
    if (recommendations.length < parseInt(limit)) {
      const allCollegesSnapshot = await db.collection('colleges').get();
      const allColleges = allCollegesSnapshot.docs
        .map(doc => ({ id: doc.id, ...doc.data() }))
        .filter(c => c.id !== collegeId && !recommendations.find(r => r.id === c.id));

      const randomRecommendations = allColleges
        .sort(() => 0.5 - Math.random())
        .slice(0, parseInt(limit) - recommendations.length);

      recommendations = [...recommendations, ...randomRecommendations];
    }

    res.json({ data: recommendations });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /comparison/trending
router.get('/trending', async (req, res) => {
  try {
    const { limit = 10 } = req.query;
    
    // Get top ranked colleges
    const topRankedSnapshot = await db.collection('colleges')
      .orderBy('rank')
      .limit(parseInt(limit))
      .get();

    const topRanked = topRankedSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    // Get highest rated colleges
    const topRatedSnapshot = await db.collection('colleges')
      .orderBy('rating', 'desc')
      .limit(parseInt(limit))
      .get();

    const topRated = topRatedSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    // Get most expensive colleges
    const mostExpensiveSnapshot = await db.collection('colleges')
      .orderBy('fees', 'desc')
      .limit(parseInt(limit))
      .get();

    const mostExpensive = mostExpensiveSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    res.json({
      data: {
        topRanked,
        topRated,
        mostExpensive
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router; 