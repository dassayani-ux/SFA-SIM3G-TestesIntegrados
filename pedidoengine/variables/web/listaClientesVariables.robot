*** Variables ***

${tituloPagina}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Listagem de clientes')]

&{pesquisa_rapida}
...        input_pesquisa=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/li/div[2]/input
...        button_pesquisar=//*[@id="btnPesquisar"]/span

&{grid_clientes}
...        campo_razao_social=//*[@id="grid_parceiro"]/div[5]/div/div[3]/div[1]
...        button_editar=//*[@id="grid_parceiro"]/div[5]/div/div[3]/div[6]/a/img
