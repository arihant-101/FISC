const express = require("express");
const client = require("./pgdatabase");

const router = express.Router();


async function refreshPortfolio() {
    try {
      await client.query("REFRESH MATERIALIZED VIEW public.portfolio");
    } catch (error) {
      throw error;
    }
  }

router.get("/portfolio/:phoneNo", async (req, res) => {
    const { phoneNo } = req.params;
  
    try {
      // Refresh the materialized view before querying data
      await refreshPortfolio();
  
      const result = await client.query(
        'SELECT * FROM public.portfolio WHERE "PhoneNo" = $1',
        [phoneNo]
      );
      res.json(result.rows);
    } catch (error) {
      res
        .status(500)
        .json({ error: "Error getting portfolio data", details: error.message });
    }
  });

module.exports = router;