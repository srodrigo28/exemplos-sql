/*
cria uma tabela de produtos com os campos: 
        id int8,
        nome text,
        quantidade int8,
        preco numeric,
        createdAt Date(now)

cria uma tabela para calcular os campos de preço e somar o valor total de produtos e valor total de preços e total de quantidade de produtos

preciso que sempre que inserir um registro recalcule automaticamente tudo novamente, inclusive se for modificada.

*/

create table produtos (
  id bigint primary key generated always as identity,
  nome text not null,
  quantidade bigint not null,
  preco numeric not null,
  created_at date default current_date
);

create table produtos_resumo (
  id bigint primary key generated always as identity,
  total_produtos bigint not null default 0,
  total_precos numeric not null default 0,
  total_quantidade bigint not null default 0
);

create
or replace function atualizar_resumo_produtos () returns trigger as $$
BEGIN
    UPDATE produtos_resumo
    SET total_produtos = (SELECT COUNT(*) FROM produtos),
        total_precos = (SELECT SUM(preco) FROM produtos),
        total_quantidade = (SELECT SUM(quantidade) FROM produtos);
    RETURN NEW;
END;
$$ language plpgsql;

create trigger trigger_atualizar_resumo
after insert
or
update
or delete on produtos for each statement
execute function atualizar_resumo_produtos ();

-- Inicializa a tabela de resumo com valores iniciais
insert into
  produtos_resumo (total_produtos, total_precos, total_quantidade)
values
  (0, 0, 0);
