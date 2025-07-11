# Projeto de Banco de Dados: Locadora de Jogos de Tabuleiro

## 📋 Descrição

Este projeto implementa um sistema completo de banco de dados para uma locadora de jogos de tabuleiro usando PostgreSQL. O sistema gerencia lojas, funcionários, clientes, jogos, alugueis, devoluções, multas e reservas.

## 🏗️ Arquitetura do Projeto

O projeto está organizado seguindo as melhores práticas de organização de arquivos SQL:

### 📁 Estrutura de Arquivos

```
trabalho_bd2/
├── schema.sql              # Criação das tabelas
├── seed.sql                # Dados iniciais obrigatórios
├── sample_data.sql         # Dados de exemplo para testes
├── functions.sql           # Funções do banco de dados
├── triggers.sql            # Triggers do banco de dados
├── views.sql              # Views do banco de dados
├── permissions.sql         # Permissões e roles
├── setup_complete.sql     # Script completo de configuração
├── locadora_jogos.sql     # Arquivo original (legado)
├── modelo_conceitual.md   # Documentação do modelo conceitual
├── modelo_conceitual_plantuml.txt  # Diagrama PlantUML
└── README.md              # Este arquivo
```

### 📊 Organização por Tipo de Operação

| Tipo de SQL | Arquivo | Descrição |
|-------------|---------|-----------|
| Criação de tabelas | `schema.sql` | Estrutura completa do banco |
| Dados iniciais | `seed.sql` | Lojas, cargos, editoras, etc. |
| Dados de exemplo | `sample_data.sql` | Dados para testes |
| Consultas complexas | `functions.sql` | Funções de busca e cálculo |
| Atualizações automáticas | `triggers.sql` | Triggers de validação e log |
| Relatórios | `views.sql` | Views para consultas complexas |
| Segurança | `permissions.sql` | Roles e permissões |
| Configuração completa | `setup_complete.sql` | Script principal |

## 🗄️ Modelo de Dados

### Entidades Principais

- **Lojas**: Gerenciamento de unidades físicas
- **Funcionários**: Staff das lojas com diferentes cargos
- **Clientes**: Cadastro de clientes com endereços
- **Jogos**: Catálogo de jogos com metadados
- **Exemplares**: Unidades físicas dos jogos
- **Alugueis**: Registro de empréstimos
- **Devoluções**: Controle de retornos
- **Multas**: Penalidades por atrasos
- **Reservas**: Sistema de reservas

### Relacionamentos

- **Muitos-para-Muitos**: Jogos ↔ Categorias, Jogos ↔ Mecânicas, Jogos ↔ Designers
- **Um-para-Muitos**: Lojas → Funcionários, Clientes → Endereços, Jogos → Exemplares
- **Transacionais**: Alugueis → Devoluções → Multas

## 🚀 Como Usar

### 1. Configuração Inicial

```bash
# Criar container PostgreSQL
docker run --name postgres-locadora -e POSTGRES_PASSWORD=123456 -e POSTGRES_DB=locadora_jogos -p 5432:5432 -d postgres:15

# Conectar ao banco
psql -h localhost -U postgres -d locadora_jogos
```

### 2. Executar Configuração Completa

```sql
-- No psql, execute:
\i setup_complete.sql
```

### 3. Executar Arquivos Individuais

```sql
-- Apenas schema
\i schema.sql

-- Apenas dados iniciais
\i seed.sql

-- Apenas dados de exemplo
\i sample_data.sql

-- Apenas funções
\i functions.sql

-- Apenas triggers
\i triggers.sql

-- Apenas views
\i views.sql

-- Apenas permissões
\i permissions.sql
```

## 🔧 Funcionalidades

### Funções Principais

- `verificar_disponibilidade_jogo(id_jogo)`: Verifica exemplares disponíveis
- `calcular_multa_atraso()`: Calcula multas por atraso
- `buscar_jogos_por_categoria()`: Busca por categoria
- `buscar_jogos_por_mecanica()`: Busca por mecânica
- `buscar_jogos_por_designer()`: Busca por designer
- `buscar_jogos_por_preco()`: Busca por faixa de preço
- `buscar_jogos_por_jogadores()`: Busca por número de jogadores
- `buscar_jogos_por_tempo()`: Busca por tempo de jogo
- `buscar_jogos_por_complexidade()`: Busca por complexidade

### Triggers Automáticos

- **Validação de Aluguel**: Verifica disponibilidade do exemplar
- **Atualização de Status**: Atualiza status do exemplar automaticamente
- **Log de Alterações**: Registra mudanças de preço
- **Notificação de Atrasos**: Detecta devoluções atrasadas
- **Validação de Devolução**: Previne devoluções duplicadas
- **Validação de Pagamento**: Verifica integridade dos pagamentos

### Views para Relatórios

- `vw_jogos_completos`: Informações completas dos jogos
- `vw_alugueis_detalhados`: Detalhes dos alugueis
- `vw_devolucoes_detalhadas`: Detalhes das devoluções
- `vw_multas_detalhadas`: Informações de multas
- `vw_pagamentos_detalhados`: Detalhes dos pagamentos
- `vw_reservas_detalhadas`: Informações de reservas
- `vw_estatisticas_loja`: Estatísticas por loja
- `vw_jogos_populares`: Jogos mais alugados
- `vw_clientes_historico`: Histórico dos clientes
- `vw_log_alteracoes_preco`: Log de alterações de preço

## 🔐 Segurança

### Roles e Permissões

- **gerente**: Acesso total ao sistema
- **funcionario**: Operações de aluguel/devolução
- **cliente**: Apenas consultas de jogos

### Row Level Security (RLS)

- Funcionários veem apenas dados de sua loja
- Clientes veem apenas seus próprios dados
- Políticas de segurança por tabela

## 📈 Exemplos de Uso

### Consultar Jogos Disponíveis

```sql
SELECT * FROM verificar_disponibilidade_jogo(1);
```

### Buscar Jogos por Categoria

```sql
SELECT * FROM buscar_jogos_por_categoria('Estratégia');
```

### Ver Relatório de Alugueis

```sql
SELECT * FROM vw_alugueis_detalhados;
```

### Ver Estatísticas da Loja

```sql
SELECT * FROM vw_estatisticas_loja;
```

## 🛠️ Manutenção

### Adicionar Novo Jogo

```sql
-- 1. Inserir editora (se não existir)
INSERT INTO Editoras (nome_editora) VALUES ('Nova Editora');

-- 2. Inserir jogo
INSERT INTO Jogos (id_editora, titulo, descricao, ano_lancamento, 
                   min_jogadores, max_jogadores, tempo_medio_minutos, 
                   complexidade, preco_aluguel_base)
VALUES (1, 'Novo Jogo', 'Descrição...', 2024, 2, 4, 60, 2.5, 25.00);

-- 3. Inserir exemplares
INSERT INTO Exemplares (id_jogo, codigo_barras, status)
VALUES (11, 'NOV001', 'Disponível');
```

### Registrar Aluguel

```sql
INSERT INTO Alugueis (id_exemplar, id_cliente, id_funcionario_emprestimo, 
                     data_devolucao_prevista, valor_cobrado)
VALUES (1, 1, 2, CURRENT_DATE + INTERVAL '7 days', 25.00);
```

### Registrar Devolução

```sql
INSERT INTO Devolucoes (id_aluguel, id_funcionario_recebimento, observacoes)
VALUES (1, 2, 'Devolução em bom estado');
```

## 📊 Dados de Exemplo

O sistema inclui dados de exemplo para testes:

- **3 Lojas**: GameStore Centro, Shopping, Zona Sul
- **3 Cargos**: Gerente, Atendente, Estoquista
- **7 Funcionários**: Distribuídos pelas lojas
- **8 Editoras**: Galápagos, Devir, Iello, etc.
- **8 Designers**: Reiner Knizia, Uwe Rosenberg, etc.
- **8 Categorias**: Estratégia, Família, Party, etc.
- **8 Mecânicas**: Worker Placement, Deck Building, etc.
- **10 Jogos**: Catan, Agricola, Ticket to Ride, etc.
- **20 Exemplares**: Distribuídos entre os jogos
- **8 Clientes**: Com endereços completos
- **5 Alugueis**: Para demonstração
- **5 Reservas**: Para demonstração

## 🔄 Versionamento

- **schema.sql**: Estrutura atual do banco
- **locadora_jogos.sql**: Arquivo original (legado)
- Todos os arquivos são versionados e podem ser modificados independentemente

## 📝 Notas

- O sistema usa PostgreSQL 15+
- Todas as funções são escritas em PL/pgSQL
- Triggers garantem integridade dos dados
- Views facilitam consultas complexas
- Roles garantem segurança adequada

## 🤝 Contribuição

Para modificar o projeto:

1. Edite o arquivo específico (schema.sql, functions.sql, etc.)
2. Teste as mudanças
3. Execute `setup_complete.sql` para aplicar todas as mudanças
4. Documente as alterações

---

**Desenvolvido para o curso de Banco de Dados 2** 