*** Settings ***

Documentation    Login
Resource    ../resources/loginResources.robot
Resource    ../variables/globalVariables.robot

*** Test Cases ***

Caso de teste 01: realizar Login

    Abrir navegador chrome
    Realizar login 
    Fechar navegador