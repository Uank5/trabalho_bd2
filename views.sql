CREATE OR REPLACE VIEW vw_jogos_completos AS
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
    e.nome_editora,
    STRING_AGG(DISTINCT c.nome_categoria, ', ' ORDER BY c.nome_categoria) as categorias,
    STRING_AGG(DISTINCT m.nome_mecanica, ', ' ORDER BY m.nome_mecanica) as mecanicas,
    STRING_AGG(DISTINCT d.nome_designer, ', ' ORDER BY d.nome_designer) as designers,
    COUNT(e2.id_exemplar) as total_exemplares,
    COUNT(CASE WHEN e2.status = 'Disponível' THEN 1 END) as exemplares_disponiveis
FROM Jogos j
JOIN Editoras e ON j.id_editora = e.id_editora
LEFT JOIN Jogo_Categoria jc ON j.id_jogo = jc.id_jogo
LEFT JOIN Categorias c ON jc.id_categoria = c.id_categoria
LEFT JOIN Jogo_Mecanica jm ON j.id_jogo = jm.id_jogo
LEFT JOIN Mecanicas m ON jm.id_mecanica = m.id_mecanica
LEFT JOIN Jogo_Designer jd ON j.id_jogo = jd.id_jogo
LEFT JOIN Designers d ON jd.id_designer = d.id_designer
LEFT JOIN Exemplares e2 ON j.id_jogo = e2.id_jogo
GROUP BY j.id_jogo, j.titulo, j.descricao, j.ano_lancamento, j.min_jogadores, 
         j.max_jogadores, j.tempo_medio_minutos, j.complexidade, j.preco_aluguel_base, e.nome_editora;

CREATE OR REPLACE VIEW vw_alugueis_detalhados AS
SELECT 
    a.id_aluguel,
    a.data_aluguel,
    a.data_devolucao_prevista,
    a.valor_cobrado,
    c.nome_completo as nome_cliente,
    c.email as email_cliente,
    c.telefone as telefone_cliente,
    f.nome_completo as nome_funcionario,
    j.titulo as titulo_jogo,
    e.codigo_barras,
    e.status as status_exemplar,
    l.nome_loja,
    CASE 
        WHEN d.id_devolucao IS NOT NULL THEN 'Devolvido'
        WHEN a.data_devolucao_prevista < CURRENT_DATE THEN 'Atrasado'
        ELSE 'Em dia'
    END as status_aluguel,
    CASE 
        WHEN d.id_devolucao IS NOT NULL THEN d.data_devolucao_efetiva
        ELSE NULL
    END as data_devolucao_efetiva
FROM Alugueis a
JOIN Clientes c ON a.id_cliente = c.id_cliente
JOIN Funcionarios f ON a.id_funcionario_emprestimo = f.id_funcionario
JOIN Lojas l ON f.id_loja = l.id_loja
JOIN Exemplares e ON a.id_exemplar = e.id_exemplar
JOIN Jogos j ON e.id_jogo = j.id_jogo
LEFT JOIN Devolucoes d ON a.id_aluguel = d.id_aluguel;

CREATE OR REPLACE VIEW vw_devolucoes_detalhadas AS
SELECT 
    d.id_devolucao,
    d.data_devolucao_efetiva,
    d.observacoes,
    a.data_aluguel,
    a.data_devolucao_prevista,
    a.valor_cobrado,
    c.nome_completo as nome_cliente,
    c.email as email_cliente,
    f_emprestimo.nome_completo as funcionario_emprestimo,
    f_devolucao.nome_completo as funcionario_devolucao,
    j.titulo as titulo_jogo,
    e.codigo_barras,
    l.nome_loja,
    CASE 
        WHEN d.data_devolucao_efetiva::DATE > a.data_devolucao_prevista THEN 'Atrasada'
        ELSE 'No prazo'
    END as status_devolucao,
    CASE 
        WHEN d.data_devolucao_efetiva::DATE > a.data_devolucao_prevista 
        THEN EXTRACT(DAY FROM (d.data_devolucao_efetiva::DATE - a.data_devolucao_prevista)::INTERVAL)
        ELSE 0
    END as dias_atraso
FROM Devolucoes d
JOIN Alugueis a ON d.id_aluguel = a.id_aluguel
JOIN Clientes c ON a.id_cliente = c.id_cliente
JOIN Funcionarios f_emprestimo ON a.id_funcionario_emprestimo = f_emprestimo.id_funcionario
JOIN Funcionarios f_devolucao ON d.id_funcionario_recebimento = f_devolucao.id_funcionario
JOIN Exemplares e ON a.id_exemplar = e.id_exemplar
JOIN Jogos j ON e.id_jogo = j.id_jogo
JOIN Lojas l ON f_devolucao.id_loja = l.id_loja;

CREATE OR REPLACE VIEW vw_multas_detalhadas AS
SELECT 
    m.id_multa,
    m.valor_multa,
    m.motivo,
    m.paga,
    d.data_devolucao_efetiva,
    a.data_devolucao_prevista,
    a.valor_cobrado,
    c.nome_completo as nome_cliente,
    c.email as email_cliente,
    j.titulo as titulo_jogo,
    l.nome_loja,
    CASE 
        WHEN m.paga THEN 'Paga'
        ELSE 'Pendente'
    END as status_pagamento
FROM Multas m
JOIN Devolucoes d ON m.id_devolucao = d.id_devolucao
JOIN Alugueis a ON d.id_aluguel = a.id_aluguel
JOIN Clientes c ON a.id_cliente = c.id_cliente
JOIN Exemplares e ON a.id_exemplar = e.id_exemplar
JOIN Jogos j ON e.id_jogo = j.id_jogo
JOIN Funcionarios f ON d.id_funcionario_recebimento = f.id_funcionario
JOIN Lojas l ON f.id_loja = l.id_loja;

CREATE OR REPLACE VIEW vw_estatisticas_loja AS
SELECT 
    l.id_loja,
    l.nome_loja,
    l.endereco,
    COUNT(DISTINCT f.id_funcionario) as total_funcionarios,
    COUNT(DISTINCT a.id_aluguel) as total_alugueis,
    COUNT(DISTINCT CASE WHEN a.data_devolucao_prevista < CURRENT_DATE AND d.id_devolucao IS NULL THEN a.id_aluguel END) as alugueis_atrasados,
    COUNT(DISTINCT d.id_devolucao) as total_devolucoes,
    COUNT(DISTINCT m.id_multa) as total_multas,
    COALESCE(SUM(a.valor_cobrado), 0) as receita_total,
    COALESCE(SUM(m.valor_multa), 0) as total_multas_valor
FROM Lojas l
LEFT JOIN Funcionarios f ON l.id_loja = f.id_loja
LEFT JOIN Alugueis a ON f.id_funcionario = a.id_funcionario_emprestimo
LEFT JOIN Devolucoes d ON a.id_aluguel = d.id_aluguel
LEFT JOIN Multas m ON d.id_devolucao = m.id_devolucao
GROUP BY l.id_loja, l.nome_loja, l.endereco;

CREATE OR REPLACE VIEW vw_jogos_populares AS
SELECT 
    j.id_jogo,
    j.titulo,
    e.nome_editora,
    COUNT(a.id_aluguel) as total_alugueis,
    COUNT(DISTINCT a.id_cliente) as clientes_unicos,
    AVG(a.valor_cobrado) as valor_medio_aluguel,
    COUNT(CASE WHEN d.id_devolucao IS NOT NULL THEN 1 END) as total_devolucoes,
    COUNT(CASE WHEN d.data_devolucao_efetiva::DATE > a.data_devolucao_prevista THEN 1 END) as devolucoes_atrasadas,
    COUNT(e2.id_exemplar) as total_exemplares,
    COUNT(CASE WHEN e2.status = 'Disponível' THEN 1 END) as exemplares_disponiveis
FROM Jogos j
JOIN Editoras e ON j.id_editora = e.id_editora
LEFT JOIN Exemplares e2 ON j.id_jogo = e2.id_jogo
LEFT JOIN Alugueis a ON e2.id_exemplar = a.id_exemplar
LEFT JOIN Devolucoes d ON a.id_aluguel = d.id_aluguel
GROUP BY j.id_jogo, j.titulo, e.nome_editora
ORDER BY total_alugueis DESC; 