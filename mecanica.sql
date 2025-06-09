-- Fluxo mecanica
-- https://database.build/db/ugyjwutt8pu4iz65

-- Script tables
create table fabricantes (
  id bigint primary key generated always as identity,
  nome text not null
);

create table modelos (
  id bigint primary key generated always as identity,
  nome text not null,
  fabricante_id bigint references fabricantes (id)
);

create table clientes (
  id bigint primary key generated always as identity,
  nome text not null
);

create table produtos (
  id bigint primary key generated always as identity,
  created_at timestamptz default now(),
  placa text not null,
  cor text not null,
  ano int not null,
  foto_principal text,
  foto_diversas text,
  descricao text,
  modelo_id bigint references modelos (id),
  cliente_id bigint references clientes (id),
  status text
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

-- Renomear uma view
ALTER VIEW lista_entrada RENAME TO  view_lista_entrada;

-- View para ver todos os dados
CREATE VIEW lista_entrada AS
SELECT 
    p.id AS produto_id,
    p.created_at,
    p.placa,
    p.cor,
    p.ano,
    p.foto_principal,
    p.foto_diversas,
    p.descricao,
    p.status,
    m.id AS modelo_id,
    m.nome AS modelo_nome,
    f.id AS fabricante_id,
    f.nome AS fabricante_nome,
    c.id AS cliente_id,
    c.nome AS cliente_nome
FROM 
    produtos p
JOIN 
    modelos m ON p.modelo_id = m.id
JOIN 
    fabricantes f ON m.fabricante_id = f.id
JOIN 
    clientes c ON p.cliente_id = c.id;

-- TOTAL ENTRADAS
create view view_total_entradas as
select
  count(*) as total_entradas
from
  produtos;

-- total aprovados
create view view_total_aprovados as
select
  count(*) as total_aprovados
from
  produtos
where
  status = 'aprovado';

-- não aprovou
create view view_total_reprovou as
select
  count(*) as total_reprovou
from
  produtos
where
  status = 'reprovou';
