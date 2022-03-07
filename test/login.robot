*** Settings ***

Documentation    Login
Resource    ../resources/loginResources.robot
Resource    ../variables/globalVariables.robot

*** Test Cases ***

Caso de teste 01: realizar Login

    acessar a pagina home do crm
    Realizar login 
    Fechar navegador