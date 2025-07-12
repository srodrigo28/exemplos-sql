-- Extensão para gerar UUIDs (muito útil para IDs primárias)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabela de Usuários (Gerenciada principalmente pelo Supabase Auth)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), -- UUID gerado automaticamente
    email TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE,
    -- ... outras colunas que você queira para o perfil (ex: full_name, avatar_url)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Autores (para gerenciar os autores do conteúdo)
CREATE TABLE authors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    bio TEXT,
    website_url TEXT,
    profile_picture_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Livros (o conteúdo em si)
CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    author_id UUID REFERENCES authors(id) ON DELETE SET NULL, -- Chave estrangeira para o autor
    isbn TEXT UNIQUE,
    publication_year INT,
    cover_image_url TEXT, -- URL para a capa no Supabase Storage
    epub_file_url TEXT,   -- URL para o arquivo EPUB no Supabase Storage
    pdf_file_url TEXT,    -- URL opcional para PDF
    price NUMERIC(10, 2) NOT NULL DEFAULT 0.00, -- Preço do livro
    is_published BOOLEAN DEFAULT FALSE, -- Se o livro está disponível no catálogo
    genre TEXT, -- Ou uma tabela separada para muitos-para-muitos
    language TEXT,
    page_count INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Audiobooks (separado, mas linkável aos livros)
CREATE TABLE audiobooks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID REFERENCES books(id) ON DELETE CASCADE, -- Chave estrangeira para o livro associado
    narrator TEXT,
    duration_seconds INT, -- Duração total em segundos
    audio_file_url TEXT, -- URL para o arquivo de áudio principal no Supabase Storage
    -- Pode adicionar JSONB para metadados de capítulos se for mais complexo
    price NUMERIC(10, 2) NOT NULL DEFAULT 0.00, -- Preço do audiobook
    is_published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela para o Progresso de Leitura/Audição do Usuário
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    last_page_read INT,         -- Para livros (número da página ou posição percentual)
    last_audio_timestamp INT,   -- Para audiobooks (segundos da última reprodução)
    is_finished BOOLEAN DEFAULT FALSE,
    current_format TEXT CHECK (current_format IN ('book', 'audiobook')), -- Indica qual formato o usuário está usando ativamente
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE (user_id, book_id) -- Garante que um usuário só tenha um progresso por livro
);

-- Tabela para Armazenar Compras de Livros/Audiobooks (se for venda avulsa)
CREATE TABLE purchases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE, -- Pode ser NULL se for apenas audiobook
    audiobook_id UUID REFERENCES audiobooks(id) ON DELETE CASCADE, -- Pode ser NULL se for apenas livro
    purchase_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    amount NUMERIC(10, 2) NOT NULL,
    -- Tipo da compra (e.g., 'book', 'audiobook', 'bundle')
    purchase_type TEXT CHECK (purchase_type IN ('book', 'audiobook', 'bundle')),
    CONSTRAINT chk_book_or_audiobook CHECK (
        (book_id IS NOT NULL AND audiobook_id IS NULL) OR
        (book_id IS NULL AND audiobook_id IS NOT NULL) OR
        (book_id IS NOT NULL AND audiobook_id IS NOT NULL AND purchase_type = 'bundle')
    ) -- Garante que ou um livro, ou um audiobook, ou ambos (bundle) foram comprados
);

-- Tabela para Anotações e Destaques
CREATE TABLE annotations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    annotation_text TEXT NOT NULL, -- O texto da anotação
    context_text TEXT,             -- O trecho do livro onde a anotação foi feita
    page_number INT,               -- Página ou identificador de posição
    audio_timestamp INT,           -- Timestamp no audiobook, se for uma anotação de áudio
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Opcional: Tabela para Assinaturas (se for um modelo de assinatura)
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE, -- Um usuário só tem uma assinatura ativa
    plan_name TEXT NOT NULL, -- Ex: 'Basic', 'Premium'
    start_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    end_date TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE,
    stripe_subscription_id TEXT, -- ID da assinatura no Stripe ou outro gateway
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Opcional: Tabela para Gêneros (se quiser uma categorização mais granular)
CREATE TABLE genres (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL
);

-- Tabela de relacionamento muitos-para-muitos entre Livros e Gêneros
CREATE TABLE book_genres (
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    genre_id UUID REFERENCES genres(id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, genre_id)
);
