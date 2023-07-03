*** Settings ***
Documentation    Arquivo utilizado para armazenar as keywords atreladas à usuários.

Resource    ${EXECDIR}/resources/data/usuario/dataUsuario.robot

*** Keywords ***
Retorna usuario aleatorio
    [Documentation]    Irá retornar uma lista contendo um *ID* e *NOME* de usuário aleatório.

    ${usuario}    Query    ${SQL_USUARIO}
    ${count}    Row Count    ${SQL_USUARIO}

    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random

    Return From Keyword    ${usuario[${index[0]}][0]}    ${usuario[${index[0]}][2]}