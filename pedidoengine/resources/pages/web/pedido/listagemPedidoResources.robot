*** Settings ***
Documentation    Arquivo utilizado para armazenar as keywords utilizadas no processo de listagem de pedido de venda.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/pedido/listagemPedidoLocators.robot
Resource    ${EXECDIR}/resources/data/pedido/dataPedido.robot
Resource    ${EXECDIR}/resources/locators/web/pedido/cadastroPedidoLocators.robot
Resource    ${EXECDIR}/resources/pages/web/pedido/cadastroPedidoResources.robot

*** Keywords ***
Acessar tela de listagem de pedidos
    [Documentation]    Irá acessar a tela de listagem de clientes

    SeleniumLibrary.Wait Until Element Is Enabled    id=${venda.menuVenda}
    SeleniumLibrary.Click Element    id=${venda.menuVenda}
    SeleniumLibrary.Wait Until Element Is Visible    id=${venda.subMenuPedido}
    SeleniumLibrary.Click Element    id=${venda.subMenuPedido}
    SeleniumLibrary.Wait Until Element Is Visible    id=${venda.listarPedido}
    SeleniumLibrary.Click Element    id=${venda.listarPedido}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${tituloPaginaListagemClientes}
    ${windowHandles}    Get Window Handles
    FOR    ${handle}    IN    @{windowHandles}
        Switch Window    ${handle}
        ${title}    Get Title
        Run Keyword If    '${title}' == 'TOTVS CRM SFA | Dashboard'    Close Window
    END
    SeleniumLibrary.Switch Window    TOTVS CRM SFA | Listagem de pedidos
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${msgCarregando}
    Sleep    0.5s
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${msgCarregando}
    Sleep    0.5s

Ativa pesquisa avancada pedido de venda
    [Documentation]    Keyword responsável por ativar a pesquisa avançada na tela de listagem de pedidos de venda.  

    SeleniumLibrary.Click Element    class=${pesquisaAvancadaPedido.ativaPesquisa}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaAvancadaPedido.camposAtivos}

Filtrar pedido por numero definido
    [Documentation]    Filtra pedido de venda poor número.
    ...    \nO número do pedido deve ser passado no argumento *numeroPedido*.
    [Arguments]    ${numeroPedido}
    
    SeleniumLibrary.Click Element    id=${pesquisaRapidaPedido.btnLimpar}
    Ativa pesquisa avancada pedido de venda
    ${headerInicial}    SeleniumLibrary.Get Text    xpath=${gridListagemPedidos.headerGrid}
    SeleniumLibrary.Scroll Element Into View    id=${pesquisaAvancadaPedido.numeroPedido}
    SeleniumLibrary.Input Text    id=${pesquisaAvancadaPedido.numeroPedido}    ${numeroPedido}
    Sleep    0.5s
    SeleniumLibrary.Click Element    id=${pesquisaRapidaPedido.btnPesquisar}
    SeleniumLibrary.Wait Until Element Does Not Contain    xpath=${gridListagemPedidos.headerGrid}    ${headerInicial}
    ${txtHeaderGridPedidos}    SeleniumLibrary.Get Text    xpath=${gridListagemPedidos.headerGrid}
    ${splitHeader}    String.Split String    ${txtHeaderGridPedidos}    /
    ${formated}    String.Remove String    ${splitHeader[0]}    (    )     Registros    .
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

Editar pedido de venda
    [Documentation]    Keyword responsável por editar o primeiro pedido de venda listado na grid de pedidos.
    [Arguments]    ${numeroPedido}

    SeleniumLibrary.Click Element    xpath=${gridListagemPedidos.editarPedido}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${cabecalhoPedido.numeroPedido}
    ${numeroEdicao}    SeleniumLibrary.Get Text    xpath=${cabecalhoPedido.numeroPedido}
    
    IF  '${numeroEdicao}' == '[Pedido ${numeroPedido}]'
        Log To Console    Tela de edição aberta com sucesso.
    ELSE
        Log to Console    Tela de edição não corresponde ao pedido editado.
        Fail
    END
    
    Popula dicionario de dados do pedido

Finalizar pedido de venda na listagem
    [Documentation]    Esta keyword é responsável por finalizar o pedido de venda na tela de listagem de pedidos.
    [Arguments]    ${numeroPedido}

    SeleniumLibrary.Click Element    xpath=${gridListagemPedidos.finalizarPedido}
    SeleniumLibrary.Wait Until Page Does Not Contain    Carregando...    180s
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpFinalizarPedidoListagem.divPopUp}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${popUpFinalizarPedidoListagem.btnSim}
    SeleniumLibrary.Click Element    xpath=${popUpFinalizarPedidoListagem.btnSim}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpFinalizarPedidoListagem.msgFinalizadoSucesso}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${popUpFinalizarPedidoListagem.btnOk}
    SeleniumLibrary.Click Element    xpath=${popUpFinalizarPedidoListagem.btnOk}

    ${situacao}=    Retornar situacao do pedido    numeroPedido=${numeroPedido}
    IF  '${situacao}' == 'PP'
        Log To Console    Pedido finalizado com sucesso.
    ELSE
        Log To Console    Pedido não encontra-se finalizado no banco de dados.
        Fail
    END

Cancelar pedido de venda pela listagem
    [Documentation]    Cancela o pedido de venda filtrado na listagem de pedidos.
    [Arguments]    ${numeroPedido}

    SeleniumLibrary.Click Element    xpath=${gridListagemPedidos.removerPedido}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpCancelarPedidoListagem.divPopUp}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${popUpCancelarPedidoListagem.btnSim}
    SeleniumLibrary.Click Element    xpath=${popUpCancelarPedidoListagem.btnSim}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpCancelarPedidoListagem.msgRemovidoSucesso}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${popUpCancelarPedidoListagem.btnOk}
    SeleniumLibrary.Click Element    xpath=${popUpCancelarPedidoListagem.btnOk}

    ${result}    DatabaseLibrary.Check If Not Exists In Database    select * from pedido p where p.numeropedido = '${numeroPedido}'

    Log To Console    Pedido cancelado.

Clonar pedido de venda
    [Documentation]    Clona o pedido de venda na listagem de pedidos.
    [Arguments]    ${numeroPedido}

    SeleniumLibrary.Click Element    xpath=${gridListagemPedidos.clonarPedido}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpClonagemPedido.titulo}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${popUpClonagemPedido.btnConfirmar}
    SeleniumLibrary.Click Element    id=${popUpClonagemPedido.btnConfirmar}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalhoPedido.idCabecalho}    60s
    Gravar pedido de venda