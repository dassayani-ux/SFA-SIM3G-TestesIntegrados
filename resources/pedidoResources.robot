*** Settings ***

Library     SeleniumLibrary
Library     BuiltIn 
Library     String
Library     OperatingSystem   
Resource    ../variables/globalVariables.robot
Resource    ../variables/pedidoVariables.robot


*** Keywords ***

entrar em vendas

    Wait Until Page Contains Element       id=${PEDIDO MENU}    timeout=50

    Click Element   id=${PEDIDO MENU}

    Sleep   1s

    Click Element   id=${VENDA PEDIDO}

    Sleep   1s

    Click Element   id=${VENDA PEDIDO NOVO}

cabeçalho pedido

    Wait Until Page Contains Element       id=${PROFISSIONAL}    timeout=50

    Click Element   id=${PROFISSIONAL}

    Sleep   0.5s

    Press Keys    Class=${PROFISSIONAL COD}    000016

    Press Keys    Class=${PROFISSIONAL COD}      ENTER

    Sleep   0.5s

    Click Element   xpath=${CLIENTE LUPA}

    Sleep   1s

    Press Keys  id=${PESQUISA CLIENTE}    000066

    Sleep   1s

    Press Keys    id=${PESQUISA CLIENTE}    ENTER

    Sleep   2s

    Click Element   id=${FILIAL}

    Sleep   1s

    Press Keys    Class=${FILIAL COD}   0101

    Press Keys    Class=${FILIAL COD}   ENTER  

    Sleep   0.5s

    Click Element   id=${CONDIÇÂO PAGAMENTO}

    Sleep   1s

    Press Keys  id=${CONDIÇÔES DISPONIVEIS}    ARROW_DOWN

    Sleep   4s

produtos

    Scroll Element Into View    xpath=${CAMPO PRODUTO}

    Sleep   1s

    Click Element   xpath=${PRIMEIRO CAMPO}

    Sleep   0.5s

    Click Element   xpath=${LUPA PRODUTO}

adicionar produtos

    Wait Until Page Contains Element       xpath=${LISTAGEM DE PRODUTOS}    timeout=50

    Wait Until Page Contains Element       xpath=${PRODUTO 1}   timeout=50

    Click Element   xpath=${PRODUTO 1}

    Sleep   0.1s

    Click Element   xpath=${PRODUTO 2}

    Sleep   0.1s

    Click Element   xpath=${PRODUTO 3}

    Sleep   0.2s

    Click Element   id=${BOTÂO CONFIRMAR}

    Sleep   2s


finalizar pedido

    Scroll Element Into View    id=${BOTÂO FINALIZAR}

    Sleep   1s

    Click Element    id=${BOTÂO FINALIZAR}

    Sleep   1.5s

    Element Should Contain    Xpath=${DIALOG CONFIRMAÇÂO PEDIDO}    ${TEXTO CONFIRMAÇÂO DE PEDIDO} 

    Sleep   0.5s

    Click Element   xpath=${BOTÂO SIM}

    Sleep   1.5s

    ${NUMERO PEDIDO}=        Get Text             ${NUMERO PEDIDO}  

    ${NUMERO PEDIDO}=        Remove String        ${NUMERO PEDIDO}  [Pedido 

    ${NUMERO PEDIDO}=        Remove String        ${NUMERO PEDIDO}  ]

    ${VALOR DO VALOR 1}=     Remove String        ${NUMERO PEDIDO}     ${SPACE}
    


    


