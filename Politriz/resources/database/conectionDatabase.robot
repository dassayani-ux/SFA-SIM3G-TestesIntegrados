*** Settings ***
Documentation    Arquivo utilizado para realizar a conexão com o banco de dados de acordo com os dador fornecidos.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/variables/web/global/globalVariables.robot

*** Keywords ***
Conecta ao banco de dados
    [Documentation]    Keyword utilizada para realizar a conexão com o banco de dados.
    Connect To Database    ${DBDriver}    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}