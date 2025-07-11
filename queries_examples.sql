-- Mostra quantos exemplares cada jogo tem e quantos estão disponíveis
SELECT j.titulo, COUNT(e.id_exemplar) as total_exemplares,
       COUNT(CASE WHEN e.status = 'Disponível' THEN 1 END) as disponiveis
FROM Jogos j
LEFT JOIN Exemplares e ON j.id_jogo = e.id_jogo
GROUP BY j.id_jogo, j.titulo
ORDER BY total_exemplares DESC;


-- Encontra jogos com alta complexidade mas tempo de jogo reduzido
SELECT j.titulo, j.complexidade, j.tempo_medio_minutos
FROM Jogos j
WHERE j.complexidade >= 3.0 AND j.tempo_medio_minutos <= 60
ORDER BY j.complexidade DESC;


-- Identifica jogos que geram mais receita por aluguel
SELECT j.titulo, AVG(a.valor_cobrado) as valor_medio_aluguel
FROM Jogos j
JOIN Exemplares e ON j.id_jogo = e.id_jogo
JOIN Alugueis a ON e.id_exemplar = a.id_exemplar
GROUP BY j.id_jogo, j.titulo
HAVING AVG(a.valor_cobrado) > 50
ORDER BY valor_medio_aluguel DESC;


-- Mostra receita e quantidade de alugueis por mês/ano
SELECT EXTRACT(YEAR FROM a.data_aluguel) as ano,
       EXTRACT(MONTH FROM a.data_aluguel) as mes,
       COUNT(a.id_aluguel) as total_alugueis,
       SUM(a.valor_cobrado) as receita_total
FROM Alugueis a
GROUP BY EXTRACT(YEAR FROM a.data_aluguel), EXTRACT(MONTH FROM a.data_aluguel)
ORDER BY ano DESC, mes DESC;

-- Mostra os jogos mais populares e quantos clientes únicos os alugaram
SELECT j.titulo, COUNT(a.id_aluguel) as total_alugueis,
       COUNT(DISTINCT a.id_cliente) as clientes_unicos
FROM Jogos j
JOIN Exemplares e ON j.id_jogo = e.id_jogo
JOIN Alugueis a ON e.id_exemplar = a.id_exemplar
GROUP BY j.id_jogo, j.titulo
ORDER BY total_alugueis DESC
LIMIT 10;




-- Mostra evolução dos alugueis por mês com comparação com período anterior
-- Usa índice idx_alugueis_data para otimizar filtro por data
SELECT 
    TO_CHAR(data_aluguel, 'YYYY-MM') as mes_ano,
    COUNT(*) as total_alugueis,
    COUNT(DISTINCT id_cliente) as clientes_unicos,
    AVG(valor_cobrado) as ticket_medio,
    SUM(valor_cobrado) as faturamento_total,
    LAG(COUNT(*)) OVER (ORDER BY TO_CHAR(data_aluguel, 'YYYY-MM')) as alugueis_mes_anterior,
    ROUND(
        (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY TO_CHAR(data_aluguel, 'YYYY-MM'))) * 100.0 / 
        NULLIF(LAG(COUNT(*)) OVER (ORDER BY TO_CHAR(data_aluguel, 'YYYY-MM')), 0), 2
    ) as crescimento_percentual
FROM Alugueis
WHERE data_aluguel >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY TO_CHAR(data_aluguel, 'YYYY-MM')
ORDER BY mes_ano;


-- Mostra padrões sazonais de alugueis por mês e dia da semana
-- Usa índices: idx_alugueis_data, idx_exemplares_jogo, idx_jogos_titulo
WITH alugueis_sazonais AS (
    SELECT 
        j.titulo,
        EXTRACT(MONTH FROM a.data_aluguel) as mes,
        EXTRACT(DOW FROM a.data_aluguel) as dia_semana,
        COUNT(*) as total_alugueis,
        AVG(a.valor_cobrado) as valor_medio
    FROM Alugueis a
    JOIN Exemplares e ON a.id_exemplar = e.id_exemplar
    JOIN Jogos j ON e.id_jogo = j.id_jogo
    WHERE a.data_aluguel >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY j.titulo, EXTRACT(MONTH FROM a.data_aluguel), EXTRACT(DOW FROM a.data_aluguel)
)
SELECT 
    titulo,
    mes,
    dia_semana,
    total_alugueis,
    valor_medio,
    ROUND(
        total_alugueis * 100.0 / SUM(total_alugueis) OVER (PARTITION BY titulo), 2
    ) as percentual_mes
FROM alugueis_sazonais
WHERE total_alugueis > 0
ORDER BY titulo, mes, dia_semana;


-- Análise completa de performance com métricas de qualidade
-- Usa índices: idx_alugueis_funcionario, idx_devolucoes_aluguel, idx_funcionarios_loja
WITH performance_funcionarios AS (
    SELECT 
        f.id_funcionario,
        f.nome_completo,
        l.nome_loja,
        cg.nome_cargo,
        COUNT(a.id_aluguel) as total_alugueis_processados,
        COUNT(d.id_devolucao) as total_devolucoes_processadas,
        SUM(a.valor_cobrado) as faturamento_gerado,
        AVG(a.valor_cobrado) as ticket_medio,
        COUNT(CASE WHEN a.data_aluguel >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as alugueis_30_dias,
        COUNT(CASE WHEN d.data_devolucao_efetiva > a.data_devolucao_prevista THEN 1 END) as devolucoes_atrasadas
    FROM Funcionarios f
    JOIN Lojas l ON f.id_loja = l.id_loja
    JOIN Cargos cg ON f.id_cargo = cg.id_cargo
    LEFT JOIN Alugueis a ON f.id_funcionario = a.id_funcionario_emprestimo
    LEFT JOIN Devolucoes d ON f.id_funcionario = d.id_funcionario_recebimento
    GROUP BY f.id_funcionario, f.nome_completo, l.nome_loja, cg.nome_cargo
)
SELECT 
    nome_completo,
    nome_loja,
    nome_cargo,
    total_alugueis_processados,
    total_devolucoes_processadas,
    faturamento_gerado,
    ticket_medio,
    alugueis_30_dias,
    devolucoes_atrasadas,
    ROUND(
        (total_alugueis_processados + total_devolucoes_processadas) * 100.0 / 
        NULLIF(SUM(total_alugueis_processados + total_devolucoes_processadas) OVER (), 0), 2
    ) as percentual_operacoes,
    CASE 
        WHEN alugueis_30_dias >= 50 AND devolucoes_atrasadas = 0 THEN 'Excelente'
        WHEN alugueis_30_dias >= 30 AND devolucoes_atrasadas <= 2 THEN 'Bom'
        WHEN alugueis_30_dias >= 15 THEN 'Regular'
        ELSE 'Abaixo da média'
    END as avaliacao_performance
FROM performance_funcionarios
ORDER BY faturamento_gerado DESC;


-- Calcula ROI e métricas financeiras para cada jogo
-- Usa índices: idx_exemplares_jogo, idx_exemplares_status, idx_jogos_editora
WITH rentabilidade_jogos AS (
    SELECT 
        j.id_jogo,
        j.titulo,
        j.preco_aluguel_base,
        ed.nome_editora,
        COUNT(a.id_aluguel) as total_alugueis,
        SUM(a.valor_cobrado) as faturamento_total,
        AVG(a.valor_cobrado) as ticket_medio,
        COUNT(e.id_exemplar) as total_exemplares,
        COUNT(CASE WHEN e.status = 'Disponível' THEN 1 END) as exemplares_disponiveis,
        -- Estimativa de custo: R$ 200 por exemplar + manutenção
        (COUNT(e.id_exemplar) * 200) as custo_estimado,
        SUM(a.valor_cobrado) - (COUNT(e.id_exemplar) * 200) as lucro_estimado
    FROM Jogos j
    JOIN Editoras ed ON j.id_editora = ed.id_editora
    LEFT JOIN Exemplares e ON j.id_jogo = e.id_jogo
    LEFT JOIN Alugueis a ON e.id_exemplar = a.id_exemplar
    GROUP BY j.id_jogo, j.titulo, j.preco_aluguel_base, ed.nome_editora
)
SELECT 
    titulo,
    nome_editora,
    total_alugueis,
    faturamento_total,
    ticket_medio,
    total_exemplares,
    exemplares_disponiveis,
    custo_estimado,
    lucro_estimado,
    ROUND(
        CASE 
            WHEN custo_estimado > 0 THEN (lucro_estimado * 100.0 / custo_estimado)
            ELSE 0 
        END, 2
    ) as roi_percentual,
    ROUND(
        CASE 
            WHEN total_exemplares > 0 THEN total_alugueis * 100.0 / total_exemplares
            ELSE 0 
        END, 2
    ) as taxa_utilizacao
FROM rentabilidade_jogos
WHERE total_alugueis > 0
ORDER BY lucro_estimado DESC;


-- Correlaciona características dos jogos com seu sucesso comercial
-- Usa índices: idx_exemplares_jogo, idx_alugueis_cliente, idx_alugueis_data
WITH correlacao_jogos AS (
    SELECT 
        j.id_jogo,
        j.titulo,
        j.complexidade,
        j.min_jogadores,
        j.max_jogadores,
        j.tempo_medio_minutos,
        COUNT(a.id_aluguel) as total_alugueis,
        AVG(a.valor_cobrado) as valor_medio,
        COUNT(DISTINCT a.id_cliente) as clientes_unicos,
        COUNT(CASE WHEN a.data_aluguel >= CURRENT_DATE - INTERVAL '90 days' THEN 1 END) as alugueis_90_dias,
        STRING_AGG(DISTINCT cat.nome_categoria, ', ') as categorias,
        STRING_AGG(DISTINCT mec.nome_mecanica, ', ') as mecanicas
    FROM Jogos j
    LEFT JOIN Exemplares e ON j.id_jogo = e.id_jogo
    LEFT JOIN Alugueis a ON e.id_exemplar = a.id_exemplar
    LEFT JOIN Jogo_Categoria jc ON j.id_jogo = jc.id_jogo
    LEFT JOIN Categorias cat ON jc.id_categoria = cat.id_categoria
    LEFT JOIN Jogo_Mecanica jm ON j.id_jogo = jm.id_jogo
    LEFT JOIN Mecanicas mec ON jm.id_mecanica = mec.id_mecanica
    GROUP BY j.id_jogo, j.titulo, j.complexidade, j.min_jogadores, j.max_jogadores, j.tempo_medio_minutos
)
SELECT 
    titulo,
    complexidade,
    min_jogadores,
    max_jogadores,
    tempo_medio_minutos,
    total_alugueis,
    valor_medio,
    clientes_unicos,
    alugueis_90_dias,
    categorias,
    mecanicas,
    CASE 
        WHEN total_alugueis >= 50 THEN 'Muito Popular'
        WHEN total_alugueis >= 20 THEN 'Popular'
        WHEN total_alugueis >= 5 THEN 'Moderado'
        ELSE 'Pouco Popular'
    END as nivel_popularidade,
    CASE 
        WHEN alugueis_90_dias >= 10 THEN 'Tendência Crescente'
        WHEN alugueis_90_dias >= 5 THEN 'Estável'
        ELSE 'Declínio'
    END as tendencia_recente
FROM correlacao_jogos
ORDER BY total_alugueis DESC, alugueis_90_dias DESC;

