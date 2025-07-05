# Modelo Conceitual - Locadora de Jogos de Tabuleiro

## 1. Diagrama Entidade-Relacionamento

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     LOJAS       │    │    CARGOS       │    │  FUNCIONARIOS   │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ id_loja (PK)    │    │ id_cargo (PK)   │    │ id_funcionario  │
│ nome_loja       │    │ nome_cargo      │    │ id_loja (FK)    │
│ endereco        │    │ descricao       │    │ id_cargo (FK)   │
│ telefone        │    └─────────────────┘    │ nome_completo   │
└─────────────────┘                          │ cpf             │
         │                                   │ data_contratacao│
         │ 1:N                               │ salario         │
         │                                   └─────────────────┘
         │
         │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ PLANOS_ASSINATURA│    │    CLIENTES     │    │ ENDERECOS_CLIENTE│
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ id_plano (PK)   │    │ id_cliente (PK) │    │ id_endereco (PK)│
│ nome_plano      │    │ id_plano (FK)   │    │ id_cliente (FK) │
│ preco_mensal    │    │ nome_completo   │    │ logradouro      │
│ limite_alugueis │    │ email           │    │ numero          │
│ desconto_percent│    │ cpf             │    │ data_nascimento │
└─────────────────┘    │ data_cadastro   │    │ data_cadastro   │
         │             │ data_cadastro   │    │ data_cadastro   │
         │ 1:N         └─────────────────┘    │ data_cadastro   │
         │                      │             │ data_cadastro   │
         │                      │ 1:N         │ data_cadastro   │
         │                      │             └─────────────────┘
         │                      │
         │                      │ 1:N
         │                      │
         │             ┌─────────────────┐    ┌─────────────────┐
         │             │TELEFONES_CLIENTE│    │PONTOS_FIDELIDADE│
         │             ├─────────────────┤    ├─────────────────┤
         │             │ id_telefone (PK)│    │ id_ponto (PK)   │
         │             │ id_cliente (FK) │    │ id_cliente (FK) │
         │             │ numero          │    │ pontos_ganhos   │
         │             │ tipo            │    │ pontos_usados   │
         │             └─────────────────┘    │ id_aluguel (FK) │
         │                                    │ data_transacao  │
         │                                    └─────────────────┘
         │
         │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    EDITORAS     │    │    DESIGNERS    │    │   CATEGORIAS   │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ id_editora (PK) │    │ id_designer (PK)│    │ id_categoria(PK)│
│ nome_editora    │    │ nome_designer   │    │ nome_categoria  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                      │                      │
         │ 1:N                  │ 1:N                  │ 1:N
         │                      │                      │
         │                      │                      │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     JOGOS       │    │   MECANICAS    │    │   EXEMPLARES   │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ id_jogo (PK)    │    │ id_mecanica(PK)│    │ id_exemplar(PK)│
│ id_editora (FK) │    │ nome_mecanica  │    │ id_jogo (FK)   │
│ titulo          │    └─────────────────┘    │ codigo_barras   │
│ descricao       │             │            │ estado_conserv  │
│ ano_lancamento  │             │ 1:N        │ status          │
│ min_jogadores   │             │            └─────────────────┘
│ max_jogadores   │             │                      │
│ tempo_medio     │             │                      │
│ complexidade    │             │                      │
│ preco_aluguel   │             │                      │
└─────────────────┘             │                      │
         │                      │                      │
         │ 1:N                  │                      │
         │                      │                      │
         │                      │                      │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ JOGO_CATEGORIA │    │  JOGO_MECANICA  │    │  JOGO_DESIGNER │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ id_jogo (FK)    │    │ id_jogo (FK)    │    │ id_jogo (FK)   │
│ id_categoria(FK)│    │ id_mecanica (FK)│    │ id_designer(FK)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                      │                      │
         │                      │                      │
         │                      │                      │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    ALUGUEIS     │    │   DEVOLUCOES   │    │     MULTAS      │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ id_aluguel (PK) │    │ id_devolucao(PK)│    │ id_multa (PK)  │
│ id_exemplar(FK) │    │ id_aluguel (FK) │    │ id_devolucao(FK)│
│ id_cliente (FK) │    │ id_funcionario  │    │ id_funcionario  │
│ id_funcionario  │    │ data_devolucao  │    │ data_devolucao  │
│ data_aluguel    │    │ observacoes     │    │ observacoes     │
│ data_devolucao  │    └─────────────────┘    └─────────────────┘
│ valor_cobrado   │             │                      │
└─────────────────┘             │                      │
         │                      │                      │
         │ 1:1                  │ 1:N                  │
         │                      │                      │
         │                      │                      │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PAGAMENTOS    │    │    RESERVAS     │    │LOG_ALTERACOES  │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ id_pagamento(PK)│    │ id_reserva (PK) │    │ id_log (PK)    │
│ id_aluguel (FK) │    │ id_jogo (FK)    │    │ id_jogo (FK)   │
│ id_multa (FK)   │    │ id_cliente (FK) │    │ preco_antigo   │
│ valor           │    │ data_reserva    │    │ preco_novo     │
│ data_pagamento  │    │ status          │    │ data_alteracao │
│ metodo_pagamento│    └─────────────────┘    │ usuario_alter  │
└─────────────────┘                           └─────────────────┘
```

## 2. Descrição das Entidades

### 2.1 Entidades Principais

**LOJAS**: Representa as unidades físicas da locadora
- Atributos: id_loja (PK), nome_loja, endereco, telefone
- Relacionamentos: 1:N com FUNCIONARIOS

**FUNCIONARIOS**: Representa os colaboradores da empresa
- Atributos: id_funcionario (PK), id_loja (FK), id_cargo (FK), nome_completo, cpf, data_contratacao, salario
- Relacionamentos: N:1 com LOJAS, N:1 com CARGOS, 1:N com ALUGUEIS, 1:N com DEVOLUCOES

**CLIENTES**: Representa os clientes da locadora
- Atributos: id_cliente (PK), id_plano (FK), nome_completo, email, cpf, data_nascimento, data_cadastro
- Relacionamentos: N:1 com PLANOS_ASSINATURA, 1:N com ENDERECOS_CLIENTE, 1:N com TELEFONES_CLIENTE, 1:N com ALUGUEIS, 1:N com RESERVAS, 1:N com PONTOS_FIDELIDADE

**JOGOS**: Representa os títulos dos jogos (conceito abstrato)
- Atributos: id_jogo (PK), id_editora (FK), titulo, descricao, ano_lancamento, min_jogadores, max_jogadores, tempo_medio_minutos, complexidade, preco_aluguel_base
- Relacionamentos: N:1 com EDITORAS, 1:N com EXEMPLARES, N:N com CATEGORIAS, N:N com MECANICAS, N:N com DESIGNERS, 1:N com RESERVAS

**EXEMPLARES**: Representa cada cópia física de um jogo
- Atributos: id_exemplar (PK), id_jogo (FK), codigo_barras, estado_conservacao, status
- Relacionamentos: N:1 com JOGOS, 1:N com ALUGUEIS

### 2.2 Entidades de Relacionamento

**JOGO_CATEGORIA**: Relacionamento N:N entre JOGOS e CATEGORIAS
**JOGO_MECANICA**: Relacionamento N:N entre JOGOS e MECANICAS  
**JOGO_DESIGNER**: Relacionamento N:N entre JOGOS e DESIGNERS

### 2.3 Entidades de Transação

**ALUGUEIS**: Registra cada aluguel realizado
- Atributos: id_aluguel (PK), id_exemplar (FK), id_cliente (FK), id_funcionario_emprestimo (FK), data_aluguel, data_devolucao_prevista, valor_cobrado
- Relacionamentos: N:1 com EXEMPLARES, N:1 com CLIENTES, N:1 com FUNCIONARIOS, 1:1 com DEVOLUCOES, 1:N com PAGAMENTOS

**DEVOLUCOES**: Registra cada devolução
- Atributos: id_devolucao (PK), id_aluguel (FK), id_funcionario_recebimento (FK), data_devolucao_efetiva, observacoes
- Relacionamentos: 1:1 com ALUGUEIS, N:1 com FUNCIONARIOS, 1:N com MULTAS

**MULTAS**: Registra multas por atraso ou danos
- Atributos: id_multa (PK), id_devolucao (FK), valor_multa, motivo, paga
- Relacionamentos: N:1 com DEVOLUCOES, 1:N com PAGAMENTOS

**PAGAMENTOS**: Registra todos os pagamentos
- Atributos: id_pagamento (PK), id_aluguel (FK), id_multa (FK), valor, data_pagamento, metodo_pagamento
- Relacionamentos: N:1 com ALUGUEIS, N:1 com MULTAS

## 3. Regras de Negócio

1. **Integridade Referencial**: Todas as chaves estrangeiras garantem integridade
2. **Status de Exemplares**: Apenas exemplares com status 'Disponível' podem ser alugados
3. **Cálculo de Multas**: Multas são calculadas automaticamente por atraso (R$ 5,00/dia)
4. **Pontos de Fidelidade**: Clientes ganham 10 pontos por aluguel pago
5. **Auditoria de Preços**: Todas as alterações de preço são registradas
6. **Reservas**: Clientes podem reservar jogos não disponíveis
7. **Planos de Assinatura**: Definem limites e descontos para clientes

## 4. Normalização

O modelo está normalizado até a 3ª Forma Normal (3FN):
- Não há dependências parciais (2FN)
- Não há dependências transitivas (3FN)
- As tabelas de relacionamento N:N evitam redundância
- Chaves primárias são simples e únicas

## 5. Considerações de Performance

- Índices em chaves estrangeiras
- Índices em campos frequentemente consultados
- Fragmentação horizontal para tabelas grandes (ALUGUEIS, PAGAMENTOS)
- Particionamento por data para logs 