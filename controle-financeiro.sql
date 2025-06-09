-- Armazena informações básicas dos usuários.
-- Categorias:

-- Define as categorias para as movimentações financeiras.
-- Movimentações:

-- Registra todas as entradas e saídas, associando-as a usuários e categorias. Inclui informações sobre contas, valores, datas de vencimento e pagamento.
-- Esquema de Banco de Dados

CREATE TABLE usuarios (
  id bigint primary key generated always as identity,
  nome text not null,
  email text not null unique,
  senha text not null, -- Armazenar como hash
  created_at timestamptz default now()
);

CREATE TABLE categorias (
  id bigint primary key generated always as identity,
  nome text not null,
  descricao text
);

CREATE TABLE movimentacoes (
  id bigint primary key generated always as identity,
  id_usuario bigint references usuarios(id),
  id_categoria bigint references categorias(id),
  tipo text not null, -- 'entrada' ou 'saida'
  valor numeric not null,
  descricao text,
  foto_principal text,
  comprovante text, 
  data_vencimento date,
  data_pagamento date,
  created_at timestamptz default now()
);

-- Criando empresa
CREATE TABLE empresa (
  id bigint primary key generated always as identity,
  nome_empresa text not null,
  cnpj_cpf text not null unique, -- Garantir que cada CNPJ/CPF seja único
  responsavel text,
  telefone text,
  endereco text,
  logo text -- Pode armazenar o caminho para o logo ou um URL
);
