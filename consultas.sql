/* ============================================================
   TREINAMENTO SQL (PostgreSQL) — Tabela: medicamentos.medicamentos
   Objetivo: consultar dados e contar registros (geral e por UF)
   Observação: comentários abaixo explicam o “porquê” de cada comando.
   ============================================================ */

-- 1) CONSULTA BÁSICA (VISUALIZAÇÃO)
-- Retorna TODAS as colunas (*) e TODAS as linhas da tabela.
-- Use para inspecionar rapidamente os dados, entender campos e validar conteúdo.
SELECT * 
FROM medicamentos.medicamentos;


-- 2) CONTAGEM TOTAL DE REGISTROS
-- COUNT(*) conta a quantidade de LINHAS da tabela, independentemente de valores nulos.
-- Ideal para saber o “tamanho” do conjunto de dados.
SELECT COUNT(*) AS total_registros
FROM medicamentos.medicamentos;


-- 3) CONTAGEM FILTRADA POR UF (EXATO)
-- Filtra apenas registros cuja UF seja exatamente 'GO' (sensível a maiúsculas/minúsculas em muitos cenários).
-- Recomendado quando você tem certeza de que a coluna sempre está padronizada (ex.: sempre 'GO').
SELECT COUNT(*) AS total_go
FROM medicamentos.medicamentos
WHERE uf = 'GO';


-- 4) CONTAGEM POR UF (SEM DIFERENCIAR MAIÚSCULAS/MINÚSCULAS) — PADRÃO RECOMENDADO EM POSTGRES
-- ILIKE faz comparação "case-insensitive" no PostgreSQL:
-- 'go', 'Go', 'gO' e 'GO' serão considerados equivalentes.
-- Útil quando os dados podem vir com variações de caixa.
SELECT COUNT(*) AS total_go
FROM medicamentos.medicamentos
WHERE uf ILIKE 'go';


-- 5) CONTAGEM POR UF USANDO NORMALIZAÇÃO (PORTÁVEL / DIDÁTICO)
-- UPPER(uf) transforma o conteúdo em maiúsculo antes de comparar.
-- Funciona em muitos bancos (incluindo Postgres) e ajuda a padronizar a comparação.
-- Atenção: isso pode impedir o uso de índice na coluna uf (dependendo do banco/índice).
SELECT COUNT(*) AS total_go
FROM medicamentos.medicamentos
WHERE UPPER(uf) = 'GO';


/* DICA DE BOAS PRÁTICAS (POSTGRES):
   - Se você SEMPRE consulta por UF sem diferenciar caixa e quer performance:
     considere padronizar os dados (guardar sempre 'GO') OU criar um índice funcional:
     CREATE INDEX idx_medicamentos_uf_upper ON medicamentos.medicamentos (UPPER(uf));
*/
