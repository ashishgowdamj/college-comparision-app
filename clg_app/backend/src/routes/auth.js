const express = require('express');
const router = express.Router();
const db = require('../utils/firebase');

// POST /auth/register
router.post('/register', async (req, res) => {
  try {
    const { email, password, name, phone } = req.body;
    
    // Basic validation
    if (!email || !password || !name) {
      return res.status(400).json({ error: 'Email, password, and name are required' });
    }

    // Check if user already exists
    const existingUser = await db.collection('users')
      .where('email', '==', email)
      .get();

    if (!existingUser.empty) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Create user document
    const userRef = await db.collection('users').add({
      email,
      name,
      phone: phone || null,
      createdAt: new Date(),
      updatedAt: new Date(),
      preferences: {
        favoriteBranches: [],
        preferredCities: [],
        maxFees: null,
        minRank: null
      }
    });

    res.status(201).json({
      message: 'User registered successfully',
      userId: userRef.id
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    // Find user by email
    const userSnapshot = await db.collection('users')
      .where('email', '==', email)
      .get();

    if (userSnapshot.empty) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const userDoc = userSnapshot.docs[0];
    const userData = userDoc.data();

    // In a real app, you'd hash and compare passwords
    // For now, we'll just check if email exists
    res.json({
      message: 'Login successful',
      userId: userDoc.id,
      user: {
        id: userDoc.id,
        email: userData.email,
        name: userData.name,
        phone: userData.phone,
        preferences: userData.preferences
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /auth/profile/:userId
router.get('/profile/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    
    const userDoc = await db.collection('users').doc(userId).get();
    
    if (!userDoc.exists) {
      return res.status(404).json({ error: 'User not found' });
    }

    const userData = userDoc.data();
    res.json({
      id: userDoc.id,
      email: userData.email,
      name: userData.name,
      phone: userData.phone,
      preferences: userData.preferences,
      createdAt: userData.createdAt,
      updatedAt: userData.updatedAt
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// PUT /auth/profile/:userId
router.put('/profile/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { name, phone, preferences } = req.body;
    
    const updateData = {
      updatedAt: new Date()
    };
    
    if (name) updateData.name = name;
    if (phone !== undefined) updateData.phone = phone;
    if (preferences) updateData.preferences = preferences;

    await db.collection('users').doc(userId).update(updateData);
    
    res.json({ message: 'Profile updated successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router; 