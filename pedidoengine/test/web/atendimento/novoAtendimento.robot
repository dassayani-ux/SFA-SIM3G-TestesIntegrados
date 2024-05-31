*** Settings ***
Documentation    Arquivo utilizado para realizar os testes relativos a lançamento de novo atendimento.

Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/atendimento/cadastroAtendimentoResources.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador    Realiza login na plataforma web
Suite Teardown    Run Keywords    Disconnect From Database    Close Browser

*** Test Cases ***
Teste 001 ::: Cadastro de atendimento
    [Documentation]    DTSFASAPP-T135 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/264681

    ${idAtendimentoAux}=    Retornar proximo atendimento
    ${idAtendimento}    Set Variable    ${idAtendimentoAux}
    Acessar tela de lançamento de atendimento
    Preencher cabeçalho do atentimento
    Iniciar atendimento
    Incluir imagem no atendimento
    Finalizar atendimento
    Validar criacao do atendimento no banco de dados    ${idAtendimento}