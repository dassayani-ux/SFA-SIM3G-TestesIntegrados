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

# ==============================================================================
# CAMADA 1 (EXTRA) — MÁSCARA E FORMATAÇÃO AVANÇADA
# Testa comportamentos específicos do campo relacionados à aplicação
# e re-sanitização da máscara em cenários alfanumérico e numérico.
# Ref: WEB_13, WEB_14, WEB_18, WEB_19 do plano de expansão.
# ==============================================================================

Teste 015 ::: WEB_13 Máscara alfanumérica exibe formato SS.SSS.SSS/SSSS-NN ao digitar
    [Documentation]    WEB_13: Ao digitar um CNPJ alfanumérico bruto (ex: 12ABC34501DE35),
    ...                o campo deve aplicar imediatamente a máscara SS.SSS.SSS/SSSS-NN,
    ...                inserindo os separadores (pontos, barra, traço) nas posições certas.
    ...                Valida o padrão da máscara e que letras permanecem visíveis.
    [Tags]    mascara    campo
    Acessa tela de cadastro de cliente
    Valida mascara alfanumerica aplicada

Teste 016 ::: WEB_14 Máscara numérica exibe formato NN.NNN.NNN/NNNN-NN ao digitar
    [Documentation]    WEB_14: Ao digitar um CNPJ numérico bruto (ex: 12345678000195),
    ...                o campo deve aplicar a máscara NN.NNN.NNN/NNNN-NN,
    ...                mantendo a compatibilidade com o formato tradicional.
    [Tags]    mascara    campo
    Acessa tela de cadastro de cliente
    Valida mascara numerica aplicada

Teste 017 ::: WEB_18 Colar CNPJ já formatado — campo re-sanitiza a máscara
    [Documentation]    WEB_18: Ao colar um CNPJ que já possui a máscara aplicada
    ...                (ex: 12.ABC.345/01DE-35 via Ctrl+V), o campo deve remover
    ...                duplicidade de separadores e re-aplicar a máscara corretamente,
    ...                garantindo que a base de 14 caracteres seja preservada.
    [Tags]    mascara    campo    colar
    Acessa tela de cadastro de cliente
    Valida campo re-sanitiza cnpj com mascara colada

Teste 018 ::: WEB_19 Colar CNPJ bruto — máscara aplicada automaticamente
    [Documentation]    WEB_19: Ao colar um CNPJ bruto sem máscara (ex: 12ABC34501DE35),
    ...                o campo deve detectar o valor colado e aplicar a máscara
    ...                SS.SSS.SSS/SSSS-NN automaticamente, sem exigir re-digitação.
    [Tags]    mascara    campo    colar
    Acessa tela de cadastro de cliente
    Valida campo aplica mascara em cnpj bruto colado

# ==============================================================================
# CAMADA 2 (EXTRA) — VALIDAÇÃO / ERRO DE NEGÓCIO
# Testa se a mensagem de erro é exibida corretamente na tentativa de gravar
# um CNPJ com DV inválido (cenário de feedback ao usuário).
# Ref: WEB_20 do plano de expansão.
# ==============================================================================

Teste 019 ::: WEB_20 Mensagem de erro visível para CNPJ com DV inválido
    [Documentation]    WEB_20: Ao preencher o formulário com um CNPJ cujo DV não bate
    ...                com o Módulo 11 (ex: 12.ABC.345/01DE-99) e clicar em Gravar,
    ...                o sistema deve exibir mensagem de erro clara ("CNPJ Inválido"
    ...                ou similar), sem fechar o formulário nem navegar.
    ...                Valida presença de toast, alerta ou campo com erro.
    [Tags]    validacao    erro
    Acessa tela de cadastro de cliente
    Preenche PJ com CNPJ    ${CNPJ_ALFA_DV_INVALIDO}
    Valida mensagem de erro visivel para cnpj invalido

# ==============================================================================
# CAMADA 3 (EXTRA) — PESQUISA POR CNPJ NUMÉRICO NA LISTAGEM
# Garante que a pesquisa avançada por documento também funciona para
# CNPJ no formato numérico tradicional (retrocompatibilidade na listagem).
# Ref: WEB_22 do plano de expansão. Depende de T014.
# ==============================================================================

Teste 020 ::: WEB_22 Pesquisa cliente por CNPJ numérico no filtro de listagem
    [Documentation]    WEB_22: Na pesquisa avançada da listagem de clientes,
    ...                filtrar pelo campo Documento usando o CNPJ numérico cadastrado
    ...                em T014. O sistema deve retornar o cliente correspondente,
    ...                validando retrocompatibilidade da busca por CNPJ numérico.
    [Tags]    pesquisa    depende-T014
    Acessa listagem de clientes
    Pesquisa cliente por CNPJ numerico no filtro    ${cnpj_numerico_suite_fmt}    ${nome_cnpj_numerico_suite}
    Valida cliente encontrado por CNPJ numerico    ${nome_cnpj_numerico_suite}

# ==============================================================================
# GRUPO TRIM / QUEBRA DE LINHA
# Testa comportamentos de higienização de entrada no campo CNPJ.
# Ref: WEB_33 do plano de expansão.
# ==============================================================================

Teste 021 ::: WEB_33 Campo sanitiza CNPJ com quebra de linha no meio
    [Documentation]    WEB_33: Simula cópia de PDF que trouxe \n no meio do CNPJ.
    ...                Cola "12ABC345<newline>01DE35" via JavaScript no campo CNPJ.
    ...                Após blur, a base deve ter ≤ 14 chars e nenhuma quebra de linha.
    ...                Valida que o front-end sanitiza \n antes de aplicar a máscara,
    ...                evitando que o valor ultrapasse o limite ou quebre a submissão.
    [Tags]    campo    trim    higienizacao
    Acessa tela de cadastro de cliente
    Valida campo sanitiza cnpj com quebra de linha

# ==============================================================================
# GRUPO LETRA O vs NÚMERO 0
# Testa que o sistema distingue a letra O (ASCII 79) do dígito 0 (ASCII 48)
# no cálculo do DV via Módulo 11.
# Ref: WEB_36 do plano de expansão.
# ==============================================================================

Teste 022 ::: WEB_36 Sistema distingue letra O de número 0 no DV
    [Documentation]    WEB_36: Digita CNPJ "00.ABC.345/O1DE-35" onde 'O' (letra O, ASCII 79)
    ...                ocupa a posição 9 da ordem em vez do dígito '0' (ASCII 48).
    ...                O DV '35' foi calculado para a base com zero, portanto é
    ...                matematicamente inválido para a base com letra O.
    ...                O sistema deve rejeitar, provando que o Módulo 11 usa ASCII correto
    ...                e não confunde os dois caracteres visualmente semelhantes.
    [Tags]    validacao    dv    campo
    Acessa tela de cadastro de cliente
    Valida campo bloqueia letra O no sufixo numerico

# ==============================================================================
# GRUPO LOCAL COM MESMA RAIZ ALFANUMÉRICA (WEB_42)
# ==============================================================================

Teste 023 ::: WEB_42 Vincular Local à Matriz com mesma raiz CNPJ alfanumérica
    [Documentation]    WEB_42: Cadastra um cliente PJ Matriz com CNPJ "12.ABC.345/0001-XX"
    ...                e vincula um Local (Filial) com CNPJ "12.ABC.345/0002-YY",
    ...                onde ambos têm a mesma raiz alfanumérica "12ABC345".
    ...                Os DVs são calculados em tempo de execução via Calcular DV CNPJ Alfanumerico,
    ...                garantindo alinhamento com o algoritmo do servidor.
    [Tags]    cadastro    local    alfa    raiz-comum
    Acessa tela de cadastro de cliente
    Cadastra PJ matriz e local com raiz CNPJ alfanumerica comum
    Valida gravacao de matriz e local com raiz alfanumerica

# ==============================================================================
# CAMADA 5 — CAMPO LOCAL (local_documentoidentificacao)
# Espelha as validações do campo PJ no campo de CNPJ do Local (filial).
# O Local é preenchido dentro do mesmo formulário de cadastro de cliente PJ.
# ==============================================================================

Teste 024 ::: Campo local aceita CNPJ alfanumérico sem remover letras
    [Documentation]    Digita CNPJ alfanumérico bruto no campo local_documentoidentificacao
    ...                e verifica que o campo aceita e preserva as letras (A-Z) sem descartá-las.
    ...                ⚠️ LACUNA FRONTEND: o campo não aplica máscara SS.SSS.SSS/SSSS-NN —
    ...                o valor fica como string bruta de 14 chars. Registrar como melhoria.
    [Tags]    campo    local    alfa    lacuna-frontend
    Acessa tela de cadastro de cliente
    Abre campo CNPJ do local
    Valida campo local aceita CNPJ alfanumerico

Teste 025 ::: Campo local bloqueia letras nas posições dos DVs
    [Documentation]    Tenta digitar letras nas posições 13-14 (DVs) do campo local.
    ...                Os DVs do CNPJ são estritamente numéricos — o campo deve bloquear letras.
    ...                Guard: verifica que o campo não ficou vazio para evitar falso positivo.
    [Tags]    campo    local    alfa
    Acessa tela de cadastro de cliente
    Abre campo CNPJ do local
    Valida campo local bloqueia letras nos DVs

Teste 026 ::: Campo local bloqueia caracteres especiais
    [Documentation]    Tenta digitar @, #, $ no campo local.
    ...                Apenas A-Z e 0-9 são permitidos pelo formato alfanumérico.
    ...                Guard: verifica que o campo não ficou vazio para evitar falso positivo.
    [Tags]    campo    local    alfa
    Acessa tela de cadastro de cliente
    Abre campo CNPJ do local
    Valida campo local bloqueia caracteres especiais

Teste 027 ::: Campo local converte minúsculas para maiúsculas automaticamente
    [Documentation]    Digita CNPJ com letras minúsculas no campo local.
    ...                O campo deve converter para maiúsculas — ASCII 'a'≠'A' quebraria o DV.
    [Tags]    campo    local    alfa
    Acessa tela de cadastro de cliente
    Abre campo CNPJ do local
    Valida campo local converte minusculas para maiusculas

Teste 028 ::: CNPJ alfanumérico válido é aceito no local e gravado no banco
    [Documentation]    Preenche o formulário PJ completo com CNPJ alfanumérico APENAS no Local.
    ...                O parceiro usa CNPJ numérico gerado pelo Faker.
    ...                Valida criação no banco: tabela local.documentoidentificacao deve
    ...                ser VARCHAR e preservar os 14 chars alfanuméricos intactos.
    ...                ⚠️ LACUNA BACKEND: se documentoidentificacao for NULL, o campo local
    ...                ainda não suporta alfanumérico — registra sem reprovar pipeline.
    [Tags]    local    alfa    banco
    Acessa tela de cadastro de cliente
    Cadastra PJ com CNPJ alfanumerico valido no local
    Valida CNPJ alfanumerico do local no banco

Teste 029 ::: CNPJ alfanumérico com DV inválido no local — documenta comportamento do back-end
    [Documentation]    Preenche o parceiro com CNPJ válido e injeta CNPJ com DV errado
    ...                (12ABC34501DE99 — DV correto: 35) no campo do Local.
    ...                Comportamento esperado: sistema rejeita ao gravar.
    ...                ⚠️ LACUNA BACKEND: atualmente o back-end não valida DV do campo local.
    ...                Teste não reprova pipeline — documenta a lacuna para melhoria futura.
    [Tags]    local    alfa    validacao    lacuna-backend
    Acessa tela de cadastro de cliente
    Preenche local com CNPJ invalido e valida rejeicao

Teste 030 ::: CNPJ numérico tradicional continua funcionando no campo local
    [Documentation]    Verifica retrocompatibilidade: preenche parceiro com CNPJ alfanumérico
    ...                e mantém o CNPJ numérico padrão (gerado pelo Faker) no Local.
    ...                O sistema deve aceitar sem erro — CNPJ numérico no Local é válido.
    [Tags]    local    numerico    retrocompat
    Acessa tela de cadastro de cliente
    Cadastra PJ com CNPJ numerico no local

# ==============================================================================
# CAMADA 6 — REGRESSÃO CPF (Pessoa Física)
# Estes testes ficam por último: garantem que a abertura do CNPJ alfanumérico
# não contaminou o campo ou o validador de CPF da Pessoa Física.
# ==============================================================================

Teste 031 ::: WEB_37 Máscara de CPF continua sendo NNN.NNN.NNN-NN
    [Documentation]    WEB_37: No formulário de Pessoa Física, digita 11 dígitos no campo
    ...                CPF e verifica que a máscara NNN.NNN.NNN-NN permanece intacta.
    ...                A introdução do CNPJ alfanumérico usa o mesmo componente de documento
    ...                (documentoIdentificacao) — valida que a máscara do CPF não foi alterada.
    [Tags]    mascara    campo    cpf    regressao
    Acessa formulario como pessoa fisica
    Valida mascara de CPF intacta

Teste 032 ::: WEB_38 Campo CPF bloqueia letras em Pessoa Física
    [Documentation]    WEB_38: No formulário de Pessoa Física, tenta digitar letras no campo CPF.
    ...                O campo deve bloquear qualquer letra — CPF é 100% numérico pela lei.
    ...                Valida que a abertura do CNPJ alfanumérico não "vazou" a permissão
    ...                de letras para o campo CPF quando o tipo de pessoa é Física.
    [Tags]    campo    cpf    regressao
    Acessa formulario como pessoa fisica
    Valida campo CPF bloqueia letras
