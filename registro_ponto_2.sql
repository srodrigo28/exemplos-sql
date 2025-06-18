-- Para tornar o script mais performático e legível, podemos simplificar a lógica de atualização e garantir que a estrutura das tabelas seja clara. Aqui está uma versão otimizada do script:
-- pontos para estudar uma forma de colocar como todo sabado que precisa ser trabalhado colocar como carga horária 4 horas oque exceder hora extra.
-- calculo de horas mês por user_ref, trazendo, nome e total de horas mês.
-- Criação da tabela funcionario

CREATE TABLE funcionario (
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome text NOT NULL,
    funcao text NOT NULL,
    data_inicio date NOT NULL,
    telefone text NOT NULL
);

-- Criação da tabela registro_ponto
CREATE TABLE registro_ponto (
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_ref bigint REFERENCES funcionario(id),
    horario_inicio time NOT NULL,
    horario_fim time NOT NULL,
    total_horas interval GENERATED ALWAYS AS (horario_fim - horario_inicio) STORED,
    total_horas_extra_dia interval GENERATED ALWAYS AS (
        CASE 
            WHEN horario_fim - horario_inicio > interval '8 hours' 
            THEN horario_fim - horario_inicio - interval '8 hours'
            ELSE interval '0 hours'
        END
    ) STORED,
    data_registro date NOT NULL DEFAULT CURRENT_DATE
);
/*
  Melhorias:
  Colunas Geradas: Agora, total_horas_extra_dia é uma coluna gerada, calculada automaticamente com base nos horários de início e fim. Isso elimina a necessidade de uma atualização manual após a inserção dos dados.
  Legibilidade: A lógica para calcular total_horas_extra_dia está diretamente na definição da tabela, tornando o script mais fácil de entender e manter.
  Desempenho: Usar colunas geradas reduz a necessidade de atualizações manuais, melhorando o desempenho ao evitar operações adicionais no banco de dados.
*/

-- novidades
-- consegue me ajudar criando 10 registros com nomes reais variados cada registro com 30 dias de trabalho variando com valores de horas extras ?

-- Inserir 10 funcionários
insert into
  funcionario (nome, funcao, data_inicio, telefone)
values
  (
    'Ana Silva',
    'Desenvolvedora',
    '2023-01-01',
    '123456789'
  ),
  (
    'Bruno Costa',
    'Analista',
    '2023-01-02',
    '987654321'
  ),
  (
    'Carla Souza',
    'Gerente',
    '2023-01-03',
    '456789123'
  ),
  (
    'Daniel Lima',
    'Designer',
    '2023-01-04',
    '789123456'
  ),
  (
    'Eduardo Pereira',
    'Engenheiro',
    '2023-01-05',
    '321654987'
  ),
  (
    'Fernanda Oliveira',
    'Consultora',
    '2023-01-06',
    '654987321'
  ),
  (
    'Gabriel Santos',
    'Arquiteto',
    '2023-01-07',
    '147258369'
  ),
  (
    'Helena Martins',
    'Coordenadora',
    '2023-01-08',
    '963852741'
  ),
  (
    'Igor Almeida',
    'Técnico',
    '2023-01-09',
    '852741963'
  ),
  (
    'Juliana Rocha',
    'Supervisora',
    '2023-01-10',
    '741963852'
  );

-- Inserir 30 registros de ponto para cada funcionário
do $$
DECLARE
    f_id bigint;
    start_time time;
    end_time time;
BEGIN
    FOR f_id IN (SELECT id FROM funcionario) LOOP
        FOR i IN 1..30 LOOP
            start_time := '08:00:00';
            end_time := start_time + (interval '8 hours' + (random() * interval '4 hours'));
            INSERT INTO registro_ponto (nome_ref, horario_inicio, horario_fim, data_registro)
            VALUES (f_id, start_time, end_time, CURRENT_DATE - (30 - i));
        END LOOP;
    END LOOP;
END $$;

-- Os registros foram inseridos com sucesso. Agora, cada funcionário tem 30 dias de registros de ponto, com horários de trabalho variando para incluir horas extras. Se precisar de mais alguma coisa, estou à --disposição para ajudar!

-- atualização

preciso colocar algumas melhorias

campo  hora_fim e total_horas veio assim 09:19:21.914471
precisa me retornar 00:00:00 se necessário arrendar para + 

já o campo total_horas_extras_dia veio null
Para melhorar a formatação dos campos de tempo e garantir que o campo total_horas_extra_dia não seja nulo, podemos fazer o seguinte:

Formatação de Tempo: Podemos usar a função date_trunc para truncar os valores de tempo para segundos, removendo as frações de segundo.

Calcular total_horas_extra_dia: Certifique-se de que o cálculo de total_horas_extra_dia seja feito corretamente, mesmo que o valor seja zero.

Vamos ajustar o script para garantir essas melhorias:

-- Atualizar registros de ponto para formatar os tempos e calcular total_horas_extra_dia
UPDATE registro_ponto
SET 
    horario_fim = date_trunc('second', horario_fim),
    total_horas_extra_dia = 
        CASE 
            WHEN total_horas > interval '8 hours' THEN total_horas - interval '8 hours'
            ELSE interval '0 hours'
        END;
Explicações:
date_trunc('second', horario_fim): Trunca o valor de horario_fim para o segundo mais próximo, removendo as frações de segundo.
Cálculo de total_horas_extra_dia: Garante que o campo não seja nulo, atribuindo interval '0 hours' quando total_horas é menor ou igual a 8 horas.
Vou aplicar essas atualizações agora.


Executed SQL
-- Atualizar registros de ponto para formatar os tempos e calcular total_horas_extra_dia
update registro_ponto
set
  horario_fim = date_trunc('second', horario_fim),
  total_horas_extra_dia = case
    when total_horas > interval '8 hours' then total_horas - interval '8 hours'
    else interval '0 hours'
  end;

--
-- As atualizações foram aplicadas com sucesso. Agora, os campos de tempo são truncados para o segundo mais próximo, e o campo total_horas_extra_dia é calculado corretamente, 
-- garantindo que não seja nulo. Se precisar de mais alguma coisa, estou à disposição para ajudar!

--essa view precisa me trazer 
-- total_horas_traba,
-- otal_horas_extras,
-- nome_ref,
-- nome,
-- funcao

create view view_total_horas as
select
  sum(rp.total_horas) as total_horas_traba,
  sum(rp.total_horas_extra_dia) as total_horas_extras,
  rp.nome_ref,
  f.nome,
  f.funcao
from
  registro_ponto rp
  join funcionario f on rp.nome_ref = f.id
group by
  rp.nome_ref,
  f.nome,
  f.funcao;
-- A view view_total_horas foi criada com sucesso. Ela fornece as seguintes informações:

-- total_horas_traba: Total de horas trabalhadas por funcionário.
-- total_horas_extras: Total de horas extras por funcionário.
-- nome_ref: Referência ao ID do funcionário.
-- nome: Nome do funcionário.
-- funcao: Função do funcionário.
