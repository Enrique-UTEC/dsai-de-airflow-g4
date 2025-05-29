-- Create database schema for banking system
SET FOREIGN_KEY_CHECKS = 0;

-- Drop tables if they exist
DROP TABLE IF EXISTS transactions;
-- DROP TABLE IF EXISTS accounts;
-- DROP TABLE IF EXISTS customers;
-- DROP TABLE IF EXISTS branches;

-- Create customers table
-- CREATE TABLE customers (
--     customer_id VARCHAR(10) PRIMARY KEY,
--     full_name VARCHAR(100) NOT NULL,
--     birth_date DATE NOT NULL,
--     nationality VARCHAR(50) NOT NULL,
--     document_number VARCHAR(20) NOT NULL
-- );

-- -- Create branches table
-- CREATE TABLE branches (
--     branch_id VARCHAR(10) PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     city VARCHAR(50) NOT NULL,
--     country VARCHAR(50) NOT NULL
-- );

-- -- Create accounts table
-- CREATE TABLE accounts (
--     account_id VARCHAR(10) PRIMARY KEY,
--     customer_id VARCHAR(10) NOT NULL,
--     account_type VARCHAR(20) NOT NULL,
--     currency VARCHAR(5) NOT NULL,
--     open_date DATE NOT NULL,
--     status VARCHAR(10) NOT NULL,
--     FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
-- );

-- Create transactions table
CREATE TABLE transactions (
    transaction_id VARCHAR(10) PRIMARY KEY,
    account_id VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    branch_id VARCHAR(10) NOT NULL
    -- FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    -- FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- Insert data into customers table
-- INSERT INTO customers (customer_id, full_name, birth_date, nationality, document_number) VALUES
-- ('C001', 'Purificación Rivero Arjona', '1976-11-29', 'Chile', '78622131'),
-- ('C002', 'Graciela Mateos Tapia', '1983-08-29', 'Chile', '88300211'),
-- ('C003', 'José Antonio Chaparro', '1978-06-22', 'Peru', '28756361'),
-- ('C004', 'Martin Iglesia Collado', '1980-05-25', 'Chile', '23255791'),
-- ('C005', 'Vinicio Murillo Suarez', '1997-05-22', 'Colombia', '23515887'),
-- ('C006', 'Irma Molina Fuente', '1996-11-22', 'Chile', '74023168'),
-- ('C007', 'Teresita Vázquez Juliá', '1963-07-13', 'Chile', '83645173'),
-- ('C008', 'Arturo Pujadas Abella', '2000-12-06', 'Chile', '76246899'),
-- ('C009', 'Daniela Morell Barros', '1972-04-17', 'Chile', '86170002'),
-- ('C010', 'Dimas de Samper', '1965-07-02', 'Chile', '20797254'),
-- ('C011', 'Valentina Verdejo Tovar', '1966-09-18', 'Colombia', '50459503'),
-- ('C012', 'Emelina de Méndez', '1996-01-22', 'Peru', '37273290'),
-- ('C013', 'Maite Maristela Maestre Salgado', '1965-07-12', 'Colombia', '90032267'),
-- ('C014', 'Ester Herranz Manrique', '1971-10-22', 'Peru', '35419673'),
-- ('C015', 'Alcides Juan Tamayo', '1963-12-30', 'Chile', '22056021'),
-- ('C016', 'Urbano Conde Arias', '1964-10-02', 'Peru', '82558093'),
-- ('C017', 'Socorro Zamorano Llorens', '1994-10-20', 'Peru', '41608507'),
-- ('C018', 'Victorino Rius', '1998-09-28', 'Colombia', '46938170'),
-- ('C019', 'Leire Palau Blanca', '1981-05-13', 'Chile', '92246356'),
-- ('C020', 'Jose Francisco Naranjo Falcón', '1975-10-31', 'Colombia', '12175538');

-- Insert data into branches table
-- INSERT INTO branches (branch_id, name, city, country) VALUES
-- ('B01', 'Agencia Central Lima', 'Lima', 'Peru'),
-- ('B02', 'Oficina Providencia', 'Santiago', 'Chile'),
-- ('B03', 'Agencia San Isidro', 'Bogotá', 'Colombia'),
-- ('B04', 'Sucursal Miraflores', 'Arequipa', 'Peru'),
-- ('B05', 'Sucursal Arequipa', 'Cusco', 'Peru');

-- Insert data into accounts table
-- INSERT INTO accounts (account_id, customer_id, account_type, currency, open_date, status) VALUES
-- ('A1001', 'C020', 'savings', 'USD', '2019-11-27', 'active'),
-- ('A1002', 'C003', 'checking', 'USD', '2017-04-14', 'active'),
-- ('A1003', 'C012', 'checking', 'USD', '2019-01-16', 'active'),
-- ('A1004', 'C018', 'checking', 'USD', '2021-08-15', 'closed'),
-- ('A1005', 'C002', 'savings', 'PEN', '2018-03-12', 'closed'),
-- ('A1006', 'C001', 'checking', 'USD', '2020-12-13', 'active'),
-- ('A1007', 'C011', 'savings', 'PEN', '2022-07-17', 'active'),
-- ('A1008', 'C008', 'savings', 'CLP', '2016-05-08', 'closed'),
-- ('A1009', 'C003', 'savings', 'USD', '2017-01-02', 'closed'),
-- ('A1010', 'C004', 'checking', 'CLP', '2017-10-13', 'closed'),
-- ('A1011', 'C004', 'checking', 'CLP', '2019-01-06', 'active'),
-- ('A1012', 'C020', 'checking', 'USD', '2016-01-24', 'active'),
-- ('A1013', 'C020', 'checking', 'USD', '2016-07-20', 'active'),
-- ('A1014', 'C010', 'savings', 'PEN', '2015-09-30', 'active'),
-- ('A1015', 'C002', 'checking', 'USD', '2017-05-30', 'active'),
-- ('A1016', 'C003', 'savings', 'PEN', '2018-07-02', 'active'),
-- ('A1017', 'C003', 'checking', 'CLP', '2017-04-30', 'closed'),
-- ('A1018', 'C017', 'savings', 'PEN', '2021-12-12', 'closed'),
-- ('A1019', 'C019', 'checking', 'USD', '2016-11-06', 'closed'),
-- ('A1020', 'C012', 'savings', 'USD', '2021-08-03', 'active'),
-- ('A1021', 'C016', 'checking', 'PEN', '2017-04-08', 'active'),
-- ('A1022', 'C001', 'checking', 'PEN', '2015-11-30', 'active'),
-- ('A1023', 'C012', 'savings', 'USD', '2015-08-30', 'closed'),
-- ('A1024', 'C002', 'savings', 'PEN', '2018-08-09', 'active'),
-- ('A1025', 'C002', 'savings', 'PEN', '2018-06-10', 'active');

-- Insert data into transactions table
INSERT INTO transactions (transaction_id, account_id, date, amount, transaction_type, branch_id) VALUES
('T0001', 'A1021', '2025-04-17', 131.12, 'deposit', 'B04'),
('T0002', 'A1003', '2025-04-17', 1220.84, 'deposit', 'B01'),
('T0003', 'A1020', '2025-04-17', -870.18, 'withdrawal', 'B01'),
('T0004', 'A1016', '2025-04-17', 263.46, 'deposit', 'B01'),
('T0005', 'A1018', '2025-04-17', 1553.71, 'deposit', 'B03'),
('T0006', 'A1003', '2025-04-17', 324.98, 'transfer', 'B03'),
('T0007', 'A1014', '2025-04-17', 81.91, 'payment', 'B01'),
('T0008', 'A1020', '2025-04-17', -394.47, 'payment', 'B02'),
('T0009', 'A1009', '2025-04-17', 1151.33, 'payment', 'B05'),
('T0010', 'A1006', '2025-04-17', 3186.18, 'withdrawal', 'B01'),
('T0011', 'A1022', '2025-04-17', -50.75, 'withdrawal', 'B03'),
('T0012', 'A1017', '2025-04-17', 504.12, 'payment', 'B02'),
('T0013', 'A1001', '2025-04-17', 1829.75, 'payment', 'B05'),
('T0014', 'A1017', '2025-04-17', 4505.07, 'transfer', 'B04'),
('T0015', 'A1022', '2025-04-17', 505.60, 'deposit', 'B04'),
('T0016', 'A1024', '2025-04-17', -525.56, 'deposit', 'B05'),
('T0017', 'A1009', '2025-04-17', -190.97, 'payment', 'B03'),
('T0018', 'A1020', '2025-04-17', 727.27, 'transfer', 'B05'),
('T0019', 'A1021', '2025-04-17', 4122.65, 'withdrawal', 'B03'),
('T0020', 'A1013', '2025-04-17', 3490.92, 'deposit', 'B01'),
('T0021', 'A1020', '2025-04-17', 153.86, 'transfer', 'B02'),
('T0022', 'A1008', '2025-04-17', 338.59, 'payment', 'B04'),
('T0023', 'A1023', '2025-04-17', 4252.54, 'payment', 'B01'),
('T0024', 'A1013', '2025-04-17', 4230.13, 'payment', 'B01'),
('T0025', 'A1006', '2025-04-17', 1672.11, 'transfer', 'B02'),
('T0026', 'A1015', '2025-04-17', 2165.44, 'payment', 'B05'),
('T0027', 'A1020', '2025-04-17', 3532.91, 'deposit', 'B04'),
('T0028', 'A1011', '2025-04-17', 872.35, 'payment', 'B01'),
('T0029', 'A1014', '2025-04-17', 128.01, 'deposit', 'B02'),
('T0030', 'A1001', '2025-04-17', 1410.90, 'payment', 'B03'),
('T0031', 'A1001', '2025-04-17', 281.15, 'deposit', 'B05'),
('T0032', 'A1020', '2025-04-17', -413.29, 'deposit', 'B05'),
('T0033', 'A1021', '2025-04-17', 191.10, 'transfer', 'B03'),
('T0034', 'A1023', '2025-04-17', 4871.09, 'deposit', 'B04'),
('T0035', 'A1013', '2025-04-17', 2765.83, 'deposit', 'B03'),
('T0036', 'A1015', '2025-04-17', 3798.95, 'deposit', 'B03'),
('T0037', 'A1005', '2025-04-17', 2921.40, 'transfer', 'B01'),
('T0038', 'A1005', '2025-04-17', 670.46, 'deposit', 'B01'),
('T0039', 'A1002', '2025-04-17', 234.41, 'transfer', 'B05'),
('T0040', 'A1011', '2025-04-17', 4679.02, 'deposit', 'B05'),
('T0041', 'A1021', '2025-04-17', 1966.91, 'payment', 'B04'),
('T0042', 'A1012', '2025-04-17', 4228.46, 'withdrawal', 'B02'),
('T0043', 'A1013', '2025-04-17', 2522.75, 'deposit', 'B02'),
('T0044', 'A1005', '2025-04-17', 628.24, 'transfer', 'B03'),
('T0045', 'A1023', '2025-04-17', -437.75, 'deposit', 'B01'),
('T0046', 'A1009', '2025-04-17', -16.84, 'transfer', 'B03'),
('T0047', 'A1013', '2025-04-17', 4935.82, 'withdrawal', 'B03'),
('T0048', 'A1004', '2025-04-17', 1868.39, 'withdrawal', 'B01'),
('T0049', 'A1010', '2025-04-17', 77.52, 'deposit', 'B03'),
('T0050', 'A1013', '2025-04-17', 4013.36, 'transfer', 'B04');

SET FOREIGN_KEY_CHECKS = 1;