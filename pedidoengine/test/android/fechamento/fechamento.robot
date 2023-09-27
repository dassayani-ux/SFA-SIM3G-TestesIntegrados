*** Settings ***
Documentation    Arquivo utilizado para rodar o ciclo de teste de fechamento
...    https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testPlayer/DTSFAPD-C4

Resource    ${EXECDIR}/resources/pages/android/login/login.robot
Resource    ${EXECDIR}/resources/pages/android/aplicacao/aplicacao.robot
Resource    ${EXECDIR}/resources/pages/android/sincronizacao/sincronizacao.robot

Suite Setup    Abrir aplicativo

*** Test Cases ***
Teste 001 ::: Realizar login válido para sincronização inicial
    [Documentation]    DTSFASAPP-T31 :: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T31
    Realizar primeiro login no app

Teste 002 ::: Realizar sync
    [Documentation]    DTSFASAPP-T31 :: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T31
    Realizar primeira sincronizacao

Teste 003 ::: Realizar login válido após sincronização inicial
    [Documentation]    DTSFASAPP-T31 :: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T31
    Realizar login no app