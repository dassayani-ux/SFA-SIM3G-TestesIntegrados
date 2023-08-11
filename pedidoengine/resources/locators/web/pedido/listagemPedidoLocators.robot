*** Settings ***
Documentation    Arquivo utilizado para armazenar os localizadores de elementos necessários no processo de listagem de pedidos.

*** Variables ***
${tituloPaginaListagemClientes}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Listagem de pedidos')]    #xpath
${msgCarregando}    //*[@class="carregando-only-message"][contains(text(),'Carregando...')]    #xpath

&{pesquisaAvancadaPedido}    
...    ativaPesquisa=btnExibePesquisaAvancada    #class
...    camposAtivos=linhaUm    #id
...    numeroPedido=numeroPedido    #id

&{pesquisaRapidaPedido}
...    btnPesquisar=btnPesquisar    #id

&{gridListagemPedidos}
...    numeroPedido=//*[@id="grid_pedido"]/div[5]/div/div[3]/div[1]    #xpath
...    headerGrid=//*[@id="principal"]/div[2]/div/div/div[2]/div[1]/span    #xpath
...    editarPedido=//*[@id="grid_pedido"]/div[5]/div/div[3]/div[21]/a    #xpath