*** Settings ***
Documentation    Arquivo utilizado para armazenar os testes que envolvem cliente.

Resource    ${EXECDIR}/resources/pages/android/login/login.robot
Resource    ${EXECDIR}/resources/pages/android/menu/menuAndroid.robot
Resource    ${EXECDIR}/resources/pages/android/aplicacao/aplicacao.robot
Resource    ${EXECDIR}/resources/pages/android/sincronizacao/sincronizacao.robot
Resource    ${EXECDIR}/resources/pages/android/cliente/listagemClienteAndroidResources.robot

Suite Setup    Run Keywords    Abrir aplicativo    Realizar login no app

*** Test Cases ***
Teste 001 ::: Lançar pedido pela tela 360° do cliente
    Acessar a guia de clientes no menu
    Ativar/desativar pesquisa avancada cliente