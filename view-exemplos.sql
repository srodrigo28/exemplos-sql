✅ Pré-requisitos (copie e execute antes)
🧱 1. Tabelas de exemplo
sql
Copiar
Editar
DROP TABLE IF EXISTS transacoes, contas, usuario, categorias;

CREATE TABLE usuario (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nome TEXT NOT NULL
);

CREATE TABLE contas (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nome TEXT NOT NULL,
  usuario_id BIGINT REFERENCES usuario(id)
);

CREATE TABLE categorias (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nome TEXT NOT NULL,
  tipo TEXT CHECK (tipo IN ('entrada', 'saida')) NOT NULL
);

CREATE TABLE transacoes (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  valor NUMERIC(10,2) NOT NULL,
  tipo TEXT CHECK (tipo IN ('entrada', 'saida')) NOT NULL,
  data DATE NOT NULL,
  conta_id BIGINT REFERENCES contas(id),
  categoria_id BIGINT REFERENCES categorias(id)
);
📥 2. Inserir dados de exemplo
sql
Copiar
Editar
INSERT INTO usuario (nome) VALUES ('Ana'), ('Carlos');

INSERT INTO contas (nome, usuario_id) VALUES 
('Carteira', 1), ('Conta Corrente', 1), 
('Cartão', 2);

INSERT INTO categorias (nome, tipo) VALUES 
('Salário', 'entrada'),
('Alimentação', 'saida'),
('Transporte', 'saida');

INSERT INTO transacoes (valor, tipo, data, conta_id, categoria_id) VALUES
(3000, 'entrada', '2025-06-01', 1, 1),
(-200, 'saida', '2025-06-03', 1, 2),
(-150, 'saida', '2025-06-05', 2, 3),
(4000, 'entrada', '2025-06-01', 3, 1),
(-500, 'saida', '2025-06-10', 3, 2);
🧪 3. Criar views testáveis
📊 View: Saldo por usuário
sql
Copiar
Editar
CREATE OR REPLACE VIEW saldo_usuario AS
SELECT 
  u.id AS usuario_id,
  u.nome,
  SUM(CASE WHEN t.tipo = 'entrada' THEN t.valor ELSE -t.valor END) AS saldo
FROM usuario u
JOIN contas c ON c.usuario_id = u.id
JOIN transacoes t ON t.conta_id = c.id
GROUP BY u.id, u.nome;
Teste:

sql
Copiar
Editar
SELECT * FROM saldo_usuario;
📅 View: Despesas por mês
sql
Copiar
Editar
CREATE OR REPLACE VIEW despesas_mensais AS
SELECT 
  u.nome AS usuario,
  DATE_TRUNC('month', t.data) AS mes,
  cat.nome AS categoria,
  SUM(t.valor) AS total_gasto
FROM usuario u
JOIN contas c ON c.usuario_id = u.id
JOIN transacoes t ON t.conta_id = c.id
JOIN categorias cat ON cat.id = t.categoria_id
WHERE t.tipo = 'saida'
GROUP BY u.nome, mes, cat.nome
ORDER BY mes;
Teste:

sql
Copiar
Editar
SELECT * FROM despesas_mensais;
🔍 View: Transações detalhadas
sql
Copiar
Editar
CREATE OR REPLACE VIEW transacoes_detalhadas AS
SELECT
  t.id,
  u.nome AS usuario,
  c.nome AS conta,
  cat.nome AS categoria,
  t.tipo,
  t.valor,
  t.data
FROM transacoes t
JOIN contas c ON c.id = t.conta_id
JOIN usuario u ON u.id = c.usuario_id
JOIN categorias cat ON cat.id = t.categoria_id;
Teste:

sql
Copiar
Editar
SELECT * FROM transacoes_detalhadas ORDER BY data;
💾 4. Ver código-fonte de views criadas
sql
Copiar
Editar
SELECT viewname, pg_get_viewdef(viewname, true) AS codigo
FROM pg_views
WHERE schemaname = 'public';
🧽 5. Excluir views (se necessário)
sql
Copiar
Editar
DROP VIEW IF EXISTS saldo_usuario;
DROP VIEW IF EXISTS despesas_mensais;
DROP VIEW IF EXISTS transacoes_detalhadas;
Se quiser posso:

Gerar um script .sql completo para importar no Supabase

Montar um dashboard baseado nessas views

Aplicar RLS para que o usuário logado veja apenas suas transações
