*** Settings ***
Documentation    Arquivo utilizado para realizar os testes de acesso na plataforma web.

Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/login/newLoginResources.robot

Suite Setup    Abre navegador

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