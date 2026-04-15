*** Settings ***
Documentation    Arquivo utilizado para armazenar os testes que envolvem consulta de pedido no Android.

Resource    ${EXECDIR}/pedidoengine/resources/pages/android/login/login.robot
Resource    ${EXECDIR}/pedidoengine/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/menu/menuAndroid.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/aplicacao/aplicacao.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/consulta/consultaGeral.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/consulta/consultaPedido.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/sincronizacao/sincronizacao.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abrir aplicativo    Realizar login no app
Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Acessar a guia de consulta e buscar pedido pelo numero
    Acessar a guia de consulta no menu
    Acessar a consulta de pedidos
    Abrir a pesquisa avancada na consulta de pedidos
    Filtrar pedido por numero    numeroPedido=80902006
    Visualizar pedido de venda