CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id INT PRIMARY KEY,
    customer_first_name TEXT,
    customer_last_name TEXT,
    customer_age INT,
    customer_email TEXT,
    customer_country TEXT,
    customer_postal_code TEXT
);

CREATE TABLE IF NOT EXISTS dim_pet (
    pet_id SERIAL PRIMARY KEY,
    pet_type TEXT,
    pet_name TEXT,
    pet_breed TEXT,
    pet_category TEXT,
    UNIQUE (pet_type, pet_name, pet_breed, pet_category)
);

CREATE TABLE IF NOT EXISTS dim_customer_pet (
    customer_id INT REFERENCES dim_customer(customer_id),
    pet_id INT REFERENCES dim_pet(pet_id),
    PRIMARY KEY (customer_id, pet_id)
);

CREATE TABLE IF NOT EXISTS dim_seller (
    seller_id INT PRIMARY KEY,
    seller_first_name TEXT,
    seller_last_name TEXT,
    seller_email TEXT,
    seller_country TEXT,
    seller_postal_code TEXT
);

CREATE TABLE IF NOT EXISTS dim_supplier (
    supplier_key SERIAL PRIMARY KEY,
    supplier_name TEXT,
    supplier_contact TEXT,
    supplier_email TEXT,
    supplier_phone TEXT,
    supplier_address TEXT,
    supplier_city TEXT,
    supplier_country TEXT,
    UNIQUE (supplier_name, supplier_email)
);

CREATE TABLE IF NOT EXISTS dim_store (
    store_key SERIAL PRIMARY KEY,
    store_name TEXT,
    store_location TEXT,
    store_city TEXT,
    store_state TEXT,
    store_country TEXT,
    store_phone TEXT,
    store_email TEXT,
    UNIQUE (store_name, store_city, store_country)
);

CREATE TABLE IF NOT EXISTS dim_product_category (
    category_id SERIAL PRIMARY KEY,
    category_name TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_brand (
    brand_id SERIAL PRIMARY KEY,
    brand_name TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_id INT PRIMARY KEY,
    product_name TEXT,
    category_id INT REFERENCES dim_product_category(category_id),
    brand_id INT REFERENCES dim_brand(brand_id),
    product_price NUMERIC(10,2),
    product_quantity INT,
    product_weight NUMERIC(10,2),
    product_color TEXT,
    product_size TEXT,
    product_material TEXT,
    product_description TEXT,
    product_rating NUMERIC(3,1),
    product_reviews INT,
    product_release_date TEXT,
    product_expiry_date TEXT
);

CREATE TABLE IF NOT EXISTS dim_date (
    date_key DATE PRIMARY KEY,
    year INT,
    quarter INT,
    month INT,
    day INT,
    weekday INT
);

CREATE TABLE IF NOT EXISTS fact_sales (
    fact_id SERIAL PRIMARY KEY,
    sale_id INT,
    sale_date DATE,
    date_key DATE REFERENCES dim_date(date_key),
    customer_id INT REFERENCES dim_customer(customer_id),
    seller_id INT REFERENCES dim_seller(seller_id),
    product_id INT REFERENCES dim_product(product_id),
    store_key INT REFERENCES dim_store(store_key),
    supplier_key INT REFERENCES dim_supplier(supplier_key),
    sale_quantity INT,
    sale_total_price NUMERIC(10,2),
    UNIQUE (sale_id, date_key, customer_id, seller_id, product_id, store_key, supplier_key)
);