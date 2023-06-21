*** Variables ***

${tituloPagina}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Listagem de pedidos')]

&{pesquisaRapida}
...        inputPesquisa=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/li/div[2]/input
...        btnPesquisar=//span[@class='ui-button-content'][contains(.,'Pesquisar')]

&{gridPedidos}
...        campoNumeroPedido=//*[@id="grid_pedido"]/div[5]/div/div[3]/div[3]
...        btnEditar=//*[@id="grid_pedido"]/div[5]/div/div[3]/div[22]/a/img
...        btnAprovacaoPendente=//*[@id="grid_pedido"]/div[5]/div/div[3]/div[20]/a/img
...        aprovacaoPendente=//*[@id="grid_pedidoAprovacao"]/div[5]/div/div[3]/div[1]

