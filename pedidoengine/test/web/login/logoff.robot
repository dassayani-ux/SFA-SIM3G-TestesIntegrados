*** Settings ***

Documentation    Logoff

Resource    ../../../resources/variables/web/global/globalVariables.robot
Resource    ../../../resources/pages/web/login/loginResources.robot
Resource    ../../../resources/pages/web/login/logoffResources.robot

*** Test Cases ***

caso de teste 01: realizar Login

    Abrir navegador chrome
    Realizar login    admin

caso de teste 02: realizar Logoff

    realizar logoff
    Fechar navegador