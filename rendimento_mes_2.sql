drop view if exists rendimento_mes;

create view rendimento_mes as
select
  p.user_ref,
  p.valor_capital as valor_capital,
  p.percentual,
  coalesce(l.total_entrada, p.valor_capital) * p.percentual / 100 as rendimento_mes
from
  perfil p
  left join (
    select
      user_ref,
      sum(valor) as total_entrada
    from
      lancamento
    where
      categoria = 'Entrada'
    group by
      user_ref
  ) l on p.user_ref = l.user_ref;
