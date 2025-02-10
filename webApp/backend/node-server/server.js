const express = require('express');
const path = require('path');
const bcrypt = require('bcrypt');
const session = require('express-session');
const cookieParser = require('cookie-parser');
const { exec } = require('child_process');
const mysql = require('mysql2/promise');
require('dotenv').config();

const app = express();
const PORT = 3000;

// Middleware to parse JSON and cookies
app.use(express.json());
app.use(cookieParser());

// Initialize session middleware
app.use(session({
    secret: 'my-secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

// Initialize MySQL connection pool
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Test database connection
async function testDB() {
    try {
        await pool.execute('SELECT 1');
        console.log("MySQL Connected");
    } catch (err) {
        console.error("MySQL Failed:", err.message);
    }
}
testDB();

// Middleware to parse JSON bodies
app.use(express.json());

// Serve static files from the frontend directory
app.use(express.static(path.join(__dirname, '../../frontend')));

// Handle requests to the root
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../../frontend/index.html'));
});

// Utility function for executing queries
async function queryDatabase(query, params) {
    try {
        const [rows] = await pool.execute(query, params);
        return rows;
    } catch (err) {
        throw new Error(err.message);
    }
}

// Check if the email is already registered
app.post('/check-email', async (req, res) => {
    try {
        const rows = await queryDatabase(`SELECT email FROM users WHERE email = ?`, [req.body.email]);
        res.json({ exists: rows.length > 0 });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Add a new user
app.post('/add-user', async (req, res) => {
    try {
        const hash = await bcrypt.hash(req.body.password, 10);
        const result = await queryDatabase(`INSERT INTO users (name, email, password) VALUES (?, ?, ?)`, [req.body.name, req.body.email, hash]);
        res.json({ message: "User added", userId: result.insertId });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
});

// Handle sign-in
app.post('/sign-in', async (req, res) => {
    try {
        const rows = await queryDatabase(`SELECT * FROM users WHERE email = ?`, [req.body.email]);
        if (rows.length === 0) return res.status(401).json({ valid: false, error: "User not found" });
        if (await bcrypt.compare(req.body.password, rows[0].password)) {
            await queryDatabase(`UPDATE users SET last_login = NOW() WHERE email = ?`, [req.body.email]);
            req.session.user = { name: rows[0].name, email: rows[0].email };
            res.json({ valid: true, message: "Sign-in successful" });
        } else {
            res.status(401).json({ valid: false, error: "Invalid password" });
        }
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Get the current session user
app.get('/current-user', async (req, res) => {
    if (!req.session.user) return res.status(401).json({ message: "No user is logged in" });
    try {
        const rows = await queryDatabase(`SELECT * FROM users WHERE email = ?`, [req.session.user.email]);
        if (rows.length === 0) return res.status(404).json({ message: 'User not found' });
        res.json({ user: rows[0] });
    } catch (err) {
        res.status(500).json({ error: 'Error retrieving user data' });
    }
});

// Sign-out route
app.post('/sign-out', async (req, res) => {
    if (!req.session.user) return res.status(401).json({ message: "No user is logged in" });
    try {
        await queryDatabase(`UPDATE users SET last_logout = NOW() WHERE email = ?`, [req.session.user.email]);
        req.session.destroy(err => {
            if (err) return res.status(500).json({ error: 'Could not log out, please try again.' });
            res.clearCookie('connect.sid');
            res.json({ message: "Sign-out successful" });
        });
    } catch (err) {
        res.status(500).json({ error: 'Error updating logout time' });
    }
});

// Delete a user by email
app.delete('/delete-user', async (req, res) => {
    try {
        await queryDatabase(`DELETE FROM users WHERE email = ?`, [req.body.email]);
        res.status(200).json({ message: 'User deleted successfully.' });
    } catch (err) {
        res.status(500).json({ error: 'Error deleting user.' });
    }
});

//////////////////////////////////////////////////////////////////////////////////////
//                                                                                  //  
//                              CONSTRUCTION ZONE                                   //
//                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////

// Update user's name and email
app.put('/update-user', (req, res) => {
    const { name, email } = req.body;
    const currentEmail = req.session.user.email;

    const sql = `UPDATE users SET name = ?, email = ? WHERE email = ?`;

    db.run(sql, [name, email, currentEmail], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        // Update session with new email and name
        req.session.user.name = name;
        req.session.user.email = email;

        res.json({ message: "User updated successfully" });
    });
});

// Update the user's color
app.put('/update-color', (req, res) => {
    const { color } = req.body;
    const currentEmail = req.session.user.email;

    const sql = `UPDATE users SET color = ? WHERE email = ?`;

    db.run(sql, [color, currentEmail], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        // Update the session with the new color
        req.session.user.color = color;

        res.json({ message: "User color updated successfully" });
    });
});

// Update user's permission
app.put('/update-permission', (req, res) => {
    const { email, permission } = req.body;

    const sql = `UPDATE users SET permission = ? WHERE email = ?`;

    db.run(sql, [permission, email], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        res.json({ message: "User permission updated successfully" });
    });
});

// Get items from items table
app.get('/items', async (req, res) => {
    const db = new sqlite3.Database(path.join(__dirname, 'database.db'));
    db.all('SELECT id, name, description, category, quantity, unit, location, supplier, returnable FROM items', [], (err, rows) => {
        if (err) {
            res.status(500).send({ message: 'Error retrieving items' });
        } else {
            res.json({ items: rows });
        }
    });
});

// Get all users from users table
app.get('/users', (req, res) => {
    const sql = `SELECT name, email, permission, last_logout, items_to_return FROM users`;
    db.all(sql, [], (err, rows) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        const users = rows.map(user => ({
            ...user,
            items_to_return: user.items_to_return ? JSON.parse(user.items_to_return) : []
        }));

        res.json({ users });
    });
});

// Get orders from orders table
app.get('/orders', async (req, res) => {
    const db = new sqlite3.Database(path.join(__dirname, 'database.db'));
    db.all('SELECT id, user_name, user_email, item_id, item_name, returnable, quantity, timestamp FROM orders', [], (err, rows) => {
        if (err) {
            res.status(500).send({ message: 'Error retrieving orders' });
        } else {
            res.json({ orders: rows });
        }
    });
});


// Management level restrictions upon every route to management
app.get('/management.html', (req, res) => {
    if (req.session.user && (req.session.user.permission === 'professor' || req.session.user.permission === 'admin')) {
        res.sendFile(path.join(__dirname, '../../frontend/management.html'));
    } else {
        res.redirect('/index.html'); // Redirect unauthorized users to index.html
    }
});

// Changing the cart of user
app.put('/update-cart', (req, res) => {
    const { cart } = req.body;
    const currentEmail = req.session.user.email;

    const sql = `UPDATE users SET cart = ? WHERE email = ?`;

    db.run(sql, [cart, currentEmail], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        res.json({ message: "User cart updated successfully" });
    });
});

// Insert into orders table
app.post('/add-order', (req, res) => {
    const { user_name, user_email, item_id, item_name, returnable, quantity } = req.body;

    const sql = `INSERT INTO orders (user_name, user_email, item_id, item_name, returnable, quantity) VALUES (?, ?, ?, ?, ?, ?)`;
    db.run(sql, [user_name, user_email, item_id, item_name, returnable, quantity], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: "Order added successfully" });
    });
});


// Edit items from management
app.put('/update-item', (req, res) => {
    const { id, name, description, category, quantity, supplier } = req.body;

    const sql = `UPDATE items SET name = ?, description = ?, category = ?, quantity = ?, supplier = ? WHERE id = ?`;
    db.run(sql, [name, description, category, quantity, supplier, id], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: "Item updated successfully" });
    });
});

// Deleting items
app.delete('/delete-item/:id', (req, res) => {
    const itemId = req.params.id;

    const sql = `DELETE FROM items WHERE id = ?`;
    db.run(sql, [itemId], function (err) {
        if (err) {
            console.error("Error deleting item:", err.message);
            return res.status(500).json({ error: err.message });
        }
        if (this.changes > 0) {
            res.json({ message: "Item deleted successfully" });
        } else {
            res.status(404).json({ message: "Item not found" });
        }
    });
});

// Adding items
app.post('/add-item', (req, res) => {
    const { name, description, category, quantity, supplier } = req.body;

    const sql = `INSERT INTO items (name, description, category, quantity, supplier) VALUES (?, ?, ?, ?, ?)`;
    db.run(sql, [name, description, category, quantity, supplier], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.status(201).json({ message: "Item added successfully", itemId: this.lastID });
    });
});

// Subtract quantity on checkout
app.put('/update-item-quantity/:id', (req, res) => {
    const { id } = req.params;
    const { quantity } = req.body;

    const sql = `UPDATE items SET quantity = ? WHERE id = ?`;
    db.run(sql, [quantity, id], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: "Item quantity updated successfully" });
    });
});

// Update items_to_return for a user
app.put('/update-items-to-return', (req, res) => {
    const { email, itemsToReturn } = req.body; 
    const sql = `UPDATE users SET items_to_return = ? WHERE email = ?`;

    db.run(sql, [itemsToReturn, email], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: "User items_to_return updated successfully" });
    });
});


// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
