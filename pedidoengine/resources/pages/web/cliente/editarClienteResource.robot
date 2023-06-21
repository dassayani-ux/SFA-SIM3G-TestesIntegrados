*** Settings ***

Library     SeleniumLibrary
Library     FakerLibrary    locale=pt_BR
Library    String
Resource    ../../../variables/web/global/globalVariables.robot
Resource    ../../../variables/web/cliente/cadastroClienteVariables.robot
Resource    ../../../querysDB/local/tabelaLocalEmail.robot
Resource    ../../../variables/web/cliente/editarClienteVariables.robot
Resource    ../../../variables/web/menu/menuLateralVariables.robot

*** Keywords ***

Clicar para editar local 
    [Arguments]    ${LOCAL PESQUISAR}

    Log    ${LOCAL PESQUISAR}

    Consultar local       ${LOCAL PESQUISAR}     

    Click Element     ${clienteLocal.btnEditar}  


Consultar local 
    [Arguments]    ${LOCAL PESQUISAR}

    Log    ${LOCAL PESQUISAR}

    Wait Until Page Contains Element        ${clienteLocal.campoPesquisar}        timeout=10s

    Press Keys     ${clienteLocal.campoPesquisar}    ${LOCAL PESQUISAR}

    Click Element    ${clienteLocal.btnPesquisar}  

    Sleep    10s

    
Pegar email 
    
    Wait Until Page Contains Element        ${localGeral.campoEmail}

    Scroll Element Into View      ${localGeral.campoEmail}  

    ${EMAIL}     Get Value        ${localGeral.campoEmail}  

    [Return]    ${EMAIL}


Comparar email do local com o banco
    
    ${emailTela}    Pegar email

    ${idParceiro}    Get Value    //*[@id="idCliente"]   

    ${emailBanco}    Consultar email na tabelaLocalEmail       ${idParceiro}     

    Log    ${emailTela}

    Log    ${emailBanco}

    IF    '''${emailTela}''' != '''${emailBanco}'''
        Fail
    END




Clicar no botão cancelar
    Click Element        ${localGeral.btnCancelar}  

    Click Element    id=${cliente.menuCliente}


