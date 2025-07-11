\i schema.sql

\i seed.sql

\i sample_data.sql

\i functions.sql

\i triggers.sql

\i views.sql

\i permissions.sql

DO $$
BEGIN
    RAISE NOTICE '=== CONFIGURAÇÃO COMPLETA ===';
    RAISE NOTICE 'Banco de dados da Locadora de Jogos configurado com sucesso!';
    RAISE NOTICE '';
    RAISE NOTICE 'Tabelas criadas:';
    RAISE NOTICE '- Lojas, Cargos, Funcionarios';
    RAISE NOTICE '- Clientes, Enderecos_Cliente';
    RAISE NOTICE '- Editoras, Designers, Categorias, Mecanicas';
    RAISE NOTICE '- Jogos, Exemplares';
    RAISE NOTICE '- Jogo_Categoria, Jogo_Mecanica, Jogo_Designer';
    RAISE NOTICE '- Alugueis, Devolucoes, Multas, Pagamentos, Reservas';
    RAISE NOTICE '- Log_Alteracoes_Preco, Historico_Aluguel_Negado, Historico_Devolucao_Problematica';
    RAISE NOTICE '';
    RAISE NOTICE 'Funções criadas:';
    RAISE NOTICE '- verificar_disponibilidade_jogo()';
    RAISE NOTICE '- calcular_multa_atraso()';
    RAISE NOTICE '- buscar_jogos_por_*() (várias funções de busca)';
    RAISE NOTICE '';
    RAISE NOTICE 'Triggers criados:';
    RAISE NOTICE '- tg_notificar_devolucoes_atrasadas';
    RAISE NOTICE '- tg_log_alteracao_preco';
    RAISE NOTICE '- tg_atualizar_status_exemplar_*';
    RAISE NOTICE '- tg_validar_* (vários triggers de validação)';
    RAISE NOTICE '';
    RAISE NOTICE 'Views criadas:';
    RAISE NOTICE '- vw_jogos_completos';
    RAISE NOTICE '- vw_alugueis_detalhados';
    RAISE NOTICE '- vw_devolucoes_detalhadas';
    RAISE NOTICE '- vw_multas_detalhadas';
    RAISE NOTICE '- vw_pagamentos_detalhados';
    RAISE NOTICE '- vw_reservas_detalhadas';
    RAISE NOTICE '- vw_estatisticas_loja';
    RAISE NOTICE '- vw_jogos_populares';
    RAISE NOTICE '- vw_clientes_historico';
    RAISE NOTICE '- vw_log_alteracoes_preco';
    RAISE NOTICE '';
    RAISE NOTICE 'Roles criados:';
    RAISE NOTICE '- gerente (acesso total)';
    RAISE NOTICE '- funcionario (operações de aluguel/devolução)';
    RAISE NOTICE '- cliente (apenas consultas)';
    RAISE NOTICE '';
    RAISE NOTICE 'Dados de exemplo inseridos:';
    RAISE NOTICE '- 3 lojas, 3 cargos, 7 funcionários';
    RAISE NOTICE '- 8 editoras, 8 designers, 8 categorias, 8 mecânicas';
    RAISE NOTICE '- 10 jogos com 20 exemplares';
    RAISE NOTICE '- 8 clientes com endereços';
    RAISE NOTICE '- 5 alugueis, 5 reservas, 5 logs de alteração de preço';
    RAISE NOTICE '';
    RAISE NOTICE '=== CONFIGURAÇÃO CONCLUÍDA ===';
END $$; 