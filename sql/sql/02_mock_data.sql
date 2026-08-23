-- 02_MOCK_DATA.SQL 

-- 1. Categories
INSERT INTO categories (category_name, target_margin_rate) VALUES
('Electronics', 0.25),
('Fashion & Apparel', 0.40),
('Home & Living', 0.30),
('Cosmetics & Beauty', 0.45);

-- 2. Suppliers
INSERT INTO suppliers (supplier_name, contact_email, country, reliability_score) VALUES
('Apex Tech Logistics', 'contact@apextech.com', 'United States', 4.80),
('Nordic Textile Co.', 'info@nordictextile.se', 'Sweden', 4.20),
('Bavaria Home Supplies', 'sales@bavariahome.de', 'Germany', 4.90),
('Global Cosmetics Ltd.', 'orders@globalbeauty.co.uk', 'United Kingdom', 3.90);

-- 3. Products
INSERT INTO products (product_name, category_id, supplier_id, unit_cost, unit_price, stock_quantity, reorder_point) VALUES
('Wireless ANC Headphones', 1, 1, 45.00, 89.99, 15, 20),
('Smart Watch Pro', 1, 1, 80.00, 159.99, 8, 15),
('Oversized Cotton Hoodie', 2, 2, 18.00, 49.99, 65, 30),
('Slim-Fit Denim Jeans', 2, 2, 22.00, 54.99, 40, 25),
('Ergonomic Standing Desk', 3, 3, 120.00, 249.99, 5, 10),
('Orthopedic Office Chair', 3, 3, 95.00, 189.99, 12, 15),
('Vitamin C Facial Serum', 4, 4, 9.00, 29.99, 85, 40),
('Hydrating Face Cream', 4, 4, 7.50, 22.00, 18, 25);

-- 4. Customers
INSERT INTO customers (first_name, last_name, email, city, country, signup_date) VALUES
('Oliver', 'Smith', 'oliver.smith@email.com', 'London', 'United Kingdom', '2025-01-15'),
('Emma', 'Johnson', 'emma.johnson@email.com', 'New York', 'United States', '2025-02-10'),
('Lucas', 'Muller', 'lucas.muller@email.com', 'Berlin', 'Germany', '2025-03-05'),
('Sophia', 'Garcia', 'sophia.garcia@email.com', 'Madrid', 'Spain', '2025-04-20'),
('Liam', 'Brown', 'liam.brown@email.com', 'Toronto', 'Canada', '2025-05-12'),
('Mia', 'Davis', 'mia.davis@email.com', 'Sydney', 'Australia', '2025-06-01');

-- 5. Orders
INSERT INTO orders (customer_id, order_date, order_status, total_amount) VALUES
(1, '2026-06-10 14:30:00', 'Delivered', 139.98),
(2, '2026-06-12 11:15:00', 'Delivered', 249.99),
(1, '2026-07-01 16:45:00', 'Delivered', 89.99),
(3, '2026-07-15 09:20:00', 'Delivered', 104.98),
(4, '2026-08-01 18:10:00', 'Delivered', 51.99),
(5, '2026-08-10 13:00:00', 'Shipped', 189.99),
(6, '2026-08-20 15:40:00', 'Processing', 89.99);

-- 6. Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES
(1, 1, 1, 89.99, 0.00),
(1, 3, 1, 49.99, 0.00),
(2, 5, 1, 249.99, 0.00),
(3, 1, 1, 89.99, 0.00),
(4, 3, 1, 49.99, 0.00),
(4, 4, 1, 54.99, 0.00),
(5, 7, 1, 29.99, 0.00),
(5, 8, 1, 22.00, 0.00),
(6, 6, 1, 189.99, 0.00),
(7, 1, 1, 89.99, 0.00);

-- 7. Shipments & Logistics
INSERT INTO shipments (order_id, carrier_name, tracking_number, shipped_date, delivery_date, shipping_cost, shipment_status) VALUES
(1, 'DHL Express', 'DHL100293841', '2026-06-11 09:00:00', '2026-06-13 14:00:00', 12.00, 'Delivered'),
(2, 'FedEx Logistics', 'FDX882910394', '2026-06-13 10:00:00', '2026-06-16 17:30:00', 25.00, 'Delivered'),
(3, 'UPS Express', 'UPS993821045', '2026-07-02 08:30:00', '2026-07-03 16:00:00', 10.00, 'Delivered'),
(4, 'DHL Express', 'DHL449201934', '2026-07-16 11:00:00', '2026-07-18 12:15:00', 14.00, 'Delivered'),
(5, 'FedEx Logistics', 'FDX100994821', '2026-08-02 10:30:00', '2026-08-04 15:00:00', 11.50, 'Delivered'),
(6, 'UPS Ground', 'UPS339102948', '2026-08-11 09:15:00', NULL, 15.00, 'In Transit');

-- 8. Inventory Log History
INSERT INTO inventory_logs (product_id, change_type, quantity_changed, log_date) VALUES
(1, 'Sale', -1, '2026-06-10 14:30:00'),
(3, 'Sale', -1, '2026-06-10 14:30:00'),
(5, 'Sale', -1, '2026-06-12 11:15:00'),
(1, 'Restock', 20, '2026-06-20 10:00:00'),
(1, 'Sale', -1, '2026-07-01 16:45:00'),
(7, 'Restock', 50, '2026-07-10 09:00:00');
