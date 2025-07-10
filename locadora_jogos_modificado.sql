-- Projeto de Banco de Dados: Locadora de Jogos de Tabuleiro
-- SGBD: PostgreSQL
-- Versão Modificada - Removidas funcionalidades complexas

-- ========= TABELAS DE LOCALIZAÇÃO E PESSOAS =========

-- Tabela para Lojas Físicas
CREATE TABLE Lojas (
    id_loja SERIAL PRIMARY KEY,
    nome_loja VARCHAR(100) NOT NULL,
    endereco TEXT NOT NULL,
    telefone VARCHAR(20)
);

-- Tabela para Cargos dos Funcionários
CREATE TABLE Cargos (
    id_cargo SERIAL PRIMARY KEY,
    nome_cargo VARCHAR(50) UNIQUE NOT NULL,
    descricao TEXT
);

-- Tabela de Funcionários
CREATE TABLE Funcionarios (
    id_funcionario SERIAL PRIMARY KEY,
    id_loja INT NOT NULL REFERENCES Lojas(id_loja),
    id_cargo INT NOT NULL REFERENCES Cargos(id_cargo),
    nome_completo VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    data_contratacao DATE NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

-- Tabela de Clientes (Modificada - telefone como atributo)
CREATE TABLE Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_nascimento DATE NOT NULL,
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Endereços dos Clientes (Um cliente pode ter múltiplos endereços)
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

-- ========= TABELAS DE JOGOS E METADADOS =========

-- Tabela de Editoras de Jogos
CREATE TABLE Editoras (
    id_editora SERIAL PRIMARY KEY,
    nome_editora VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela de Designers de Jogos
CREATE TABLE Designers (
    id_designer SERIAL PRIMARY KEY,
    nome_designer VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela de Categorias de Jogos
CREATE TABLE Categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(50) UNIQUE NOT NULL
);

-- Tabela de Mecânicas de Jogos
CREATE TABLE Mecanicas (
    id_mecanica SERIAL PRIMARY KEY,
    nome_mecanica VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela Principal de Jogos
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

-- Tabela de Exemplares
CREATE TABLE Exemplares (
    id_exemplar SERIAL PRIMARY KEY,
    id_jogo INT NOT NULL REFERENCES Jogos(id_jogo),
    codigo_barras VARCHAR(50) UNIQUE NOT NULL,
    estado_conservacao VARCHAR(50) DEFAULT 'Bom',
    status VARCHAR(20) NOT NULL DEFAULT 'Disponível'
);

-- ========= TABELAS DE RELACIONAMENTO (MUITOS-PARA-MUITOS) =========

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

-- ========= TABELAS DE TRANSAÇÕES E OPERAÇÕES =========

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

-- ========= TABELAS DE LOG =========

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

-- ========= FUNÇÕES PRINCIPAIS =========

-- Função para registrar aluguel
CREATE OR REPLACE FUNCTION registrar_aluguel(
    p_id_exemplar INT,
    p_id_cliente INT,
    p_id_funcionario INT,
    p_data_devolucao_prevista DATE,
    p_valor_cobrado NUMERIC
) RETURNS INT AS $$
DECLARE
    v_id_aluguel INT;
    v_status_exemplar VARCHAR(20);
BEGIN
    -- Verificar se o exemplar está disponível
    SELECT status INTO v_status_exemplar
    FROM Exemplares
    WHERE id_exemplar = p_id_exemplar;
    
    IF v_status_exemplar != 'Disponível' THEN
        RAISE EXCEPTION 'Exemplar não está disponível para aluguel';
    END IF;
    
    -- Inserir o aluguel
    INSERT INTO Alugueis (id_exemplar, id_cliente, id_funcionario_emprestimo, 
                          data_devolucao_prevista, valor_cobrado)
    VALUES (p_id_exemplar, p_id_cliente, p_id_funcionario, 
            p_data_devolucao_prevista, p_valor_cobrado)
    RETURNING id_aluguel INTO v_id_aluguel;
    
    -- Atualizar status do exemplar
    UPDATE Exemplares 
    SET status = 'Alugado'
    WHERE id_exemplar = p_id_exemplar;
    
    RETURN v_id_aluguel;
END;
$$ LANGUAGE plpgsql;

-- Função para registrar devolução
CREATE OR REPLACE FUNCTION registrar_devolucao(
    p_id_aluguel INT,
    p_id_funcionario INT,
    p_observacoes TEXT DEFAULT NULL
) RETURNS INT AS $$
DECLARE
    v_id_devolucao INT;
    v_id_exemplar INT;
    v_data_prevista DATE;
    v_valor_multa NUMERIC(8, 2) := 0;
BEGIN
    -- Obter informações do aluguel
    SELECT id_exemplar, data_devolucao_prevista 
    INTO v_id_exemplar, v_data_prevista
    FROM Alugueis
    WHERE id_aluguel = p_id_aluguel;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Aluguel não encontrado';
    END IF;
    
    -- Inserir devolução
    INSERT INTO Devolucoes (id_aluguel, id_funcionario_recebimento, observacoes)
    VALUES (p_id_aluguel, p_id_funcionario, p_observacoes)
    RETURNING id_devolucao INTO v_id_devolucao;
    
    -- Atualizar status do exemplar
    UPDATE Exemplares 
    SET status = 'Disponível'
    WHERE id_exemplar = v_id_exemplar;
    
    -- Calcular multa se atrasado
    IF CURRENT_DATE > v_data_prevista THEN
        v_valor_multa := (CURRENT_DATE - v_data_prevista) * 5.00; -- R$ 5,00 por dia
        
        INSERT INTO Multas (id_devolucao, valor_multa, motivo)
        VALUES (v_id_devolucao, v_valor_multa, 'Atraso na devolução');
    END IF;
    
    RETURN v_id_devolucao;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar disponibilidade de jogo
CREATE OR REPLACE FUNCTION verificar_disponibilidade_jogo(p_id_jogo INT)
RETURNS TABLE(
    exemplares_disponiveis INT,
    exemplares_total INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(CASE WHEN e.status = 'Disponível' THEN 1 END) as exemplares_disponiveis,
        COUNT(*) as exemplares_total
    FROM Exemplares e
    WHERE e.id_jogo = p_id_jogo;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar disponibilidade detalhada
CREATE OR REPLACE FUNCTION verificar_disponibilidade_jogo_detalhada(p_id_jogo INT)
RETURNS TABLE(
    id_exemplar INT,
    codigo_barras VARCHAR(50),
    estado_conservacao VARCHAR(50),
    status VARCHAR(20),
    disponivel BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id_exemplar,
        e.codigo_barras,
        e.estado_conservacao,
        e.status,
        (e.status = 'Disponível') as disponivel
    FROM Exemplares e
    WHERE e.id_jogo = p_id_jogo
    ORDER BY e.status, e.id_exemplar;
END;
$$ LANGUAGE plpgsql;

-- Função para calcular faturamento por período
CREATE OR REPLACE FUNCTION calcular_faturamento_periodo(
    p_data_inicio DATE,
    p_data_fim DATE
) RETURNS TABLE(
    total_alugueis INT,
    faturamento_total NUMERIC,
    ticket_medio NUMERIC,
    clientes_unicos INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_alugueis,
        SUM(a.valor_cobrado) as faturamento_total,
        AVG(a.valor_cobrado) as ticket_medio,
        COUNT(DISTINCT a.id_cliente) as clientes_unicos
    FROM Alugueis a
    WHERE a.data_aluguel::date BETWEEN p_data_inicio AND p_data_fim;
END;
$$ LANGUAGE plpgsql;

-- Função para recomendar jogos para cliente
CREATE OR REPLACE FUNCTION recomendar_jogos_cliente(p_id_cliente INT, p_limite INT DEFAULT 5)
RETURNS TABLE(
    id_jogo INT,
    titulo VARCHAR(150),
    complexidade NUMERIC(3, 1),
    preco_aluguel_base NUMERIC(8, 2),
    score_recomendacao NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        j.id_jogo,
        j.titulo,
        j.complexidade,
        j.preco_aluguel_base,
        (j.complexidade * 0.3 + j.preco_aluguel_base * 0.7) as score_recomendacao
    FROM Jogos j
    WHERE j.id_jogo NOT IN (
        SELECT DISTINCT a.id_exemplar 
        FROM Alugueis a 
        JOIN Exemplares e ON a.id_exemplar = e.id_exemplar 
        WHERE a.id_cliente = p_id_cliente
    )
    ORDER BY score_recomendacao DESC
    LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

-- Função para relatório de inadimplência
CREATE OR REPLACE FUNCTION relatorio_inadimplencia(p_dias_atraso_minimo INT DEFAULT 1)
RETURNS TABLE(
    id_cliente INT,
    nome_completo VARCHAR(150),
    email VARCHAR(100),
    total_alugueis_atrasados INT,
    dias_atraso_medio NUMERIC,
    valor_multa_total NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id_cliente,
        c.nome_completo,
        c.email,
        COUNT(*) as total_alugueis_atrasados,
        AVG(CURRENT_DATE - a.data_devolucao_prevista) as dias_atraso_medio,
        COALESCE(SUM(m.valor_multa), 0) as valor_multa_total
    FROM Clientes c
    JOIN Alugueis a ON c.id_cliente = a.id_cliente
    LEFT JOIN Devolucoes d ON a.id_aluguel = d.id_aluguel
    LEFT JOIN Multas m ON d.id_devolucao = m.id_devolucao
    WHERE a.data_devolucao_prevista < CURRENT_DATE
    AND d.id_devolucao IS NULL
    AND (CURRENT_DATE - a.data_devolucao_prevista) >= p_dias_atraso_minimo
    GROUP BY c.id_cliente, c.nome_completo, c.email
    ORDER BY dias_atraso_medio DESC;
END;
$$ LANGUAGE plpgsql;

-- ========= TRIGGERS SIMPLIFICADOS =========

-- Trigger para log de mudanças de preço
CREATE OR REPLACE FUNCTION log_mudanca_preco_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.preco_aluguel_base != NEW.preco_aluguel_base THEN
        INSERT INTO Log_Alteracoes_Preco (id_jogo, preco_anterior, preco_novo)
        VALUES (NEW.id_jogo, OLD.preco_aluguel_base, NEW.preco_aluguel_base);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_log_mudanca_preco
    AFTER UPDATE ON Jogos
    FOR EACH ROW
    EXECUTE FUNCTION log_mudanca_preco_trigger_func();

-- Trigger para notificar devoluções atrasadas
CREATE OR REPLACE FUNCTION notificar_devolucoes_atrasadas_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Aqui você pode adicionar lógica para notificar funcionários
    -- Por exemplo, inserir em uma tabela de notificações
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_notificar_devolucoes_atrasadas
    AFTER INSERT ON Devolucoes
    FOR EACH ROW
    EXECUTE FUNCTION notificar_devolucoes_atrasadas_trigger_func();

-- Trigger para validar integridade de dados
CREATE OR REPLACE FUNCTION validar_integridade_dados_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Validações básicas
    IF NEW.valor_cobrado <= 0 THEN
        RAISE EXCEPTION 'Valor cobrado deve ser maior que zero';
    END IF;
    
    IF NEW.data_devolucao_prevista <= CURRENT_DATE THEN
        RAISE EXCEPTION 'Data de devolução prevista deve ser futura';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validar_integridade_alugueis
    BEFORE INSERT OR UPDATE ON Alugueis
    FOR EACH ROW
    EXECUTE FUNCTION validar_integridade_dados_trigger_func();

CREATE TRIGGER tg_validar_integridade_clientes
    BEFORE INSERT OR UPDATE ON Clientes
    FOR EACH ROW
    EXECUTE FUNCTION validar_integridade_dados_trigger_func();

CREATE TRIGGER tg_validar_integridade_exemplares
    BEFORE INSERT OR UPDATE ON Exemplares
    FOR EACH ROW
    EXECUTE FUNCTION validar_integridade_dados_trigger_func();

-- ========= VIEWS =========

-- View de jogos disponíveis
CREATE OR REPLACE VIEW vw_jogos_disponiveis AS
SELECT 
    j.id_jogo,
    j.titulo,
    j.complexidade,
    j.preco_aluguel_base,
    COUNT(CASE WHEN e.status = 'Disponível' THEN 1 END) as exemplares_disponiveis,
    COUNT(*) as total_exemplares
FROM Jogos j
LEFT JOIN Exemplares e ON j.id_jogo = e.id_jogo
GROUP BY j.id_jogo, j.titulo, j.complexidade, j.preco_aluguel_base
HAVING COUNT(CASE WHEN e.status = 'Disponível' THEN 1 END) > 0;

-- View de alugueis atrasados
CREATE OR REPLACE VIEW vw_alugueis_atrasados AS
SELECT 
    a.id_aluguel,
    c.nome_completo as cliente,
    j.titulo as jogo,
    a.data_aluguel,
    a.data_devolucao_prevista,
    CURRENT_DATE - a.data_devolucao_prevista as dias_atraso,
    a.valor_cobrado
FROM Alugueis a
JOIN Clientes c ON a.id_cliente = c.id_cliente
JOIN Exemplares e ON a.id_exemplar = e.id_exemplar
JOIN Jogos j ON e.id_jogo = j.id_jogo
LEFT JOIN Devolucoes d ON a.id_aluguel = d.id_aluguel
WHERE a.data_devolucao_prevista < CURRENT_DATE
AND d.id_devolucao IS NULL
ORDER BY dias_atraso DESC;

-- ========= ÍNDICES BÁSICOS =========

CREATE INDEX idx_alugueis_id_exemplar ON Alugueis(id_exemplar);
CREATE INDEX idx_alugueis_id_cliente ON Alugueis(id_cliente);
CREATE INDEX idx_alugueis_id_funcionario ON Alugueis(id_funcionario_emprestimo);
CREATE INDEX idx_alugueis_data_aluguel ON Alugueis(data_aluguel);
CREATE INDEX idx_alugueis_data_prevista ON Alugueis(data_devolucao_prevista);
CREATE INDEX idx_devolucoes_id_aluguel ON Devolucoes(id_aluguel);
CREATE INDEX idx_multas_id_devolucao ON Multas(id_devolucao);
CREATE INDEX idx_pagamentos_id_aluguel ON Pagamentos(id_aluguel);
CREATE INDEX idx_pagamentos_id_multa ON Pagamentos(id_multa);
CREATE INDEX idx_exemplares_id_jogo ON Exemplares(id_jogo);
CREATE INDEX idx_exemplares_status ON Exemplares(status);
CREATE INDEX idx_jogos_id_editora ON Jogos(id_editora);
CREATE INDEX idx_jogos_complexidade ON Jogos(complexidade);
CREATE INDEX idx_clientes_email ON Clientes(email);
CREATE INDEX idx_clientes_cpf ON Clientes(cpf);
CREATE INDEX idx_funcionarios_cpf ON Funcionarios(cpf);
CREATE INDEX idx_reservas_id_cliente ON Reservas(id_cliente);
CREATE INDEX idx_reservas_status ON Reservas(status);

-- ========= ROLES SIMPLIFICADOS (APENAS 3) =========

-- Role para gerente (acesso total)
CREATE ROLE gerente_locadora;

-- Role para funcionário (acesso operacional)
CREATE ROLE funcionario_locadora;

-- Role para cliente (acesso limitado)
CREATE ROLE cliente_locadora;

-- ========= PERMISSÕES PARA GERENTE =========
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gerente_locadora;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO gerente_locadora;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO gerente_locadora;

-- ========= PERMISSÕES PARA FUNCIONÁRIO =========
GRANT SELECT, INSERT, UPDATE ON Alugueis TO funcionario_locadora;
GRANT SELECT, INSERT, UPDATE ON Devolucoes TO funcionario_locadora;
GRANT SELECT, INSERT, UPDATE ON Pagamentos TO funcionario_locadora;
GRANT SELECT, INSERT, UPDATE ON Multas TO funcionario_locadora;
GRANT SELECT, INSERT, UPDATE ON Reservas TO funcionario_locadora;
GRANT SELECT ON Clientes TO funcionario_locadora;
GRANT SELECT ON Exemplares TO funcionario_locadora;
GRANT SELECT ON Jogos TO funcionario_locadora;
GRANT SELECT ON vw_jogos_disponiveis TO funcionario_locadora;
GRANT SELECT ON vw_alugueis_atrasados TO funcionario_locadora;
GRANT EXECUTE ON FUNCTION registrar_aluguel TO funcionario_locadora;
GRANT EXECUTE ON FUNCTION registrar_devolucao TO funcionario_locadora;
GRANT EXECUTE ON FUNCTION verificar_disponibilidade_jogo_detalhada TO funcionario_locadora;

-- ========= PERMISSÕES PARA CLIENTE =========
GRANT SELECT ON vw_jogos_disponiveis TO cliente_locadora;
GRANT SELECT ON Jogos TO cliente_locadora;
GRANT SELECT ON Categorias TO cliente_locadora;
GRANT SELECT ON Mecanicas TO cliente_locadora;
GRANT SELECT ON Editoras TO cliente_locadora;
GRANT SELECT ON Designers TO cliente_locadora;
GRANT EXECUTE ON FUNCTION verificar_disponibilidade_jogo_detalhada TO cliente_locadora;
GRANT EXECUTE ON FUNCTION recomendar_jogos_cliente TO cliente_locadora;

-- ========= POLÍTICAS DE SEGURANÇA =========

-- Política para clientes só verem seus próprios dados
CREATE POLICY cliente_own_data ON Clientes
    FOR SELECT TO cliente_locadora
    USING (id_cliente = current_setting('app.current_user_id')::INT);

-- Política para funcionários verem dados de clientes para atendimento
CREATE POLICY funcionario_view_clients ON Clientes
    FOR SELECT TO funcionario_locadora
    USING (true);

-- Política para funcionários atualizarem alugueis
CREATE POLICY funcionario_manage_rentals ON Alugueis
    FOR ALL TO funcionario_locadora
    USING (true)
    WITH CHECK (true);

-- ========= COMENTÁRIOS =========

COMMENT ON TABLE Clientes IS 'Tabela de clientes da locadora com telefone como atributo direto';
COMMENT ON TABLE Alugueis IS 'Registro de alugueis de jogos';
COMMENT ON TABLE Devolucoes IS 'Registro de devoluções de jogos';
COMMENT ON TABLE Jogos IS 'Catálogo de jogos disponíveis para aluguel';
COMMENT ON TABLE Exemplares IS 'Exemplares físicos dos jogos';
COMMENT ON FUNCTION registrar_aluguel IS 'Função para registrar novo aluguel';
COMMENT ON FUNCTION registrar_devolucao IS 'Função para registrar devolução';
COMMENT ON VIEW vw_jogos_disponiveis IS 'View com jogos que possuem exemplares disponíveis';
COMMENT ON VIEW vw_alugueis_atrasados IS 'View com alugueis em atraso'; 