*** Settings ***
Documentation    Arquivo utilizado para realizar os testes relativos a edição de atendimento.

Resource    ${EXECDIR}/resources/pages/web/login/newLoginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/atendimento/listagemAtendimentoResources.robot
Resource    ${EXECDIR}/resources/pages/web/atendimento/cadastroAtendimentoResources.robot
Resource    ${EXECDIR}/resources/database/conectionDatabase.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador    Realiza login na plataforma web
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Editar atendimento
    [Documentation]    DTSFASAPP-T703 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/300860

    ${idAtendimentoAux}=    Retorna ultimo atendimento
    Set Test Variable    ${idAtendimento}    ${idAtendimentoAux}

    Acessa listagem de atendimentos
    Edita Atendimento
    Altera data fim do atendimento    ${idAtendimento} 
    Finaliza atendimento
    Valida edicao do atendimento    ${idAtendimento}