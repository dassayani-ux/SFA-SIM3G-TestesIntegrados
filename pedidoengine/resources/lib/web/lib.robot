*** Settings ***
Documentation    Arquivo utilizado para centralizar as bibliotecas utilizadas  para os testes web.

Library    SeleniumLibrary    screenshot_root_directory=${EXECDIR}/screenshots
Library    FakerLibrary    locale=pt_BR
Library    DatabaseLibrary
Library    String
Library    DateTime
Library    Collections
Library    ${EXECDIR}/pedidoengine/libraries/sfa_lib_web.py