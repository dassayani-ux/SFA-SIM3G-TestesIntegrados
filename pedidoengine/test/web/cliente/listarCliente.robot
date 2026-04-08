*** Settings ***
Documentation    Arquivo utilizado para realizar os testes relativos a listagem de clientes.

Resource    ${EXECDIR}/pedidoengine/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/cliente/listagemClientesResource.robot

Suite Setup      Run Keywords    Conecta ao banco de dados
...              AND             Abre navegador
...              AND             Realiza login na plataforma web
...              AND             Prepara dados de automacao para listagem
Suite Teardown   Run Keywords    Realizar logoff
...              AND             Close Browser
...              AND             Disconnect From Database

*** Test Cases ***
Teste 001 ::: Pesquisa rápida de cliente usando nome
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 4
    Acessa tela de listagem de clientes
    Ativa pesquisa avancada
    Filtra cliente na pesquisa rapida por nome

Teste 002 ::: Pesquisa rápida de cliente usando numero
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 4
    Filtra cliente na pesquisa rapida por numero

Teste 003 ::: Filtra cliente pessoa física
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 6
    Filtra cliente por tipo pessoa    tipo=PF

Teste 004 ::: Filtra cliente pessoa jurídica
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 7
    Filtra cliente por tipo pessoa    tipo=PJ

Teste 005 ::: Filtra cliente com ambos os tipos de pessoas marcados
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 8
    Filtra cliente por tipo pessoa    tipo=AMBOS_CHECK

Teste 006 ::: Filtra cliente com ambos os tipos de pessoas desmarcados
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 9
    Filtra cliente por tipo pessoa    tipo=AMBOS_UNCHECK

Teste 007 ::: Filtra cliente com situação Ativo
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 10
    Filtra cliente por situacao    situacao=1

Teste 008 ::: Filtra cliente com situação Inativo
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 11
    Filtra cliente por situacao    situacao=0

Teste 009 ::: Filtra cliente com ambas as situações marcadas
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 12
    Filtra cliente por situacao    situacao=AMBOS_CHECK

# Teste 010 ::: Filtra cliente com ambas as situações desmarcadas
#     [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 13
#     Filtra cliente por situacao    situacao=AMBOS_UNCHECK

Teste 011 ::: Filtra Cliente por situacao aprovacao
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 15
    Filtra Cliente por situacao aprovacao

Teste 012 ::: Filtra cliente por razão social
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 16
    Filtra cliente por razao social

Teste 013 ::: Filtra cliente por nome fantasia
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 17
    Filtra cliente por fantasia

Teste 014 ::: Filtra cliente por local
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 18
    Filtra cliente por local

Teste 015 ::: Filtra cliente por documento
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 19
    Filtra cliente por documento

Teste 016 ::: Filtra cliente por matricula
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 20
    Filtra cliente por matricula

Teste 017 ::: Filtra cliente por bairro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 21
    Filtra cliente por bairro

Teste 018 ::: Filtra cliente por logradouro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 22
    Filtra cliente por logradouro

Teste 019 ::: Filtra cliente por uf
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 23
    Filtra cliente por estado

Teste 020 ::: Filtra cliente por cidade
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 24
    Filtra cliente por cidade

Teste 021 ::: Filtra cliente por profissional
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 25
    Filtra cliente por profissional

Teste 022 ::: Filtra cliente por classificacao
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 26
    Filtra cliente por classificacao

Teste 023 ::: Filtra cliente por situacao de cadastro
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 27
    Filtra cliente por situacao de cadastro