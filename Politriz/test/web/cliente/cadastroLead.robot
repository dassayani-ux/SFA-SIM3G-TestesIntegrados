*** Settings ***
Default Tags      Cadastro Lead

Resource    ${EXECDIR}/resources/pages/web/cliente/cadastroLeadResources.robot

*** Test Cases ***

Caso de teste: Inscricoes estaduais de todos os estados LEAD
    [Documentation]    DTSFASAPP-T804 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T804
    Teste de cadastro de inscricoes estaduais de todos os estados-LEAD POLITRIZ