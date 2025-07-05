-- Criação da tabela empresa
create table empresa (
  id bigint primary key generated always as identity,
  nome text not null,
  telefone text not null,
  cnpj text not null,
  estado text not null,
  email text not null,
  cidade text not null,
  bairro text not null,
  complemento text
);

-- Criação da tabela usuario
create table usuario (
  id bigint primary key generated always as identity,
  nome text not null,
  email text not null,
  telefone text not null,
  papel text not null,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null,
  empresa_id bigint,
  foreign key (empresa_id) references empresa (id)
);

-- Criação da tabela categorias
create table categorias (
  id bigint primary key generated always as identity,
  nome text not null,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

-- Criação da tabela conta
create table conta (
  id bigint primary key generated always as identity,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

-- Criação da tabela fornecedor
create table fornecedor (
  id bigint primary key generated always as identity,
  nome text not null,
  telefone text not null,
  email text not null,
  endereco text not null
);

-- Criação da tabela produtos com fornecedor_id
create table produtos (
  id bigint primary key generated always as identity,
  nome text not null,
  descricao text,
  preco numeric(15, 2) not null,
  fornecedor_id bigint references fornecedor (id),
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

-- Criação da tabela estoque
create table estoque (
  id bigint primary key generated always as identity,
  produto_id bigint references produtos (id),
  quantidade int not null,
  localizacao text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

-- Criação da tabela funcionario
create table funcionario (
  id bigint primary key generated always as identity,
  nome text not null,
  email text not null,
  telefone text not null,
  cargo text not null,
  usuario_id bigint references usuario (id),
  empresa_id bigint references empresa (id)
);

-- Atualização na tabela usuario para permitir que um usuário seja um funcionário
alter table usuario
add column funcionario_id bigint references funcionario (id);

-- Criação da tabela transacoes
create table transacoes (
  id bigint primary key generated always as identity,
  data date not null,
  nome text not null,
  descricao text,
  valor numeric(15, 2) not null,
  tipo text check (tipo in ('entrada', 'saída')) not null,
  categoria_id bigint references categorias (id),
  usuario_id bigint references usuario (id),
  produto_id bigint references produtos (id),
  conta_id bigint references conta (id),
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

-- Criação da tabela lancamento_contas_futuras
create table lancamento_contas_futuras (
  id bigint primary key generated always as identity,
  data_prevista date not null,
  valor numeric(15, 2) not null,
  tipo text check (tipo in ('entrada', 'saída')) not null,
  conta_id bigint references conta (id),
  descricao text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);
