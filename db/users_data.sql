SELECT * FROM Inventory_Tracker.users;

/*
-- Insert a record into the User table
INSERT INTO users (FirstName, LastName, Email, Role, Username, PasswordHash) VALUES
    ('Alice', 'Smith', 'alice.smith@tamu.edu', 'Student', 'alicesmith', 'hashed_pw1'),
    ('Bob', 'Johnson', 'bob.johnson@tamu.edu', 'Admin', 'bobjohnson', 'hashed_pw2'),
    ('Carol', 'Williams', 'carol.williams@tamu.edu', 'Graduate TA', 'carolwilliams', 'hashed_pw3'),
    ('David', 'Brown', 'david.brown@tamu.edu', 'Professor', 'davidbrown', 'hashed_pw4'),
    ('Emma', 'Jones', 'emma.jones@tamu.edu', 'Student', 'emmajones', 'hashed_pw5'),
    ('Frank', 'Garcia', 'frank.garcia@tamu.edu', 'Admin', 'frankgarcia', 'hashed_pw6'),
    ('Grace', 'Martinez', 'grace.martinez@tamu.edu', 'Graduate TA', 'gracemartinez', 'hashed_pw7'),
    ('Hank', 'Robinson', 'hank.robinson@tamu.edu', 'Professor', 'hankrobinson', 'hashed_pw8'),
    ('Ivy', 'Clark', 'ivy.clark@tamu.edu', 'Student', 'ivyclark', 'hashed_pw9'),
    ('Jake', 'Lewis', 'jake.lewis@tamu.edu', 'Student', 'jakelewis', 'hashed_pw10'),
    ('Lily', 'Walker', 'lily.walker@tamu.edu', 'Graduate TA', 'lilywalker', 'hashed_pw11'),
    ('Max', 'Young', 'max.young@tamu.edu', 'Admin', 'maxyoung', 'hashed_pw12'),
    ('Nina', 'King', 'nina.king@tamu.edu', 'Student', 'ninaking', 'hashed_pw13'),
    ('Oscar', 'Wright', 'oscar.wright@tamu.edu', 'Professor', 'oscarwright', 'hashed_pw14'),
    ('Paul', 'Lopez', 'paul.lopez@tamu.edu', 'Admin', 'paullopez', 'hashed_pw15');
*/

/*deleting certain users by username if we run query command above*/
/*DELETE FROM users 
WHERE Username IN ('alicesmith', 'bobjohnson', 'carolwilliams'); */


/*delete users by role*/
/*DELETE FROM users 
WHERE Role = 'Student';


/*finding users with a specific role*/
SELECT name, email
FROM users
WHERE permission = 'admin'; /*can change the role*/

/*count the number of users*/
SELECT COUNT(*) AS TotalUsers FROM users;

/*find users w duplicate emails*/
SELECT email, COUNT(*) 
FROM users 
GROUP BY email 
HAVING COUNT(*) > 1;

/*adding a new user*/
INSERT INTO users (email, permission, password, name, color)
VALUES ('testuser@tamu.edu', 'student', 'hashed_pwX', 'Test User', '#abcdef'); /*can change the info 

/*selecting certain user by id*/
SELECT * FROM users WHERE id = 5;
/*DELETE FROM users WHERE id = 4;

/*change a users permission level */
UPDATE users SET permission = 'admin' WHERE email = 'jonbaker.moore@gmail.com';

/*delete a test user*/
DELETE FROM users WHERE email = 'test@test.com';


