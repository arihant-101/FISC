// investmentRoutes.js

const express = require("express");
const client = require("./pgdatabase");

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

// Updated Calculate End Date based on InvestedAt date and MonthsLeft
function calculateEndDate(investedAt, monthsLeft) {
  const investedDate = new Date(investedAt);
  investedDate.setMonth(investedDate.getMonth() + monthsLeft);
  const endDate = investedDate.toISOString().split("T")[0];
  return endDate;
}

// Updated Calculate Next Due Date based on InvestedAt date and Frequency
function calculateNextDueDate(investedAt, frequency) {
  if (frequency === "one-time") {
    return null; // For one-time frequency, set nextDueDate to null
  }

  const investedDate = new Date(investedAt);

  if (frequency === "monthly") {
    // Add 1 month to the investedAt date for monthly frequency
    investedDate.setMonth(investedDate.getMonth() + 1);
  } else if (frequency === "weekly") {
    // Add 1 week to the investedAt date for weekly frequency
    investedDate.setDate(investedDate.getDate() + 7);
  }

  const nextDueDate = investedDate.toISOString().split("T")[0];
  return nextDueDate;
}

// Updated Function to add an investment without authentication
async function addInvestment(
  planId,
  phoneNo,
  amount,
  monthsLeft,
  DurationLeft,
  CurrentAmount,
  status,
  frequency
) {
  try {
    const investedAt = new Date().toISOString().split("T")[0]; // Simplified date format
    const endDate = calculateEndDate(investedAt, monthsLeft);
    const nextDueDate = calculateNextDueDate(investedAt, frequency);

    const result = await client.query(
      'INSERT INTO public."investments" ("PlanId", "PhoneNo", "Amount", "InvestedAt", "DurationLeft", "CurrentAmount", "EndDate", "NextDueDate", "MonthsLeft", "Status", "Frequency") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING *',
      [
        planId,
        phoneNo,
        amount,
        investedAt,
        DurationLeft,
        CurrentAmount,
        endDate,
        nextDueDate, // Set nextDueDate in the query
        monthsLeft,
        status,
        frequency,
      ]
    );

    return result.rows[0];
  } catch (error) {
    throw error;
  }
}

// Update investment details by InvestmentId
router.patch("/investments/:investmentId", async (req, res) => {
  const { investmentId } = req.params;
  const {
    amount,
    monthsLeft,
    DurationLeft,
    CurrentAmount,
    status,
    frequency,
  } = req.body;

  try {
    const investedAt = new Date().toISOString().split("T")[0];
    const endDate = calculateEndDate(investedAt, monthsLeft);
    const nextDueDate = calculateNextDueDate(investedAt, frequency);

    const result = await client.query(
      `UPDATE public."investments"
       SET
         "Amount" = $1,
         "DurationLeft" = $2,
         "CurrentAmount" = $3,
         "EndDate" = $4,
         "NextDueDate" = $5,
         "MonthsLeft" = $6,   
         "Status" = $7,
         "Frequency" = $8
       WHERE "InvestmentId" = $9
       RETURNING *`,
      [
        amount,
        DurationLeft,
        CurrentAmount,
        endDate,
        nextDueDate,
        monthsLeft,
        status,
        frequency,
        investmentId,
      ]
    );

    res.json(result.rows[0]);
  } catch (error) {
    res
      .status(500)
      .json({
        error: "Error updating investment details",
        details: error.message,
      });
  }
});

// Example API endpoint for creating an investment without authentication
router.post("/investments", async (req, res) => {
  const {
    planId,
    phoneNo,
    amount,
    monthsLeft,
    DurationLeft,
    CurrentAmount,
    status,
    frequency,
  } = req.body;

  try {
    const investment = await addInvestment(
      planId,
      phoneNo,
      amount,
      monthsLeft,
      DurationLeft,
      CurrentAmount,
      status,
      frequency
    );
    res.json(investment);
  } catch (error) {
    res
      .status(500)
      .json({ error: "Error creating investment", details: error.message });
  }
});

router.get("/investments/:phoneNo", async (req, res) => {
  const { phoneNo } = req.params;

  try {
    const investments = await getUserInvestments(phoneNo);
    res.json(investments);
  } catch (error) {
    res
      .status(500)
      .json({ error: "Error getting investments", details: error.message });
  }
});

module.exports = router;