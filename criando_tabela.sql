-- comentário de uma linha

DROP DATABASE IF EXISTS escola_db2; -- EXCLUI CASO EXISTA

DROP DATABASE IF EXISTS escola_db;  -- EXCLUI CASO EXISTA

CREATE DATABASE escola_db; -- CRIA O BANCO

USE escola_db; -- SELECIONA O BANCO

-- CRIA UMA TABELA ALUNOS
CREATE TABLE IF NOT EXISTS alunos (
    id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_sala INTEGER,
    nome VARCHAR(255) NOT NULL,
    sexo VARCHAR(1) NOT NULL
);

-- CRIA UMA TABELA SALAS
CREATE TABLE IF NOT EXISTS salas (
    id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(10) NOT NULL,
    capacidade VARCHAR(3)
);

-- CRIA UMA TABELA PARA RELACIONAMENTO
CREATE TABLE IF NOT EXISTS aluno_sala (
    id_sala INTEGER,
    id_aluno INTEGER
);

-- relacionamentos multos para muitos
ALTER TABLE aluno_sala
ADD FOREIGN KEY (id_sala) REFERENCES salas(id) ON UPDATE CASCADE;

ALTER TABLE aluno_sala
ADD FOREIGN KEY (id_aluno) REFERENCES alunos(id) ON UPDATE CASCADE;

-- Criando produtos
CREATE TABLE IF NOT EXISTS produtos (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_categoria INTEGER,
    nome VARCHAR(30) NOT NULL,
    qtd INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_cadastro timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Criando categorias
CREATE TABLE IF NOT EXISTS categorias(
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(30) NOT NULL
);

-- Criando relacionamento
ALTER TABLE produtos
ADD FOREIGN KEY (id_categoria) REFERENCES categorias(id) ON UPDATE CASCADE;