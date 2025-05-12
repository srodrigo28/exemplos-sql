-- gerando tabela perfil
-- lembrar de verificar o relacionamento

create table perfil (
  id bigint primary key generated always as identity,
  user_ref uuid,
  nome text,
  telefone text,
  cpf text,
  percentual bigint,
  valor_capital numeric,
  email text,
  senha text,
  data_inicio date,
  create_at date default now()
);

-- tabela lançamentos
create table lancamento (
  id bigint primary key generated always as identity,
  user_ref uuid,
  data date,
  valor numeric,
  categoria text
);

-- atualizando condicao de lançamento anual
create
or replace function atualizar_lancamento_ano_update () returns trigger as $$
BEGIN
    UPDATE lancamento_ano
    SET total_valor = total_valor - OLD.valor + NEW.valor
    WHERE user_ref = NEW.user_ref AND ano = EXTRACT(YEAR FROM NEW.data);
    RETURN NEW;
END;
$$ language plpgsql;

create trigger trigger_atualizar_lancamento_ano_update
after
update on lancamento for each row
execute function atualizar_lancamento_ano_update ();

create
or replace function atualizar_lancamento_ano_delete () returns trigger as $$
BEGIN
    UPDATE lancamento_ano
    SET total_valor = total_valor - OLD.valor
    WHERE user_ref = OLD.user_ref AND ano = EXTRACT(YEAR FROM OLD.data);
    RETURN OLD;
END;
$$ language plpgsql;

create trigger trigger_atualizar_lancamento_ano_delete
after delete on lancamento for each row
execute function atualizar_lancamento_ano_delete ();


-- criando uma view
create or replace view saldo_atual as
select
  p.user_ref,
  p.valor_capital + coalesce(la.total_valor, 0) as saldo_atual
from
  perfil p
  left join lancamento_ano la on p.user_ref = la.user_ref;
