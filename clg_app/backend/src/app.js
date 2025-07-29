const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();

app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

// Import routes
const collegesRouter = require('./routes/colleges');
const branchesRouter = require('./routes/branches');
const authRouter = require('./routes/auth');
const favoritesRouter = require('./routes/favorites');
const searchRouter = require('./routes/search');
const comparisonRouter = require('./routes/comparison');
const realtimeRouter = require('./routes/realtime');

// Use routes
app.use('/colleges', collegesRouter);
app.use('/branches', branchesRouter);
app.use('/auth', authRouter);
app.use('/favorites', favoritesRouter);
app.use('/search', searchRouter);
app.use('/comparison', comparisonRouter);
app.use('/realtime', realtimeRouter);

// Root route
app.get('/', (req, res) => {
  res.send('College Comparison API is running!');
});

module.exports = app; 