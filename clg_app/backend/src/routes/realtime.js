const express = require('express');
const router = express.Router();
const RealTimeDataService = require('../services/realTimeDataService');

const realTimeService = new RealTimeDataService();

// GET /realtime/rankings/nirf - Get live NIRF rankings
router.get('/rankings/nirf', async (req, res) => {
  try {
    const rankings = await realTimeService.getLiveNIRFRankings();
    res.json({ data: rankings });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/rankings/qs - Get live QS World rankings
router.get('/rankings/qs', async (req, res) => {
  try {
    const rankings = await realTimeService.getLiveQSWorldRankings();
    res.json({ data: rankings });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/admissions/deadlines - Get live admission deadlines
router.get('/admissions/deadlines', async (req, res) => {
  try {
    const deadlines = await realTimeService.getLiveAdmissionDeadlines();
    res.json({ data: deadlines });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/placements/:collegeName - Get live placement stats for a college
router.get('/placements/:collegeName', async (req, res) => {
  try {
    const { collegeName } = req.params;
    const stats = await realTimeService.getLivePlacementStats(collegeName);
    res.json({ data: stats });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/fees/:collegeName - Get live fee updates for a college
router.get('/fees/:collegeName', async (req, res) => {
  try {
    const { collegeName } = req.params;
    const fees = await realTimeService.getLiveFeeUpdates(collegeName);
    res.json({ data: fees });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/cutoffs/:collegeName - Get live cutoff trends for a college
router.get('/cutoffs/:collegeName', async (req, res) => {
  try {
    const { collegeName } = req.params;
    const trends = await realTimeService.getLiveCutoffTrends(collegeName);
    res.json({ data: trends });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/trending - Get trending colleges
router.get('/trending', async (req, res) => {
  try {
    const trending = await realTimeService.getTrendingColleges();
    res.json({ data: trending });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/news - Get live news and updates
router.get('/news', async (req, res) => {
  try {
    const news = await realTimeService.getLiveNews();
    res.json({ data: news });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/college/:collegeName - Get all real-time data for a college
router.get('/college/:collegeName', async (req, res) => {
  try {
    const { collegeName } = req.params;
    
    // Fetch all real-time data for the college
    const [placements, fees, cutoffs] = await Promise.all([
      realTimeService.getLivePlacementStats(collegeName),
      realTimeService.getLiveFeeUpdates(collegeName),
      realTimeService.getLiveCutoffTrends(collegeName)
    ]);

    const collegeData = {
      college: collegeName,
      placements,
      fees,
      cutoffs,
      lastUpdated: new Date().toISOString()
    };

    res.json({ data: collegeData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/dashboard - Get all real-time data for dashboard
router.get('/dashboard', async (req, res) => {
  try {
    // Fetch all real-time data
    const [nirfRankings, qsRankings, deadlines, trending, news] = await Promise.all([
      realTimeService.getLiveNIRFRankings(),
      realTimeService.getLiveQSWorldRankings(),
      realTimeService.getLiveAdmissionDeadlines(),
      realTimeService.getTrendingColleges(),
      realTimeService.getLiveNews()
    ]);

    const dashboardData = {
      rankings: {
        nirf: nirfRankings,
        qs: qsRankings
      },
      admissions: deadlines,
      trending,
      news,
      lastUpdated: new Date().toISOString()
    };

    res.json({ data: dashboardData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /realtime/cache/clear - Clear cache (admin only)
router.post('/cache/clear', async (req, res) => {
  try {
    realTimeService.clearCache();
    res.json({ message: 'Cache cleared successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /realtime/cache/stats - Get cache statistics
router.get('/cache/stats', async (req, res) => {
  try {
    const stats = realTimeService.getCacheStats();
    res.json({ data: stats });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router; 