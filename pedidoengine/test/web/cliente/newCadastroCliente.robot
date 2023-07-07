*** Settings ***
Documentation    Arquivo utilizado para armazenar os testes relativos a cadastro de clientes.

Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/newLoginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/newCadastroCLienteResource.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador    Realiza login na plataforma web
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Valida campos obrigatórios cadastro cliente
    [Documentation]    DTSFASAPP-T59 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/256241
    Acessa tela de cadastro de cliente
    Valida campos obrigatorios do cliente

Teste 002 ::: Cadastro de cliente
    [Documentation]    DTSFASAPP-T76 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/256534
    Cadastra cliente juridico

Teste 003 ::: Valida tipo cobrança cliente
    [Documentation]    DTSFASAPP-T89 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/258851
    Acessa tela de listagem de clientes
    Ativa pesquisa avancada
    Valida tipo cobranca padrao