-- Create table usuarios
CREATE TABLE usuarios (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nome_usuario TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  senha TEXT NOT NULL,
  data_criacao TIMESTAMPTZ DEFAULT NOW(),
  biografia TEXT,
  url_foto_perfil TEXT
);

-- Create table postagem_videos
CREATE TABLE videos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id BIGINT NOT NULL,
  titulo TEXT NOT NULL,
  descricao TEXT,
  url_video TEXT NOT NULL,
  data_publicacao TIMESTAMPTZ DEFAULT NOW(),
  visualizacoes INT DEFAULT 0,
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
);

-- Create table curtidas
CREATE TABLE curtidas (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id BIGINT NOT NULL,
  video_id BIGINT NOT NULL,
  data_curtida TIMESTAMPTZ DEFAULT NOW(),
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
  FOREIGN KEY (video_id) REFERENCES videos (id),
  UNIQUE (usuario_id, video_id)
);

-- Create table comentarios
CREATE TABLE comentarios (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id BIGINT NOT NULL,
  video_id BIGINT NOT NULL,
  texto TEXT NOT NULL,
  data_comentario TIMESTAMPTZ DEFAULT NOW(),
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
  FOREIGN KEY (video_id) REFERENCES videos (id),
  UNIQUE (usuario_id, video_id, data_comentario)
);

-- Create table seguidores
CREATE TABLE seguidores (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  seguidor_id BIGINT NOT NULL,
  seguido_id BIGINT NOT NULL,
  data_seguimento TIMESTAMPTZ DEFAULT NOW(),
  FOREIGN KEY (seguidor_id) REFERENCES usuarios (id),
  FOREIGN KEY (seguido_id) REFERENCES usuarios (id),
  UNIQUE (seguidor_id, seguido_id)
);

-- Create table postagem_imagem
CREATE TABLE postagem_imagem (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id BIGINT NOT NULL,
  titulo TEXT NOT NULL,
  descricao TEXT,
  url_imagem TEXT NOT NULL,
  data_publicacao TIMESTAMPTZ DEFAULT NOW(),
  visualizacoes INT DEFAULT 0,
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
);

-- 1. View de Painel de Usuário
CREATE VIEW painel_usuario AS
SELECT 
  u.id AS usuario_id,
  u.nome_usuario,
  u.email,
  COUNT(DISTINCT v.id) AS total_videos,
  COUNT(DISTINCT c.id) AS total_curtidas_recebidas,
  COUNT(DISTINCT cm.id) AS total_comentarios_feitos,
  COUNT(DISTINCT s.seguidor_id) AS total_seguidores
FROM 
  usuarios u
LEFT JOIN 
  videos v ON u.id = v.usuario_id
LEFT JOIN 
  curtidas c ON v.id = c.video_id
LEFT JOIN 
  comentarios cm ON u.id = cm.usuario_id
LEFT JOIN 
  seguidores s ON u.id = s.seguido_id
GROUP BY 
  u.id, u.nome_usuario, u.email;

-- 2. View de Estatísticas de Vídeos
CREATE VIEW estatisticas_videos AS
SELECT 
  v.id AS video_id,
  v.titulo,
  v.visualizacoes,
  COUNT(c.id) AS total_curtidas
FROM 
  videos v
LEFT JOIN 
  curtidas c ON v.id = c.video_id
GROUP BY 
  v.id, v.titulo, v.visualizacoes;

-- 3. View de Seguidores
CREATE VIEW lista_seguidores AS
SELECT 
  u.id AS usuario_id,
  u.nome_usuario,
  s.seguidor_id,
  su.nome_usuario AS nome_seguidor
FROM 
  seguidores s
JOIN 
  usuarios u ON s.seguido_id = u.id
JOIN 
  usuarios su ON s.seguidor_id = su.id;
