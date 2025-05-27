drop view if exists saldo_view;

create view saldo_view as
select
  p.user_ref,
  p.email as nome,
  p.valor_capital + coalesce(sum(l.valor), 0) as valor_capital
from
  perfil p
  left join lancamento l on p.user_ref = l.user_ref
  and l.categoria = 'Entrada'
group by
  p.user_ref,
  p.email,
  p.valor_capital;
