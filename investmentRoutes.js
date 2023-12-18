const express = require('express');
const client = require('./pgdatabase');

const router = express.Router();

// Function to get user investments without authentication
async function getUserInvestments(phoneNo) {
  try {
    const result = await client.query(
      'SELECT * FROM public."investments" WHERE "PhoneNo" = $1',
      [phoneNo]
    );

    return result.rows;
  } catch (error) {
    throw error;
  }
}

// Function to add an investment without authentication
async function addInvestment(planId, phoneNo, amount, monthsLeft, DurationLeft, CurrentAmount, endDate, nextDueDate, status, frequency) {
  try {
    const investedAt = new Date().toISOString().split('T')[0]; // Simplified date format

    const result = await client.query(
      'INSERT INTO public."investments" ("PlanId", "PhoneNo", "Amount", "InvestedAt", "DurationLeft", "CurrentAmount", "EndDate", "NextDueDate", "MonthsLeft", "Status", "Frequency") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING *',
      [planId, phoneNo, amount, investedAt, DurationLeft, amount, endDate, nextDueDate, monthsLeft, status, frequency]
      // Set CurrentAmount to amount
    );

    return result.rows[0];
  } catch (error) {
    throw error;
  }
}

// Example API endpoint for creating an investment without authentication
router.post('/investments', async (req, res) => {
  const { planId, phoneNo, amount, monthsLeft, DurationLeft, CurrentAmount, endDate, nextDueDate, status, frequency } = req.body;

  try {
    const investment = await addInvestment(planId, phoneNo, amount, monthsLeft, DurationLeft, amount, endDate, nextDueDate, status, frequency);
    res.json(investment);
  } catch (error) {
    res.status(500).json({ error: 'Error creating investment', details: error.message });
  }
});

// Add more endpoints as needed

module.exports = router;