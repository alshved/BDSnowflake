TRUNCATE TABLE dim_customer_pet, dim_pet, dim_customer, dim_seller, dim_supplier, dim_store, dim_product, dim_product_category, dim_brand, dim_date, fact_sales CASCADE;

INSERT INTO dim_customer (customer_id, customer_first_name, customer_last_name, customer_age, customer_email, customer_country, customer_postal_code)
SELECT DISTINCT ON (sale_customer_id) sale_customer_id, customer_first_name, customer_last_name, customer_age, customer_email, customer_country, customer_postal_code
FROM mock_data
WHERE sale_customer_id IS NOT NULL
ORDER BY sale_customer_id, id;

INSERT INTO dim_pet (pet_type, pet_name, pet_breed, pet_category)
SELECT DISTINCT customer_pet_type, customer_pet_name, customer_pet_breed, pet_category
FROM mock_data
WHERE customer_pet_type IS NOT NULL;

INSERT INTO dim_customer_pet (customer_id, pet_id)
SELECT DISTINCT c.customer_id, p.pet_id
FROM mock_data m
JOIN dim_customer c ON c.customer_id = m.sale_customer_id
JOIN dim_pet p ON p.pet_type = m.customer_pet_type AND p.pet_name = m.customer_pet_name AND p.pet_breed = m.customer_pet_breed AND p.pet_category = m.pet_category
WHERE m.sale_customer_id IS NOT NULL AND m.customer_pet_type IS NOT NULL
ON CONFLICT (customer_id, pet_id) DO NOTHING;

INSERT INTO dim_seller (seller_id, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code)
SELECT DISTINCT ON (sale_seller_id) sale_seller_id, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code
FROM mock_data
WHERE sale_seller_id IS NOT NULL
ORDER BY sale_seller_id, id;

INSERT INTO dim_supplier (supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country)
SELECT DISTINCT supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country
FROM mock_data
WHERE supplier_name IS NOT NULL;

INSERT INTO dim_store (store_name, store_location, store_city, store_state, store_country, store_phone, store_email)
SELECT DISTINCT store_name, store_location, store_city, store_state, store_country, store_phone, store_email
FROM mock_data
WHERE store_name IS NOT NULL;

INSERT INTO dim_product_category (category_name)
SELECT DISTINCT product_category FROM mock_data WHERE product_category IS NOT NULL;

INSERT INTO dim_brand (brand_name)
SELECT DISTINCT product_brand FROM mock_data WHERE product_brand IS NOT NULL;

INSERT INTO dim_product (product_id, product_name, category_id, brand_id, product_price, product_quantity, product_weight, product_color, product_size, product_material, product_description, product_rating, product_reviews, product_release_date, product_expiry_date)
SELECT DISTINCT ON (sale_product_id)
    sale_product_id,
    product_name,
    c.category_id,
    b.brand_id,
    product_price,
    product_quantity,
    product_weight,
    product_color,
    product_size,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date
FROM mock_data m
LEFT JOIN dim_product_category c ON c.category_name = m.product_category
LEFT JOIN dim_brand b ON b.brand_name = m.product_brand
WHERE sale_product_id IS NOT NULL
ORDER BY sale_product_id, id;

INSERT INTO dim_date (date_key, year, quarter, month, day, weekday)
SELECT DISTINCT date_key,
       EXTRACT(YEAR FROM date_key)::INT,
       EXTRACT(QUARTER FROM date_key)::INT,
       EXTRACT(MONTH FROM date_key)::INT,
       EXTRACT(DAY FROM date_key)::INT,
       EXTRACT(DOW FROM date_key)::INT
FROM (
    SELECT DISTINCT to_date(sale_date, 'MM/DD/YYYY') AS date_key
    FROM mock_data
    WHERE sale_date IS NOT NULL
) t;

INSERT INTO fact_sales (sale_id, sale_date, date_key, customer_id, seller_id, product_id, store_key, supplier_key, sale_quantity, sale_total_price)
SELECT
    m.id AS sale_id,
    to_date(m.sale_date, 'MM/DD/YYYY') AS sale_date,
    to_date(m.sale_date, 'MM/DD/YYYY') AS date_key,
    m.sale_customer_id AS customer_id,
    m.sale_seller_id AS seller_id,
    m.sale_product_id AS product_id,
    s.store_key,
    sup.supplier_key,
    m.sale_quantity,
    m.sale_total_price
FROM mock_data m
LEFT JOIN dim_store s ON s.store_name = m.store_name AND s.store_city = m.store_city AND s.store_country = m.store_country
LEFT JOIN dim_supplier sup ON sup.supplier_name = m.supplier_name AND sup.supplier_email = m.supplier_email
ON CONFLICT (sale_id, date_key, customer_id, seller_id, product_id, store_key, supplier_key) DO NOTHING;
