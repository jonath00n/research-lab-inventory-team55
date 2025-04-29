const express = require('express');
const path = require('path');
const bcrypt = require('bcrypt');
const mysql = require('mysql');
const session = require('express-session');
const cookieParser = require('cookie-parser');
const { exec } = require('child_process');
const { sendReturnsNotification } = require('./emailUtils');
const cron = require('node-cron');
const app = express();
const PORT = 3000;
require('dotenv').config();

// Middleware to parse JSON and cookies
app.use(express.json());
app.use(cookieParser());

// Initialize session middleware
app.use(session({
    secret: 'my-secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: {
        secure: false,
        maxAge: 1000 * 60 * 30  // 30 minutes
    }
}));

app.use((req, res, next) => {
    if (req.session.user) {
        req.session.lastActivity = Date.now();
    }
    next();
});

// Initialize MySQL connection
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect((err) => {
    if (err) {
        console.error("Error connecting to database: ", err.message);
    } else {
        console.log("Connected to MySQL database.");
    }
});

// Middleware to parse JSON bodies
app.use(express.json());

// Serve static files from the frontend directory
app.use(express.static(path.join(__dirname, '../../frontend')));

// Handle requests to the root
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../../frontend/index.html'));
});

// Check if the email is already registered
app.post('/check-email', (req, res) => {
    const { email } = req.body;
    const sql = `SELECT email FROM users WHERE email = ?`;
    db.query(sql, [email], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ exists: results.length > 0 });
    });
});

// Add a new user
app.post('/add-user', (req, res) => {
    const { name, email, password } = req.body;
    bcrypt.hash(password, 10, (err, hash) => {
        if (err) return res.status(500).json({ error: err.message });
        const sql = `INSERT INTO users (name, email, password) VALUES (?, ?, ?)`;
        db.query(sql, [name, email, hash], (err, result) => {
            if (err) return res.status(400).json({ error: err.message });
            res.json({ message: "User added", userId: result.insertId });
        });
    });
});

// Handle sign-in
app.post('/sign-in', (req, res) => {
    const { email, password } = req.body;
    const sql = `SELECT * FROM users WHERE email = ?`;
    db.query(sql, [email], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(401).json({ valid: false, error: "User not found" });

        const user = results[0];
        bcrypt.compare(password, user.password, (err, result) => {
            if (err) return res.status(500).json({ error: err.message });
            if (result) {
                const updateLoginTimeSQL = `UPDATE users SET last_login = NOW() WHERE email = ?`;
                db.query(updateLoginTimeSQL, [email], (err) => {
                    if (err) return res.status(500).json({ error: 'Error updating login time' });
                    req.session.user = { name: user.name, email: user.email };
                    res.json({ valid: true, message: "Sign-in successful" });
                });
            } else {
                res.status(401).json({ valid: false, error: "Invalid password" });
            }
        });
    });
});

// Get current user session data
app.get('/current-user', (req, res) => {
    if (req.session.user) {
        const sql = `SELECT * FROM users WHERE email = ?`;
        db.query(sql, [req.session.user.email], (err, results) => {
            if (err) return res.status(500).json({ error: 'Error retrieving user data' });
            if (results.length === 0) return res.status(404).json({ message: 'User not found' });
            res.json({ user: results[0] });
        });
    } else {
        res.status(401).json({ message: "No user is logged in" });
    }
});

// Sign-out
app.post('/sign-out', (req, res) => {
    if (req.session.user) {
        const sql = `UPDATE users SET last_logout = NOW() WHERE email = ?`;
        db.query(sql, [req.session.user.email], (err) => {
            if (err) return res.status(500).json({ error: 'Error updating logout time' });
            req.session.destroy(err => {
                if (err) return res.status(500).json({ error: 'Could not log out, please try again.' });
                res.clearCookie('connect.sid');
                res.json({ message: "Sign-out successful" });
            });
        });
    } else {
        res.status(401).json({ message: "No user is logged in" });
    }
});

// Delete the user by email in the database
app.delete('/delete-user', (req, res) => {
    const email = req.body.email;

    const sql = `DELETE FROM users WHERE email = ?`;
    db.query(sql, [email], function (err) {
        if (err) {
            console.error('Error deleting user:', err.message);
            return res.status(500).send({ message: 'Error deleting user.' });
        }

        // Return success even if no rows were affected (user already gone)
        res.status(200).send({ message: 'User deleted successfully.' });
    });
});


// Update user's name and email
app.put('/update-user', (req, res) => {
    const { name, email } = req.body;
    const currentEmail = req.session.user.email;

    const sql = `UPDATE users SET name = ?, email = ? WHERE email = ?`;

    db.query(sql, [name, email, currentEmail], function (err) {
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

    db.query(sql, [color, currentEmail], function (err) {
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

    db.query(sql, [permission, email], function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        res.json({ message: "User permission updated successfully" });
    });
});

// Fetch all items
app.get('/items', (req, res) => {
    const query = `
        SELECT id, name, description, categoryID, quantity, unit, location, supplier, returnable
        FROM items
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching items:", err);
            return res.status(500).json({ error: "Error fetching items" });
        }

        res.json({ items: results });
    });
});

// Fetch all users
app.get('/users', (req, res) => {
    const query = `
        SELECT 
            u.*, 
            GROUP_CONCAT(CONCAT(r.item_name, ' (', r.quantity, ')') SEPARATOR ', ') AS rented_items
        FROM users u
        LEFT JOIN returns r ON u.email = r.email
        GROUP BY u.email
        ORDER BY u.name ASC
    `;

    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ users: results });
    });
});


// Fetch all orders
app.get('/orders', (req, res) => {
    const query = `
        SELECT * FROM orders
        ORDER BY timestamp DESC
    `;
    
    db.query(query, (err, results) => {
        if (err) return res.status(500).send({ message: 'Error retrieving orders' });
        res.json({ orders: results });
    });
});



// Management level restrictions upon every route to management
app.get('/management.html', (req, res) => {
    if (req.session.user && (req.session.user.permission === 'professor' || req.session.user.permission === 'admin')) {
        res.sendFile(path.join(__dirname, '../../frontend/management.html'));
    } else {
        res.redirect('/index.html'); 
    }
});

// Fetch user's cart items
app.get('/cart', (req, res) => {
    if (!req.session.user || !req.session.user.email) {
        return res.status(401).json({ error: "User not logged in" });
    }

    const email = req.session.user.email;

    const query = `
        SELECT cart.item_id, items.name AS item_name, cart.quantity, items.returnable
        FROM cart
        INNER JOIN items ON cart.item_id = items.id
        WHERE cart.email = ?
    `;

    db.query(query, [email], (err, results) => {
        if (err) {
            console.error("Error fetching cart:", err);
            return res.status(500).json({ error: "Error fetching cart" });
        }

        res.json(results);
    });
});

// For adding items to the cart
app.post('/add-to-cart', (req, res) => {
    if (!req.session.user || !req.session.user.email) {
        return res.status(401).json({ error: "User not logged in" });
    }

    let { item_id, quantity } = req.body;
    const email = req.session.user.email;

    if (!item_id || item_id === "0" || item_id === "" || item_id === null) {
        console.error("Invalid item ID received:", item_id);
        return res.status(400).json({ error: "Invalid item ID" });
    }

    item_id = parseInt(item_id);
    quantity = parseInt(quantity);

    if (isNaN(quantity) || quantity <= 0) {
        console.error("Invalid quantity received:", quantity);
        return res.status(400).json({ error: "Invalid quantity" });
    }

    // Check if item already exists in the cart
    db.query("SELECT * FROM cart WHERE email = ? AND item_id = ?", [email, item_id], (err, results) => {
        if (err) {
            console.error("Database error checking cart:", err);
            return res.status(500).json({ error: "Error checking cart" });
        }

        if (results.length > 0) {
            db.query(
                "UPDATE cart SET quantity = quantity + ? WHERE email = ? AND item_id = ?", 
                [quantity, email, item_id], 
                (err) => {
                    if (err) {
                        console.error("Error updating cart:", err);
                        return res.status(500).json({ error: "Error updating cart" });
                    }
                    res.json({ success: true });
                }
            );
        } else {
            db.query(
                "INSERT INTO cart (email, item_id, quantity) VALUES (?, ?, ?)", 
                [email, item_id, quantity], 
                (err) => {
                    if (err) {
                        console.error("Error adding to cart:", err);
                        return res.status(500).json({ error: "Error adding to cart" });
                    }
                    res.json({ success: true });
                }
            );
        }
    });
});

// Removing from the cart of user
app.delete('/remove-from-cart', (req, res) => {
    const { item_id } = req.body;
    if (!req.session.user || !req.session.user.email) {
        return res.status(401).json({ error: "User not logged in" });
    }

    const email = req.session.user.email;

    console.log(`Removing item ${item_id} from cart for user: ${email}`);

    db.query(
        "DELETE FROM cart WHERE email = ? AND item_id = ?",
        [email, item_id],
        (err, result) => {
            if (err) {
                console.error("Error removing item from cart:", err.message);
                return res.status(500).json({ error: "Internal server error" });
            }
            if (result.affectedRows === 0) {
                return res.status(404).json({ error: "Item not found in cart" });
            }

            console.log("Item removed from cart successfully");
            res.json({ success: true });
        }
    );
});

// For updating cart quantity
app.put('/update-cart', (req, res) => {
    const { item_id, quantity } = req.body;
    if (!req.session.user || !req.session.user.email) {
        return res.status(401).json({ error: "User not logged in" });
    }

    const email = req.session.user.email;

    if (quantity < 1) {
        db.query("DELETE FROM cart WHERE email = ? AND item_id = ?", [email, item_id], (err, result) => {
            if (err) return res.status(500).json({ error: "Internal server error" });
            return res.json({ success: true, message: "Item removed from cart" });
        });
    } else {
        db.query("UPDATE cart SET quantity = ? WHERE email = ? AND item_id = ?", [quantity, email, item_id], (err, result) => {
            if (err) return res.status(500).json({ error: "Internal server error" });
            res.json({ success: true });
        });
    }
});

// Insert into orders table
app.post('/add-order', (req, res) => {
    const { user_name, user_email, item_id, item_name, returnable, quantity } = req.body;

    if (!item_id || !item_name || quantity <= 0) {
        return res.status(400).json({ error: "Invalid order data" });
    }

    const query = `
        INSERT INTO orders (item_id, item_name, returnable, quantity, user_name, user_email, timestamp)
        VALUES (?, ?, ?, ?, ?, ?, NOW())
    `;

    db.query(query, [item_id, item_name, returnable, quantity, user_name, user_email], (err) => {
        if (err) {
            console.error("Error adding order:", err);
            return res.status(500).json({ error: "Error adding order" });
        }
        res.json({ success: true, message: "Order placed successfully" });
    });
});

// Insert into return table
app.post('/add-return', (req, res) => {
    const { email, item_id, item_name, quantity } = req.body;

    if (!item_id || !item_name || quantity <= 0) {
        return res.status(400).json({ error: "Invalid return data" });
    }

    const query = `
        INSERT INTO returns (item_id, item_name, email, check_out_date, quantity)
        VALUES (?, ?, ?, NOW(), ?)
    `;

    db.query(query, [item_id, item_name, email, quantity], (err) => {
        if (err) {
            console.error("Error adding return:", err);
            return res.status(500).json({ error: "Error adding return" });
        }
        res.json({ success: true, message: "Return recorded successfully" });
    });
});

// Updating item quantity during checkout
app.put('/update-item-quantity/:item_id', (req, res) => {
    const { item_id } = req.params;
    const { quantity } = req.body;

    db.query(`
        UPDATE items SET quantity = quantity + ? WHERE id = ?`,
        [quantity, item_id],
        (err) => {
            if (err) return res.status(500).json({ error: "Error updating stock" });
            res.json({ success: true });
        }
    );
});

// Clearing cart during checkout
app.delete('/clear-cart', (req, res) => {
    if (!req.session.user || !req.session.user.email) {
        return res.status(401).json({ error: "User not logged in" });
    }

    db.query("DELETE FROM cart WHERE email = ?", [req.session.user.email], (err) => {
        if (err) return res.status(500).json({ error: "Error clearing cart" });
        res.json({ success: true });
    });
});

// Edit items from management
app.put('/update-item', (req, res) => {
    const { id, name, description, category, quantity, unit, location, supplier, returnable } = req.body;

    const query = `
        UPDATE items 
        SET name = ?, description = ?, categoryID = ?, quantity = ?, unit = ?, location = ?, supplier = ?, returnable = ? 
        WHERE id = ?
    `;
    const values = [name, description, category, quantity, unit, location, supplier, returnable, id];

    db.query(query, values, (err, result) => {
        if (err) {
            console.error("Error updating item:", err);
            return res.status(500).json({ error: "Error updating item" });
        }
        res.json({ success: true });
    });
});

// Deleting items
app.delete('/delete-item/:id', (req, res) => {
    const itemId = req.params.id;

    const sql = `DELETE FROM items WHERE id = ?`;
    db.query(sql, [itemId], function (err) {
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
    const { name, description, category, quantity, unit, location, supplier, returnable } = req.body;

    const sql = `
        INSERT INTO items (name, description, categoryID, quantity, unit, location, supplier, returnable) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;

    db.query(sql, [name, description, category, quantity, unit, location, supplier, returnable], function (err, result) {
        if (err) {
            console.error("Error adding item:", err);
            return res.status(500).json({ error: err.message });
        }
        res.status(201).json({ message: "Item added successfully", itemId: result.insertId });
    });
});

app.post('/send-returns-email', async (req, res) => {
    try {
        await sendReturnsNotification();
        res.status(200).json({ message: "Emails simulated. Check console for preview URLs." });
    } catch (err) {
        console.error("Email error:", err);
        res.status(500).json({ error: "Failed to send emails." });
    }
});

cron.schedule('0 8 * * 1', async () => {
    console.log('⏰ Weekly return reminder email dispatch running...');
    try {
        await sendReturnReminderEmails();
        console.log('✅ Weekly return reminder emails sent successfully.');
    } catch (error) {
        console.error('❌ Error sending weekly return reminder emails:', error);
    }
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
