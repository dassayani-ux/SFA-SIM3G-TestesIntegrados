*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas para validar ou apresentar informalões respectivas ao local do parceiro.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/variables/web/global/newGlobalVariables.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/data/local/dataLocal.robot

*** Keywords ***
Retorna descricao local
    [Documentation]    Irá retornar a descrição de um local de acordo com o parceiro passado como argumento.
    [Arguments]    ${parceiro}

    ${LOCAL_CLIENTE}    Query    ${LOCAL_CLIENTE_SQL}${parceiro}
    ${COUNT_LOCAL}    Row Count    ${LOCAL_CLIENTE_SQL}${parceiro}    

    ${Index}=    Evaluate    random.sample(range(0, ${COUNT_LOCAL}), 1)    random

    ${DESCRICAO_LOCAL}    Query    ${DESCRICAO_LOCAL_SQL}${LOCAL_CLIENTE[${Index[0]}][0]}

    Log To Console    Local selecionado: ${DESCRICAO_LOCAL[0][0]}
    
    Return From Keyword    ${DESCRICAO_LOCAL[0][0]}