*** Settings ***
Documentation    Arquivo utilizado para centralizar as bibliotecas utilizadas para os testes Android.

Library    AppiumLibrary
Library    Collections
Library    String
Library    ${EXECDIR}/pedidoengine/libraries/sfa_lib_mobile.py    # path relativo à raiz do projeto
Library    DateTime