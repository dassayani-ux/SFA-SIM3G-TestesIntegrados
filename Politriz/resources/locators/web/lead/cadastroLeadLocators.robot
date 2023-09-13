*** Variables ***

${UF}       //option[contains(text(), '{state}')]
${CIDADE2}    //option[contains(text(), '{city}')]  

&{cabecalho}
...    razaoSocial=formLeadrazaoSocial     #id
...    nomeFantasia=formLeadnomeFantasia    #id
...    cnpj=formLeadcnpj            #id
...    btnPesquisar=//a[contains(@id, 'btnPesquisar')]        #xpath
...    profissional=//*[@id="popup0"]/div/div[1]/div[2]/div/div/div/form/ul/li[2]/div[2]/div[5]/div/div[3]/div[1]    #xpath
...    contato=formLeadcontato    #id
...    telefone=formLeadtelefone        #id
...    email=formLeademail        #id
...    responsavel=formLeadresponsavelcomercial    #id


&{dialogProfissional}
...    titleDialog=//h3[contains(text(),'Profissional')]        #xpath
...    btnConfirmar=btnConfirmar                #id


&{local}
...    comboBoxPais=//*[@id="select2-cmbPais-container"]    #xpath
...    opcaoBrasil=//li[contains(text(), 'BRASIL')]             #xpath
...    comboBoxEstado=//*[@id="select2-cmbUf-container"]    #xpath
...    inputEstado=/html/body/span/span/span[1]/input     #xpath
...    inputCidade=/html/body/span/span/span[1]/input    #xpath
...    comboBoxCidade=/html/body/div[1]/div[2]/div/main/div/div[2]/div/div/form/div[1]/div[4]/ul/li[17]/span/span[1]/span/span[2]         #xpath
...    labelLogradouro=//*[@id="formLead"]/div[1]/div[4]/ul/li[18]/label    #xpath
...    logradouro=formLeadrua         #id
...    numero=formLeadnumero        #id
...    descricao=formLeaddescricao    #id
...    inscEstadual=formLeadie    #id


&{complementoLead}
...    bairro=//*[@id="DYNAMIC_ID_1"]        #xpath
...    cep=//*[@id="DYNAMIC_ID_2"]         #xpath
...    segmento=//*[@id="DYNAMIC_ID_3"]            #xpath
...    valorPrevisto=//*[@id="DYNAMIC_ID_4"]   #xpath


${btnGravar}    gravar
${mensagem}    //*[@id="jGrowl"]/div/div[@class='jGrowl-message']    #class
