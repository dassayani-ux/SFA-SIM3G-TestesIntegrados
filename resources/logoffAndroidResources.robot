*** Settings ***

Library     AppiumLibrary
Resource    ../variables/logoffAndroidVariables.robot

*** Keywords ***

logoff


    Wait Until Element Is Visible       ${BARRA}    timeout=120

    Click Text       ${BOTÂO SAIR}      exact_match=True

    Wait Until Element Is Visible       ${BOTÂO SIM}    timeout=120 

    Click Element  ${BOTÂO SIM}

