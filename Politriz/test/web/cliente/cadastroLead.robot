*** Settings ***
Documentation    Arquivo utilizado para armazenar os testes relativos a cadastro de Lead.

Default Tags      Cadastro Lead

Resource    ${EXECDIR}/resources/pages/web/cliente/cadastroLeadResources.robot

*** Test Cases ***

Caso de teste: Inscricoes estaduais de todos os estados LEAD
    [Documentation]    DTSFASAPP-T804 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T804
    Cadastrar inscricoes estaduais de todos os estados-LEAD POLITRIZ