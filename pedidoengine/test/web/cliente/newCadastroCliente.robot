*** Settings ***
Documentation    Arquivo utilizado para armazenar os testes relativos a cadastro de clientes.

Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/newLoginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/newCadastroCLienteResource.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador    Realiza login na plataforma web
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Cadastro de cliente
    [Documentation]    DTSFASAPP-T76 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/256534

    Acessa tela de cadastro de cliente
    Cadastra cliente juridico