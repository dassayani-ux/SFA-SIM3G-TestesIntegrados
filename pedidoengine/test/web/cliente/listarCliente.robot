*** Settings ***
Documentation    Arquivo utilizado para realizar os testes relativos a listagem de clientes.

Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/newLoginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/listagemClientesResource.robot

Suite Setup    Run Keywords    Abre navegador    Realiza login na plataforma web    Conecta ao banco de dados
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Pesquisa rápida de cliente usando nome
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 4
    Acessa tela de listagem de clientes
    Filtra cliente na pesquisa rapida por nome

Teste 002 ::: Pesquisa rápida de cliente usando numero
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 4
    Filtra cliente na pesquisa rapida por numero

Teste 003 ::: Filtra cliente pessoa física
    [Documentation]    DTSFASAPP-T205 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/268553 :: Passo 6
    Ativa pesquisa avancada
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