*** Settings ***
Documentation    Arquivo utilizado para armazenar os casos de testes relativos à cadastro de pedido na web.

Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/newLoginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/pedido/cadastroPedidoResources.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador    Realiza login na plataforma web
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Cadastra novo pedido
    [Documentation]    DTSFASAPP-T42 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/255956
    Acessar cadastro de novo pedido
    Preenche cabecalho pedido
    Gravar pedido de venda
    Acessa tela de listagem de pedidos
    Ativa pesquisa avancada pedido de venda
    Filtra pedido por numero definido    numeroPedido=${dadosPedido.numeroPedido}
    Edita pedido de venda
    Incluir itens no pedido
    # Sleep    3s