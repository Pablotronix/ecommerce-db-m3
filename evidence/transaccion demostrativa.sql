-- transaction_create_order.sql (ejemplo en PostgreSQL)
BEGIN;

-- 1) Crear la orden
INSERT INTO orders (customer_id, status, total)
VALUES ('<customer-uuid-here>', 'pending', 0)
RETURNING id INTO order_id;

-- 2) Insertar items (ejemplo con dos items)
INSERT INTO order_items (order_id, product_id, unit_price, quantity, line_total)
VALUES
(order_id, '<product-uuid-1>', 49.99, 1, 49.99),
(order_id, '<product-uuid-2>', 7.50, 2, 15.00);

-- 3) Recalcular total
UPDATE orders
SET total = (SELECT SUM(line_total) FROM order_items WHERE order_id = orders.id)
WHERE id = order_id;

-- 4) Registrar pagos (opcional) y actualizar stock + inventory_movements
-- Para cada item:
UPDATE products SET stock = stock - 1 WHERE id = '<product-uuid-1>';
INSERT INTO inventory_movements (product_id, change, reason) VALUES ('<product-uuid-1>', -1, 'sale');

UPDATE products SET stock = stock - 2 WHERE id = '<product-uuid-2>';
INSERT INTO inventory_movements (product_id, change, reason) VALUES ('<product-uuid-2>', -2, 'sale');

-- 5) Marcar orden como 'paid' si el pago fue exitoso
UPDATE orders SET status = 'paid' WHERE id = order_id;

COMMIT;
-- Si ocurre error en cualquier paso, ejecutar ROLLBACK;