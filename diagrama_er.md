# Diagrama Entidade-Relacionamento (texto / Mermaid)

Podes copiar o código Mermaid abaixo para https://mermaid.live ou draw.io e exportar como `diagrama_er.png`.

```mermaid
erDiagram
    UTILIZADORES ||--o{ ATIVOS : "é responsável"
    UTILIZADORES ||--o{ INCIDENTES : "reporta"
    UTILIZADORES ||--o{ INCIDENTES : "é atribuído"
    UTILIZADORES ||--o{ MANUTENCOES : "executa"
    UTILIZADORES ||--o{ ALTERACOES : "solicita"
    UTILIZADORES ||--o{ ALTERACOES : "aprova"
    UTILIZADORES ||--o{ SERVICOS_TI : "é proprietário"

    LOCALIZACOES ||--o{ ATIVOS : "localiza"
    TIPOS_ATIVO ||--o{ ATIVOS : "classifica"

    ATIVOS ||--o{ DEPENDENCIAS_ATIVOS : "origem"
    ATIVOS ||--o{ DEPENDENCIAS_ATIVOS : "destino"
    ATIVOS ||--o{ SERVICOS_ATIVOS : "suporta"
    ATIVOS ||--o{ INCIDENTES : "afeta"
    ATIVOS ||--o{ MANUTENCOES : "sofre"
    ATIVOS ||--o{ ALERTAS_MONITORIZACAO : "gera"
    ATIVOS ||--o{ ALTERACOES : "é alvo"

    SERVICOS_TI ||--o{ SERVICOS_ATIVOS : "usa"
    SERVICOS_TI ||--o{ INCIDENTES : "afeta"
    SERVICOS_TI ||--o{ ALTERACOES : "é alvo"

    UTILIZADORES {
        int id PK
        string nome
        string email
        string papel
        boolean ativo
    }

    LOCALIZACOES {
        int id PK
        string nome
        string cidade
    }

    TIPOS_ATIVO {
        int id PK
        string nome
        string categoria
    }

    ATIVOS {
        int id PK
        string nome
        string numero_serie
        int tipo_ativo_id FK
        int localizacao_id FK
        int responsavel_id FK
        string status
        string criticidade
    }

    SERVICOS_TI {
        int id PK
        string nome
        string criticidade
        string status
        int proprietario_id FK
    }

    DEPENDENCIAS_ATIVOS {
        int id PK
        int ativo_origem_id FK
        int ativo_destino_id FK
        string tipo_dependencia
    }

    SERVICOS_ATIVOS {
        int id PK
        int servico_id FK
        int ativo_id FK
        string papel
    }

    INCIDENTES {
        int id PK
        string titulo
        int ativo_id FK
        int servico_id FK
        int reportado_por FK
        int atribuido_a FK
        string prioridade
        string status
    }

    MANUTENCOES {
        int id PK
        int ativo_id FK
        int tecnico_id FK
        string tipo
        string status
    }

    ALERTAS_MONITORIZACAO {
        int id PK
        int ativo_id FK
        string metrica
        string severidade
        string status
    }

    ALTERACOES {
        int id PK
        string titulo
        int solicitado_por FK
        int aprovado_por FK
        int ativo_principal_id FK
        int servico_id FK
        string risco
        string status
    }
```

**Cardinalidades principais:**
- Um Utilizador pode ser responsável por vários Ativos (1:N)
- Um Ativo pertence a uma Localização e a um Tipo (N:1)
- Dependências: N:N entre Ativos (através de DEPENDENCIAS_ATIVOS)
- Serviços N:N Ativos (através de SERVICOS_ATIVOS)
- Um Ativo pode ter muitos Incidentes, Manutenções e Alertas (1:N)

**Nota para o vídeo:** Explica as cardinalidades, a participação (total/parcial) e o papel da entidade associativa `dependencias_ativos` para a análise automática de impacto.
