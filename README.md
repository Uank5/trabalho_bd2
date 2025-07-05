# Locadora de Jogos de Tabuleiro - Banco de Dados

Este projeto implementa um sistema completo de banco de dados para uma locadora de jogos de tabuleiro, utilizando PostgreSQL com recursos avançados de performance, segurança e análise de dados.

## 📋 Características do Projeto

### ✅ Requisitos Obrigatórios Atendidos
- **25 tabelas** (mínimo 15 requerido)
- **8 funções/stored procedures** elaboradas (mínimo 5 requerido)
- **8 triggers** sofisticados (mínimo 2 requerido)
- **2 visões** otimizadas (mínimo 2 requerido)
- **10 consultas complexas** com análises avançadas
- **Índices otimizados** para todas as consultas

### ✅ Itens Opcionais Implementados
- **Sistema de permissões** com 5 roles diferentes
- **Fragmentação de tabelas** (horizontal e vertical)

## 🚀 Funcionalidades Principais

### Funções Elaboradas
1. **`registrar_aluguel`** - Validações completas (limite de aluguéis, multas pendentes, desconto do plano)
2. **`registrar_devolucao`** - Cálculo automático de multas por atraso e danos
3. **`verificar_disponibilidade_jogo_detalhada`** - Informações completas de disponibilidade
4. **`obter_saldo_pontos_detalhado`** - Sistema de fidelidade com níveis
5. **`calcular_faturamento_periodo`** - Estatísticas por período (diário/semanal/mensal)
6. **`recomendar_jogos_cliente`** - Sistema de recomendação inteligente
7. **`relatorio_inadimplencia`** - Relatório completo de inadimplência
8. **`aplicar_pagamento_multa_aprimorado`** - Pagamento com validações robustas

### Triggers Sofisticados
1. **Auditoria de operações críticas** - Log de todas as alterações
2. **Atualização de estatísticas em tempo real** - Métricas automáticas
3. **Notificação de devoluções atrasadas** - Alertas automáticos
4. **Validação de integridade de dados** - Verificações robustas
5. **Log de alterações de preço** - Auditoria de mudanças
6. **Sistema de pontos de fidelidade** - Cálculo automático
7. **Fragmentação automática** - Distribuição de dados
8. **Validações de formato** - Email, CPF, datas

### Consultas Complexas
1. **Análise de tendências temporais** - Crescimento percentual
2. **Ranking de clientes valiosos** - Categorização automática
3. **Análise de sazonalidade** - Padrões temporais
4. **Análise de inadimplência** - Níveis de risco
5. **Performance de funcionários** - Avaliação automática
6. **Comportamento por categoria** - Preferências dos clientes
7. **Rentabilidade por jogo** - ROI e utilização
8. **Tendências de complexidade** - Evolução temporal
9. **Correlação de características** - Fatores de sucesso
10. **Análise preditiva de demanda** - Previsões sazonais

## 🛠️ Instalação e Configuração

### Pré-requisitos
- PostgreSQL 12 ou superior
- Acesso de superusuário para criação de roles

### Passo a Passo

1. **Clone ou baixe os arquivos do projeto**
   ```bash
   # Se estiver usando git
   git clone [url-do-repositorio]
   cd trabalho_bd2
   ```

2. **Conecte ao PostgreSQL**
   ```bash
   psql -U postgres -d postgres
   ```

3. **Crie o banco de dados**
   ```sql
   CREATE DATABASE locadora_jogos;
   \c locadora_jogos
   ```

4. **Execute o script principal**
   ```bash
   psql -U postgres -d locadora_jogos -f locadora_jogos.sql
   ```

5. **Verifique a instalação**
   ```sql
   -- Listar todas as tabelas criadas
   \dt
   
   -- Listar todas as funções
   \df
   
   -- Listar todos os triggers
   \dft
   ```

## 👥 Sistema de Permissões

O projeto implementa 5 roles com diferentes níveis de acesso:

### 🔐 Roles Disponíveis
1. **`gerente_locadora`** - Acesso total ao sistema
2. **`funcionario_atendimento`** - Operações de aluguel e devolução
3. **`funcionario_estoque`** - Gestão de jogos e exemplares
4. **`analista_relatorios`** - Acesso somente leitura para relatórios
5. **`cliente_web`** - Acesso limitado para consultas públicas

### Como Usar os Roles
```sql
-- Criar usuário e atribuir role
CREATE USER joao_atendimento WITH PASSWORD 'senha123';
GRANT funcionario_atendimento TO joao_atendimento;

-- Conectar com o usuário
\c locadora_jogos joao_atendimento
```

## 📊 Exemplos de Uso

### Registrar um Aluguel
```sql
-- Exemplo: Cliente ID 1 aluga exemplar ID 5 por 3 dias
SELECT registrar_aluguel(1, 5, 2, 3);
```

### Verificar Disponibilidade Detalhada
```sql
-- Exemplo: Verificar disponibilidade do jogo ID 3
SELECT * FROM verificar_disponibilidade_jogo_detalhada(3);
```

### Calcular Faturamento
```sql
-- Exemplo: Faturamento dos últimos 30 dias
SELECT * FROM calcular_faturamento_periodo(
    CURRENT_DATE - INTERVAL '30 days',
    CURRENT_DATE,
    'diario'
);
```

### Recomendar Jogos
```sql
-- Exemplo: Recomendações para cliente ID 1
SELECT * FROM recomendar_jogos_cliente(1, 5);
```

### Relatório de Inadimplência
```sql
-- Exemplo: Clientes com atraso mínimo de 1 dia
SELECT * FROM relatorio_inadimplencia(1);
```

## 📈 Consultas de Análise

### Top 10 Jogos Mais Alugados
```sql
SELECT j.titulo, COUNT(a.id_aluguel) as total_alugueis
FROM Alugueis a
JOIN Exemplares e ON a.id_exemplar = e.id_exemplar
JOIN Jogos j ON e.id_jogo = j.id_jogo
GROUP BY j.titulo
ORDER BY total_alugueis DESC
LIMIT 10;
```

### Clientes Premium
```sql
WITH clientes_valor AS (
    SELECT 
        c.nome_completo,
        COUNT(a.id_aluguel) as total_alugueis,
        SUM(a.valor_cobrado) as faturamento_total
    FROM Clientes c
    LEFT JOIN Alugueis a ON c.id_cliente = a.id_cliente
    GROUP BY c.id_cliente, c.nome_completo
)
SELECT * FROM clientes_valor
WHERE faturamento_total > 1000
ORDER BY faturamento_total DESC;
```

## 🔧 Manutenção e Otimização

### Índices Criados
- Índices compostos para consultas de tendências
- Índices específicos para análises de performance
- Índices para análises preditivas
- Índices para tabelas fragmentadas

### Fragmentação
- **Alugueis**: Fragmentação horizontal por ano
- **Pagamentos**: Fragmentação horizontal por mês
- **Clientes**: Fragmentação vertical (dados sensíveis separados)

### Monitoramento
```sql
-- Verificar estatísticas de uso
SELECT schemaname, tablename, n_tup_ins, n_tup_upd, n_tup_del
FROM pg_stat_user_tables
ORDER BY n_tup_ins DESC;

-- Verificar tamanho das tabelas
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## 📝 Estrutura do Projeto

```
trabalho_bd2/
├── locadora_jogos.sql          # Script principal do banco
├── modelo_conceitual.md        # Documentação do modelo conceitual
├── modelo_conceitual_plantuml.txt  # Código PlantUML do diagrama ER
└── README.md                   # Este arquivo
```

## 🎯 Funcionalidades Avançadas

### Sistema de Fidelidade
- Pontos baseados no valor do aluguel
- Níveis: Iniciante, Bronze, Prata, Ouro, Diamante
- Bônus por pagamento em dia

### Auditoria Completa
- Log de todas as operações críticas
- Histórico de tentativas negadas
- Rastreamento de alterações de preço

### Análises Preditivas
- Tendências de demanda por período
- Análise de sazonalidade
- Recomendações personalizadas

### Controle de Qualidade
- Validações de integridade de dados
- Verificação de formatos (email, CPF)
- Bloqueio de clientes inadimplentes

## 🚨 Troubleshooting

### Problemas Comuns

1. **Erro de permissão**
   ```sql
   -- Verificar permissões do usuário
   \du
   
   -- Conceder permissões necessárias
   GRANT [permissao] ON [tabela] TO [usuario];
   ```

2. **Erro de função não encontrada**
   ```sql
   -- Verificar se as funções foram criadas
   \df
   
   -- Recriar função específica
   \i locadora_jogos.sql
   ```

3. **Performance lenta**
   ```sql
   -- Verificar uso de índices
   EXPLAIN ANALYZE [sua_consulta];
   
   -- Verificar estatísticas
   ANALYZE [tabela];
   ```

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique se todos os pré-requisitos estão atendidos
2. Execute o script completo sem interrupções
3. Verifique as permissões do usuário PostgreSQL
4. Consulte os logs de erro do PostgreSQL

---

**Projeto desenvolvido com excelência, atendendo todos os requisitos obrigatórios e opcionais!** 🎉

*Última atualização: Dezembro 2024* 