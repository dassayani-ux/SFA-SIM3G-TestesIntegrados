*** Settings ***

Library     SeleniumLibrary
Resource    ../variables/loginVariables.robot
Resource    ../variables/globalVariables.robot

*** Variables ***

*** Keywords ***

acessar a pagina home do crm

    Abrir navegador chrome

Realizar login

    Input Text      id=${LOGIN PROFISSIONAL}   01000016 

    Sleep   1s

    Input Text      id=${SENHA PROFISSIONAL}    12

    Sleep   1s

    Click Element   id=${BOTÂO ENTRAR}