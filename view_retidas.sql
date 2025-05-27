drop view if exists view_retidas;

create view view_retidas as
select
  l.user_ref,
  l.categoria,
  sum(l.valor) as valor
from
  lancamento l
where
  l.categoria = 'Retirada'
group by
  l.user_ref,
  l.categoria;
