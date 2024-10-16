const express = require('express');
const mysql = require('mysql');

const app = express();
const port = 3000;

// Create a connection to the database
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'testdb'
});

// Connect to the database
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the database');
});

// Route with a vulnerable SQL query (SQL Injection)
app.get('/user/:id', (req, res) => {
  const userId = req.params.id;

  // Vulnerable SQL query: no input sanitization
  const query = `SELECT * FROM users WHERE id = ${userId}`;
  
  connection.query(query, (err, result) => {
    if (err) {
      res.status(500).send('Database query error');
      return;
    }
    res.json(result);
  });
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
