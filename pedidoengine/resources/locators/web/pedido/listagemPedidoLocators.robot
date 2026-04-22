*** Settings ***
Documentation    Arquivo utilizado para armazenar os localizadores de elementos necessários no processo de listagem de pedidos.

*** Variables ***
${tituloPaginaListagemClientes}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Listagem de pedidos')]    #xpath
${msgCarregando}    //*[@id="loading"]/div[2]/div[contains(text(),'Carregando...')]    #xpath

&{pesquisaAvancadaPedido}    
...    ativaPesquisa=btnExibePesquisaAvancada    #class
...    camposAtivos=linhaUm    #id
...    numeroPedido=numeroPedido    #id

&{pesquisaRapidaPedido}
...    btnPesquisar=btnPesquisar    #id
...    btnLimpar=btnLimpar    #id

&{gridListagemPedidos}
...    numeroPedido=//*[@id="grid_pedido"]/div[5]/div/div[3]/div[1]    #xpath
...    headerGrid=//*[@id="principal"]/div[2]/div/div/div[2]/div[1]/span    #xpath
...    editarPedido=(//*[@id="grid_pedido"]//div[contains(@class,'l18 r18')]//a//img)[1]    #xpath — coluna 18 (Editar)
...    clonarPedido=(//*[@id="grid_pedido"]//div[contains(@class,'l19 r19')]//a//img)[1]    #xpath — coluna 19 (Clonar)
...    finalizarPedido=(//*[@id="grid_pedido"]//div[contains(@class,'l20 r20')]//a//img)[1]    #xpath — coluna 20 (Finalizar; visível quando parâmetro sim3g.desabilita.finalizar.listagem.pedido=1)
...    removerPedido=(//*[@id="grid_pedido"]//div[contains(@class,'l21 r21')]//a//img)[1]    #xpath — coluna 21 (Remover)

&{popUpFinalizarPedidoListagem}
...    divPopUp=/html/body/div[4]/div    #xpath
...    btnSim=/html/body/div[4]/div/div[3]/button[2]    #xpath
...    msgFinalizadoSucesso=/html/body/div[4]/div/div[2]/div[contains(text(),'Pedido finalizado com sucesso')]    #xpath
...    btnOk=/html/body/div[4]/div/div[3]/button    #xpath

&{popUpCancelarPedidoListagem}
...    divPopUp=/html/body/div[4]/div    #xpath
...    btnSim=/html/body/div[4]/div/div[3]/button[2]    #xpath
...    msgRemovidoSucesso=/html/body/div[4]/div/div[2]/div[contains(text(),'Removido com sucesso')]    #xpath
...    btnOk=/html/body/div[4]/div/div[3]/button    #xpath

&{popUpClonagemPedido}
...    titulo=//*[@id="popup0"]/div/div/div[1]/div/div[1]/h3[contains(text(),'Clonagem de pedido')]    #xpath
...    btnConfirmar=btnConfirmar    #id