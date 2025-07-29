const express = require('express');
const router = express.Router();
const db = require('../utils/firebase');

// GET /favorites/:userId
router.get('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    
    const favoritesSnapshot = await db.collection('users')
      .doc(userId)
      .collection('favorites')
      .get();

    const favoriteIds = favoritesSnapshot.docs.map(doc => doc.id);
    
    if (favoriteIds.length === 0) {
      return res.json({ data: [] });
    }

    // Get college details for favorite IDs
    const colleges = [];
    for (const collegeId of favoriteIds) {
      const collegeDoc = await db.collection('colleges').doc(collegeId).get();
      if (collegeDoc.exists) {
        colleges.push({ id: collegeDoc.id, ...collegeDoc.data() });
      }
    }

    res.json({ data: colleges });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /favorites/:userId/:collegeId
router.post('/:userId/:collegeId', async (req, res) => {
  try {
    const { userId, collegeId } = req.params;
    
    // Check if college exists
    const collegeDoc = await db.collection('colleges').doc(collegeId).get();
    if (!collegeDoc.exists) {
      return res.status(404).json({ error: 'College not found' });
    }

    // Check if already favorited
    const existingFavorite = await db.collection('users')
      .doc(userId)
      .collection('favorites')
      .doc(collegeId)
      .get();

    if (existingFavorite.exists) {
      return res.status(400).json({ error: 'College already in favorites' });
    }

    // Add to favorites
    await db.collection('users')
      .doc(userId)
      .collection('favorites')
      .doc(collegeId)
      .set({
        addedAt: new Date(),
        collegeName: collegeDoc.data().name
      });

    res.json({ message: 'College added to favorites' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// DELETE /favorites/:userId/:collegeId
router.delete('/:userId/:collegeId', async (req, res) => {
  try {
    const { userId, collegeId } = req.params;
    
    await db.collection('users')
      .doc(userId)
      .collection('favorites')
      .doc(collegeId)
      .delete();

    res.json({ message: 'College removed from favorites' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /favorites/:userId/check/:collegeId
router.get('/:userId/check/:collegeId', async (req, res) => {
  try {
    const { userId, collegeId } = req.params;
    
    const favoriteDoc = await db.collection('users')
      .doc(userId)
      .collection('favorites')
      .doc(collegeId)
      .get();

    res.json({ isFavorited: favoriteDoc.exists });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router; 