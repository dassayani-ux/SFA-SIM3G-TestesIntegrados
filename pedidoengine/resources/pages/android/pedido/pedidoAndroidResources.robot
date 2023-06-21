*** Settings ***

Library     AppiumLibrary
Resource    ../../../variables/android/pedido/pedidoAndroidVariables.robot

*** Keywords ***

entrar no cliente

    Wait Until Element Is Visible       ${BOTÃO CLIENTE}    timeout=1200

    Click Text       ${BOTÃO CLIENTE}      exact_match=True

    Wait Until Element Is Visible  ${CLIENTE}  timeout=120 

    Click Text       ${CLIENTE}     exact_match=True

    








