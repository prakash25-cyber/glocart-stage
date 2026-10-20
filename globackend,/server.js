const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Configure PostgreSQL connection using environment variables
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_NAME || 'glocart',
  port: process.env.DB_PORT || 5432,
});

// Health check endpoint for Kubernetes / GKE
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'Backend is healthy and running!' });
});

// API endpoint to get all e-commerce products
app.get('/api/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products');
    res.json(result.rows);
  } catch (err) {
    console.error('Database error:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Globackend server is running on port ${PORT}`);
});