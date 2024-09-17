const express = require('express');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcrypt');
const session = require('express-session');
const cookieParser = require('cookie-parser');
const app = express();
const PORT = 3000;

// Middleware to parse JSON and cookies
app.use(express.json());
app.use(cookieParser());

// Initialize session middleware
app.use(session({
    secret: 'your-secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

// Initialize SQLite database
const db = new sqlite3.Database(path.join(__dirname, 'database.db'), (err) => {
    if (err) {
        console.error("Error opening database: ", err.message);
    } else {
        console.log("Connected to the SQLite database.");
        
        // Create a table if it doesn't exist
        db.run(`CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
        )`, (err) => {
            if (err) {
                console.error("Error creating table: ", err.message);
            }
        });
    }
});

// Middleware to parse JSON bodies
app.use(express.json());

// Serve static files from the frontend directory
app.use(express.static(path.join(__dirname, '../../frontend')));

// Route to handle requests to the root
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../../frontend/index.html'));
});

// Route to check if the email is already registered
app.post('/check-email', (req, res) => {
    const { email } = req.body;
    const sql = `SELECT email FROM users WHERE email = ?`;
    
    db.get(sql, [email], (err, row) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (row) {
            res.json({ exists: true });
        } else {
            res.json({ exists: false });
        }
    });
});

// Route to add a new user
app.post('/add-user', (req, res) => {
    const { name, email, password } = req.body;

    // Hash the password before storing it
    bcrypt.hash(password, 10, (err, hash) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        // Insert the name, email, and hashed password into the database
        const sql = `INSERT INTO users (name, email, password) VALUES (?, ?, ?)`;
        
        db.run(sql, [name, email, hash], function(err) {
            if (err) {
                return res.status(400).json({ error: err.message });
            }
            res.json({ message: "User added", userId: this.lastID });
        });
    });
});

// Route to handle sign-in
app.post('/sign-in', (req, res) => {
    const { email, password } = req.body;

    const sql = `SELECT * FROM users WHERE email = ?`;
    db.get(sql, [email], (err, row) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (!row) {
            return res.status(401).json({ valid: false, error: "User not found" });
        }

        // Compare the provided password with the hashed password in the database
        bcrypt.compare(password, row.password, (err, result) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            if (result) {
                // Set the user session
                req.session.user = {
                    name: row.name,
                    email: row.email
                };
                res.json({ valid: true, message: "Sign-in successful" });
            } else {
                res.status(401).json({ valid: false, error: "Invalid password" });
            }
        });
    });
});

// Route to get the current session user
app.get('/current-user', (req, res) => {
    if (req.session.user) {
        res.json({ user: req.session.user });
    } else {
        res.status(401).json({ message: "No user is logged in" });
    }
});

// Route to handle sign-out
app.post('/sign-out', (req, res) => {
    req.session.destroy(err => {
        if (err) {
            return res.status(500).json({ error: 'Could not log out, please try again.' });
        }
        res.clearCookie('connect.sid');
        res.json({ message: "Sign-out successful" });
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
