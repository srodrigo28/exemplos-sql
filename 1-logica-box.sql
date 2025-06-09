create table fabricantes (
  id bigint primary key generated always as identity,
  nome text not null
);

create table modelos (
  id bigint primary key generated always as identity,
  nome text not null,
  fabricante_id bigint references fabricantes (id)
);

-- Inserir fabricantes

INSERT INTO fabricantes (nome) VALUES 
('Toyota'), 
('Ford'), 
('Volkswagen'), 
('Honda'), 
('Hyundai'), 
('Chevrolet'), 
('Nissan'), 
('BMW'), 
('Mercedes-Benz'), 
('Audi'), 
('Kia'), 
('Mazda'), 
('Subaru'), 
('Renault'), 
('Peugeot'), 
('Fiat'), 
('Jeep'), 
('Land Rover'), 
('Jaguar'), 
('Volvo');

-- Inserir modelos
INSERT INTO modelos (nome, fabricante_id) VALUES 
('Corolla', 1),  -- Toyota
('Camry', 1),    -- Toyota
('RAV4', 1),     -- Toyota
('Focus', 2),    -- Ford
('Fiesta', 2),   -- Ford
('Mustang', 2),  -- Ford
('Golf', 3),     -- Volkswagen
('Passat', 3),   -- Volkswagen
('Tiguan', 3),   -- Volkswagen
('Civic', 4),    -- Honda
('Accord', 4),   -- Honda
('CR-V', 4),     -- Honda
('Elantra', 5),  -- Hyundai
('Sonata', 5),   -- Hyundai
('Tucson', 5),   -- Hyundai
('Malibu', 6),   -- Chevrolet
('Impala', 6),   -- Chevrolet
('Silverado', 6),-- Chevrolet
('Altima', 7),   -- Nissan
('Sentra', 7),   -- Nissan
('Maxima', 7),   -- Nissan
('3 Series', 8), -- BMW
('5 Series', 8), -- BMW
('X5', 8),       -- BMW
('C-Class', 9),  -- Mercedes-Benz
('E-Class', 9),  -- Mercedes-Benz
('GLA', 9),      -- Mercedes-Benz
('A4', 10),      -- Audi
('A6', 10),      -- Audi
('Q5', 10),      -- Audi
('Sportage', 11),-- Kia
('Sorento', 11), -- Kia
('Optima', 11),  -- Kia
('Mazda3', 12),  -- Mazda
('Mazda6', 12),  -- Mazda
('CX-5', 12),    -- Mazda
('Impreza', 13), -- Subaru
('Outback', 13), -- Subaru
('Forester', 13),-- Subaru
('Clio', 14),    -- Renault
('Megane', 14),  -- Renault
('Captur', 14),  -- Renault
('208', 15),     -- Peugeot
('3008', 15),    -- Peugeot
('5008', 15),    -- Peugeot
('500', 16),     -- Fiat
('Panda', 16),   -- Fiat
('Tipo', 16),    -- Fiat
('Wrangler', 17),-- Jeep
('Cherokee', 17),-- Jeep
('Compass', 17), -- Jeep
('Discovery', 18),-- Land Rover
('Range Rover', 18),-- Land Rover
('Defender', 18),-- Land Rover
('XE', 19),      -- Jaguar
('XF', 19),      -- Jaguar
('F-Pace', 19),  -- Jaguar
('XC40', 20),    -- Volvo
('XC60', 20),    -- Volvo
('XC90', 20);    -- Volvo
