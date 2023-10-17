*** Settings ***
Documentation    Arquivo utilizado para rodar o ciclo de teste de fechamento
...    https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testPlayer/DTSFAPD-C3   

Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/resources/pages/web/atendimento/listagemAtendimentoResources.robot
Resource    ${EXECDIR}/resources/pages/web/atendimento/cadastroAtendimentoResources.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/cadastroCLienteResource.robot
Resource    ${EXECDIR}/resources/pages/web/pedido/cadastroPedidoResources.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador    Inativar pesquisa de Tipo Cobraca
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Realizar login com usuario invalido
    Login com usuario invalido

Teste 002 ::: Realizar login com senha Invalida
    Login com senha invalida

Teste 003 ::: Realizar login com usuario e senha invalidos
    Login com usuario e senha invalidos

Teste 004 ::: Realizar login valido
    [Documentation]    https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testPlayer/DTSFAPD-C3

    Realiza login na plataforma web

Teste 005 ::: Cadastrar atendimento
    [Documentation]    DTSFASAPP-T135 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/264681

    ${idAtendimentoAux}=    Retornar proximo atendimento
    ${idAtendimento}    Set Variable    ${idAtendimentoAux}
    Acessar tela de lançamento de atendimento
    Preencher cabeçalho do atentimento
    Iniciar atendimento
    Incluir imagem no atendimento
    Finalizar atendimento
    Validar criacao do atendimento no banco de dados    ${idAtendimento}

Teste 006 ::: Editar atendimento
    [Documentation]    DTSFASAPP-T703 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/300860

    ${idAtendimentoAux}=    Retornar ultimo atendimento
    ${idAtendimento}    Set Variable    ${idAtendimentoAux}
    Acessar listagem de atendimentos
    Editar Atendimento
    Alterar data fim do atendimento    ${idAtendimento} 
    Finalizar atendimento
    Sleep    2s
    Validar edicao do atendimento    ${idAtendimento}

Teste 007 ::: Validar campos obrigatórios no cadastro de cliente
    [Documentation]    https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/256241
    Acessa tela de cadastro de cliente
    Valida campos obrigatorios do cliente

Teste 008 ::: Cadastrar cliente
    [Documentation]    DTSFASAPP-T76 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/256534
    Cadastra cliente juridico

Teste 009 ::: Pesquisa rápida de cliente usando nome
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 4
    Acessa tela de listagem de clientes
    Filtra cliente na pesquisa rapida por nome

Teste 010 ::: Pesquisa rápida de cliente usando numero
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 4
    Filtra cliente na pesquisa rapida por numero

Teste 011 ::: Filtrar cliente pessoa física
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 6
    Ativa pesquisa avancada
    Filtra cliente por tipo pessoa    tipo=PF

Teste 012 ::: Filtrar cliente pessoa jurídica
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 7
    Filtra cliente por tipo pessoa    tipo=PJ

Teste 013 ::: Filtrar cliente com ambos os tipos de pessoas marcados
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 8
    Filtra cliente por tipo pessoa    tipo=AMBOS_CHECK

Teste 014 ::: Filtrar cliente com ambos os tipos de pessoas desmarcados
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 9
    Filtra cliente por tipo pessoa    tipo=AMBOS_UNCHECK

Teste 015 ::: Filtrar cliente com situação Ativo
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 10
    Filtra cliente por situacao    situacao=1

Teste 016 ::: Filtrar cliente com situação Inativo
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 11
    Filtra cliente por situacao    situacao=0

Teste 017 ::: Filtrar cliente com ambas as situações marcadas
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 12
    Filtra cliente por situacao    situacao=AMBOS_CHECK

# Teste 017 ::: Filtra cliente com ambas as situações desmarcadas
#     [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 13
#     Filtra cliente por situacao    situacao=AMBOS_UNCHECK

Teste 019 ::: Filtrar Cliente por situacao aprovacao
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 15
    Filtra Cliente por situacao aprovacao

Teste 020 ::: Filtrar cliente por razão social
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 16
    Filtra cliente por razao social

Teste 021 ::: Filtrar cliente por nome fantasia
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 17
    Filtra cliente por fantasia

Teste 022 ::: Filtrar cliente por local
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 18
    Filtra cliente por local

Teste 023 ::: Filtrar cliente por documento
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 19
    Filtra cliente por documento

Teste 024 ::: Filtrar cliente por matricula
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 20
    Filtra cliente por matricula

Teste 025 ::: Filtrar cliente por bairro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 21
    Filtra cliente por bairro

Teste 026 ::: Filtrar cliente por logradouro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 22
    Filtra cliente por logradouro

Teste 027 ::: Filtrar cliente por uf
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 23
    Filtra cliente por estado

Teste 028 ::: Filtrar cliente por cidade
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 24
    Filtra cliente por cidade

Teste 029 ::: Filtrar cliente por profissional
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 25
    Filtra cliente por profissional

Teste 030 ::: Filtrar cliente por classificacao
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 26
    Filtra cliente por classificacao

Teste 031 ::: Filtrar cliente por situacao de cadastro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 27
    Filtra cliente por situacao de cadastro

Teste 032 ::: Validar tipo cobrança cliente
    [Documentation]    DTSFASAPP-T89 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/258851
    Valida tipo cobranca padrao

Teste 033 ::: Cadastrar novo pedido
    [Documentation]    DTSFASAPP-T42 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/255956
    Acessar cadastro de novo pedido
    Preenche cabecalho pedido
    Incluir itens no pedido
    Gravar pedido de venda
    Validar pedido no banco de dados

Teste 034 ::: Filtrar pedido, editar e finalizar
    [Documentation]    DTSFASAPP-T705 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T705
    Acessar tela de listagem de pedidos
    ${numeroPedido}=    Retornar numero ultimo pedido NF
    Filtrar pedido por numero definido    ${numeroPedido}
    Editar pedido de venda    ${numeroPedido}
    Excluir itens originais e incluir novos
    Finalizar pedido de venda

Teste 035 ::: Filtrar pedido e finalizar na listagem
    [Documentation]    DTSFASAPP-T704 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T704 :: Passo 4
    Acessar tela de listagem de pedidos
    ${numeroPedido}=    Retornar numero ultimo pedido NF
    Filtrar pedido por numero definido    ${numeroPedido}
    Finalizar pedido de venda na listagem    ${numeroPedido}

Teste 036 ::: Filtrar pedido e cancelar pela grid
    [Documentation]    DTSFASAPP-T704 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T704 :: Passo 5
    Acessar tela de listagem de pedidos
    ${numeroPedido}=    Retornar numero ultimo pedido NF
    Filtrar pedido por numero definido    ${numeroPedido}
    Cancelar pedido de venda pela listagem    ${numeroPedido}

Teste 037 ::: Clonar pedido de venda
    [Documentation]    DTSFASAPP-T410 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T410
    Acessar tela de listagem de pedidos
    ${numeroPedido}=    Retornar numero ultimo pedido
    Filtrar pedido por numero definido    ${numeroPedido}
    Clonar pedido de venda    ${numeroPedido}
    Verificar informações do pedido clonado    ${numeroPedido}

Teste 038 ::: Realizar logoff
    [Documentation]    DTSFASAPP-T79 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T79
    Realizar logoff