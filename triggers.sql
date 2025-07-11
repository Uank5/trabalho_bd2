CREATE OR REPLACE FUNCTION tg_notificar_devolucoes_atrasadas()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_devolucao_efetiva::DATE > (
        SELECT data_devolucao_prevista 
        FROM Alugueis 
        WHERE id_aluguel = NEW.id_aluguel
    ) THEN
        INSERT INTO Historico_Devolucao_Problematica (
            id_devolucao, 
            tipo_problema, 
            descricao
        ) VALUES (
            NEW.id_devolucao,
            'Atraso',
            'Devolução realizada após a data prevista'
        );
        
        INSERT INTO Multas (
            id_devolucao,
            valor_multa,
            motivo
        ) VALUES (
            NEW.id_devolucao,
            calcular_multa_atraso(
                (SELECT data_devolucao_prevista FROM Alugueis WHERE id_aluguel = NEW.id_aluguel),
                NEW.data_devolucao_efetiva,
                (SELECT valor_cobrado FROM Alugueis WHERE id_aluguel = NEW.id_aluguel)
            ),
            'Atraso na devolução'
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_notificar_devolucoes_atrasadas
    AFTER INSERT ON Devolucoes
    FOR EACH ROW
    EXECUTE FUNCTION tg_notificar_devolucoes_atrasadas();

CREATE OR REPLACE FUNCTION tg_log_alteracao_preco()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.preco_aluguel_base != NEW.preco_aluguel_base THEN
        INSERT INTO Log_Alteracoes_Preco (
            id_jogo,
            preco_anterior,
            preco_novo,
            data_alteracao
        ) VALUES (
            NEW.id_jogo,
            OLD.preco_aluguel_base,
            NEW.preco_aluguel_base,
            CURRENT_TIMESTAMP
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_log_alteracao_preco
    AFTER UPDATE ON Jogos
    FOR EACH ROW
    EXECUTE FUNCTION tg_log_alteracao_preco();

CREATE OR REPLACE FUNCTION tg_atualizar_status_exemplar_aluguel()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Exemplares 
    SET status = 'Alugado'
    WHERE id_exemplar = NEW.id_exemplar;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_atualizar_status_exemplar_aluguel
    AFTER INSERT ON Alugueis
    FOR EACH ROW
    EXECUTE FUNCTION tg_atualizar_status_exemplar_aluguel();

CREATE OR REPLACE FUNCTION tg_atualizar_status_exemplar_devolucao()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Exemplares 
    SET status = 'Disponível'
    WHERE id_exemplar = (
        SELECT id_exemplar 
        FROM Alugueis 
        WHERE id_aluguel = NEW.id_aluguel
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_atualizar_status_exemplar_devolucao
    AFTER INSERT ON Devolucoes
    FOR EACH ROW
    EXECUTE FUNCTION tg_atualizar_status_exemplar_devolucao();

CREATE OR REPLACE FUNCTION tg_validar_aluguel()
RETURNS TRIGGER AS $$
DECLARE
    status_atual VARCHAR(20);
BEGIN
    SELECT status INTO status_atual
    FROM Exemplares
    WHERE id_exemplar = NEW.id_exemplar;
    
    IF status_atual != 'Disponível' THEN
        INSERT INTO Historico_Aluguel_Negado (
            id_cliente,
            id_exemplar,
            motivo
        ) VALUES (
            NEW.id_cliente,
            NEW.id_exemplar,
            'Exemplar não disponível - Status: ' || status_atual
        );
        
        RAISE EXCEPTION 'Exemplar não está disponível para aluguel. Status atual: %', status_atual;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validar_aluguel
    BEFORE INSERT ON Alugueis
    FOR EACH ROW
    EXECUTE FUNCTION tg_validar_aluguel();

CREATE OR REPLACE FUNCTION tg_validar_devolucao()
RETURNS TRIGGER AS $$
DECLARE
    aluguel_existe BOOLEAN;
    ja_devolvido BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM Alugueis WHERE id_aluguel = NEW.id_aluguel) INTO aluguel_existe;
    
    IF NOT aluguel_existe THEN
        RAISE EXCEPTION 'Aluguel com ID % não existe', NEW.id_aluguel;
    END IF;
    
    SELECT EXISTS(SELECT 1 FROM Devolucoes WHERE id_aluguel = NEW.id_aluguel) INTO ja_devolvido;
    
    IF ja_devolvido THEN
        RAISE EXCEPTION 'Este aluguel já foi devolvido';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validar_devolucao
    BEFORE INSERT ON Devolucoes
    FOR EACH ROW
    EXECUTE FUNCTION tg_validar_devolucao();

CREATE OR REPLACE FUNCTION tg_validar_pagamento()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_aluguel IS NULL AND NEW.id_multa IS NULL THEN
        RAISE EXCEPTION 'Pagamento deve estar associado a um aluguel ou multa';
    END IF;
    
    IF NEW.id_aluguel IS NOT NULL AND NEW.id_multa IS NOT NULL THEN
        RAISE EXCEPTION 'Pagamento não pode estar associado a aluguel e multa simultaneamente';
    END IF;
    
    IF NEW.id_aluguel IS NOT NULL THEN
        IF NOT EXISTS(SELECT 1 FROM Alugueis WHERE id_aluguel = NEW.id_aluguel) THEN
            RAISE EXCEPTION 'Aluguel com ID % não existe', NEW.id_aluguel;
        END IF;
    END IF;
    
    IF NEW.id_multa IS NOT NULL THEN
        IF NOT EXISTS(SELECT 1 FROM Multas WHERE id_multa = NEW.id_multa) THEN
            RAISE EXCEPTION 'Multa com ID % não existe', NEW.id_multa;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validar_pagamento
    BEFORE INSERT ON Pagamentos
    FOR EACH ROW
    EXECUTE FUNCTION tg_validar_pagamento(); 