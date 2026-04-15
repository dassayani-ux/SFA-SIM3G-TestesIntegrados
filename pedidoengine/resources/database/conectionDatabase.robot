*** Settings ***
Documentation    Arquivo utilizado para realizar a conexão com o banco de dados de acordo com os dador fornecidos.

Library    DatabaseLibrary
Variables    ${EXECDIR}/pedidoengine/libraries/variables/sfa_variables.py

*** Keywords ***
Conecta ao banco de dados
    [Documentation]    Keyword utilizada para realizar a conexão com o banco de dados.
    Connect To Database    psycopg2    ${banco_de_dados.dbName}    ${banco_de_dados.dbUser}    ${banco_de_dados.dbPass}    ${banco_de_dados.dbHost}    ${banco_de_dados.dbPort}

Buscar usuario automacao no banco
    [Documentation]    Busca no banco o profissional de automação mais recente que esteja ativo
    ...                (nome LIKE '%Automação%' AND idnativo = 1) e define as variáveis de suite
    ...                ${USUARIO_MOBILE} e ${SENHA_MOBILE} com o login encontrado.
    ...                O login e a senha são iguais, conforme padrão de criação do profissional automação.

    ${result}=    DatabaseLibrary.Query
    ...    SELECT login FROM usuario WHERE nome LIKE '%Automação%' AND idnativo = 1 ORDER BY idusuario DESC LIMIT 1
    Should Not Be Empty    ${result}
    ...    msg=❌ Nenhum profissional de automação ativo encontrado no banco. Execute o teste web de cadastro antes.
    ${login}=    Set Variable    ${result[0][0]}
    Set Suite Variable    ${USUARIO_MOBILE}    ${login}
    Set Suite Variable    ${SENHA_MOBILE}      ${login}
    Log To Console    \n✅ Usuário automação encontrado para o mobile: ${login}