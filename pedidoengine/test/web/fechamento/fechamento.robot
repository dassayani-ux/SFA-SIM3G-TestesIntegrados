*** Settings ***
Documentation    Arquivo utilizado para rodar o ciclo de teste de fechamento
...    https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testPlayer/DTSFAPD-C3   

Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/newLoginResources.robot
Resource    ${EXECDIR}/resources/pages/web/atendimento/listagemAtendimentoResources.robot
Resource    ${EXECDIR}/resources/pages/web/atendimento/cadastroAtendimentoResources.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/newCadastroCLienteResource.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Login usuario invalido
    Login com usuario invalido

Teste 002 ::: Login senha Invalida
    Login com senha invalida

Teste 003 ::: Login usuario e senha invalidos
    Login com usuario e senha invalidos

Teste 004 ::: Login valido
    [Documentation]    https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testPlayer/DTSFAPD-C3

    Realiza login na plataforma web

Teste 005 ::: Cadastro de atendimento
    [Documentation]    DTSFASAPP-T135 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/264681

    ${idAtendimentoAux}=    Retorna proximo atendimento
    Set Test Variable    ${idAtendimento}    ${idAtendimentoAux}

    Acessa tela de cadastro de atendimento
    Preenche cabeçalho do atendimento
    Inicia atendimento
    Inlcuir imagem no atendimento
    Finaliza atendimento
    Valida criacao do atendimento no bd    ${idAtendimento}

Teste 006 ::: Editar atendimento
    [Documentation]    DTSFASAPP-T703 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/300860

    ${idAtendimentoAux}=    Retorna ultimo atendimento
    Set Test Variable    ${idAtendimento}    ${idAtendimentoAux}

    Acessa listagem de atendimentos
    Edita Atendimento
    Altera data fim do atendimento    ${idAtendimento} 
    Finaliza atendimento
    Valida edicao do atendimento    ${idAtendimento}

Teste 007 ::: Cadastro de cliente
    [Documentation]    DTSFASAPP-T76 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/256534

    Acessa tela de cadastro de cliente
    Cadastra cliente juridico

Teste 008 ::: Pesquisa rápida de cliente usando nome
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 4
    Acessa tela de listagem de clientes
    Filtra cliente na pesquisa rapida por nome

Teste 009 ::: Pesquisa rápida de cliente usando numero
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 4
    Filtra cliente na pesquisa rapida por numero

Teste 010 ::: Filtra cliente pessoa física
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 6
    Ativa pesquisa avancada
    Filtra cliente por tipo pessoa    tipo=PF

Teste 011 ::: Filtra cliente pessoa jurídica
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 7
    Filtra cliente por tipo pessoa    tipo=PJ

Teste 012 ::: Filtra cliente com ambos os tipos de pessoas marcados
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 8
    Filtra cliente por tipo pessoa    tipo=AMBOS_CHECK

Teste 013 ::: Filtra cliente com ambos os tipos de pessoas desmarcados
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 9
    Filtra cliente por tipo pessoa    tipo=AMBOS_UNCHECK

Teste 014 ::: Filtra cliente com situação Ativo
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 10
    Filtra cliente por situacao    situacao=1

Teste 015 ::: Filtra cliente com situação Inativo
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 11
    Filtra cliente por situacao    situacao=0

Teste 016 ::: Filtra cliente com ambas as situações marcadas
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 12
    Filtra cliente por situacao    situacao=AMBOS_CHECK

# Teste 017 ::: Filtra cliente com ambas as situações desmarcadas
#     [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 13
#     Filtra cliente por situacao    situacao=AMBOS_UNCHECK

Teste 018 ::: Filtra Cliente por situacao aprovacao
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 15
    Filtra Cliente por situacao aprovacao

Teste 019 ::: Filtra cliente por razão social
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 16
    Filtra cliente por razao social

Teste 020 ::: Filtra cliente por nome fantasia
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 17
    Filtra cliente por fantasia

Teste 021 ::: Filtra cliente por local
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 18
    Filtra cliente por local

Teste 022 ::: Filtra cliente por documento
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 19
    Filtra cliente por documento

Teste 023 ::: Filtra cliente por matricula
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 20
    Filtra cliente por matricula

Teste 024 ::: Filtra cliente por bairro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 21
    Filtra cliente por bairro

Teste 025 ::: Filtra cliente por logradouro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 22
    Filtra cliente por logradouro

Teste 026 ::: Filtra cliente por uf
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 23
    Filtra cliente por estado

Teste 027 ::: Filtra cliente por cidade
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 24
    Filtra cliente por cidade

Teste 028 ::: Filtra cliente por profissional
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 25
    Filtra cliente por profissional

Teste 029 ::: Filtra cliente por classificacao
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 26
    Filtra cliente por classificacao

Teste 030 ::: Filtra cliente por situacao de cadastro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 27
    Filtra cliente por situacao de cadastro