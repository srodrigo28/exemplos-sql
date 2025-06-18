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
