*** Variables ***

${tituloListagemAtendimento}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Atendimento')]

&{listagem}
...    gridListagem=grid_atendimento    #id
...    editarAtendimento=//*[@id="grid_atendimento"]/div[5]/div/div[3]/div[12]