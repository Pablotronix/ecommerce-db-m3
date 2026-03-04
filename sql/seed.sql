-- seed.sql (PostgreSQL sample data)

-- categories
INSERT INTO categories (name, description) VALUES
('Electrónica','Dispositivos y accesorios'),
('Ropa','Prendas y accesorios'),
('Hogar','Artículos para el hogar');

-- customers
INSERT INTO customers (first_name, last_name, email, phone) VALUES
('Pablo','González','pablo@example.com','+56911111111'),
('María','López','maria@example.com','+56922222222'),
('Ana','Ruiz','ana@example.com',NULL);

-- products
INSERT INTO products (sku, name, description, price, stock, category_id) VALUES
('SKU-1001','Auriculares Bluetooth','Auriculares inalámbricos',49.99,100,1),
('SKU-1002','Camiseta Algodón','Camiseta unisex',19.90,50,2),
('SKU-1003','Taza Cerámica','Taza 350ml',7.50,200,3),
('SKU-1004','Cargador USB-C','Cargador 20W',15.00,0,1);

-- inventory movements (initial stock)
INSERT INTO inventory_movements (product_id, change, reason)
SELECT id, stock, 'initial' FROM products;

-- orders + items
-- Order 1
INSERT INTO orders (customer_id, status, total)
VALUES ((SELECT id FROM customers WHERE email='pablo@example.com'), 'paid', 0)
RETURNING id INTO TEMP TABLE tmp_order1;

INSERT INTO order_items (order_id, product_id, unit_price, quantity, line_total)
VALUES
((SELECT id FROM tmp_order1), (SELECT id FROM products WHERE sku='SKU-1001'), 49.99, 1, 49.99),
((SELECT id FROM tmp_order1), (SELECT id FROM products WHERE sku='SKU-1003'), 7.50, 2, 15.00);

-- update order total
UPDATE orders SET total = (SELECT SUM(line_total) FROM order_items WHERE order_id = orders.id)
WHERE id = (SELECT id FROM tmp_order1);

-- payment for order 1
INSERT INTO payments (order_id, amount, method, status, paid_at)
VALUES ((SELECT id FROM tmp_order1), 64.99, 'card', 'completed', now());

-- adjust stock and record movements
UPDATE products SET stock = stock - 1 WHERE sku='SKU-1001';
INSERT INTO inventory_movements (product_id, change, reason)
VALUES ((SELECT id FROM products WHERE sku='SKU-1001'), -1, 'sale');

UPDATE products SET stock = stock - 2 WHERE sku='SKU-1003';
INSERT INTO inventory_movements (product_id, change, reason)
VALUES ((SELECT id FROM products WHERE sku='SKU-1003'), -2, 'sale');

-- Order 2 (María, pending)
INSERT INTO orders (customer_id, status, total)
VALUES ((SELECT id FROM customers WHERE email='maria@example.com'), 'pending', 19.90)
RETURNING id INTO TEMP TABLE tmp_order2;

INSERT INTO order_items (order_id, product_id, unit_price, quantity, line_total)
VALUES
((SELECT id FROM tmp_order2), (SELECT id FROM products WHERE sku='SKU-1002'), 19.90, 1, 19.90);