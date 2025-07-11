CREATE OR REPLACE FUNCTION verificar_disponibilidade_jogo(p_id_jogo INT)
RETURNS TABLE (
    id_exemplar INT,
    codigo_barras VARCHAR(50),
    status VARCHAR(20),
    disponivel BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id_exemplar,
        e.codigo_barras,
        e.status,
        CASE 
            WHEN e.status = 'Disponível' THEN true
            ELSE false
        END as disponivel
    FROM Exemplares e
    WHERE e.id_jogo = p_id_jogo
    ORDER BY e.id_exemplar;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calcular_multa_atraso(
    p_data_devolucao_prevista DATE,
    p_data_devolucao_efetiva TIMESTAMP WITH TIME ZONE,
    p_valor_aluguel NUMERIC(8, 2)
)
RETURNS NUMERIC(8, 2) AS $$
DECLARE
    dias_atraso INT;
    valor_multa NUMERIC(8, 2);
BEGIN
    dias_atraso := EXTRACT(DAY FROM (p_data_devolucao_efetiva::DATE - p_data_devolucao_prevista));
    
    IF dias_atraso <= 0 THEN
        RETURN 0;
    END IF;
    
    valor_multa := p_valor_aluguel * 0.10 * dias_atraso;
    
    IF valor_multa > p_valor_aluguel THEN
        valor_multa := p_valor_aluguel;
    END IF;
    
    RETURN valor_multa;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buscar_jogos_por_categoria(p_nome_categoria VARCHAR(50))
RETURNS TABLE (
    id_jogo INT,
    titulo VARCHAR(150),
    descricao TEXT,
    ano_lancamento INT,
    min_jogadores INT,
    max_jogadores INT,
    tempo_medio_minutos INT,
    complexidade NUMERIC(3, 1),
    preco_aluguel_base NUMERIC(8, 2),
    nome_editora VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        j.id_jogo,
        j.titulo,
        j.descricao,
        j.ano_lancamento,
        j.min_jogadores,
        j.max_jogadores,
        j.tempo_medio_minutos,
        j.complexidade,
        j.preco_aluguel_base,
        e.nome_editora
    FROM Jogos j
    JOIN Editoras e ON j.id_editora = e.id_editora
    JOIN Jogo_Categoria jc ON j.id_jogo = jc.id_jogo
    JOIN Categorias c ON jc.id_categoria = c.id_categoria
    WHERE c.nome_categoria = p_nome_categoria
    ORDER BY j.titulo;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buscar_jogos_por_preco(
    p_preco_minimo NUMERIC(8, 2),
    p_preco_maximo NUMERIC(8, 2)
)
RETURNS TABLE (
    id_jogo INT,
    titulo VARCHAR(150),
    descricao TEXT,
    ano_lancamento INT,
    min_jogadores INT,
    max_jogadores INT,
    tempo_medio_minutos INT,
    complexidade NUMERIC(3, 1),
    preco_aluguel_base NUMERIC(8, 2),
    nome_editora VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        j.id_jogo,
        j.titulo,
        j.descricao,
        j.ano_lancamento,
        j.min_jogadores,
        j.max_jogadores,
        j.tempo_medio_minutos,
        j.complexidade,
        j.preco_aluguel_base,
        e.nome_editora
    FROM Jogos j
    JOIN Editoras e ON j.id_editora = e.id_editora
    WHERE j.preco_aluguel_base BETWEEN p_preco_minimo AND p_preco_maximo
    ORDER BY j.preco_aluguel_base;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buscar_jogos_por_tempo(
    p_tempo_maximo_minutos INT
)
RETURNS TABLE (
    id_jogo INT,
    titulo VARCHAR(150),
    descricao TEXT,
    ano_lancamento INT,
    min_jogadores INT,
    max_jogadores INT,
    tempo_medio_minutos INT,
    complexidade NUMERIC(3, 1),
    preco_aluguel_base NUMERIC(8, 2),
    nome_editora VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        j.id_jogo,
        j.titulo,
        j.descricao,
        j.ano_lancamento,
        j.min_jogadores,
        j.max_jogadores,
        j.tempo_medio_minutos,
        j.complexidade,
        j.preco_aluguel_base,
        e.nome_editora
    FROM Jogos j
    JOIN Editoras e ON j.id_editora = e.id_editora
    WHERE j.tempo_medio_minutos <= p_tempo_maximo_minutos
    ORDER BY j.tempo_medio_minutos;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buscar_jogos_por_complexidade(
    p_complexidade_minima NUMERIC(3, 1),
    p_complexidade_maxima NUMERIC(3, 1)
)
RETURNS TABLE (
    id_jogo INT,
    titulo VARCHAR(150),
    descricao TEXT,
    ano_lancamento INT,
    min_jogadores INT,
    max_jogadores INT,
    tempo_medio_minutos INT,
    complexidade NUMERIC(3, 1),
    preco_aluguel_base NUMERIC(8, 2),
    nome_editora VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        j.id_jogo,
        j.titulo,
        j.descricao,
        j.ano_lancamento,
        j.min_jogadores,
        j.max_jogadores,
        j.tempo_medio_minutos,
        j.complexidade,
        j.preco_aluguel_base,
        e.nome_editora
    FROM Jogos j
    JOIN Editoras e ON j.id_editora = e.id_editora
    WHERE j.complexidade BETWEEN p_complexidade_minima AND p_complexidade_maxima
    ORDER BY j.complexidade;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION registrar_aluguel(
    p_id_exemplar INT,
    p_id_cliente INT,
    p_id_funcionario INT,
    p_data_devolucao_prevista DATE,
    p_valor_cobrado NUMERIC(8, 2)
)
RETURNS INT AS $$
DECLARE
    v_id_aluguel INT;
    v_status_exemplar VARCHAR(20);
BEGIN
    SELECT status INTO v_status_exemplar
    FROM Exemplares
    WHERE id_exemplar = p_id_exemplar;
    
    IF v_status_exemplar != 'Disponível' THEN
        RAISE EXCEPTION 'Exemplar não está disponível para aluguel';
    END IF;
    
    INSERT INTO Alugueis (id_exemplar, id_cliente, id_funcionario_emprestimo, 
                          data_aluguel, data_devolucao_prevista, valor_cobrado)
    VALUES (p_id_exemplar, p_id_cliente, p_id_funcionario, 
            CURRENT_TIMESTAMP, p_data_devolucao_prevista, p_valor_cobrado)
    RETURNING id_aluguel INTO v_id_aluguel;
    
    UPDATE Exemplares 
    SET status = 'Alugado'
    WHERE id_exemplar = p_id_exemplar;
    
    RETURN v_id_aluguel;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calcular_faturamento_periodo(
    p_data_inicio DATE,
    p_data_fim DATE
)
RETURNS TABLE (
    periodo VARCHAR(20),
    total_alugueis NUMERIC(10, 2),
    total_multas NUMERIC(10, 2),
    total_receita NUMERIC(10, 2),
    quantidade_alugueis BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        'Período Especificado' as periodo,
        COALESCE(SUM(a.valor_cobrado), 0) as total_alugueis,
        COALESCE(SUM(m.valor_multa), 0) as total_multas,
        COALESCE(SUM(a.valor_cobrado), 0) + COALESCE(SUM(m.valor_multa), 0) as total_receita,
        COUNT(a.id_aluguel) as quantidade_alugueis
    FROM Alugueis a
    LEFT JOIN Devolucoes d ON a.id_aluguel = d.id_aluguel
    LEFT JOIN Multas m ON d.id_devolucao = m.id_devolucao
    WHERE a.data_aluguel::DATE BETWEEN p_data_inicio AND p_data_fim;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION recomendar_jogos_clientes(
    p_id_cliente INT
)
RETURNS TABLE (
    id_jogo INT,
    titulo VARCHAR(150),
    descricao TEXT,
    preco_aluguel_base NUMERIC(8, 2),
    nome_editora VARCHAR(100),
    score_recomendacao NUMERIC(5, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        j.id_jogo,
        j.titulo,
        j.descricao,
        j.preco_aluguel_base,
        e.nome_editora,
        ROUND(
            (COUNT(a.id_aluguel) * 0.4 + 
             AVG(j.complexidade) * 0.3 + 
             (1.0 / j.preco_aluguel_base) * 100 * 0.3)::NUMERIC, 2
        ) as score_recomendacao
    FROM Jogos j
    JOIN Editoras e ON j.id_editora = e.id_editora
    LEFT JOIN Exemplares ex ON j.id_jogo = ex.id_jogo
    LEFT JOIN Alugueis a ON ex.id_exemplar = a.id_exemplar
    WHERE j.id_jogo NOT IN (
        SELECT DISTINCT j2.id_jogo
        FROM Jogos j2
        JOIN Exemplares ex2 ON j2.id_jogo = ex2.id_jogo
        JOIN Alugueis a2 ON ex2.id_exemplar = a2.id_exemplar
        WHERE a2.id_cliente = p_id_cliente
    )
    GROUP BY j.id_jogo, j.titulo, j.descricao, j.preco_aluguel_base, e.nome_editora
    ORDER BY score_recomendacao DESC
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION registrar_devolução(
    p_id_aluguel INT,
    p_id_funcionario INT,
    p_observacoes TEXT DEFAULT NULL
)
RETURNS INT AS $$
DECLARE
    v_id_devolucao INT;
    v_id_exemplar INT;
    v_data_devolucao_prevista DATE;
    v_valor_multa NUMERIC(8, 2);
BEGIN
    SELECT id_exemplar, data_devolucao_prevista 
    INTO v_id_exemplar, v_data_devolucao_prevista
    FROM Alugueis
    WHERE id_aluguel = p_id_aluguel;
    
    IF v_id_exemplar IS NULL THEN
        RAISE EXCEPTION 'Aluguel não encontrado';
    END IF;
    
    INSERT INTO Devolucoes (id_aluguel, id_funcionario_recebimento, 
                            data_devolucao_efetiva, observacoes)
    VALUES (p_id_aluguel, p_id_funcionario, CURRENT_TIMESTAMP, p_observacoes)
    RETURNING id_devolucao INTO v_id_devolucao;
    
    UPDATE Exemplares 
    SET status = 'Disponível'
    WHERE id_exemplar = v_id_exemplar;
    
    IF CURRENT_DATE > v_data_devolucao_prevista THEN
        v_valor_multa := calcular_multa_atraso(
            v_data_devolucao_prevista, 
            CURRENT_TIMESTAMP, 
            (SELECT valor_cobrado FROM Alugueis WHERE id_aluguel = p_id_aluguel)
        );
        
        IF v_valor_multa > 0 THEN
            INSERT INTO Multas (id_devolucao, valor_multa, motivo, paga)
            VALUES (v_id_devolucao, v_valor_multa, 'Atraso na devolução', false);
        END IF;
    END IF;
    
    RETURN v_id_devolucao;
END;
$$ LANGUAGE plpgsql; 