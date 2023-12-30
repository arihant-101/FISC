// transactionRoutes.js

const express = require('express');
const router = express.Router();
const db = require('./pgdatabase'); // Import your database connection

// Create a new transaction
router.post('/transactions', async (req, res) => {
  try {
    const {
      InvestmentId,
      PhoneNo,
      Amount,
      Status,
      GeneratedAt,
      DueDate
    } = req.body;

    // Insert a new transaction record into the database
    const query = `
      INSERT INTO public."transactions" ("InvestmentId", "PhoneNo", "Amount", "Status", "GeneratedAt", "DueDate")
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *;
    `;

    const { rows } = await db.query(query, [
      InvestmentId,
      PhoneNo,
      Amount,
      Status,
      GeneratedAt,
      DueDate
    ]);

    res.json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while creating the transaction.' });
  }
});

// Retrieve transaction history for a user
router.get('/transactions/:PhoneNo', async (req, res) => {
  const { PhoneNo } = req.params;

  try {
    const result = await db.query(
      'SELECT * FROM public."transactions" WHERE "PhoneNo" = $1',
      [PhoneNo]
    );

    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching transaction history.' });
  }
});

router.post('/create-transaction', async (req, res) => {
  try {
    const {
      InvestmentId,
      PhoneNo,
      Amount,
      Status,
      GeneratedAt,
      DueDate
    } = req.body;

    // Include your payment processing logic here (e.g., validate payment)

    // Insert a new transaction record into the database
    const query = `
      INSERT INTO public."transactions" ("InvestmentId", "PhoneNo", "Amount", "Status", "GeneratedAt", "DueDate")
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *;
    `;

    const { rows } = await db.query(query, [
      InvestmentId,
      PhoneNo,
      Amount,
      Status,
      GeneratedAt,
      DueDate
    ]);

    res.json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while creating the transaction.' });
  }
});

// Update the status and PaidAt date of a transaction (e.g., when a transaction is completed)
router.patch('/transactions/:TransactionId', async (req, res) => {
  const { TransactionId } = req.params;

  try {
    const result = await db.query(
      'UPDATE public."transactions" SET "Status" = $1, "PaidAt" = current_date WHERE "TransactionId" = $2 RETURNING *',
      [true, TransactionId]
    );

    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while updating the transaction status.' });
  }
});

module.exports = router;