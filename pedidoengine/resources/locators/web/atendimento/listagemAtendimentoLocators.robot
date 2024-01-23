*** Variables ***

${tituloListagemAtendimento}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Atendimento')]

&{listagem}
...    gridListagem=grid_atendimento    #id
...    editarAtendimento=
...    campos=//*[@id="grid_atendimento"]/div[2]/div/div    #xpath

${btnPesquisa}    btnPesquisar    #id