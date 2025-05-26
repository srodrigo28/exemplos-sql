create or replace view view_rendimento_mes as
select
  sa.user_ref,
  sa.saldo_atual,
  p.percentual,
  ( sa.saldo_atual * p.percentual ) 100 as rendimento,
  sum(
    case
      when l.categoria = 'Aplicado' then l.valor
      else 0
    end
  ) as soma_aplicado,
  sum(
    case
      when l.categoria = 'Retirada' then l.valor
      else 0
    end
  ) as soma_retiradas
from
  saldo_atual sa
  join perfil p on sa.user_ref = p.user_ref
  left join lancamento l on sa.user_ref = l.user_ref
group by
  sa.user_ref,
  sa.saldo_atual,
  p.percentual;
