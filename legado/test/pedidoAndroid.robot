*** Settings ***

Resource    ../variables/globalAndroid.robot
Resource    ../resources/loginAndroidResources.robot
Resource    ../resources/pedidoAndroidResources.robot

*** Test Cases ***

Caso de teste 01: Abrir o aplicativo Totvs
    abrir aplicativo

Caso de teste 02: Realizar Login

    login

Caso de teste 03: Entrar no cliente

    entrar no cliente