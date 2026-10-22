-- ============================================================
-- Sistema de Gestão de TI
-- Script de manipulação de dados (SELECT, JOIN, UPDATE, DELETE, teste de integridade)
-- Autor: Edil Borges Figueiredo
-- ============================================================

USE gestao_ti;

-- ------------------------------------------------------------
-- 1. SELECT simples (mínimo 3) — com WHERE e ORDER BY
-- ------------------------------------------------------------

-- 1.1 Listar todos os ativos com criticidade Critica ou Alta, ordenados por nome
SELECT id, nome, status, criticidade, numero_serie
FROM ativos
WHERE criticidade IN ('Critica', 'Alta')
ORDER BY criticidade DESC, nome;

-- 1.2 Listar incidentes ainda abertos ou em progresso, ordenados por prioridade e data
SELECT id, titulo, prioridade, status, data_abertura
FROM incidentes
WHERE status IN ('Aberto', 'EmProgresso')
ORDER BY FIELD(prioridade, 'Critica', 'Alta', 'Media', 'Baixa'), data_abertura;

-- 1.3 Listar alertas ativos de severidade Critical ou Warning, mais recentes primeiro
SELECT id, ativo_id, metrica, valor_atual, severidade, mensagem, data_alerta
FROM alertas_monitorizacao
WHERE status = 'Ativo' AND severidade IN ('Critical', 'Warning')
ORDER BY data_alerta DESC;

-- ------------------------------------------------------------
-- 2. SELECT com JOIN (mínimo 2)
-- ------------------------------------------------------------

-- 2.1 Incidentes com nome do ativo, serviço e técnico atribuído
SELECT 
    i.id,
    i.titulo,
    i.prioridade,
    i.status,
    a.nome AS ativo,
    s.nome AS servico,
    u.nome AS tecnico_atribuido
FROM incidentes i
LEFT JOIN ativos a ON i.ativo_id = a.id
LEFT JOIN servicos_ti s ON i.servico_id = s.id
LEFT JOIN utilizadores u ON i.atribuido_a = u.id
ORDER BY i.data_abertura DESC
LIMIT 15;

-- 2.2 Análise de impacto: ativos que dependem (diretamente) de um ativo crítico
--    Exemplo: o que fica afetado se o host ESXi (id=22) falhar
SELECT 
    d.tipo_dependencia,
    origem.nome AS ativo_que_depende,
    origem.criticidade AS criticidade_origem,
    destino.nome AS ativo_critico,
    destino.criticidade AS criticidade_destino
FROM dependencias_ativos d
JOIN ativos origem ON d.ativo_origem_id = origem.id
JOIN ativos destino ON d.ativo_destino_id = destino.id
WHERE d.ativo_destino_id = 22   -- ESXI-HOST-01
ORDER BY origem.criticidade DESC;

-- (Extra útil) Serviços suportados por um determinado ativo
SELECT 
    s.nome AS servico,
    s.criticidade,
    sa.papel,
    a.nome AS ativo
FROM servicos_ativos sa
JOIN servicos_ti s ON sa.servico_id = s.id
JOIN ativos a ON sa.ativo_id = a.id
WHERE a.id = 2   -- SRV-DB-01
ORDER BY s.criticidade DESC;

-- ------------------------------------------------------------
-- 3. UPDATE (mínimo 2)
-- ------------------------------------------------------------

-- 3.1 Resolver um incidente que estava em progresso (exemplo: id=1)
UPDATE incidentes
SET status = 'Resolvido',
    data_resolucao = NOW()
WHERE id = 1 AND status = 'EmProgresso';

-- Verificar
SELECT id, titulo, status, data_resolucao FROM incidentes WHERE id = 1;

-- 3.2 Reconhecer um alerta ativo
UPDATE alertas_monitorizacao
SET status = 'Reconhecido'
WHERE id = 1 AND status = 'Ativo';

-- Verificar
SELECT id, metrica, severidade, status FROM alertas_monitorizacao WHERE id = 1;

-- ------------------------------------------------------------
-- 4. DELETE (mínimo 1) — respeitando chaves estrangeiras
-- ------------------------------------------------------------

-- Apagar um alerta já resolvido (não tem dependências)
DELETE FROM alertas_monitorizacao
WHERE id = 25 AND status = 'Resolvido';

-- Verificar que foi removido
SELECT COUNT(*) AS restantes_com_id_25 FROM alertas_monitorizacao WHERE id = 25;

-- ------------------------------------------------------------
-- 5. Teste de integridade (mínimo 1)
--    Tentar inserir uma chave estrangeira inexistente
-- ------------------------------------------------------------

-- Tentativa: criar um incidente associado a um ativo que não existe (id=9999)
-- Este comando DEVE falhar com erro de foreign key constraint

-- Descomente a linha seguinte para executar o teste:
-- INSERT INTO incidentes (titulo, descricao, ativo_id, reportado_por, prioridade, status)
-- VALUES ('Teste de integridade', 'Este insert deve falhar', 9999, 1, 'Baixa', 'Aberto');

-- Explicação do erro esperado:
-- ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails
-- (`gestao_ti`.`incidentes`, CONSTRAINT `fk_inc_ativo` FOREIGN KEY (`ativo_id`) REFERENCES `ativos` (`id`))
--
-- Isto demonstra que a base de dados está a proteger a integridade referencial:
-- não é possível referenciar um ativo inexistente.

-- Para confirmar que a restrição existe:
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'gestao_ti'
  AND TABLE_NAME = 'incidentes'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

SELECT 'Script de manipulação executado. (O teste de integridade deve ser corrido manualmente e o erro explicado no vídeo.)' AS resultado;
