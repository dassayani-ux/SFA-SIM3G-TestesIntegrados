*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas para validar ou apresentar informalões respectivas ao local do parceiro.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/data/local/dataLocal.robot

*** Keywords ***
Retorna local aleatorio
    [Documentation]    Irá retornar um local aleatório com base nos registros salvos no banco de dados.

    ${countLocal}    Row Count    ${SQL_LOCAL}
    ${queryLocal}    Query    ${SQL_LOCAL}
    ${index}=    Evaluate    random.sample(range(0, ${countLocal}), 1)    random

    Return From Keyword    ${queryLocal[${index[0]}][0]}    ${queryLocal[${index[0]}][2]}

Retorna bairro aleatorio
    [Documentation]    Irá retornar um bairro aleatório com base nos registros salvos na tabela *local* do banco de dados.

    ${countLocal}    Row Count    ${SQL_LOCAL}
    ${queryLocal}    Query    ${SQL_LOCAL}
    ${index}=    Evaluate    random.sample(range(0, ${countLocal}), 1)    random

    Return From Keyword    ${queryLocal[${index[0]}][1]}

Retorna logradouro aleatorio
    [Documentation]    Irá retornar um logradouro aleatório com base nos registros salvos na tabela *local* do banco de dados.

    ${countLocal}    Row Count    ${SQL_LOCAL}
    ${queryLocal}    Query    ${SQL_LOCAL}
    ${index}=    Evaluate    random.sample(range(0, ${countLocal}), 1)    random

    Return From Keyword    ${queryLocal[${index[0]}][3]}

Retorna count Cidade
    [Documentation]    Esta keyword irá retornar a quantidade de cidades que possuem em sua descrição a palavra passada como argumento.
    [Arguments]    ${cidade}

    ${count}    Row Count    select * from cidade c where c.descricao ilike '%${cidade}%';
    
    Return From Keyword    ${count}

Retorna count Estado
    [Documentation]    Esta keyword irá retornar a quantidade de estados que possuem em sua descrição a palavra passada como argumento.
    [Arguments]    ${estado}

    ${count}    Row Count    select * from unidadefederativa u where u.descricao ilike '%${estado}%';
    
    Return From Keyword    ${count}