*** Settings ***

Documentation    Logoff
Resource    ../resources/loginResources.robot
Resource    ../resources/logoffResources.robot
Resource    ../variables/globalVariables.robot

*** Test Cases ***

caso de teste 01: realizar Login

    Abrir navegador chrome
    Realizar login

caso de teste 02: realizar Logoff

    realizar logoff
    Fechar navegador