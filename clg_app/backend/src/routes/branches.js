const express = require('express');
const router = express.Router();
const db = require('../utils/firebase');

// GET /branches
router.get('/', async (req, res) => {
  try {
    const snapshot = await db.collection('colleges').get();
    const branchesSet = new Set();
    snapshot.forEach(doc => {
      const data = doc.data();
      if (Array.isArray(data.courses)) {
        data.courses.forEach(course => branchesSet.add(course));
      }
    });
    res.json({ data: Array.from(branchesSet) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router; 