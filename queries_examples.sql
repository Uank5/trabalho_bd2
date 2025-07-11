
-- Mostra jogos recentes ordenados por ano de lançamento
SELECT j.titulo, j.ano_lancamento, e.nome_editora, j.preco_aluguel_base
FROM Jogos j
JOIN Editoras e ON j.id_editora = e.id_editora
WHERE j.ano_lancamento >= 2020
ORDER BY j.ano_lancamento DESC;


-- Mostra quais clientes mais alugam jogos, ordenados por quantidade
SELECT c.nome_completo, COUNT(a.id_aluguel) as total_alugueis
FROM Clientes c
LEFT JOIN Alugueis a ON c.id_cliente = a.id_cliente
GROUP BY c.id_cliente, c.nome_completo
HAVING COUNT(a.id_aluguel) > 0
ORDER BY total_alugueis DESC;


-- Mostra quantos exemplares cada jogo tem e quantos estão disponíveis
SELECT j.titulo, COUNT(e.id_exemplar) as total_exemplares,
       COUNT(CASE WHEN e.status = 'Disponível' THEN 1 END) as disponiveis
FROM Jogos j
LEFT JOIN Exemplares e ON j.id_jogo = e.id_jogo
GROUP BY j.id_jogo, j.titulo
ORDER BY total_exemplares DESC;


-- Mostra quantos funcionários cada loja possui
SELECT l.nome_loja, COUNT(f.id_funcionario) as total_funcionarios
FROM Lojas l
LEFT JOIN Funcionarios f ON l.id_loja = f.id_loja
GROUP BY l.id_loja, l.nome_loja
ORDER BY total_funcionarios DESC;


-- Encontra jogos com alta complexidade mas tempo de jogo reduzido
SELECT j.titulo, j.complexidade, j.tempo_medio_minutos
FROM Jogos j
WHERE j.complexidade >= 3.0 AND j.tempo_medio_minutos <= 60
ORDER BY j.complexidade DESC;


-- Mostra quantos jogos cada categoria possui
SELECT c.nome_categoria, COUNT(jc.id_jogo) as total_jogos
FROM Categorias c
LEFT JOIN Jogo_Categoria jc ON c.id_categoria = jc.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
ORDER BY total_jogos DESC;


-- Mostra quantos alugueis cada funcionário processou
SELECT f.nome_completo, l.nome_loja, COUNT(a.id_aluguel) as alugueis_processados
FROM Funcionarios f
JOIN Lojas l ON f.id_loja = l.id_loja
LEFT JOIN Alugueis a ON f.id_funcionario = a.id_funcionario_emprestimo
GROUP BY f.id_funcionario, f.nome_completo, l.nome_loja
ORDER BY alugueis_processados DESC;


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


-- Lista clientes que têm multas pendentes ou pagas
SELECT c.nome_completo, COUNT(m.id_multa) as total_multas,
       SUM(m.valor_multa) as valor_total_multas
FROM Clientes c
LEFT JOIN Alugueis a ON c.id_cliente = a.id_cliente
LEFT JOIN Devolucoes d ON a.id_aluguel = d.id_aluguel
LEFT JOIN Multas m ON d.id_devolucao = m.id_devolucao
GROUP BY c.id_cliente, c.nome_completo
HAVING COUNT(m.id_multa) > 0
ORDER BY total_multas DESC;


-- Mostra os jogos mais populares e quantos clientes únicos os alugaram
SELECT j.titulo, COUNT(a.id_aluguel) as total_alugueis,
       COUNT(DISTINCT a.id_cliente) as clientes_unicos
FROM Jogos j
JOIN Exemplares e ON j.id_jogo = e.id_jogo
JOIN Alugueis a ON e.id_exemplar = a.id_exemplar
GROUP BY j.id_jogo, j.titulo
ORDER BY total_alugueis DESC
LIMIT 10;


-- Mostra quantos jogos cada designer criou
SELECT d.nome_designer, COUNT(jd.id_jogo) as total_jogos_designados
FROM Designers d
LEFT JOIN Jogo_Designer jd ON d.id_designer = jd.id_designer
GROUP BY d.id_designer, d.nome_designer
ORDER BY total_jogos_designados DESC;


-- Mostra quais mecânicas de jogo são mais comuns
SELECT m.nome_mecanica, COUNT(jm.id_jogo) as total_jogos
FROM Mecanicas m
LEFT JOIN Jogo_Mecanica jm ON m.id_mecanica = jm.id_mecanica
GROUP BY m.id_mecanica, m.nome_mecanica
ORDER BY total_jogos DESC;


-- Encontra jogos que podem ser jogados por 4 pessoas
SELECT j.titulo, j.min_jogadores, j.max_jogadores, j.tempo_medio_minutos
FROM Jogos j
WHERE j.min_jogadores <= 4 AND j.max_jogadores >= 4
ORDER BY j.tempo_medio_minutos; 