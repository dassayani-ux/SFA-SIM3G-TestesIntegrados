*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas para abrir as opções do menu principal na lateral esquerda da web.

Library     SeleniumLibrary
 
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot


*** Keywords ***
Iniciar um novo pedido quando menu recolhido
    [Documentation]    irá expandir a opção de menu Venda e clicar em Novo  
    Set Selenium Speed    2s
    Wait Until Page Contains Element       ${venda.menuVenda}    timeout=50
    Click Element   ${venda.menuVenda}
    Click Element   ${venda.menuPedido}
    Novo Pedido
    
Novo Pedido
    [Documentation]    irá clicar em Novo quando o menu Venda já está expandido 
    Click Element   ${venda.pedidoNovo}
    Sleep   2s


Abrir listagem
    [Documentation]    irá expandir a opção de menu Venda e clicar em Listar  
    Wait Until Page Contains Element       ${venda.menuVenda}    timeout=50
    Click Element   ${venda.menuVenda}
    Wait Until Element Is Visible    ${venda.menuPedido}    timeout=5s
    Click Element   ${venda.menuPedido}
    Wait Until Element Is Visible    ${venda.pedidoListar}
    Clicar no botão listar pedidos

Clicar no botão listar pedidos
    [Documentation]    irá clicar em Listar quando o menu Venda já está expandido   
    Click Element   ${venda.pedidoListar}



Iniciar um novo lead quando menu recolhido
    [Documentation]    irá expandir a opção de menu Lead e clicar em Novo  
    Wait Until Page Contains Element       id=${lead.menuLead}    timeout=50
    Click Element   id=${lead.menuLead}
    Wait Until Element Is Visible    id=${lead.novoLead}
    Click Element   id=${lead.novoLead}
    Wait Until Page Contains    Lead

