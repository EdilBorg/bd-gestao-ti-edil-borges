# Projeto de Base de Dados — Sistema de Gestão de TI

**Estudante:** Edil Borges Figueiredo  
**Curso:** Licenciatura em Informática — 2º Ano  
**Disciplina:** Tecnologias de Base de Dados  
**Tema:** Sistema de Gestão de TI (ITSM) com análise automática de impacto de falhas e avaliação de riscos de alterações

## Descrição do problema

As organizações modernas dependem fortemente da sua infraestrutura de TI. Quando um servidor, switch ou serviço crítico falha, o impacto pode propagar-se a dezenas de outros componentes e a utilizadores finais. Da mesma forma, alterações mal planeadas (atualizações, mudanças de configuração) introduzem riscos que muitas vezes só são detetados depois de ocorrerem incidentes.

Este projeto cria uma base de dados para um **sistema próprio de Gestão de TI** (não uma instalação do GLPI). O sistema permite:

- Inventariar ativos de TI (hardware, software, equipamentos de rede) e a sua localização;
- Gerir incidentes e manutenções;
- Modelar **dependências** entre ativos e serviços (inspirado no NetBox);
- Registar métricas e alertas de monitorização (inspirado no Zabbix);
- Registar **alterações** com avaliação explícita de risco;
- Calcular / consultar o **impacto potencial** de uma falha a partir das dependências.

O sistema servirá de base a um futuro projeto de Programação Web, onde técnicos, gestores e utilizadores finais poderão registar incidentes, consultar inventário, analisar impacto e aprovar alterações.

## Regras de negócio

1. Todo o ativo pertence a uma localização e a um tipo de ativo.
2. Um ativo pode depender de zero ou mais outros ativos (relação N:N através da tabela `dependencias_ativos`).
3. Um serviço de TI depende de um ou mais ativos críticos.
4. Um incidente está sempre associado a pelo menos um ativo ou a um serviço.
5. Só é permitido eliminar um ativo se não existirem incidentes abertos nem dependências ativas que o referenciem.
6. As alterações (Change Management) devem ter um nível de risco (Baixo, Médio, Alto, Crítico) calculado ou atribuído com base na criticidade dos ativos/serviços afetados.
7. Alertas de monitorização são gerados a partir de limiares definidos e ficam associados a um ativo.
8. Utilizadores do sistema têm papéis (Administrador, Técnico, Gestor, Utilizador Final) que determinam o que podem fazer no futuro sistema web.
9. Manutenções programadas ou corretivas devem registar o técnico responsável e o período.
10. A análise de impacto de uma falha consiste em percorrer as dependências (diretas e indiretas) para listar todos os ativos e serviços potencialmente afetados.

## Sistema web previsto

- **Utilizadores finais / colaboradores**: abrir incidentes, consultar estado dos seus equipamentos.
- **Técnicos**: gerir inventário, atribuir e resolver incidentes, registar manutenções, analisar impacto.
- **Gestores**: aprovar alterações de risco elevado, visualizar dashboards de disponibilidade e risco.
- **Administradores**: gerir utilizadores, tipos de ativo, localizações e limiares de alerta.

Funcionalidades principais: formulários de registo (incidentes, alterações, ativos), listagens com filtros, pesquisas, visualização de árvore de dependências e simulação de impacto.

## Estrutura do repositório

```
bd-gestao-ti-edil-borges/
├── README.md
├── diagrama_er.md          (exportar para PNG com mermaid.live ou draw.io)
├── modelo_relacional.md
├── 01_criacao_e_insercao.sql
└── 02_manipulacao.sql
```

## Link do vídeo

*(Colocar aqui o link do YouTube quando o vídeo estiver publicado)*

---

**Nota:** Esta base de dados foi desenhada de raiz, usando o GLPI como referência conceptual de gestão de ativos e ITIL, o Zabbix como referência de monitorização e o NetBox como referência de modelação de dependências de infraestrutura. Não se trata de uma cópia de nenhum desses sistemas.
