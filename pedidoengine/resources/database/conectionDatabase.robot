*** Settings ***
Documentation    Arquivo utilizado para realizar a conexão com o banco de dados de acordo com os dador fornecidos.

Library    DatabaseLibrary
Variables    ${EXECDIR}/pedidoengine/libraries/variables/sfa_variables.py

*** Keywords ***
Conecta ao banco de dados
    [Documentation]    Keyword utilizada para realizar a conexão com o banco de dados.
    Connect To Database    psycopg2    ${banco_de_dados.dbName}    ${banco_de_dados.dbUser}    ${banco_de_dados.dbPass}    ${banco_de_dados.dbHost}    ${banco_de_dados.dbPort}