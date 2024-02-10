// server.js

const express = require('express');
const authRoutes = require('./auth');
const investmentRoutes = require('./investmentRoutes');
const transactionRoutes = require('./transactionRoutes');
const portfolioRoutes = require('./portfolioroutes'); // Import your transaction routes

const app = express();

// Middleware to parse JSON bodies
app.use(express.json());

// Use the authentication routes
app.use('/api', authRoutes);

// Use the investment routes
app.use('/api', investmentRoutes);

// Use the transaction routes
app.use('/api', transactionRoutes);

app.use('/api', portfolioRoutes)

// Start the server on port 3000
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log('Server is running on port ${port}');
});