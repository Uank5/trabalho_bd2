CREATE TABLE Lojas (
    id_loja SERIAL PRIMARY KEY,
    nome_loja VARCHAR(100) NOT NULL,
    endereco TEXT NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE Cargos (
    id_cargo SERIAL PRIMARY KEY,
    nome_cargo VARCHAR(50) UNIQUE NOT NULL,
    descricao TEXT
);

CREATE TABLE Funcionarios (
    id_funcionario SERIAL PRIMARY KEY,
    id_loja INT NOT NULL REFERENCES Lojas(id_loja),
    id_cargo INT NOT NULL REFERENCES Cargos(id_cargo),
    nome_completo VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    data_contratacao DATE NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_nascimento DATE NOT NULL,
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Enderecos_Cliente (
    id_endereco SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES Clientes(id_cliente) ON DELETE CASCADE,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    principal BOOLEAN DEFAULT false
);

CREATE TABLE Editoras (
    id_editora SERIAL PRIMARY KEY,
    nome_editora VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Designers (
    id_designer SERIAL PRIMARY KEY,
    nome_designer VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Mecanicas (
    id_mecanica SERIAL PRIMARY KEY,
    nome_mecanica VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Jogos (
    id_jogo SERIAL PRIMARY KEY,
    id_editora INT NOT NULL REFERENCES Editoras(id_editora),
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    ano_lancamento INT,
    min_jogadores INT,
    max_jogadores INT,
    tempo_medio_minutos INT,
    complexidade NUMERIC(3, 1) CHECK (complexidade >= 1 AND complexidade <= 5),
    preco_aluguel_base NUMERIC(8, 2) NOT NULL
);

CREATE TABLE Exemplares (
    id_exemplar SERIAL PRIMARY KEY,
    id_jogo INT NOT NULL REFERENCES Jogos(id_jogo),
    codigo_barras VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Disponível'
);

CREATE TABLE Jogo_Categoria (
    id_jogo INT NOT NULL REFERENCES Jogos(id_jogo),
    id_categoria INT NOT NULL REFERENCES Categorias(id_categoria),
    PRIMARY KEY (id_jogo, id_categoria)
);

CREATE TABLE Jogo_Mecanica (
    id_jogo INT NOT NULL REFERENCES Jogos(id_jogo),
    id_mecanica INT NOT NULL REFERENCES Mecanicas(id_mecanica),
    PRIMARY KEY (id_jogo, id_mecanica)
);

CREATE TABLE Jogo_Designer (
    id_jogo INT NOT NULL REFERENCES Jogos(id_jogo),
    id_designer INT NOT NULL REFERENCES Designers(id_designer),
    PRIMARY KEY (id_jogo, id_designer)
);

CREATE TABLE Alugueis (
    id_aluguel SERIAL PRIMARY KEY,
    id_exemplar INT NOT NULL REFERENCES Exemplares(id_exemplar),
    id_cliente INT NOT NULL REFERENCES Clientes(id_cliente),
    id_funcionario_emprestimo INT NOT NULL REFERENCES Funcionarios(id_funcionario),
    data_aluguel TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    data_devolucao_prevista DATE NOT NULL,
    valor_cobrado NUMERIC(8, 2) NOT NULL
);

CREATE TABLE Devolucoes (
    id_devolucao SERIAL PRIMARY KEY,
    id_aluguel INT UNIQUE NOT NULL REFERENCES Alugueis(id_aluguel),
    id_funcionario_recebimento INT NOT NULL REFERENCES Funcionarios(id_funcionario),
    data_devolucao_efetiva TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    observacoes TEXT
);

CREATE TABLE Multas (
    id_multa SERIAL PRIMARY KEY,
    id_devolucao INT NOT NULL REFERENCES Devolucoes(id_devolucao),
    valor_multa NUMERIC(8, 2) NOT NULL,
    motivo VARCHAR(255),
    paga BOOLEAN DEFAULT false
);

CREATE TABLE Pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_aluguel INT REFERENCES Alugueis(id_aluguel),
    id_multa INT REFERENCES Multas(id_multa),
    valor NUMERIC(10, 2) NOT NULL,
    data_pagamento TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metodo_pagamento VARCHAR(50)
);

CREATE TABLE Reservas (
    id_reserva SERIAL PRIMARY KEY,
    id_jogo INT NOT NULL REFERENCES Jogos(id_jogo),
    id_cliente INT NOT NULL REFERENCES Clientes(id_cliente),
    data_reserva TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Ativa'
);

CREATE TABLE Log_Alteracoes_Preco (
    id_log SERIAL PRIMARY KEY,
    id_jogo INT NOT NULL REFERENCES Jogos(id_jogo),
    preco_anterior NUMERIC(8, 2) NOT NULL,
    preco_novo NUMERIC(8, 2) NOT NULL,
    data_alteracao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    id_funcionario INT REFERENCES Funcionarios(id_funcionario)
);

CREATE TABLE Historico_Aluguel_Negado (
    id_historico SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES Clientes(id_cliente),
    id_exemplar INT NOT NULL REFERENCES Exemplares(id_exemplar),
    motivo VARCHAR(255) NOT NULL,
    data_tentativa TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Historico_Devolucao_Problematica (
    id_historico SERIAL PRIMARY KEY,
    id_devolucao INT NOT NULL REFERENCES Devolucoes(id_devolucao),
    tipo_problema VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
); 