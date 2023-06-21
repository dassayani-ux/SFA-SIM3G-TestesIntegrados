*** Settings ***

Documentation    Login
Resource    ../../../resources/pages/web/login/loginResources.robot
Resource    ../../../resources/variables/web/global/globalVariables.robot

*** Test Cases ***

Caso de teste 01: realizar Login

    Abrir navegador chrome
    Realizar login     admin
    Fechar navegador