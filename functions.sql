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

CREATE OR REPLACE FUNCTION buscar_jogos_por_mecanica(p_nome_mecanica VARCHAR(100))
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
    JOIN Jogo_Mecanica jm ON j.id_jogo = jm.id_jogo
    JOIN Mecanicas m ON jm.id_mecanica = m.id_mecanica
    WHERE m.nome_mecanica = p_nome_mecanica
    ORDER BY j.titulo;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buscar_jogos_por_designer(p_nome_designer VARCHAR(100))
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
    JOIN Jogo_Designer jd ON j.id_jogo = jd.id_jogo
    JOIN Designers d ON jd.id_designer = d.id_designer
    WHERE d.nome_designer = p_nome_designer
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

CREATE OR REPLACE FUNCTION buscar_jogos_por_jogadores(p_num_jogadores INT)
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
    WHERE j.min_jogadores <= p_num_jogadores AND j.max_jogadores >= p_num_jogadores
    ORDER BY j.titulo;
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