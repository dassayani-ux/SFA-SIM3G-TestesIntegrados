*** Variables ***

${tituloPagina}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Listagem de pedidos')]

&{pesquisa_rapida}
...        input_pesquisa=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/li/div[2]/input
...        button_pesquisar=//span[@class='ui-button-content'][contains(.,'Pesquisar')]

&{grid_pedidos}
...        campo_numero_pedido=//*[@id="grid_pedido"]/div[5]/div/div[3]/div[3]
...        button_editar=(//img[contains(@border,'0')])[2]
...        btn_aprovacao=//*[@id="grid_pedido"]/div[5]/div/div[3]/div[19]/a/img
...        aprovacao_pendente=//*[@id="grid_pedidoAprovacao"]/div[5]/div/div[3]/div[1]

