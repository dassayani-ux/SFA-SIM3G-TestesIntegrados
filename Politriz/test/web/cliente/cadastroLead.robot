*** Settings ***
Default Tags      Cadastro Lead

Resource    ${EXECDIR}/resources/pages/web/cliente/cadastroLeadResources.robot

*** Test Cases ***

Caso de teste: Inscricoes estaduais de todos os estados LEAD
    Teste de cadastro de inscricoes estaduais de todos os estados-LEAD POLITRIZ