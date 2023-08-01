*** Settings ***
Documentation    Arquivo utilizado para armazenar as keywords utilizadas no processo de listagem de pedido de venda.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/pedido/listagemPedidoLocators.robot

*** Keywords ***
Acessa tela de listagem de pedidos
    [Documentation]    Irá acessar a tela de listagem de clientes

    SeleniumLibrary.Click Element    id=${venda.menuVenda}
    SeleniumLibrary.Wait Until Element Is Visible    id=${venda.subMenuPedido}
    SeleniumLibrary.Click Element    id=${venda.subMenuPedido}
    SeleniumLibrary.Wait Until Element Is Visible    id=${venda.listarPedido}
    SeleniumLibrary.Click Element    id=${venda.listarPedido}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${tituloPaginaListagemClientes}
    SeleniumLibrary.Switch Window    TOTVS CRM SFA | Listagem de pedidos
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${msgCarregando}
    Sleep    0.5s
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${msgCarregando}

Ativa pesquisa avancada pedido de venda
    [Documentation]    Keyword responsável por ativar a pesquisa avançada na tela de listagem de pedidos de venda.  

    SeleniumLibrary.Click Element    class=${pesquisaAvancadaPedido.ativaPesquisa}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaAvancadaPedido.camposAtivos}

Filtra pedido por numero definido
    [Documentation]    Filtra pedido de venda poor número.
    ...    \nO número do pedido deve ser passado no argumento *numeroPedido*.
    [Arguments]    ${numeroPedido}
    
    SeleniumLibrary.Input Text    id=${pesquisaAvancadaPedido.numeroPedido}    ${numeroPedido}
    SeleniumLibrary.Click Element    id=${pesquisaRapidaPedido.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${msgCarregando}
    Sleep    0.5s
    ${txtHeaderGridPedidos}    SeleniumLibrary.Get Text    xpath=${gridListagemPedidos.headerGrid}
    ${splitHeader}    String.Split String    ${txtHeaderGridPedidos}    /
    ${formated}    String.Remove String    ${splitHeader[0]}    (    )     Registros 
    ${intPedidos}    Convert To Integer    ${formated}

    IF  ${intPedidos} == ${1}
        ${numeroPedidoListagem}    SeleniumLibrary.Get Text    xpath=${gridListagemPedidos.numeroPedido}
        IF  '${numeroPedidoListagem}' == '${numeroPedido}'
            Log To Console    Pedido ${numeroPedido} localizado com sucesso!
        ELSE    
            Log To Console    Pedido ${numeroPedido} não foi encontrado.
            Fail     
        END
    ELSE   
        Log To Console    Há uma inconsistência na filtragem.
        Fail   
    END

Edita pedido de venda
    [Documentation]    Keyword responsável por editar o primeiro pedido de venda listado na grid de pedidos.

    SeleniumLibrary.Click Element    xpath=${gridListagemPedidos.editarPedido}