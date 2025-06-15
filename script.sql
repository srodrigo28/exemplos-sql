2:49 tela escrito Sebstião ao invés de Sebastião

saldo_view
lancamento_categoria_view


saldo_view_capital

-- exit o conteúdo da view
select
  definition
from
  pg_views
where
  viewname = 'saldo_view';

-- tabela perfil: user_ref uuid, 
		  email text,
		  valor capital numeric

-- tabela lancamento: user_ref uuid, 
		      categoria text
		      valor numeric

-- retornou saldo_view, 
 SELECT p.user_ref,
    p.email AS nome,
    (p.valor_capital + COALESCE(sum(l.valor), (0)::numeric)) AS saldo_atual
   FROM (perfil p
     LEFT JOIN lancamento l ON (((p.user_ref = l.user_ref) AND (l.categoria = 'Entrada'::text))))
  GROUP BY p.user_ref, p.email, p.valor_capital;


-- retornou saldo_atual

 SELECT p.user_ref,
    (p.valor_capital + COALESCE(la.total_valor, (0)::numeric)) AS saldo_atual
   FROM (perfil p
     LEFT JOIN lancamento_ano la ON ((p.user_ref = la.user_ref)));


-- condição 1
create or replace view saldo_view2 as
select
  p.user_ref,
  p.email as nome,
  (
    p.valor_capital + coalesce(
      sum(
        case
          when l.categoria = 'Entrada' then l.valor
          else 0
        end
      ),
      0::numeric
    ) + coalesce(
      sum(
        case
          when l.categoria = 'Aplicado' then l.valor
          else 0
        end
      ),
      0::numeric
    )
  ) as saldo_atual
from
  perfil p
  left join lancamento l on p.user_ref = l.user_ref
group by
  p.user_ref,
  p.email,
  p.valor_capital;

-- condição 1 atualizada

create or replace view saldo_view2 as
select
  p.user_ref,
  p.email as nome,
  (
    p.valor_capital + coalesce(
      sum(
        case
          when l.categoria = 'Entrada' then l.valor
          else 0
        end
      ),
      0::numeric
    ) + coalesce(
      sum(
        case
          when l.categoria = 'Aplicado' then l.valor
          else 0
        end
      ),
      0::numeric
    )
  ) as saldo_atual
from
  perfil p
  left join lancamento l on p.user_ref = l.user_ref
group by
  p.user_ref,
  p.email,
  p.valor_capital;

-- rendimento mês
 SELECT p.user_ref,
    p.valor_capital,
    p.percentual,
    (((COALESCE(l.total_entrada, p.valor_capital))::double precision * p.percentual) / (100)::double precision) AS rendimento_mes
   FROM (perfil p
     LEFT JOIN ( SELECT lancamento.user_ref,
            sum(lancamento.valor) AS total_entrada
           FROM lancamento
          WHERE (lancamento.categoria = 'Entrada'::text)
          GROUP BY lancamento.user_ref) l ON ((p.user_ref = l.user_ref)));
