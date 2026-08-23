-- E-COMMERCE & SUPPLY CHAIN DATABASE SCHEMA 

-- 1. Customer Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    country VARCHAR(50) DEFAULT 'Turkey',
    signup_date DATE NOT NULL
);

-- 2. Supplier Table
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    country VARCHAR(50),
    reliability_score NUMERIC(3, 2) -- Supplier score between 1.00 and 5.00
);

-- 3. Product Categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    target_margin_rate NUMERIC(4, 2) -- Target profit margin
);

-- 4. Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    supplier_id INT REFERENCES suppliers(supplier_id),
    unit_cost NUMERIC(10, 2) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    reorder_point INT DEFAULT 20 -- Reorder point
);

-- 5. Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(20) CHECK (order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount NUMERIC(10, 2)
);

-- 6. Order Items / Details
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL,
    discount NUMERIC(4, 2) DEFAULT 0.00
);

-- 7. Shipping & Logistics Table
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    carrier_name VARCHAR(50) NOT NULL, 
    tracking_number VARCHAR(100) UNIQUE,
    shipped_date TIMESTAMP,
    delivery_date TIMESTAMP,
    shipping_cost NUMERIC(10, 2),
    shipment_status VARCHAR(20) DEFAULT 'In Transit'
);

-- 8. Inventory & Stock Movement Logs
CREATE TABLE inventory_logs (
    log_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    change_type VARCHAR(20) CHECK (change_type IN ('Sale', 'Restock', 'Return', 'Adjustment')),
    quantity_changed INT NOT NULL,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
