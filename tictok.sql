/*
preciso de um projeto que seja clone do tictok todas tabelas com uma boa descrição em português é claro
Para criar um projeto que seja um clone do TikTok, precisamos definir as tabelas principais que representam as 
funcionalidades básicas da plataforma. Aqui estão algumas tabelas essenciais que você pode considerar:

1. Usuários: Armazena informações sobre os usuários da plataforma.
2. Vídeos: Armazena informações sobre os vídeos postados pelos usuários.
3. Curtidas: Armazena informações sobre as curtidas que os vídeos recebem.
4. Comentários: Armazena os comentários feitos nos vídeos.
5. Seguidores: Armazena informações sobre as relações de seguidores entre os usuários.
Vou criar essas tabelas com descrições em português. Vamos começar com a tabela de usuários.
*/

create table usuarios (
  id bigint primary key generated always as identity,
  nome_usuario text not null,
  email text unique not null,
  senha text not null,
  data_criacao timestamp with time zone default now(),
  biografia text,
  foto_perfil text
);

comment on table usuarios is 'Armazena informações sobre os usuários da plataforma.';

comment on column usuarios.nome_usuario is 'Nome de usuário único na plataforma.';

comment on column usuarios.email is 'Endereço de email do usuário, deve ser único.';

comment on column usuarios.senha is 'Senha do usuário, armazenada de forma segura.';

comment on column usuarios.data_criacao is 'Data e hora em que o usuário foi criado.';

comment on column usuarios.biografia is 'Texto opcional que o usuário pode adicionar ao seu perfil.';

comment on column usuarios.foto_perfil is 'URL para a foto de perfil do usuário.';

/*
A tabela usuarios foi criada com sucesso. Ela armazena informações sobre os usuários da plataforma, incluindo 
nome de usuário, email, senha, data de criação, biografia e foto de perfil.
Agora, vamos criar a tabela de vídeos.
*/

create table videos (
  id bigint primary key generated always as identity,
  usuario_id bigint not null,
  titulo text not null,
  descricao text,
  url_video text not null,
  data_publicacao timestamp with time zone default now(),
  visualizacoes int default 0,
  foreign key (usuario_id) references usuarios (id)
);

comment on table videos is 'Armazena informações sobre os vídeos postados pelos usuários.';
comment on column videos.usuario_id is 'ID do usuário que postou o vídeo.';
comment on column videos.titulo is 'Título do vídeo.';
comment on column videos.descricao is 'Descrição opcional do vídeo.';
comment on column videos.url_video is 'URL onde o vídeo está armazenado.';
comment on column videos.data_publicacao is 'Data e hora em que o vídeo foi publicado.';
comment on column videos.visualizacoes is 'Número de visualizações que o vídeo recebeu.';

/*
A tabela videos foi criada com sucesso. Ela armazena informações sobre os vídeos postados pelos usuários, 
incluindo o usuário que postou, título, descrição, URL do vídeo, data de publicação e número de visualizações.
Agora, vamos criar a tabela de curtidas.
*/

create table curtidas (
  id bigint primary key generated always as identity,
  usuario_id bigint not null,
  video_id bigint not null,
  data_curtida timestamp with time zone default now(),
  foreign key (usuario_id) references usuarios (id),
  foreign key (video_id) references videos (id)
);
comment on table curtidas is 'Armazena informações sobre as curtidas que os vídeos recebem.';
comment on column curtidas.usuario_id is 'ID do usuário que curtiu o vídeo.';
comment on column curtidas.video_id is 'ID do vídeo que foi curtido.';
comment on column curtidas.data_curtida is 'Data e hora em que a curtida foi feita.';

/*
me nomei pontos de melhoria que poderia ajudar virilizar  
Para melhorar a viralização de uma plataforma semelhante ao TikTok, considere os seguintes pontos de melhoria:
Algoritmo de Recomendação: Desenvolva um algoritmo de recomendação robusto que personalize o feed de cada usuário 
com base em suas interações, preferências e comportamento de visualização.
Interatividade: Adicione funcionalidades interativas, como desafios, duetos e colaborações, que incentivem os usuários 
a participar e criar conteúdo.
Integração com Outras Redes Sociais: Facilite o compartilhamento de vídeos em outras plataformas sociais para aumentar 
o alcance e atrair novos usuários.
Análise de Dados: Utilize análises de dados para entender melhor o comportamento dos usuários e ajustar a plataforma 
para atender às suas necessidades e preferências.
Gamificação: Introduza elementos de gamificação, como conquistas, níveis e recompensas, para aumentar o engajamento dos usuários.
Qualidade do Conteúdo: Incentive a criação de conteúdo de alta qualidade, oferecendo ferramentas de edição avançadas e filtros criativos.
Comunidade e Engajamento: Crie uma comunidade forte e engajada, promovendo interações positivas e moderando conteúdo inadequado.
Eventos e Campanhas: Organize eventos e campanhas temáticas que incentivem a participação dos usuários e criem um senso de comunidade.
Notificações Personalizadas: Envie notificações personalizadas para manter os usuários informados sobre novos conteúdos e interações relevantes.
Suporte Multilíngue: Ofereça suporte em múltiplos idiomas para alcançar um público global e diversificado.
*/
