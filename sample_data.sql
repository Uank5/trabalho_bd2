INSERT INTO Funcionarios (id_loja, id_cargo, nome_completo, cpf, data_contratacao, salario) VALUES
(1, 1, 'João Silva', '123.456.789-01', '2023-01-15', 3500.00),
(1, 2, 'Maria Santos', '234.567.890-12', '2023-02-20', 2200.00),
(1, 3, 'Pedro Costa', '345.678.901-23', '2023-03-10', 2000.00),
(2, 1, 'Ana Oliveira', '456.789.012-34', '2023-01-20', 3500.00),
(2, 2, 'Carlos Lima', '567.890.123-45', '2023-02-15', 2200.00),
(3, 1, 'Lucia Ferreira', '678.901.234-56', '2023-01-10', 3500.00),
(3, 2, 'Roberto Alves', '789.012.345-67', '2023-03-05', 2200.00);

INSERT INTO Jogos (id_editora, titulo, descricao, ano_lancamento, min_jogadores, max_jogadores, tempo_medio_minutos, complexidade, preco_aluguel_base) VALUES
(1, 'Catan', 'Jogo de estratégia com construção de cidades e rotas comerciais', 1995, 3, 4, 90, 2.0, 25.00),
(2, 'Agricola', 'Jogo de agricultura e gestão de recursos', 2007, 1, 4, 150, 3.5, 35.00),
(3, 'Ticket to Ride', 'Jogo de construção de rotas ferroviárias', 2004, 2, 5, 60, 1.8, 20.00),
(4, 'Carcassonne', 'Jogo de colocação de peças e construção de paisagens', 2000, 2, 5, 45, 1.5, 18.00),
(5, 'Pandemic', 'Jogo cooperativo de combate a doenças', 2008, 2, 4, 45, 2.5, 22.00),
(6, 'Codenames', 'Jogo de palavras e dedução', 2015, 4, 8, 30, 1.2, 15.00),
(7, 'Terraforming Mars', 'Jogo de colonização de Marte', 2016, 1, 5, 180, 3.8, 40.00),
(8, 'Azul', 'Jogo de colocação de azulejos', 2017, 2, 4, 45, 1.8, 20.00),
(1, 'Splendor', 'Jogo de desenvolvimento de gemas', 2014, 2, 4, 30, 1.7, 18.00),
(2, '7 Wonders', 'Jogo de construção de civilizações', 2010, 3, 7, 30, 2.2, 25.00);

INSERT INTO Exemplares (id_jogo, codigo_barras, status) VALUES
(1, 'CAT001', 'Disponível'),
(1, 'CAT002', 'Disponível'),
(1, 'CAT003', 'Disponível'),
(2, 'AGR001', 'Disponível'),
(2, 'AGR002', 'Disponível'),
(3, 'TTR001', 'Disponível'),
(3, 'TTR002', 'Disponível'),
(3, 'TTR003', 'Disponível'),
(4, 'CAR001', 'Disponível'),
(4, 'CAR002', 'Disponível'),
(5, 'PAN001', 'Disponível'),
(5, 'PAN002', 'Disponível'),
(6, 'COD001', 'Disponível'),
(7, 'TER001', 'Disponível'),
(8, 'AZU001', 'Disponível'),
(8, 'AZU002', 'Disponível'),
(9, 'SPL001', 'Disponível'),
(9, 'SPL002', 'Disponível'),
(10, 'WON001', 'Disponível'),
(10, 'WON002', 'Disponível');

INSERT INTO Clientes (nome_completo, email, cpf, telefone, data_nascimento, data_cadastro) VALUES
('Fernando Almeida', 'fernando@email.com', '111.222.333-44', '(11) 9999-4444', '1985-03-15', '2023-01-10 10:00:00'),
('Juliana Costa', 'juliana@email.com', '222.333.444-55', '(11) 9999-5555', '1990-07-22', '2023-01-15 14:30:00'),
('Ricardo Santos', 'ricardo@email.com', '333.444.555-66', '(11) 9999-6666', '1988-11-08', '2023-02-05 09:15:00'),
('Amanda Silva', 'amanda@email.com', '444.555.666-77', '(11) 9999-7777', '1992-04-30', '2023-02-10 16:45:00'),
('Marcos Oliveira', 'marcos@email.com', '555.666.777-88', '(11) 9999-8888', '1987-09-12', '2023-02-20 11:20:00'),
('Carolina Lima', 'carolina@email.com', '666.777.888-99', '(11) 9999-9999', '1995-12-25', '2023-03-01 13:10:00'),
('Thiago Ferreira', 'thiago@email.com', '777.888.999-00', '(11) 9999-0000', '1991-06-18', '2023-03-10 15:30:00'),
('Patricia Alves', 'patricia@email.com', '888.999.000-11', '(11) 9999-1111', '1989-01-03', '2023-03-15 10:45:00');

INSERT INTO Enderecos_Cliente (id_cliente, logradouro, numero, complemento, bairro, cidade, estado, cep, principal) VALUES
(1, 'Rua das Palmeiras', '100', 'Apto 101', 'Vila Madalena', 'São Paulo', 'SP', '01234-567', true),
(1, 'Av. Brigadeiro Faria Lima', '2000', 'Sala 50', 'Itaim Bibi', 'São Paulo', 'SP', '04538-000', false),
(2, 'Rua Augusta', '500', 'Apto 302', 'Consolação', 'São Paulo', 'SP', '01305-000', true),
(3, 'Rua Oscar Freire', '150', 'Casa', 'Jardins', 'São Paulo', 'SP', '01426-000', true),
(4, 'Rua Teodoro Sampaio', '300', 'Apto 15', 'Pinheiros', 'São Paulo', 'SP', '05406-000', true),
(5, 'Av. Paulista', '1000', 'Apto 1001', 'Bela Vista', 'São Paulo', 'SP', '01310-100', true),
(6, 'Rua Harmonia', '400', 'Casa', 'Vila Madalena', 'São Paulo', 'SP', '05435-000', true),
(7, 'Rua Cardeal Arcoverde', '250', 'Apto 505', 'Pinheiros', 'São Paulo', 'SP', '05407-000', true),
(8, 'Rua Fradique Coutinho', '600', 'Apto 201', 'Vila Madalena', 'São Paulo', 'SP', '05416-000', true);

INSERT INTO Jogo_Categoria (id_jogo, id_categoria) VALUES
(1, 1), (1, 5),
(2, 1), (2, 5),
(3, 2), (3, 5),
(4, 2), (4, 5),
(5, 4),
(6, 3), (6, 7),
(7, 1), (7, 5),
(8, 2), (8, 5),
(9, 2), (9, 5),
(10, 1), (10, 5);

INSERT INTO Jogo_Mecanica (id_jogo, id_mecanica) VALUES
(1, 5), (1, 6),
(2, 1), (2, 5),
(3, 8), (3, 6),
(4, 4), (4, 7),
(5, 7),
(6, 7), (6, 8),
(7, 1), (7, 5),
(8, 4), (8, 7),
(9, 5), (9, 7),
(10, 3), (10, 5);

INSERT INTO Jogo_Designer (id_jogo, id_designer) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 1),
(10, 2);

INSERT INTO Alugueis (id_exemplar, id_cliente, id_funcionario_emprestimo, data_aluguel, data_devolucao_prevista, valor_cobrado) VALUES
(3, 1, 2, CURRENT_TIMESTAMP, CURRENT_DATE + INTERVAL '7 days', 25.00),
(11, 2, 2, CURRENT_TIMESTAMP, CURRENT_DATE + INTERVAL '7 days', 25.00),
(13, 3, 2, CURRENT_TIMESTAMP, CURRENT_DATE + INTERVAL '7 days', 15.00),
(15, 4, 2, CURRENT_TIMESTAMP, CURRENT_DATE + INTERVAL '7 days', 20.00),
(17, 5, 2, CURRENT_TIMESTAMP, CURRENT_DATE + INTERVAL '7 days', 18.00);

INSERT INTO Reservas (id_jogo, id_cliente, data_reserva, status) VALUES
(1, 1, CURRENT_TIMESTAMP, 'Ativa'),
(3, 2, CURRENT_TIMESTAMP, 'Ativa'),
(5, 3, CURRENT_TIMESTAMP, 'Ativa'),
(7, 4, CURRENT_TIMESTAMP, 'Cancelada'),
(9, 5, CURRENT_TIMESTAMP, 'Ativa');

INSERT INTO Log_Alteracoes_Preco (id_jogo, preco_anterior, preco_novo, data_alteracao, id_funcionario) VALUES
(1, 20.00, 25.00, '2024-01-01 10:00:00', 1),
(2, 30.00, 35.00, '2024-01-15 14:30:00', 1),
(3, 18.00, 20.00, '2024-02-01 09:15:00', 1),
(4, 15.00, 18.00, '2024-02-10 16:45:00', 1),
(5, 20.00, 22.00, '2024-02-20 11:30:00', 1); 