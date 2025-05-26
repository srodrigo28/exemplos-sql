create or replace view lancamento_categoria_view as
select
  l.user_ref,
  l.data,
  l.valor,
  l.categoria,
  sum(
    case
      when l.categoria = 'Aplicado' then l.valor
      else 0
    end
  ) over (
    partition by
      l.user_ref
  ) as soma_aplicado,
  sum(
    case
      when l.categoria = 'Retirada' then l.valor
      else 0
    end
  ) over (
    partition by
      l.user_ref
  ) as soma_retiradas
from
  lancamento l;
