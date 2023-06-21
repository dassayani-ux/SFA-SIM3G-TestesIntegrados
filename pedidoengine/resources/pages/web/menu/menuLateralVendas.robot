*** Settings ***

Library     SeleniumLibrary
 
Resource    ../../../variables/web/menu/menuLateralVariables.robot
Resource    ../../../variables/web/pedido/listaPedidosVariables.robot


*** Keywords ***
Iniciar um novo pedido quando menu recolhido
    Set Selenium Speed    2s
    Wait Until Page Contains Element       ${venda.menuVenda}    timeout=50
    Click Element   ${venda.menuVenda}
    Click Element   ${venda.menuPedido}
    Novo Pedido
    
Novo Pedido
   Click Element   ${venda.pedidoNovo}
   Sleep   2s


Abrir listagem
    Wait Until Page Contains Element       ${venda.menuVenda}    timeout=50
    Click Element   ${venda.menuVenda}
    Wait Until Element Is Visible    ${venda.menuPedido}    timeout=5s
    Click Element   ${venda.menuPedido}
    Wait Until Element Is Visible    ${venda.pedidoListar}
    Clicar no botão listar pedidos

Clicar no botão listar pedidos
   Click Element   ${venda.pedidoListar}
   Wait Until Page Contains Element   ${tituloPagina}    40s

