create table usuario (
  id bigint primary key generated always as identity,
  nome text not null,
  tipo text not null,
  email text not null,
  telefone text not null,
  user_ref uuid not null unique,
  saldo_inicial numeric(15, 2) not null,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create table categorias (
  id bigint primary key generated always as identity,
  nome text not null,
  descricao text not null,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

CREATE TABLE transacoes (
  id bigint primary key generated always as identity,
  data date not null,
  descricao text,
  valor numeric(15, 2) not null,
  tipo text check (tipo in ('entrada', 'saida')) not null,
  status text check (status in ('aguardando', 'pago', 'vencida')) not null,
  usuario_id bigint references usuario(id),
  categoria_id bigint references categorias(id),
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create table lancamento_usuario_futuras (
  id bigint primary key generated always as identity,
  data_prevista date not null,
  valor numeric(15, 2) not null,
  tipo text check (tipo in ('entrada', 'saida')) not null,
  conta_id bigint references usuario (id),
  descricao text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);
