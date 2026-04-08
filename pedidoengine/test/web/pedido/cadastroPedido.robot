*** Settings ***
Documentation    Arquivo utilizado para armazenar os casos de testes relativos à cadastro de pedido na web.

Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/pedido/cadastroPedidoResources.robot

Suite Setup      Run Keywords    Conecta ao banco de dados
...              AND             Abre Navegador
...              AND             Realiza login na plataforma web
Suite Teardown   Run Keywords    Realizar logoff
...              AND             Close Browser
...              AND             Disconnect From Database

*** Test Cases ***
Teste 001 ::: Cadastra novo pedido
    [Documentation]    DTSFASAPP-T42 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/255956
    Acessar cadastro de novo pedido
    Preenche cabecalho pedido
    Incluir itens no pedido
    Gravar pedido de venda
    Validar pedido no banco de dados