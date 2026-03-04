-- queries.sql

-- 1) Búsqueda de productos por nombre (case-insensitive)
SELECT id, sku, name, price, stock FROM products
WHERE LOWER(name) LIKE LOWER('%auriculares%');

-- 2) Búsqueda por categoría (por nombre de categoría)
SELECT p.id, p.sku, p.name, p.price, p.stock, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Electrónica';

-- 3) Top N productos por cantidad vendida (cantidad)
SELECT p.id, p.sku, p.name, SUM(oi.quantity) AS total_qty_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.id, p.sku, p.name
ORDER BY total_qty_sold DESC
LIMIT 10;

-- 4) Ventas por mes y por categoría (monto total y número de órdenes)
SELECT date_trunc('month', o.created_at) AS month,
       c.name AS category,
       SUM(oi.line_total) AS total_sales,
       COUNT(DISTINCT o.id) AS orders_count
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON oi.product_id = p.id
LEFT JOIN categories c ON p.category_id = c.id
WHERE o.created_at >= (now() - INTERVAL '12 months')
GROUP BY month, c.name
ORDER BY month DESC, total_sales DESC;

-- 5) Ticket promedio en rango de fechas
SELECT AVG(total) AS avg_ticket, COUNT(*) AS orders_count
FROM orders
WHERE created_at BETWEEN '2026-01-01' AND '2026-02-28' AND status = 'paid';

-- 6) Stock bajo (umbral configurable)
-- Reemplazar 5 por el umbral deseado
SELECT id, sku, name, stock FROM products WHERE stock <= 5 ORDER BY stock ASC;

-- 7) Productos sin ventas
SELECT p.id, p.sku, p.name
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.id IS NULL;

-- 8) Clientes frecuentes (>= X órdenes)
-- Reemplazar 2 por X
SELECT c.id, c.first_name, c.last_name, c.email, COUNT(o.id) AS orders_count
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.id
HAVING COUNT(o.id) >= 2
ORDER BY orders_count DESC;