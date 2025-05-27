create or replace view view_retidas as
select
  l.user_ref,
  l.categoria,
  sum(l.valor) as valor,
  l.data
from
  lancamento l
where
  l.categoria = 'Retirada'
group by
  l.user_ref,
  l.categoria,
  l.data;
