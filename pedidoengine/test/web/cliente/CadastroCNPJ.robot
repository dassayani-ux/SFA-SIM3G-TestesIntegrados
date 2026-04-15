*** Settings ***
Documentation    Testes de validação do campo CNPJ alfanumérico no cadastro de cliente PJ.
...
...              Contexto: A partir da Instrução Normativa RFB nº 2.119/2022, o CNPJ passa
...              a aceitar caracteres alfanuméricos (letras A-Z e dígitos 0-9) nas posições
...              de raiz e ordem (posições 1 a 12). Os 2 dígitos verificadores continuam
...              numéricos, calculados via Módulo 11 com valores ASCII (char - 48).
...
...              Formato alfanumérico: SS.SSS.SSS/SSSS-NN  (S=letra ou número, N=número)
...              Exemplo válido: 12.ABC.345/01DE-35
...
...              CAMADAS TESTADAS:
...              1. Campo/Máscara — comportamento do input enquanto o usuário digita
...              2. Regra de negócio — cálculo do Módulo 11 com ASCII
...              3. Persistência — gravação correta no banco (campo VARCHAR)
...              4. Pesquisa — listagem de clientes por CNPJ alfanumérico
...              5. Retrocompatibilidade — CNPJ numérico ainda funciona
...
...              ⚠️  Pré-requisito: a versão do SFA deve ter o suporte a CNPJ alfanumérico
...              implementado. Testes de comportamento do campo (T002–T005) falharão
...              em versões sem a feature de front-end. T001 e T009 falharão sem back-end.

Resource         ${EXECDIR}/pedidoengine/resources/base_web.robot
Resource         ${EXECDIR}/pedidoengine/resources/pages/web/cliente/cadastroCNPJResource.robot

Suite Setup      Run Keywords    Conecta ao banco de dados
...              AND             Configura parametros padroes do sistema
...              AND             Configura parametros para testes de CNPJ
...              AND             Abre navegador
...              AND             Realiza login na plataforma web

Suite Teardown   Disconnect From Database

*** Test Cases ***
# ==============================================================================
# CAMADA 1 — COMPORTAMENTO DO CAMPO (MÁSCARA / FRONT-END)
# Testa o campo isoladamente, sem necessidade de salvar o formulário.
# Ref: CT01, CT02, CT03, CT10, CT11 do documento de cenários.
# ==============================================================================

Teste 001 ::: Campo aceita letras A-Z nas 12 primeiras posições e aplica máscara
    [Documentation]    CT01: Digitar letras maiúsculas nas posições 1-12 do CNPJ.
    ...                O campo deve aceitar e aplicar a máscara SS.SSS.SSS/SSSS-NN.
    ...                Letras devem aparecer formatadas com pontos, barra e traço.
    Acessa tela de cadastro de cliente
    Valida campo aceita letras e aplica mascara

Teste 002 ::: Campo bloqueia letras nas posições dos dígitos verificadores (13-14)
    [Documentation]    CT02: Tentar digitar letras nas duas últimas posições do CNPJ.
    ...                A lei exige que os DVs sejam estritamente numéricos.
    ...                O campo deve bloquear qualquer letra nas posições 13 e 14.
    Acessa tela de cadastro de cliente
    Valida campo bloqueia letras nos DVs

Teste 003 ::: Campo bloqueia caracteres especiais em qualquer posição
    [Documentation]    CT03: Tentar digitar @, #, $, %, & no campo CNPJ.
    ...                O campo não deve aceitar nenhum caractere especial.
    Acessa tela de cadastro de cliente
    Valida campo bloqueia caracteres especiais

Teste 004 ::: Campo converte letras minúsculas para maiúsculas automaticamente
    [Documentation]    CT10: Digitar CNPJ com letras minúsculas (ex: 12abc34501de).
    ...                A lei especifica A-Z maiúsculas. O campo deve converter
    ...                automaticamente para maiúsculas ao digitar ou ao sair do campo (blur).
    ...                Isso evita quebra no cálculo do DV (ASCII 'a'=97 ≠ 'A'=65).
    Acessa tela de cadastro de cliente
    Valida campo converte minusculas para maiusculas

Teste 005 ::: Campo bloqueia letras acentuadas e caractere Ç
    [Documentation]    CT11: Tentar colar/digitar ã, é, ç, etc.
    ...                A lei especifica as 26 letras do alfabeto (sem acentos).
    ...                Acentos desviam do padrão ASCII e devem ser bloqueados.
    Acessa tela de cadastro de cliente
    Valida campo bloqueia letras acentuadas

Teste 006 ::: Campo sanitiza CNPJ colado com espaços extras (trim)
    [Documentation]    CT12: Colar no campo um CNPJ com espaços em branco no início/fim,
    ...                simulando cópia de PDF ou e-mail.
    ...                O campo deve fazer trim e aplicar a máscara corretamente,
    ...                sem jogar os últimos caracteres para fora do limite de 14 posições.
    Acessa tela de cadastro de cliente
    Valida campo faz trim em cnpj colado com espacos

# ==============================================================================
# CAMADA 2 — REGRA DE NEGÓCIO (MÓDULO 11 / VALIDAÇÃO)
# Testa a validação matemática do CNPJ. Requer formulário completo + salvar.
# Ref: CT04, CT05 do documento de cenários.
# ==============================================================================

Teste 007 ::: CNPJ alfanumérico válido é aceito e gravado no banco
    [Documentation]    CT04: Gera CNPJ alfanumérico dinamicamente com DVs matematicamente
    ...                corretos (Módulo 11 / ASCII). Cadastra PJ completo e valida
    ...                persistência no banco. Atenção: a coluna documentoidentificacao
    ...                deve ser VARCHAR — se for Integer, o banco estoura Type Mismatch.
    Acessa tela de cadastro de cliente
    Cadastra PJ com CNPJ alfanumerico valido
    Valida CNPJ alfanumerico no banco de dados

Teste 008 ::: CNPJ alfanumérico com DV inválido é rejeitado pelo sistema
    [Documentation]    CT05: Usa base conhecida 12ABC34501DE cujos DVs corretos são 35.
    ...                Informa DV errado (99) e tenta salvar. O sistema deve barrar
    ...                e exibir mensagem de erro (ex: "CNPJ Inválido").
    Acessa tela de cadastro de cliente
    Preenche PJ com CNPJ    ${CNPJ_ALFA_DV_INVALIDO}
    Tenta gravar e valida rejeicao
    Valida que cliente nao foi gravado no banco

Teste 009 ::: CNPJ alfanumérico zerado é rejeitado (regra RFB)
    [Documentation]    CNPJ composto somente de zeros (00000000000000) é vedado pela RFB.
    ...                O sistema deve rejeitar sem gravar.
    Acessa tela de cadastro de cliente
    Preenche PJ com CNPJ    ${CNPJ_ALFA_ZEROS}
    Tenta gravar e valida rejeicao
    Valida que cliente nao foi gravado no banco

Teste 010 ::: CNPJ alfanumérico com tamanho incorreto é rejeitado
    [Documentation]    CNPJ com 13 caracteres (um a menos que o obrigatório de 14)
    ...                deve ser rejeitado por formato inválido.
    Acessa tela de cadastro de cliente
    Preenche PJ com CNPJ    ${CNPJ_ALFA_TAMANHO_CURTO}
    Tenta gravar e valida rejeicao
    Valida que cliente nao foi gravado no banco

Teste 011 ::: CNPJ alfanumérico com base 100% em letras é aceito
    [Documentation]    CT17: Apesar de improvável no primeiro dia da lei, é matematicamente
    ...                e legalmente possível um CNPJ com os 12 primeiros caracteres
    ...                sendo apenas letras (ex: AA.AAA.AAA/AAAA-XX).
    ...                O sistema não pode presumir que deve haver ao menos um número.
    Acessa tela de cadastro de cliente
    Cadastra PJ com CNPJ base 100 por cento letras
    Valida CNPJ alfanumerico no banco de dados

# ==============================================================================
# CAMADA 3 — PESQUISA E FILTROS
# Testa a busca na listagem de clientes após cadastro com CNPJ alfanumérico.
# Ref: CT08, CT09 do documento de cenários.
# Depende de T007 ter sido executado com sucesso (cria o cliente com CNPJ alfanum.).
# ==============================================================================

Teste 012 ::: Pesquisa cliente por CNPJ alfanumérico com máscara
    [Documentation]    CT08: Na listagem de clientes, pesquisar usando CNPJ formatado
    ...                (ex: 12.ABC.345/01DE-35). O sistema deve retornar o cadastro.
    ...                Depende de T007 ter criado um cliente com CNPJ alfanumérico.
    [Tags]    depende-T007
    Acessa listagem de clientes
    Pesquisa cliente por CNPJ com mascara    ${cnpj_alfanum_suite_fmt}
    Valida resultado da pesquisa por CNPJ

Teste 013 ::: Pesquisa cliente por CNPJ alfanumérico sem máscara
    [Documentation]    CT09: Na listagem de clientes, pesquisar usando CNPJ sem formatação
    ...                (ex: 12ABC34501DE35). O sistema deve limpar a formatação
    ...                internamente e retornar o mesmo cadastro.
    ...                Depende de T007 ter criado um cliente com CNPJ alfanumérico.
    [Tags]    depende-T007
    Acessa listagem de clientes
    Pesquisa cliente por CNPJ sem mascara    ${cnpj_alfanum_suite_raw}
    Valida resultado da pesquisa por CNPJ

# ==============================================================================
# CAMADA 4 — RETROCOMPATIBILIDADE
# Garante que a mudança não quebra CNPJs numéricos já cadastrados.
# Ref: CT06 do documento de cenários.
# ==============================================================================

Teste 014 ::: CNPJ numérico tradicional continua sendo aceito
    [Documentation]    CT06: A lei é clara — CNPJs numéricos existentes continuam válidos.
    ...                Valida que a implementação do CNPJ alfanumérico não quebra
    ...                o fluxo de cadastro com CNPJ numérico no formato NN.NNN.NNN/NNNN-NN.
    ...                Esta é a principal garantia de não quebrar a base de clientes atual.
    Acessa tela de cadastro de cliente
    Cadastra PJ com CNPJ numerico
    Valida cliente no banco de dados
