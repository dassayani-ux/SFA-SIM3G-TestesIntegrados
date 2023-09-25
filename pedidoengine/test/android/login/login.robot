*** Settings ***
Documentation    Arquivo utilizado para realizar testes no processo de login do app Android.

Resource    ${EXECDIR}/resources/pages/android/login/login.robot
Resource    ${EXECDIR}/resources/pages/android/aplicacao/aplicacao.robot

Suite Setup    Abrir aplicativo

*** Test Cases ***
Teste 001 ::: Realizar login válido após sincronização inicial
    Realizar login no app