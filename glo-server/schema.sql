-- Create database tables for glocart-stage
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_email VARCHAR(255) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample product data for testing
INSERT INTO products (name, description, price, stock_quantity) VALUES 
('Wireless Gaming Mouse', 'High-precision ergonomic wireless mouse', 49.99, 120),
('Mechanical Keyboard', 'RGB backlit mechanical keyboard with blue switches', 89.99, 75);