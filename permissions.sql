CREATE ROLE gerente;
CREATE ROLE funcionario;
CREATE ROLE cliente;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gerente;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO gerente;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO gerente;
GRANT ALL PRIVILEGES ON ALL VIEWS IN SCHEMA public TO gerente;

GRANT SELECT, INSERT, UPDATE ON 
    Alugueis, Devolucoes, Pagamentos, Reservas, 
    Clientes, Exemplares, Jogos, Funcionarios, Lojas
TO funcionario;

GRANT SELECT ON 
    Categorias, Mecanicas, Designers, Editoras,
    Jogo_Categoria, Jogo_Mecanica, Jogo_Designer,
    Multas, Log_Alteracoes_Preco, Historico_Aluguel_Negado, Historico_Devolucao_Problematica,
    vw_jogos_completos, vw_alugueis_detalhados, vw_devolucoes_detalhadas,
    vw_multas_detalhadas, vw_pagamentos_detalhados, vw_reservas_detalhadas,
    vw_estatisticas_loja, vw_jogos_populares, vw_clientes_historico,
    vw_log_alteracoes_preco
TO funcionario;

GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO funcionario;

GRANT SELECT ON 
    Jogos, Exemplares, Categorias, Mecanicas, Designers, Editoras,
    Jogo_Categoria, Jogo_Mecanica, Jogo_Designer,
    vw_jogos_completos, vw_jogos_populares
TO cliente;

GRANT EXECUTE ON FUNCTION verificar_disponibilidade_jogo(INT) TO funcionario, cliente;
GRANT EXECUTE ON FUNCTION buscar_jogos_por_categoria(VARCHAR) TO funcionario, cliente;
GRANT EXECUTE ON FUNCTION buscar_jogos_por_mecanica(VARCHAR) TO funcionario, cliente;
GRANT EXECUTE ON FUNCTION buscar_jogos_por_designer(VARCHAR) TO funcionario, cliente;
GRANT EXECUTE ON FUNCTION buscar_jogos_por_preco(NUMERIC, NUMERIC) TO funcionario, cliente;
GRANT EXECUTE ON FUNCTION buscar_jogos_por_jogadores(INT) TO funcionario, cliente;
GRANT EXECUTE ON FUNCTION buscar_jogos_por_tempo(INT) TO funcionario, cliente;
GRANT EXECUTE ON FUNCTION buscar_jogos_por_complexidade(NUMERIC, NUMERIC) TO funcionario, cliente;

GRANT EXECUTE ON FUNCTION calcular_multa_atraso(DATE, TIMESTAMP WITH TIME ZONE, NUMERIC) TO funcionario, gerente;

GRANT INSERT ON Log_Alteracoes_Preco TO gerente;
GRANT INSERT ON Historico_Aluguel_Negado TO gerente;
GRANT INSERT ON Historico_Devolucao_Problematica TO gerente;

GRANT UPDATE ON Jogos TO gerente;

GRANT INSERT, UPDATE, DELETE ON Funcionarios TO gerente;
GRANT INSERT, UPDATE, DELETE ON Cargos TO gerente;
GRANT INSERT, UPDATE, DELETE ON Lojas TO gerente;

GRANT INSERT, UPDATE, DELETE ON Jogos TO gerente;
GRANT INSERT, UPDATE, DELETE ON Exemplares TO gerente;
GRANT INSERT, UPDATE, DELETE ON Editoras TO gerente;
GRANT INSERT, UPDATE, DELETE ON Designers TO gerente;
GRANT INSERT, UPDATE, DELETE ON Categorias TO gerente;
GRANT INSERT, UPDATE, DELETE ON Mecanicas TO gerente;
GRANT INSERT, UPDATE, DELETE ON Jogo_Categoria TO gerente;
GRANT INSERT, UPDATE, DELETE ON Jogo_Mecanica TO gerente;
GRANT INSERT, UPDATE, DELETE ON Jogo_Designer TO gerente;

GRANT INSERT, UPDATE ON Clientes TO funcionario;
GRANT INSERT, UPDATE ON Enderecos_Cliente TO funcionario;

GRANT INSERT, UPDATE ON Multas TO gerente;

ALTER TABLE Alugueis ENABLE ROW LEVEL SECURITY;
ALTER TABLE Devolucoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE Funcionarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE Clientes ENABLE ROW LEVEL SECURITY;

CREATE POLICY funcionario_loja_policy ON Alugueis
    FOR ALL TO funcionario
    USING (
        id_funcionario_emprestimo IN (
            SELECT id_funcionario 
            FROM Funcionarios 
            WHERE id_loja = (
                SELECT id_loja 
                FROM Funcionarios 
                WHERE id_funcionario = current_setting('app.current_user_id')::INT
            )
        )
    );

CREATE POLICY funcionario_loja_policy_devolucoes ON Devolucoes
    FOR ALL TO funcionario
    USING (
        id_funcionario_recebimento IN (
            SELECT id_funcionario 
            FROM Funcionarios 
            WHERE id_loja = (
                SELECT id_loja 
                FROM Funcionarios 
                WHERE id_funcionario = current_setting('app.current_user_id')::INT
            )
        )
    );

CREATE POLICY cliente_own_data_policy ON Clientes
    FOR SELECT TO cliente
    USING (id_cliente = current_setting('app.current_user_id')::INT);

CREATE OR REPLACE FUNCTION log_user_action(
    p_action VARCHAR(50),
    p_table_name VARCHAR(50),
    p_record_id INT,
    p_user_id INT
)
RETURNS VOID AS $$
BEGIN
    NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION log_user_action(VARCHAR, VARCHAR, INT, INT) TO gerente, funcionario;

CREATE INDEX IF NOT EXISTS idx_alugueis_cliente ON Alugueis(id_cliente);
CREATE INDEX IF NOT EXISTS idx_alugueis_data ON Alugueis(data_aluguel);
CREATE INDEX IF NOT EXISTS idx_alugueis_funcionario ON Alugueis(id_funcionario_emprestimo);
CREATE INDEX IF NOT EXISTS idx_devolucoes_aluguel ON Devolucoes(id_aluguel);
CREATE INDEX IF NOT EXISTS idx_exemplares_jogo ON Exemplares(id_jogo);
CREATE INDEX IF NOT EXISTS idx_exemplares_status ON Exemplares(status);
CREATE INDEX IF NOT EXISTS idx_jogos_titulo ON Jogos(titulo);
CREATE INDEX IF NOT EXISTS idx_jogos_editora ON Jogos(id_editora);
CREATE INDEX IF NOT EXISTS idx_clientes_email ON Clientes(email);
CREATE INDEX IF NOT EXISTS idx_clientes_cpf ON Clientes(cpf);
CREATE INDEX IF NOT EXISTS idx_funcionarios_loja ON Funcionarios(id_loja);
CREATE INDEX IF NOT EXISTS idx_reservas_cliente ON Reservas(id_cliente);
CREATE INDEX IF NOT EXISTS idx_reservas_jogo ON Reservas(id_jogo);

ALTER TABLE Jogos ADD CONSTRAINT chk_ano_lancamento 
    CHECK (ano_lancamento >= 1900 AND ano_lancamento <= EXTRACT(YEAR FROM CURRENT_DATE));

ALTER TABLE Jogos ADD CONSTRAINT chk_jogadores 
    CHECK (min_jogadores > 0 AND max_jogadores >= min_jogadores);

ALTER TABLE Jogos ADD CONSTRAINT chk_tempo_medio 
    CHECK (tempo_medio_minutos > 0);

ALTER TABLE Alugueis ADD CONSTRAINT chk_data_devolucao 
    CHECK (data_devolucao_prevista > data_aluguel::DATE);

ALTER TABLE Clientes ADD CONSTRAINT chk_data_nascimento 
    CHECK (data_nascimento <= CURRENT_DATE);

ALTER TABLE Funcionarios ADD CONSTRAINT chk_salario 
    CHECK (salario > 0);

ALTER TABLE Exemplares ADD CONSTRAINT chk_status 
    CHECK (status IN ('Disponível', 'Alugado', 'Manutenção', 'Perdido')); 