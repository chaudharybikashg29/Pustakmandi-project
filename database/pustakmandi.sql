-- =====================================================
-- PustakMandi Database Schema
-- Online Book Marketplace (Admin / Seller / Customer)
-- =====================================================

CREATE DATABASE IF NOT EXISTS pustakmandi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pustakmandi;

-- -----------------------------------------------------
-- Table: users
-- Stores admin, seller and customer accounts
-- -----------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'seller', 'customer') NOT NULL DEFAULT 'customer',
    college VARCHAR(100) DEFAULT NULL,
     bio TEXT DEFAULT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    address VARCHAR(255) DEFAULT NULL,
    profile_pic VARCHAR(255) DEFAULT 'default.png',
    status ENUM('active', 'blocked') DEFAULT 'active',
   last_login DATETIME DEFAULT NULL,
     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
) ;

-- -----------------------------------------------------
-- Table: categories
-- -----------------------------------------------------
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL UNIQUE,
    description VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table: products (books)
-- -----------------------------------------------------
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT NOT NULL,
    category_id INT DEFAULT NULL,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(150) DEFAULT NULL,
    isbn VARCHAR(50) DEFAULT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    stock INT NOT NULL DEFAULT 0,
    book_condition ENUM('new', 'like_new', 'used', 'old') NOT NULL DEFAULT 'new',
    image VARCHAR(255) DEFAULT 'default-book.png',
    status ENUM('active', 'inactive', 'pending') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table: cart
-- -----------------------------------------------------
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_cart_item (customer_id, product_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table: wishlist
-- -----------------------------------------------------
CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_wishlist_item (customer_id, product_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table: orders
-- -----------------------------------------------------
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    payment_method ENUM('cod', 'esewa', 'khalti', 'card') NOT NULL DEFAULT 'cod',
    shipping_address VARCHAR(255) NOT NULL,
    shipping_phone VARCHAR(20) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table: order_items
-- -----------------------------------------------------
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    seller_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    item_status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table: contact_messages (for contact.php form)
-- -----------------------------------------------------
CREATE TABLE contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    subject VARCHAR(200) DEFAULT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Seed data
-- -----------------------------------------------------

-- Default admin account (email: admin@pustakmandi.com / password: Admin@123)
INSERT INTO users (name, email, password, role, status) VALUES
('Site Admin', 'admin@pustakmandi.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active');
-- NOTE: the hash above is a placeholder. Run reset-admin-password.php (see below) or
-- use PHP's password_hash('Admin@123', PASSWORD_DEFAULT) to generate a real one, then
-- UPDATE users SET password = '<hash>' WHERE email = 'admin@pustakmandi.com';

INSERT INTO categories (name, slug, description) VALUES
('Fiction', 'fiction', 'Novels and fictional stories'),
('Non-Fiction', 'non-fiction', 'Real world topics and facts'),
('Academic', 'academic', 'Textbooks and academic references'),
('Children', 'children', 'Books for kids'),
('Self Help', 'self-help', 'Personal growth and motivation'),
('Comics', 'comics', 'Comics and graphic novels');
