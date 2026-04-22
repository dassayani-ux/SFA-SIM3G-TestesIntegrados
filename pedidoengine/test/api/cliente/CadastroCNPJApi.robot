*** Settings ***
Documentation    Testes de API REST para validação do campo CNPJ alfanumérico no cadastro de cliente (parceiro).
...
...              Contexto: A partir da Instrução Normativa RFB nº 2.119/2022, o CNPJ passa
...              a aceitar caracteres alfanuméricos (letras A-Z e dígitos 0-9) nas posições
...              de raiz e ordem (posições 1 a 12). Os 2 dígitos verificadores continuam
...              numéricos, calculados via Módulo 11 com valores ASCII (char - 48).
...
...              Formato alfanumérico: SS.SSS.SSS/SSSS-NN  (S=letra ou número, N=número)
...              Exemplo válido: 12.ABC.345/01DE-35
...
...              CAMADAS TESTADAS VIA API:
...              1. Criação — POST com CNPJ válido/inválido/numérico/especial
...              2. Pesquisa — GET filtrando por CNPJ com e sem máscara
...              3. Unicidade — POST com CNPJ duplicado
...              4. Atualização — PUT com novo CNPJ válido
...              5. Exclusão — DELETE + GET confirma ausência
...
...              ⚠️  Pré-requisito: a versão do SFA deve ter os endpoints REST habilitados.
...              ⚠️  API_08/09 dependem de API_01 ter criado o parceiro com sucesso.
...              ⚠️  API_10 depende de API_01. API_11/12 dependem de API_01.

Resource    ${EXECDIR}/pedidoengine/resources/pages/api/cliente/cadastroCNPJApiResource.robot

Suite Setup      Run Keywords
...              Cria sessao da API
...              AND    Conecta ao banco de dados

Suite Teardown   Run Keywords
...              Encerra sessao da API
...              AND    Disconnect From Database

*** Test Cases ***
# ==============================================================================
# CAMADA 1 — CRIAÇÃO DE PARCEIRO (POST)
# Testa a criação via API com diferentes variações de CNPJ.
# ==============================================================================

API_01 ::: POST com CNPJ alfanumérico válido retorna 200 ou 201
    [Documentation]    Gera CNPJ alfanumérico dinamicamente com DVs matematicamente corretos
    ...                (Módulo 11 / ASCII) e envia POST para criar o parceiro.
    ...                Valida que a API aceita e retorna 200 ou 201.
    ...                O ID retornado é salvo em Suite Variable para reuso nos testes seguintes.
    [Tags]    api    criacao    alfa    positivo
    Cadastra parceiro via API com CNPJ alfanumerico valido

API_02 ::: POST com CNPJ DV inválido retorna 400 ou 422
    [Documentation]    Envia POST com CNPJ cujo DV não é matematicamente correto
    ...                (ex: 12.ABC.345/01DE-99 — DV correto seria 35).
    ...                A API deve rejeitar com 400 ou 422 e retornar mensagem de erro clara.
    [Tags]    api    criacao    alfa    negativo    validacao
    ${resp}=    Tenta cadastrar parceiro com CNPJ DV invalido
    Valida rejeicao por DV invalido    ${resp}

API_03 ::: POST com CNPJ zerado retorna 400 ou 422
    [Documentation]    CNPJ composto somente de zeros (00.000.000/0000-00) é vedado pela RFB.
    ...                A API deve rejeitar sem gravar o registro.
    [Tags]    api    criacao    negativo    validacao
    ${resp}=    Tenta cadastrar parceiro com CNPJ zerado
    Valida rejeicao por CNPJ zerado    ${resp}

API_04 ::: POST com CNPJ de tamanho incorreto retorna 400 ou 422
    [Documentation]    CNPJ com 13 caracteres (um a menos que o obrigatório 14) deve ser
    ...                rejeitado por formato inválido. Garante que a API valida o tamanho
    ...                antes de tentar calcular o DV.
    [Tags]    api    criacao    negativo    validacao
    ${resp}=    Tenta cadastrar parceiro com CNPJ curto
    Valida rejeicao por CNPJ curto    ${resp}

API_05 ::: POST com CNPJ em letras minúsculas — normalização ou rejeição explícita
    [Documentation]    Envia CNPJ com letras minúsculas (12.abc.345/01de-35).
    ...                Comportamento aceito:
    ...                  a) Normalização (to uppercase) pelo back-end → 200/201
    ...                  b) Rejeição explícita por formato → 400/422
    ...                Proibido: retornar 200/201 gravando minúsculas (bug de DV case-sensitive).
    ...                Proibido: retornar 500 (erro não tratado).
    [Tags]    api    criacao    negativo    normalizacao
    ${resp}=    Cadastra parceiro com CNPJ em minusculas
    Valida comportamento de CNPJ minusculas    ${resp}

API_06 ::: POST com CNPJ numérico tradicional retorna 200 ou 201 (retrocompat)
    [Documentation]    A lei é clara — CNPJs numéricos existentes continuam válidos.
    ...                Valida que o endpoint REST aceita o formato NN.NNN.NNN/NNNN-NN
    ...                sem regressão. Esta é a garantia de retrocompatibilidade da API.
    [Tags]    api    criacao    numerico    retrocompat    positivo
    Cadastra parceiro via API com CNPJ numerico

API_07 ::: POST com CNPJ contendo caracteres especiais retorna 400 ou 422
    [Documentation]    Envia CNPJ com @, #, etc. (ex: 12.@BC.345/01#E-35).
    ...                Esses caracteres são explicitamente proibidos pelo formato A-Z/0-9.
    ...                A API deve rejeitar sem explodir em erro 500.
    [Tags]    api    criacao    negativo    validacao
    ${resp}=    Tenta cadastrar parceiro com CNPJ com caracteres especiais
    Valida rejeicao por caracteres especiais    ${resp}

# ==============================================================================
# CAMADA 2 — PESQUISA DE PARCEIRO (GET)
# Testa filtros por CNPJ alfanumérico com e sem máscara.
# Depende de API_01 ter criado o parceiro com CNPJ alfanumérico.
# ==============================================================================

API_08 ::: GET com CNPJ alfanumérico COM máscara retorna parceiro esperado
    [Documentation]    Na listagem de parceiros, filtra pelo CNPJ formatado com pontos/barra/traço
    ...                (ex: 12.ABC.345/01DE-35). O back-end deve localizar e retornar o parceiro.
    ...                Depende de API_01 ter criado o parceiro com sucesso.
    [Tags]    api    pesquisa    alfa    depende-API_01
    ${resp}=    Pesquisa parceiro via API por CNPJ com mascara    ${api_cnpj_alfa_usado}
    Valida resultado da pesquisa por CNPJ alfanumerico    ${resp}    ${api_cnpj_alfa_usado}    ${api_nome_alfa_usado}

API_09 ::: GET com CNPJ alfanumérico SEM máscara retorna o mesmo parceiro
    [Documentation]    Na listagem, filtra pelo CNPJ sem formatação (14 chars brutos, ex: 12ABC34501DE35).
    ...                O back-end deve normalizar internamente e retornar o mesmo parceiro de API_08.
    ...                Garante que a API não exige máscara para a busca.
    [Tags]    api    pesquisa    alfa    depende-API_01
    ${resp}=    Pesquisa parceiro via API por CNPJ sem mascara    ${api_cnpj_alfa_raw}
    Valida resultado da pesquisa por CNPJ sem mascara    ${resp}    ${api_nome_alfa_usado}

# ==============================================================================
# CAMADA 3 — UNICIDADE (POST duplicado)
# Testa que o mesmo CNPJ não pode ser cadastrado duas vezes.
# Depende de API_01 ter criado o primeiro parceiro com esse CNPJ.
# ==============================================================================

API_10 ::: POST com CNPJ duplicado retorna 400, 409 ou 422
    [Documentation]    Tenta criar um segundo parceiro com o mesmo CNPJ alfanumérico
    ...                já cadastrado em API_01. O sistema deve garantir unicidade e
    ...                rejeitar a tentativa com erro de conflito/duplicidade.
    [Tags]    api    criacao    negativo    unicidade    depende-API_01
    ${resp}=    Tenta cadastrar parceiro com CNPJ duplicado    ${api_cnpj_alfa_usado}
    Valida rejeicao por CNPJ duplicado    ${resp}

# ==============================================================================
# CAMADA 4 — ATUALIZAÇÃO (PUT)
# Testa atualização do CNPJ de um parceiro existente.
# Depende de API_01 ter criado o parceiro e retornado o ID.
# ==============================================================================

API_11 ::: PUT atualiza CNPJ do parceiro com novo CNPJ alfanumérico válido
    [Documentation]    Gera um novo CNPJ alfanumérico válido e atualiza o parceiro
    ...                criado em API_01 via PUT. A API deve aceitar e persistir o novo CNPJ.
    ...                Valida que a atualização retorna 200 e que o dado foi alterado.
    [Tags]    api    atualizacao    alfa    depende-API_01
    ${resp}=    Atualiza CNPJ do parceiro via API    ${api_id_criado_alfa}    ${api_nome_alfa_usado}
    Valida atualizacao de CNPJ via API    ${resp}

# ==============================================================================
# CAMADA 5 — EXCLUSÃO + CONFIRMAÇÃO (DELETE + GET)
# Testa remoção do parceiro e confirma ausência no sistema.
# Depende de API_01 ter criado o parceiro e retornado o ID.
# ==============================================================================

API_12 ::: DELETE parceiro + GET confirma que não é mais localizado
    [Documentation]    Envia DELETE para o parceiro criado em API_01.
    ...                Em seguida, envia GET por ID e GET por CNPJ para confirmar que
    ...                o parceiro não é mais localizado (404 ou lista vazia).
    ...                Garante que a exclusão é efetiva e não apenas um soft-delete invisível.
    [Tags]    api    exclusao    alfa    depende-API_01
    ${resp_del}=    Remove parceiro via API    ${api_id_criado_alfa}
    Valida exclusao do parceiro    ${resp_del}
    Confirma parceiro nao encontrado apos exclusao    ${api_id_criado_alfa}    ${api_cnpj_alfa_usado}

# ==============================================================================
# CAMADA 6 — TRIM E HIGIENIZAÇÃO DE ENTRADA (POST)
# Testa se o servidor sanitiza espaços antes de validar o CNPJ.
# Um servidor robusto deve aceitar CNPJs com espaços acidentais;
# um que rejeita documenta necessidade de melhoria sem breaking change.
# Ref: API_31, API_32 do plano de expansão.
# ==============================================================================

API_31 ::: POST com CNPJ com espaços nas extremidades — servidor deve fazer trim
    [Documentation]    Envia CNPJ válido envolvido em espaços ("  12ABC...35  ").
    ...                O servidor DEVE aceitar após trim silencioso (200/201).
    ...                Se rejeitar (400/422): comportamento tolerável — anotar como melhoria.
    ...                Proibido: retornar 500 (espaço causando NullPointerException).
    [Tags]    api    criacao    trim    higienizacao
    ${resp}=    Cadastra parceiro com CNPJ com espacos nas extremidades
    Valida aceitacao com CNPJ apos trim de extremidades    ${resp}

API_32 ::: POST com CNPJ com espaços internos — servidor deve aplicar strip
    [Documentation]    Envia CNPJ válido com espaços entre grupos de caracteres
    ...                (ex: "12AB C34 501D E35"). Após remover [^a-zA-Z0-9], o CNPJ é válido.
    ...                O servidor DEVE remover os espaços e aceitar (200/201).
    ...                Se rejeitar (400/422): sem regex de limpeza — anotar como melhoria.
    ...                Proibido: retornar 500.
    [Tags]    api    criacao    trim    higienizacao
    ${resp}=    Cadastra parceiro com CNPJ com espacos internos
    Valida aceitacao com CNPJ apos remocao de espacos internos    ${resp}

# ==============================================================================
# CAMADA 7 — BUGS CLÁSSICOS DE ZEROS
# Testa dois cenários opostos: zeros absolutos (devem ser rejeitados por regra
# explícita) e zeros à esquerda em CNPJ válido (devem ser preservados como string).
# Ref: API_34, API_35 do plano de expansão.
# ==============================================================================

API_34 ::: POST com CNPJ de zeros absolutos é rejeitado por regra explícita
    [Documentation]    Envia CNPJ "00000000000000" (14 zeros, sem máscara).
    ...                O Módulo 11 puro com zeros poderia resultar em DV=00 (tecnicamente
    ...                "válido" matematicamente), mas a RFB proíbe CNPJ de zeros.
    ...                O servidor DEVE ter regra explícita anti-zeros independente do DV.
    [Tags]    api    criacao    negativo    zeros
    ${resp}=    Tenta cadastrar parceiro com CNPJ zeros absolutos sem mascara
    Valida rejeicao por zeros absolutos    ${resp}

API_35 ::: POST com CNPJ válido iniciando em "00" — zeros à esquerda preservados
    [Documentation]    Envia CNPJ alfanumérico válido cuja raiz começa com "00"
    ...                (ex: 00.ABC.345/01DE-XX com DV calculado dinamicamente).
    ...                Sistemas que convertem para Integer/Long perdem os zeros à esquerda.
    ...                O campo é VARCHAR — os 14 chars devem ser preservados intactos.
    ...                Valida criação (200/201) e busca pelo CNPJ confirmando zeros no retorno.
    [Tags]    api    criacao    zeros    positivo
    ${resp}=    Cadastra parceiro com CNPJ com zeros a esquerda
    Valida aceitacao e preservacao de zeros a esquerda    ${resp}

# ==============================================================================
# CAMADA 8 — REGRESSÃO EM CPF (Pessoa Física)
# Garante que o back-end (DocumentValidator) não generalizou a permissão de letras
# do CNPJ alfanumérico para o CPF de Pessoa Física.
# Ref: API_39, API_40 do plano de expansão.
# ==============================================================================

API_39 ::: POST Pessoa Física com CPF válido é aceito (regressão do validador legado)
    [Documentation]    Cria um parceiro Pessoa Física com CPF válido (111.444.777-35).
    ...                Valida que o algoritmo legado de CPF (Módulo 11 numérico) continua
    ...                funcionando corretamente após a introdução do CNPJ alfanumérico.
    ...                Um 400/422 aqui indica regressão no DocumentValidator.
    [Tags]    api    criacao    cpf    regressao    positivo
    ${resp}=    Cadastra parceiro PF via API com CPF valido
    Valida aceitacao de CPF valido via API    ${resp}

API_40 ::: POST Pessoa Física com CPF contendo letras é rejeitado
    [Documentation]    Tenta criar parceiro Pessoa Física com CPF "123.ABC.789-10".
    ...                CPF é e sempre foi 100% numérico — a abertura de letras no CNPJ
    ...                não pode ter sido generalizada para o campo CPF de PF.
    ...                Um 200/201 aqui é um bug de segurança grave no validador.
    [Tags]    api    criacao    cpf    negativo    regressao
    ${resp}=    Tenta cadastrar parceiro PF com CPF com letras
    Valida rejeicao de CPF com letras    ${resp}

# ==============================================================================
# CAMADA 9 — MÓDULO DE LOCAIS (campo local.documentoidentificacao)
# Testa que o endpoint de Local também suporta CNPJ alfanumérico,
# espelhando a cobertura feita no cadastro do parceiro principal.
# Ref: API_41 do plano de expansão.
# ==============================================================================

API_41 ::: POST Local vinculado a parceiro aceita CNPJ alfanumérico
    [Documentation]    Cria um parceiro auxiliar e, em seguida, cria um Local sob ele
    ...                usando um CNPJ alfanumérico válido no campo documentoIdentificacao.
    ...                Valida que o módulo de Locais (filial/ponto de entrega) suporta
    ...                o novo formato — sem esse suporte, filiais alfa não poderiam ser criadas.
    ...                Se o endpoint de Local não existir (404), registra aviso sem reprovar.
    [Tags]    api    criacao    local    alfa
    ${resp}=    Cadastra local via API com CNPJ alfanumerico
    Valida criacao de local com CNPJ alfanumerico    ${resp}
