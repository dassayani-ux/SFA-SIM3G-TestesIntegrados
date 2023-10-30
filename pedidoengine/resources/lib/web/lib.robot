*** Settings ***
Documentation    Arquivo utilizado para centralizar as bibliotecas utilizadas  para os testes web.

Library    SeleniumLibrary
Library    FakerLibrary    locale=pt_BR
Library    DatabaseLibrary
Library    String
Library    DateTime
Library    Collections
Library    ${EXECDIR}/libraries/sfa_lib_web.py