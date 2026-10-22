# Modelo Relacional — Sistema de Gestão de TI

## Tabelas e Chaves

### 1. utilizadores
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id                | INT               | PK, AUTO_INCREMENT                  |
| nome              | VARCHAR(100)      | NOT NULL                            |
| email             | VARCHAR(150)      | NOT NULL, UNIQUE                    |
| password_hash     | VARCHAR(255)      | NOT NULL                            |
| papel             | ENUM(...)         | NOT NULL (Administrador, Tecnico, Gestor, UtilizadorFinal) |
| ativo             | BOOLEAN           | DEFAULT TRUE                        |
| data_criacao      | DATETIME          | DEFAULT CURRENT_TIMESTAMP           |

### 2. localizacoes
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id                | INT               | PK, AUTO_INCREMENT                  |
| nome              | VARCHAR(100)      | NOT NULL                            |
| edificio          | VARCHAR(100)      |                                     |
| piso              | VARCHAR(50)       |                                     |
| cidade            | VARCHAR(80)       | NOT NULL                            |
| descricao         | TEXT              |                                     |

### 3. tipos_ativo
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id                | INT               | PK, AUTO_INCREMENT                  |
| nome              | VARCHAR(80)       | NOT NULL, UNIQUE                    |
| categoria         | ENUM(...)         | Hardware, Software, Rede, Servico   |
| descricao         | TEXT              |                                     |

### 4. ativos
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id                  | INT               | PK, AUTO_INCREMENT                  |
| nome                | VARCHAR(150)      | NOT NULL                            |
| numero_serie        | VARCHAR(80)       | UNIQUE                              |
| tipo_ativo_id       | INT               | FK → tipos_ativo(id)                |
| localizacao_id      | INT               | FK → localizacoes(id)               |
| responsavel_id      | INT               | FK → utilizadores(id)               |
| status              | ENUM(...)         | Operacional, EmManutencao, Avariado, Descontinuado |
| criticidade         | ENUM(...)         | Baixa, Media, Alta, Critica         |
| data_aquisicao      | DATE              |                                     |
| data_fim_garantia   | DATE              |                                     |
| observacoes         | TEXT              |                                     |

### 5. servicos_ti
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id              | INT               | PK, AUTO_INCREMENT                  |
| nome            | VARCHAR(120)      | NOT NULL, UNIQUE                    |
| descricao       | TEXT              |                                     |
| criticidade     | ENUM(...)         | Baixa, Media, Alta, Critica         |
| status          | ENUM(...)         | Ativo, Degradado, Indisponivel      |
| proprietario_id | INT               | FK → utilizadores(id)               |

### 6. dependencias_ativos  (relação N:N + tipo de dependência)
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id                  | INT               | PK, AUTO_INCREMENT                  |
| ativo_origem_id     | INT               | FK → ativos(id)                     |
| ativo_destino_id    | INT               | FK → ativos(id)                     |
| tipo_dependencia    | ENUM(...)         | ExecutaEm, ComunicaCom, ArmazenaEm, ProtegidoPor |
| descricao           | VARCHAR(255)      |                                     |
| UNIQUE (ativo_origem_id, ativo_destino_id, tipo_dependencia)

### 7. servicos_ativos  (quais ativos suportam cada serviço)
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id              | INT               | PK, AUTO_INCREMENT                  |
| servico_id      | INT               | FK → servicos_ti(id)                |
| ativo_id        | INT               | FK → ativos(id)                     |
| papel           | ENUM(...)         | Primario, Secundario, Suporte       |
| UNIQUE (servico_id, ativo_id)

### 8. incidentes
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id              | INT               | PK, AUTO_INCREMENT                  |
| titulo          | VARCHAR(200)      | NOT NULL                            |
| descricao       | TEXT              |                                     |
| ativo_id        | INT               | FK → ativos(id) (nullable)          |
| servico_id      | INT               | FK → servicos_ti(id) (nullable)     |
| reportado_por   | INT               | FK → utilizadores(id)               |
| atribuido_a     | INT               | FK → utilizadores(id)               |
| prioridade      | ENUM(...)         | Baixa, Media, Alta, Critica         |
| status          | ENUM(...)         | Aberto, EmProgresso, Resolvido, Fechado |
| data_abertura   | DATETIME          | DEFAULT CURRENT_TIMESTAMP           |
| data_resolucao  | DATETIME          |                                     |

### 9. manutencoes
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id              | INT               | PK, AUTO_INCREMENT                  |
| ativo_id        | INT               | FK → ativos(id)                     |
| tecnico_id      | INT               | FK → utilizadores(id)               |
| tipo            | ENUM(...)         | Preventiva, Corretiva, Preditiva    |
| descricao       | TEXT              | NOT NULL                            |
| data_inicio     | DATETIME          | NOT NULL                            |
| data_fim        | DATETIME          |                                     |
| status          | ENUM(...)         | Planeada, EmCurso, Concluida, Cancelada |

### 10. alertas_monitorizacao
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id              | INT               | PK, AUTO_INCREMENT                  |
| ativo_id        | INT               | FK → ativos(id)                     |
| metrica         | VARCHAR(80)       | NOT NULL (ex: CPU, RAM, Disco, Latencia) |
| valor_atual     | DECIMAL(10,2)     |                                     |
| limiar          | DECIMAL(10,2)     |                                     |
| severidade      | ENUM(...)         | Info, Warning, Critical             |
| mensagem        | VARCHAR(255)      |                                     |
| data_alerta     | DATETIME          | DEFAULT CURRENT_TIMESTAMP           |
| status          | ENUM(...)         | Ativo, Reconhecido, Resolvido       |

### 11. alteracoes
| Coluna            | Tipo              | Restrições                          |
|-------------------|-------------------|-------------------------------------|
| id                  | INT               | PK, AUTO_INCREMENT                  |
| titulo              | VARCHAR(200)      | NOT NULL                            |
| descricao           | TEXT              |                                     |
| solicitado_por      | INT               | FK → utilizadores(id)               |
| aprovado_por        | INT               | FK → utilizadores(id) (nullable)    |
| ativo_principal_id  | INT               | FK → ativos(id) (nullable)          |
| servico_id          | INT               | FK → servicos_ti(id) (nullable)     |
| risco               | ENUM(...)         | Baixo, Medio, Alto, Critico         |
| status              | ENUM(...)         | Solicitada, EmAvaliacao, Aprovada, Rejeitada, Implementada, Cancelada |
| data_solicitacao    | DATETIME          | DEFAULT CURRENT_TIMESTAMP           |
| data_implementacao  | DATETIME          |                                     |
| justificativa_risco | TEXT            |                                     |

## Relacionamentos principais

- utilizadores 1:N ativos (responsável)
- localizacoes 1:N ativos
- tipos_ativo 1:N ativos
- ativos N:N ativos (via dependencias_ativos)
- servicos_ti N:N ativos (via servicos_ativos)
- ativos 1:N incidentes, manutencoes, alertas
- utilizadores 1:N incidentes (reportado_por / atribuido_a)
- utilizadores 1:N alteracoes, manutencoes

## Entidade fraca / especial

A tabela `dependencias_ativos` funciona como entidade associativa com atributos próprios (tipo_dependencia), essencial para a análise automática de impacto.
