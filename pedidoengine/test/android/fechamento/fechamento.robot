*** Settings ***
Documentation    Arquivo utilizado para rodar o ciclo de teste de fechamento
...    https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testPlayer/DTSFAPD-C4

Resource    ${EXECDIR}/resources/pages/android/login/login.robot
Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/android/menu/menuAndroid.robot
Resource    ${EXECDIR}/resources/pages/android/aplicacao/aplicacao.robot
Resource    ${EXECDIR}/resources/pages/android/consulta/consultaGeral.robot
Resource    ${EXECDIR}/resources/pages/android/consulta/consultaPedido.robot
Resource    ${EXECDIR}/resources/pages/android/sincronizacao/sincronizacao.robot
Resource    ${EXECDIR}/resources/pages/android/pedido/cadastroPedidoAndroidResources.robot
Resource    ${EXECDIR}/resources/pages/android/cliente/listagemClienteAndroidResources.robot
Resource    ${EXECDIR}/resources/pages/android/cliente/tela360ClienteAndroid.Resources.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abrir aplicativo
Suite Teardown    Run Keywords    Disconnect From Database    Close Application

*** Test Cases ***
Teste 001 ::: Realizar login válido para sincronização inicial
    [Documentation]    DTSFASAPP-T31 :: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T31
    Realizar primeiro login no app

Teste 002 ::: Realizar sync
    [Documentation]    DTSFASAPP-T31 :: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T31
    Realizar primeira sincronizacao

Teste 003 ::: Realizar login válido após sincronização inicial
    [Documentation]    DTSFASAPP-T31 :: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T31
    Realizar login no app

Teste 004 ::: Lançar pedido pela tela 360° do cliente, gravar e finalizar
    Acessar a guia de clientes no menu
    Filtrar cliente por razao social e Matricula e selecionar
    Iniciar atendimento tela 360
    Iniciar novo pedido tela 360
    Preencher cabecalho pedido - Android
    Acessar guia de produtos - Android
    Incluir produtos no pedido - Android
    Gravar pedido de venda - Android
    Validar informacoes da guia resumo
    Finalizar pedido de venda - Android
    Finalizar atendimento tela 360

Teste 005 ::: Filtrar pedido na listagem e editar
    Acessar a guia de consulta no menu
    Acessar a consulta de pedidos
    Abrir a pesquisa avancada na consulta de pedidos
    Filtrar pedido por numero    numeroPedido=${dadosPedidoAndroid.numeroPedido}
    Visualizar pedido de venda
    Acessar a guia de carrinho - Android
    Remover itens do pedido
    Acessar guia de produtos - Android
    Incluir produtos no pedido - Android
    Gravar pedido de venda - Android
    Validar informacoes da guia resumo
    Finalizar pedido de venda - Android

Teste 006 ::: Filtrar pedido e clonar
    Abrir a pesquisa avancada na consulta de pedidos
    Filtrar pedido por numero    numeroPedido=${dadosPedidoAndroid.numeroPedido}
    Clonar pedido de venda
    Validar cabecalho do pedido clonado