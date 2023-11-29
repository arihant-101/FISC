const express = require('express');
const router = express.Router();
const db = require('./pgdatabase');
const client = require('./pgdatabase'); // Import your database connection



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
  
  async function addInvestment(planId, phoneNo, amount, durationLeft) {
    try {
      // Generate investedAt as today's date
      const investedAt = new Date();
  
      // Calculate endDate by adding durationLeft months to investedAt
      const endDate = new Date(investedAt);
      endDate.setMonth(endDate.getMonth() + durationLeft);
  
      const result = await client.query(
        'INSERT INTO public."investments" ("PlanId", "PhoneNo", "Amount", "DurationLeft", "CurrentAmount", "InvestedAt", "EndDate") VALUES ($1, $2, $3, $4, $3, $5, $6) RETURNING *',
        [planId, phoneNo, amount, durationLeft, investedAt, endDate]
      );
  
      // Refresh the portfolio materialized view
      await client.query('SELECT refresh_portfolio()');
  
      return result.rows[0];
    } catch (error) {
      throw error;
    }
  }
  
  router.get('/investments/:phoneNo', async (req, res) => {
    const { phoneNo } = req.params;
  
    try {
      const investments = await getUserInvestments(phoneNo);
      res.json(investments);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });
  
  router.post('/investments', async (req, res) => {
    const { planId, phoneNo, amount, durationLeft } = req.body;
  
    try {
      const investment = await addInvestment(planId, phoneNo, amount, durationLeft);
      res.json(investment);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });
  // ... (other routes and code)
  


module.exports = router;