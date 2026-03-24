TRUNCATE TABLE mock_data;

\copy mock_data FROM 'data/MOCK_DATA.csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (1).csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (2).csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (3).csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (4).csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (5).csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (6).csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (7).csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (8).csv' CSV HEADER;
\copy mock_data FROM 'data/MOCK_DATA (9).csv' CSV HEADER;

\echo После загрузки строк:
SELECT count(*) FROM mock_data;