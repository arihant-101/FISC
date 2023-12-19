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
async function addInvestment(planId, phoneNo, amount, monthsLeft, DurationLeft, CurrentAmount, status, frequency) {
  try {
    const investedAt = new Date().toISOString().split('T')[0]; // Simplified date format
    const endDate = calculateEndDate(investedAt, monthsLeft);
    const nextDueDate = calculateNextDueDate(investedAt, frequency === 'monthly' ? 'monthly' : 'weekly');

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

// Calculate End Date based on InvestedAt date and MonthsLeft
function calculateEndDate(investedAt, monthsLeft) {
  const investedDate = new Date(investedAt);
  investedDate.setMonth(investedDate.getMonth() + monthsLeft);
  const endDate = investedDate.toISOString().split('T')[0];
  return endDate;
}

// Calculate Next Due Date based on InvestedAt date and Frequency
function calculateNextDueDate(investedAt, frequency) {
  const investedDate = new Date(investedAt);

  if (frequency === 'monthly') {
    // Add 1 month to the investedAt date for monthly frequency
    investedDate.setMonth(investedDate.getMonth() + 1);
  } else if (frequency === 'weekly') {
    // Add 1 week to the investedAt date for weekly frequency
    investedDate.setDate(investedDate.getDate() + 7);
  }

  const nextDueDate = investedDate.toISOString().split('T')[0];
  return nextDueDate;
}

// Example API endpoint for creating an investment without authentication
router.post('/investments', async (req, res) => {
  const { planId, phoneNo, amount, monthsLeft, DurationLeft, CurrentAmount, status, frequency } = req.body;

  try {
    const investment = await addInvestment(planId, phoneNo, amount, monthsLeft, DurationLeft, amount, status, frequency);
    res.json(investment);
  } catch (error) {
    res.status(500).json({ error: 'Error creating investment', details: error.message });
  }
});

module.exports = router;
