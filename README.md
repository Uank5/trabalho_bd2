# 🎲 Locadora de Jogos - Banco de Dados PostgreSQL

Sistema completo de banco de dados para uma locadora de jogos de tabuleiro, desenvolvido em PostgreSQL com 21 tabelas e funcionalidades avançadas.

## 📊 Requisitos Mínimos vs. Implementação

| Componente | Mínimo | Implementado | Status |
|------------|--------|--------------|--------|
| **Tabelas** | 15 | 21 | ✅ +6 |
| **Funções** | 5 | 8 | ✅ +3 |
| **Triggers** | 2 | 6 | ✅ +4 |
| **Views** | 2 | 4 | ✅ +2 |
| **Consultas** | 10 | 14 | ✅ +4 |

## 🗂️ Estrutura do Projeto

```
trabalho_bd2/
├── schema.sql              # Estrutura das tabelas (21 tabelas)
├── seed.sql                # Dados iniciais (categorias, editoras, etc.)
├── sample_data.sql         # Dados de exemplo
├── functions.sql           # Funções armazenadas (8 funções)
├── triggers.sql            # Triggers (6 triggers)
├── views.sql              # Views (4 views)
├── permissions.sql         # Permissões e RLS
├── setup_complete.sql      # Script completo de setup
├── queries_examples.sql    # Exemplos de consultas (14 consultas)
├── modelo_conceitual_plantuml.txt  # Diagrama PlantUML
└── README.md              # Este arquivo
```

## 🚀 Como Usar

### 1. Usando Docker (Recomendado)

```bash
# Criar container PostgreSQL
docker run --name postgres-locadora -e POSTGRES_PASSWORD=123456 -e POSTGRES_DB=locadora_jogos -p 5432:5432 -d postgres:15

# Executar script completo
docker exec -i postgres-locadora psql -U postgres -d locadora_jogos < setup_complete.sql
```

### 2. Usando PostgreSQL Local

```bash
# Conectar ao PostgreSQL
psql -U postgres -d locadora_jogos

# Executar script completo
\i setup_complete.sql
```

### 3. Usando DBeaver

1. Criar nova conexão PostgreSQL
2. Host: `localhost`
3. Port: `5432`
4. Database: `locadora_jogos`
5. Username: `postgres`
6. Password: `123456`
7. Executar `setup_complete.sql`

## 📋 Estrutura do Banco

### Tabelas Principais (21 total)

#### Entidades Core (5 tabelas)
- **Lojas** - Filiais da locadora
- **Cargos** - Cargos dos funcionários
- **Funcionarios** - Funcionários das lojas
- **Clientes** - Cadastro de clientes
- **Enderecos_Cliente** - Endereços dos clientes

#### Jogos e Exemplares (6 tabelas)
- **Editoras** - Editoras dos jogos
- **Designers** - Designers dos jogos
- **Categorias** - Categorias dos jogos
- **Mecanicas** - Mecânicas dos jogos
- **Jogos** - Catálogo de jogos
- **Exemplares** - Cópias físicas dos jogos

#### Relacionamentos (3 tabelas)
- **Jogo_Categoria** - Relacionamento N:N jogos-categorias
- **Jogo_Mecanica** - Relacionamento N:N jogos-mecânicas
- **Jogo_Designer** - Relacionamento N:N jogos-designers

#### Operações (5 tabelas)
- **Alugueis** - Registro de aluguéis
- **Devolucoes** - Registro de devoluções
- **Multas** - Multas por atraso
- **Pagamentos** - Pagamentos de aluguéis e multas
- **Reservas** - Reservas de jogos

#### Auditoria (3 tabelas)
- **Log_Alteracoes_Preco** - Log de alterações de preço
- **Historico_Aluguel_Negado** - Histórico de aluguéis negados
- **Historico_Devolucao_Problematica** - Histórico de devoluções problemáticas

### Funções (8 total)

#### Funções de Busca (4 funções)
1. `verificar_disponibilidade_jogo(p_id_jogo)` - Verifica disponibilidade de exemplares
2. `buscar_jogos_por_categoria(p_nome_categoria)` - Busca jogos por categoria
3. `buscar_jogos_por_preco(p_preco_minimo, p_preco_maximo)` - Busca por faixa de preço
4. `buscar_jogos_por_complexidade(p_complexidade_minima, p_complexidade_maxima)` - Busca por complexidade

#### Funções de Operação (2 funções)
5. `registrar_aluguel(p_id_exemplar, p_id_cliente, p_id_funcionario, p_data_devolucao_prevista, p_valor_cobrado)` - Registra novo aluguel
6. `registrar_devolução(p_id_aluguel, p_id_funcionario, p_observacoes)` - Registra devolução

#### Funções de Relatório (2 funções)
7. `calcular_faturamento_periodo(p_data_inicio, p_data_fim)` - Calcula faturamento do período
8. `recomendar_jogos_clientes(p_id_cliente)` - Sistema de recomendação

### Triggers (6 total)

1. `tg_notificar_devolucoes_atrasadas` - Notifica devoluções atrasadas
2. `tg_log_alteracao_preco` - Log de alterações de preço
3. `tg_validar_aluguel` - Valida aluguel
4. `tg_atualizar_status_exemplar` - Atualiza status do exemplar
5. `tg_validar_devolucao` - Valida devolução
6. `tg_calcular_multa_automatica` - Calcula multa automaticamente

### Views (4 total)

1. `vw_jogos_completos` - Informações completas dos jogos
2. `vw_alugueis_detalhados` - Detalhes dos aluguéis
3. `vw_estatisticas_loja` - Estatísticas por loja
4. `vw_jogos_populares` - Jogos mais populares

### Consultas de Exemplo (14 total)

Consultas SQL demonstrando:
- Relatórios de aluguéis por período
- Estatísticas de clientes e funcionários
- Análise de jogos populares e disponibilidade
- Relatórios financeiros e faturamento
- Consultas por categoria, mecânica e designer
- Análise temporal e geográfica
- Relatórios de multas e pagamentos

## 🔐 Segurança

### Roles
- **gerente** - Acesso total ao sistema
- **funcionario** - Acesso limitado às operações
- **cliente** - Acesso apenas a consultas básicas

### Row Level Security (RLS)
- Políticas de acesso por loja
- Restrições por cargo
- Isolamento de dados por filial
- Controle de acesso por cliente

## 📈 Recursos Avançados

### Índices
- Índices em chaves primárias e estrangeiras
- Índices em campos de busca frequente
- Índices compostos para consultas complexas

### Fragmentação
- Fragmentação horizontal por loja
- Políticas RLS para isolamento de dados

### Permissões
- Controle granular de acesso
- Separação de responsabilidades
- Auditoria de operações

## 🎯 Funcionalidades Principais

### Gestão de Jogos
- Cadastro completo de jogos com metadados
- Controle de exemplares e status
- Categorização e classificação
- Busca avançada por múltiplos critérios
- Sistema de recomendação inteligente

### Gestão de Clientes
- Cadastro completo de clientes
- Gestão de endereços múltiplos
- Histórico completo de aluguéis
- Controle de multas e pagamentos
- Sistema de reservas

### Gestão de Aluguéis
- Processo completo de aluguel com validação
- Controle de devoluções com observações
- Cálculo automático de multas
- Relatórios detalhados por período
- Histórico de tentativas negadas

### Gestão Financeira
- Controle de pagamentos de aluguéis e multas
- Cálculo automático de multas por atraso
- Relatórios de faturamento por período
- Análise de receita e rentabilidade
- Auditoria de alterações de preço

### Gestão de Funcionários
- Controle de funcionários por loja
- Diferentes cargos e permissões
- Histórico de operações realizadas
- Controle de salários e contratos

## 🔧 Manutenção

### Backup
```bash
pg_dump -U postgres -d locadora_jogos > backup.sql
```

### Restore
```bash
psql -U postgres -d locadora_jogos < backup.sql
```

### Verificação de Integridade
```sql
-- Verificar relacionamentos
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY';
```

## 📝 Exemplos de Uso

### Registrar Aluguel
```sql
SELECT registrar_aluguel(1, 1, 2, '2024-01-15', 25.00);
```

### Buscar Jogos por Categoria
```sql
SELECT * FROM buscar_jogos_por_categoria('Estratégia');
```

### Calcular Faturamento
```sql
SELECT * FROM calcular_faturamento_periodo('2024-01-01', '2024-01-31');
```

### Recomendar Jogos
```sql
SELECT * FROM recomendar_jogos_clientes(1);
```

### Ver Relatórios
```sql
SELECT * FROM vw_jogos_populares LIMIT 10;
SELECT * FROM vw_estatisticas_loja;
```

## 🎨 Modelo Conceitual

O projeto inclui um diagrama PlantUML completo em `modelo_conceitual_plantuml.txt` que representa:
- 21 entidades principais
- Todos os relacionamentos com cardinalidades
- Chaves primárias e estrangeiras
- Atributos de cada entidade

## 📊 Estatísticas do Projeto

- **21 Tabelas** - Estrutura completa do domínio
- **8 Funções** - Lógica de negócio implementada
- **6 Triggers** - Validações e auditoria automática
- **4 Views** - Relatórios e consultas complexas
- **14 Consultas** - Exemplos práticos de uso
- **3 Roles** - Controle de acesso
- **RLS Ativo** - Segurança em nível de linha

## 🚀 Tecnologias

- **PostgreSQL 15+** - Banco de dados principal
- **PL/pgSQL** - Linguagem de programação
- **Docker** - Containerização
- **PlantUML** - Diagramação
- **DBeaver** - Interface gráfica

## 📝 Notas

- Todos os scripts estão sem comentários conforme solicitado
- Estrutura modular para fácil manutenção
- Compatível com PostgreSQL 12+
- Testado com Docker e instalação local
- Documentação completa incluída
- Modelo conceitual atualizado

---

**Desenvolvido para o curso de Banco de Dados 2** 🎓 