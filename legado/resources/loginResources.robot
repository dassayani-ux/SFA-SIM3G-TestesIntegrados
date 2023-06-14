*** Settings ***

Library     SeleniumLibrary
Resource    ../variables/loginVariables.robot

*** Keywords ***

Realizar login

    Input Text      id=${LOGIN PROFISSIONAL}   01000016 

    Sleep   1s

    Input Text      id=${SENHA PROFISSIONAL}    12

    Sleep   1s

    Click Element   id=${BOTÂO ENTRAR}