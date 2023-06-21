*** Settings ***
Documentation    Arquivo utilizado para realizar os testes relativos a lançamento de novo atendimento.

Resource    ${EXECDIR}/resources/pages/web/login/newLoginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/atendimento/cadastroAtendimentoResources.robot
Resource    ${EXECDIR}/resources/database/conectionDatabase.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador    Realiza login na plataforma web
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Cadastro de atendimento
    [Documentation]    DTSFASAPP-T135 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/264681

    ${idAtendimentoAux}=    Retorna proximo atendimento
    Set Test Variable    ${idAtendimento}    ${idAtendimentoAux}

    Acessa tela de cadastro de atendimento
    Preenche cabeçalho do atendimento
    Inicia atendimento
    Inlcuir imagem no atendimento
    Finaliza atendimento
    Valida criacao do atendimento no bd    ${idAtendimento}