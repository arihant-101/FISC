const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const client = require('./pgdatabase');

const router = express.Router();

const secret = 'CE9786DAE64949DB15DD1E9ADF466';

async function signup(name, phoneNo, email, password, kycVerified = false) {
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    await client.query('BEGIN');

    const userResult = await client.query(
      'INSERT INTO public."user" ("Name", "PhoneNo", "Email", "KycVerified", "createdAt") VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [name, phoneNo, email, kycVerified, new Date()]
    );

    const user = userResult.rows[0];

    await client.query(
      'INSERT INTO public."user_credentials" ("PhoneNo", "Password") VALUES ($1, $2)',
      [phoneNo, hashedPassword]
    );

    await client.query('COMMIT');

    const token = jwt.sign({ userId: user.PhoneNo }, secret, { expiresIn: '1h' });

    return { token };
  } catch (error) {
    await client.query('ROLLBACK');

    if (error.code === '23505') {
      throw new Error('A user with the same phone number or email ID already exists');
    }

    throw error;
  }
}

async function login(phoneNo, password) {
  try {
    const credentialsResult = await client.query(
      'SELECT * FROM public."user_credentials" WHERE "PhoneNo" = $1',
      [phoneNo]
    );

    const credentials = credentialsResult.rows[0];

    if (!credentials) {
      throw new Error('Invalid phone number or password');
    }

    const isMatch = await bcrypt.compare(password, credentials.Password);

    if (!isMatch) {
      throw new Error('Invalid phone number or password');
    }

    const token = jwt.sign({ userId: credentials.PhoneNo }, secret, { expiresIn: '1h' });

    return { token };
  } catch (error) {
    throw error;
  }
}
  
router.post('/signup', async (req, res) => {
  const { name, phoneNo, email, password, kycVerified } = req.body;

  try {
    const result = await signup(name, phoneNo, email, password, kycVerified);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/login', async (req, res) => {
  const { phoneNo, password } = req.body;

  try {
    const result = await login(phoneNo, password);
    res.json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
