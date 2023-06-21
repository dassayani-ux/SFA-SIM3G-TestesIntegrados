*** Settings ***

Resource    ../../../resources/variables/android/global/globalAndroid.robot
Resource    ../../../resources/pages/android/login/loginAndroidResources.robot

*** Test Cases ***

Caso de teste 01: Abrir o aplicativo Totvs
    abrir aplicativo

Caso de teste 02: Realizar Login

    login