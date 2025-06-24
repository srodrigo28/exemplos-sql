-- ✅ Ordem correta do código para funcionar
-- 1. Tabela usuario

CREATE TABLE usuario (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nome TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  senha TEXT NOT NULL
);

-- 2. Tabela categorias (estava faltando no seu código, mas é referenciada por outras tabelas – precisa ser criada)
CREATE TABLE categorias (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nome TEXT NOT NULL,
  tipo TEXT CHECK (tipo IN ('entrada', 'saida')) NOT NULL
);
-- 3. Tabela contas
CREATE TABLE contas (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nome TEXT NOT NULL,
  saldo_inicial NUMERIC(12, 2) NOT NULL DEFAULT 0,
  usuario_id BIGINT REFERENCES usuario(id)
);

-- 4. Tabela transacoes
CREATE TABLE transacoes (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  descricao TEXT,
  valor NUMERIC(12, 2) NOT NULL,
  tipo TEXT CHECK (tipo IN ('entrada', 'saida')) NOT NULL,
  data DATE NOT NULL,
  conta_id BIGINT REFERENCES contas(id),
  categoria_id BIGINT REFERENCES categorias(id)
);
-- 5. Tabela metas
CREATE TABLE metas (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id BIGINT REFERENCES usuario(id),
  categoria_id BIGINT REFERENCES categorias(id),
  valor_mensal NUMERIC(12, 2) NOT NULL,
  mes DATE NOT NULL
);
-- 6. View saldo_usuario
CREATE VIEW saldo_usuario AS
SELECT 
  u.id AS usuario_id,
  u.nome AS nome_usuario,
  SUM(CASE WHEN t.tipo = 'entrada' THEN t.valor ELSE -t.valor END) AS saldo
FROM usuario u
JOIN contas c ON c.usuario_id = u.id
JOIN transacoes t ON t.conta_id = c.id
GROUP BY u.id, u.nome;

-- 7. View resumo_despesas_categoria
CREATE VIEW resumo_despesas_categoria AS
SELECT 
  u.id AS usuario_id,
  u.nome AS nome_usuario,
  c.nome AS categoria,
  DATE_TRUNC('month', t.data) AS mes,
  SUM(t.valor) AS total_gasto
FROM usuario u
JOIN contas ct ON ct.usuario_id = u.id
JOIN transacoes t ON t.conta_id = ct.id
JOIN categorias c ON c.id = t.categoria_id
WHERE t.tipo = 'saida'
GROUP BY u.id, u.nome, c.nome, DATE_TRUNC('month', t.data);

/*
📌 Resumo final por tópicos
📁 1. Estrutura de Tabelas
usuario: Armazena dados pessoais.

categorias: Define os tipos de transações (ex: "Alimentação", "Salário").

contas: Representa contas bancárias do usuário.

transacoes: Entradas/saídas de dinheiro ligadas às contas.

metas: Planejamento financeiro mensal por categoria.

🔍 2. Views criadas
saldo_usuario: Calcula o saldo total de cada usuário considerando suas transações.

resumo_despesas_categoria: Resume gastos por categoria e por mês.

⚠️ 3. Correções feitas
A tabela categorias não estava no seu código, mas era referenciada por transacoes e metas, então foi adicionada.

A ordem foi ajustada para garantir que todas as referências existam no momento da criação das tabelas e views.

*/
