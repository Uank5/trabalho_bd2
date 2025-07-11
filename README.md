# 🎲 Locadora de Jogos - Banco de Dados PostgreSQL

Sistema completo de banco de dados para uma locadora de jogos de tabuleiro, desenvolvido em PostgreSQL.

## 📊 Requisitos Mínimos vs. Implementação

| Componente | Mínimo | Implementado | Status |
|------------|--------|--------------|--------|
| **Tabelas** | 15 | 18 | ✅ +3 |
| **Funções** | 5 | 9 | ✅ +4 |
| **Triggers** | 2 | 6 | ✅ +4 |
| **Views** | 2 | 6 | ✅ +4 |
| **Consultas** | 10 | 14 | ✅ +4 |

## 🗂️ Estrutura do Projeto

```
trabalho_bd2/
├── schema.sql              # Estrutura das tabelas
├── seed.sql                # Dados iniciais (categorias, editoras, etc.)
├── sample_data.sql         # Dados de exemplo
├── functions.sql           # Funções armazenadas
├── triggers.sql            # Triggers
├── views.sql              # Views
├── permissions.sql         # Permissões e RLS
├── setup_complete.sql      # Script completo de setup
├── queries_examples.sql    # Exemplos de consultas
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

### Tabelas Principais (18 total)

#### Entidades Core
- **Clientes** - Cadastro de clientes
- **Funcionarios** - Funcionários das lojas
- **Lojas** - Filiais da locadora
- **Cargos** - Cargos dos funcionários

#### Jogos e Exemplares
- **Jogos** - Catálogo de jogos
- **Exemplares** - Cópias físicas dos jogos
- **Editoras** - Editoras dos jogos
- **Categorias** - Categorias dos jogos
- **Mecanicas** - Mecânicas dos jogos
- **Designers** - Designers dos jogos

#### Relacionamentos
- **Jogo_Categoria** - Relacionamento N:N jogos-categorias
- **Jogo_Mecanica** - Relacionamento N:N jogos-mecânicas
- **Jogo_Designer** - Relacionamento N:N jogos-designers

#### Operações
- **Alugueis** - Registro de aluguéis
- **Devolucoes** - Registro de devoluções
- **Multas** - Multas por atraso
- **Pagamentos** - Pagamentos de aluguéis e multas
- **Reservas** - Reservas de jogos

#### Auditoria
- **Log_Alteracoes_Preco** - Log de alterações de preço

### Funções (9 total)

1. `verificar_disponibilidade_jogo(p_id_jogo)` - Verifica disponibilidade de exemplares
2. `calcular_multa_atraso()` - Calcula multa por atraso
3. `buscar_jogos_por_categoria(p_nome_categoria)` - Busca jogos por categoria
4. `buscar_jogos_por_mecanica(p_nome_mecanica)` - Busca jogos por mecânica
5. `buscar_jogos_por_designer(p_nome_designer)` - Busca jogos por designer
6. `buscar_jogos_por_preco(p_preco_minimo, p_preco_maximo)` - Busca por faixa de preço
7. `buscar_jogos_por_jogadores(p_num_jogadores)` - Busca por número de jogadores
8. `buscar_jogos_por_tempo(p_tempo_maximo_minutos)` - Busca por tempo de jogo
9. `buscar_jogos_por_complexidade(p_complexidade_minima, p_complexidade_maxima)` - Busca por complexidade

### Triggers (6 total)

1. `tg_notificar_devolucoes_atrasadas` - Notifica devoluções atrasadas
2. `tg_log_alteracao_preco` - Log de alterações de preço
3. `tg_validar_aluguel` - Valida aluguel
4. `tg_atualizar_status_exemplar` - Atualiza status do exemplar
5. `tg_validar_devolucao` - Valida devolução
6. `tg_calcular_multa_automatica` - Calcula multa automaticamente

### Views (6 total)

1. `vw_jogos_completos` - Informações completas dos jogos
2. `vw_alugueis_detalhados` - Detalhes dos aluguéis
3. `vw_devolucoes_detalhadas` - Detalhes das devoluções
4. `vw_multas_detalhadas` - Detalhes das multas
5. `vw_estatisticas_loja` - Estatísticas por loja
6. `vw_jogos_populares` - Jogos mais populares

### Consultas de Exemplo (14 total)

Consultas SQL demonstrando:
- Relatórios de aluguéis
- Estatísticas de clientes
- Análise de jogos populares
- Relatórios financeiros
- Consultas por categoria/mecânica
- Análise temporal

## 🔐 Segurança

### Roles
- **gerente** - Acesso total ao sistema
- **funcionario** - Acesso limitado às operações
- **cliente** - Acesso apenas a consultas básicas

### Row Level Security (RLS)
- Políticas de acesso por loja
- Restrições por cargo
- Isolamento de dados por filial

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
- Cadastro completo de jogos
- Controle de exemplares
- Categorização e classificação
- Busca avançada

### Gestão de Clientes
- Cadastro de clientes
- Histórico de aluguéis
- Controle de multas
- Sistema de reservas

### Gestão de Aluguéis
- Processo completo de aluguel
- Controle de devoluções
- Cálculo automático de multas
- Relatórios detalhados

### Gestão Financeira
- Controle de pagamentos
- Cálculo de multas
- Relatórios de faturamento
- Análise de receita

## 🔧 Manutenção

### Backup
```bash
pg_dump -U postgres -d locadora_jogos > backup.sql
```

### Restore
```bash
psql -U postgres -d locadora_jogos < backup.sql
```

## 📝 Notas

- Todos os scripts estão sem comentários conforme solicitado
- Estrutura modular para fácil manutenção
- Compatível com PostgreSQL 12+
- Testado com Docker e instalação local 