SELECT * FROM vw_jogos_completos ORDER BY titulo;

SELECT * FROM buscar_jogos_por_categoria('Estratégia');

SELECT * FROM buscar_jogos_por_mecanica('Worker Placement');

SELECT * FROM buscar_jogos_por_designer('Reiner Knizia');

SELECT * FROM buscar_jogos_por_preco(15.00, 30.00);

SELECT * FROM buscar_jogos_por_jogadores(4);

SELECT * FROM buscar_jogos_por_tempo(60);

SELECT * FROM buscar_jogos_por_complexidade(2.0, 3.0);

SELECT * FROM verificar_disponibilidade_jogo(1);

SELECT 
    j.titulo,
    e.codigo_barras,
    e.status
FROM Exemplares e
JOIN Jogos j ON e.id_jogo = j.id_jogo
WHERE e.status = 'Disponível'
ORDER BY j.titulo;

SELECT * FROM vw_alugueis_detalhados 
WHERE status_aluguel != 'Devolvido'
ORDER BY data_aluguel DESC;

SELECT * FROM vw_alugueis_detalhados 
WHERE status_aluguel = 'Atrasado'
ORDER BY data_devolucao_prevista;

SELECT 
    nome_cliente,
    COUNT(*) as total_alugueis,
    SUM(valor_cobrado) as valor_total
FROM vw_alugueis_detalhados
GROUP BY nome_cliente
ORDER BY total_alugueis DESC;

SELECT * FROM vw_devolucoes_detalhadas 
WHERE status_devolucao = 'Atrasada'
ORDER BY dias_atraso DESC;

SELECT 
    funcionario_devolucao,
    COUNT(*) as total_devolucoes,
    COUNT(CASE WHEN status_devolucao = 'Atrasada' THEN 1 END) as devolucoes_atrasadas
FROM vw_devolucoes_detalhadas
GROUP BY funcionario_devolucao
ORDER BY total_devolucoes DESC;

SELECT * FROM vw_multas_detalhadas 
WHERE status_pagamento = 'Pendente'
ORDER BY valor_multa DESC;

SELECT 
    nome_cliente,
    COUNT(*) as total_multas,
    SUM(valor_multa) as valor_total_multas
FROM vw_multas_detalhadas
GROUP BY nome_cliente
ORDER BY valor_total_multas DESC;

SELECT 
    metodo_pagamento,
    COUNT(*) as total_pagamentos,
    SUM(valor) as valor_total
FROM vw_pagamentos_detalhados
GROUP BY metodo_pagamento
ORDER BY valor_total DESC;

SELECT 
    DATE(data_pagamento) as data,
    COUNT(*) as total_pagamentos,
    SUM(valor) as valor_total
FROM vw_pagamentos_detalhados
WHERE data_pagamento >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(data_pagamento)
ORDER BY data;

SELECT * FROM vw_reservas_detalhadas 
WHERE status = 'Ativa'
ORDER BY data_reserva;

SELECT 
    titulo_jogo,
    COUNT(*) as total_reservas,
    COUNT(CASE WHEN status = 'Ativa' THEN 1 END) as reservas_ativas
FROM vw_reservas_detalhadas
GROUP BY titulo_jogo
ORDER BY total_reservas DESC;

SELECT * FROM vw_estatisticas_loja;

SELECT * FROM vw_jogos_populares LIMIT 10;

SELECT * FROM vw_clientes_historico 
ORDER BY total_alugueis DESC;

SELECT * FROM vw_log_alteracoes_preco 
WHERE data_alteracao >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY data_alteracao DESC;

SELECT 
    titulo_jogo,
    COUNT(*) as total_alteracoes,
    AVG(percentual_alteracao) as media_alteracao
FROM vw_log_alteracoes_preco
GROUP BY titulo_jogo
ORDER BY total_alteracoes DESC;

SELECT 
    nome_completo,
    total_alugueis,
    valor_total_alugueis,
    valor_total_multas,
    (valor_total_alugueis - valor_total_multas) as valor_liquido
FROM vw_clientes_historico
ORDER BY valor_liquido DESC
LIMIT 5;

SELECT 
    j.titulo,
    COUNT(a.id_aluguel) as total_alugueis,
    AVG(a.valor_cobrado) as valor_medio,
    COUNT(e2.id_exemplar) as total_exemplares,
    ROUND((COUNT(a.id_aluguel) * AVG(a.valor_cobrado) / COUNT(e2.id_exemplar))::NUMERIC, 2) as rentabilidade_por_exemplar
FROM Jogos j
LEFT JOIN Exemplares e2 ON j.id_jogo = e2.id_jogo
LEFT JOIN Alugueis a ON e2.id_exemplar = a.id_exemplar
GROUP BY j.id_jogo, j.titulo
HAVING COUNT(e2.id_exemplar) > 0
ORDER BY rentabilidade_por_exemplar DESC;

SELECT 
    EXTRACT(MONTH FROM a.data_aluguel) as mes,
    COUNT(*) as total_alugueis,
    SUM(a.valor_cobrado) as faturamento
FROM Alugueis a
WHERE a.data_aluguel >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY EXTRACT(MONTH FROM a.data_aluguel)
ORDER BY mes;

SELECT 
    j.titulo,
    e.codigo_barras,
    e.status
FROM Exemplares e
JOIN Jogos j ON e.id_jogo = j.id_jogo
WHERE e.status = 'Manutenção'
ORDER BY j.titulo;

SELECT 
    j.titulo,
    e.codigo_barras,
    e.status
FROM Exemplares e
JOIN Jogos j ON e.id_jogo = j.id_jogo
WHERE e.status = 'Perdido'
ORDER BY j.titulo;

SELECT 
    f.nome_completo,
    l.nome_loja,
    COUNT(a.id_aluguel) as total_alugueis_processados
FROM Funcionarios f
JOIN Lojas l ON f.id_loja = l.id_loja
LEFT JOIN Alugueis a ON f.id_funcionario = a.id_funcionario_emprestimo
GROUP BY f.id_funcionario, f.nome_completo, l.nome_loja
ORDER BY total_alugueis_processados DESC;

SELECT 
    f.nome_completo,
    l.nome_loja,
    COUNT(d.id_devolucao) as total_devolucoes_processadas
FROM Funcionarios f
JOIN Lojas l ON f.id_loja = l.id_loja
LEFT JOIN Devolucoes d ON f.id_funcionario = d.id_funcionario_recebimento
GROUP BY f.id_funcionario, f.nome_completo, l.nome_loja
ORDER BY total_devolucoes_processadas DESC;

SELECT 
    j.titulo,
    STRING_AGG(DISTINCT c.nome_categoria, ', ' ORDER BY c.nome_categoria) as categorias,
    STRING_AGG(DISTINCT m.nome_mecanica, ', ' ORDER BY m.nome_mecanica) as mecanicas,
    STRING_AGG(DISTINCT d.nome_designer, ', ' ORDER BY d.nome_designer) as designers
FROM Jogos j
LEFT JOIN Jogo_Categoria jc ON j.id_jogo = jc.id_jogo
LEFT JOIN Categorias c ON jc.id_categoria = c.id_categoria
LEFT JOIN Jogo_Mecanica jm ON j.id_jogo = jm.id_jogo
LEFT JOIN Mecanicas m ON jm.id_mecanica = m.id_mecanica
LEFT JOIN Jogo_Designer jd ON j.id_jogo = jd.id_jogo
LEFT JOIN Designers d ON jd.id_designer = d.id_designer
GROUP BY j.id_jogo, j.titulo
ORDER BY j.titulo;

SELECT 
    c.nome_completo,
    j.titulo,
    han.motivo,
    han.data_tentativa
FROM Historico_Aluguel_Negado han
JOIN Clientes c ON han.id_cliente = c.id_cliente
JOIN Exemplares e ON han.id_exemplar = e.id_exemplar
JOIN Jogos j ON e.id_jogo = j.id_jogo
ORDER BY han.data_tentativa DESC;

SELECT 
    j.titulo,
    c.nome_completo,
    hdp.tipo_problema,
    hdp.descricao,
    hdp.data_registro
FROM Historico_Devolucao_Problematica hdp
JOIN Devolucoes d ON hdp.id_devolucao = d.id_devolucao
JOIN Alugueis a ON d.id_aluguel = a.id_aluguel
JOIN Clientes c ON a.id_cliente = c.id_cliente
JOIN Exemplares e ON a.id_exemplar = e.id_exemplar
JOIN Jogos j ON e.id_jogo = j.id_jogo
ORDER BY hdp.data_registro DESC;

SELECT 
    (SELECT COUNT(*) FROM Clientes) as total_clientes,
    (SELECT COUNT(*) FROM Jogos) as total_jogos,
    (SELECT COUNT(*) FROM Exemplares WHERE status = 'Disponível') as exemplares_disponiveis,
    (SELECT COUNT(*) FROM Alugueis WHERE data_aluguel >= CURRENT_DATE - INTERVAL '30 days') as alugueis_ultimo_mes,
    (SELECT COALESCE(SUM(valor_cobrado), 0) FROM Alugueis WHERE data_aluguel >= CURRENT_DATE - INTERVAL '30 days') as faturamento_ultimo_mes,
    (SELECT COUNT(*) FROM Alugueis WHERE data_devolucao_prevista < CURRENT_DATE AND id_aluguel NOT IN (SELECT id_aluguel FROM Devolucoes)) as alugueis_atrasados;

SELECT 
    'Jogos por Complexidade' as categoria,
    CASE 
        WHEN complexidade < 2.0 THEN 'Iniciante'
        WHEN complexidade < 3.0 THEN 'Intermediário'
        WHEN complexidade < 4.0 THEN 'Avançado'
        ELSE 'Expert'
    END as nivel,
    COUNT(*) as quantidade
FROM Jogos
GROUP BY 
    CASE 
        WHEN complexidade < 2.0 THEN 'Iniciante'
        WHEN complexidade < 3.0 THEN 'Intermediário'
        WHEN complexidade < 4.0 THEN 'Avançado'
        ELSE 'Expert'
    END
ORDER BY 
    CASE nivel
        WHEN 'Iniciante' THEN 1
        WHEN 'Intermediário' THEN 2
        WHEN 'Avançado' THEN 3
        WHEN 'Expert' THEN 4
    END; 