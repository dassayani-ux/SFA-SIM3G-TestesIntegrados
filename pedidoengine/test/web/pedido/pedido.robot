*** Settings ***
Documentation       Essa suite de testes, testa o pedido da Assaabloy 
Test Setup          Abrir navegador chrome
# Test Teardown       Fechar navegador   

Resource    ../../../resources/pages/web/pedido/pedidoResources.robot
Resource    ../../../resources/pages/web/login/loginResources.robot
Resource    ../../../resources/pages/web/pedido/ListagemPedidosResource.robot
Resource    ../../../resources/pages/web/pedido/CabecalhoPedidoResource.robot
Resource    ../../../resources/variables/web/global/globalVariables.robot
Resource    ../../../resources/pages/web/login/logoffResources.robot
Resource    ../../../resources/data/dados_pedido.robot
Resource    ../../../resources/data/dados_cliente.robot
Resource    ../../../resources/pages/web/pedido/aprovacaoPedidoPorLink.robot
Resource    ../../../resources/pages/web/pedido/aprovacaoPedido.robot
Resource    ../../../resources/pages/web/cliente/editarClienteResource.robot
Resource    ../../../resources/pages/web/menu/menuLateralVendas.robot
Resource    ../../../resources/variables/web/pedido/ajusteVinculosPedido.robot


Default Tags      Pedido

*** Variables ***

# ${NUMERO PEDIDO FINAL}    PORC262687

*** Test Cases ***
Caso de teste T174
    [Documentation]     Automação do caso de teste T174: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T174
    [TAGS]              T174     planoRegressao

    Realizar login    admin
    Iniciar um novo pedido quando menu recolhido
    Cabeçalho pedido: Selecionar estabelecimento             ${estabelecimento.aa_205}
    Cabeçalho pedido: Selecionar profissional                ${profissional.SILVA}
    Cabeçalho pedido: Selecionar unidade                     ${unidade.PAPAIZ}
    Cabeçalho pedido: Selecionar cliente                     ${clientePH.codigoCliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${frete.CIF}
    Cabeçalho pedido: Selecionar Vertical                    ${vertical.residencial}
    Produtos: Abrir dialog de busca de produtos
    Produtos: Adicionar produto com preço e com quantidade    0109003CX      25,00    39
    Produtos: Adicionar produto com preço e com quantidade    0880200PT     100,00    20
    Produtos: Adicionar produto com preço e com quantidade    0114401SMVD    60,00    40
    Produtos: Confirmar produtos selecionados
    Calcular imposto
    Gravar pedido
    Finalizar pedido com aprovação                  Faixa de Desconto de 10.01 ate 23.0
    Abrir listagem
    Localizar pedido pelo campo pesquisa rápida     ${NUMERO_PEDIDO_FINAL}
    Verificar se gerou aprovação
    Fechar dialog de aprovacao
    realizar logoff
    Realizar login            adetes
    Abrir listagem
    Aprovar pedido            ${NUMERO_PEDIDO_FINAL}
    realizar logoff
    Realizar login            adisim
    Abrir listagem
    Aprovar pedido            ${NUMERO_PEDIDO_FINAL}
    realizar logoff
    Realizar login            admin
    Abrir listagem
    Localizar pedido pelo campo pesquisa rápida         ${NUMERO_PEDIDO_FINAL}
    Editar Pedido 
    Clicar no botão gerar pedido e clicar em sim
    Abrir listagem
    Localizar pedido pelo campo pesquisa rápida         ${NUMERO_PEDIDO_FINAL} 
	
	
Caso de teste T176
    [Documentation]     Automação do caso de teste T176: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T176
    [TAGS]              T176

    Realizar login      admin
    Entrar em vendas
    Cabeçalho pedido: Selecionar estabelecimento             ${CT_174_176.estabelecimento}
    Cabeçalho pedido: Selecionar profissional                ${CT_174_176.profissional}
    Cabeçalho pedido: Selecionar unidade                     ${CT_174_176.unidade}
    Cabeçalho pedido: Selecionar cliente                     ${CT_174_176.cliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${CT_174_176.frete}
    Cabeçalho pedido: Selecionar Vertical                    ${CT_174_176.vertical}
    Produtos: Abrir dialog de busca de produtos
    Produtos: Adicionar produto "0109003CX" com quantidade "39" 
    Produtos: Adicionar produto "0880200PT" com quantidade "20" 
    Produtos: Adicionar produto "0114401SMVD" com quantidade "40"
    Produtos: Confirmar produtos selecionados
    Calcular imposto
    Gravar pedido
    Finalizar pedido sem aprovação
    Abrir listagem
    Localizar pedido pelo campo pesquisa rápida     ${NUMERO PEDIDO FINAL}
    Editar Pedido 
    Clicar no botão gerar pedido
    Abrir listagem
    Localizar pedido pelo campo pesquisa rápida         ${NUMERO PEDIDO FINAL} 
    
    
Caso de teste T266
    [Documentation]     Automação do caso de teste T266: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T266
    [TAGS]              T266    planoRegressão

    Realizar login    admin
    Entrar em vendas    
    Cabeçalho pedido: Selecionar estabelecimento             ${CT_266.estabelecimento}
    Cabeçalho pedido: Selecionar profissional                ${CT_266.profissional}
    Cabeçalho pedido: Selecionar unidade                     ${CT_266.unidade}
    Cabeçalho pedido: Selecionar cliente                     ${CT_266.cliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${CT_266.frete}
    Cabeçalho pedido: Selecionar Vertical                    ${CT_266.vertical}
    Produtos: Abrir dialog de busca de produtos
    Produtos: Adicionar apenas produto "35.00086" 
    Produtos: Confirmar produtos selecionados
    Calcular imposto



Caso de teste T274
    [Documentation]     Automação do caso de teste T274: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T274
    [TAGS]              T274    planoRegressão

    Realizar login    admin
    Entrar em vendas
    Cabeçalho pedido: Selecionar estabelecimento             ${CT_274.estabelecimento}
    Cabeçalho pedido: Selecionar profissional                ${CT_274.profissional}
    Cabeçalho pedido: Selecionar unidade                     ${CT_274.unidade}
    Cabeçalho pedido: Selecionar cliente                     ${CT_274.cliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${CT_274.frete}
    Cabeçalho pedido: Selecionar Vertical                    ${CT_274.vertical}
    Produtos: Abrir dialog de busca de produtos
    Produtos: Adicionar produto "0109004CX" e alterar preço para "5,59"
    Produtos: Adicionar produto "0109011CX" e alterar preço para "3,72"
    Produtos: Adicionar produto "0880200BR" e alterar preço para "11,58"
    Produtos: Confirmar produtos selecionados
    Calcular imposto
    Clicar no botão gerar pedido                                      Faixa de Desconto de 23.01 ate 100.0
    Abrir listagem
    Localizar pedido pelo campo pesquisa rápida                       ${NUMERO PEDIDO FINAL}
    Verificar se gerou aprovação                    
    Verificar tipo Aprovação                                          Faixa de Desconto de 23.01 ate 100.0
    Acessar link de aprovacao do pedido                               AP    ${NUMERO PEDIDO FINAL}    650  
    Verificar se na web exibe o status de aprovação por usuario       ${NUMERO PEDIDO FINAL}    EDUARDO YOKOTA    AP
    Acessar link de aprovacao do pedido                               AP    ${NUMERO PEDIDO FINAL}    579  


Caso de teste T275
    [Documentation]     Automação do caso de teste T274: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T275
    [TAGS]              T275    planoRegressão

    Realizar login    admin
    Entrar em vendas
    Cabeçalho pedido: Selecionar estabelecimento             ${CT_274.estabelecimento}
    Cabeçalho pedido: Selecionar profissional                ${CT_274.profissional}
    Cabeçalho pedido: Selecionar unidade                     ${CT_274.unidade}
    Cabeçalho pedido: Selecionar cliente                     ${CT_274.cliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${CT_274.frete}
    Cabeçalho pedido: Selecionar Vertical                    ${CT_274.vertical}
    Produtos: Abrir dialog de busca de produtos
    Produtos: Adicionar produto "0109004CX" e alterar preço para "5,59"
    Produtos: Adicionar produto "0109011CX" e alterar preço para "3,72"
    Produtos: Adicionar produto "0880200BR" e alterar preço para "11,58"
    Produtos: Confirmar produtos selecionados
    Calcular imposto
    Clicar no botão gerar pedido                                      Faixa de Desconto de 23.01 ate 100.0     
    Abrir listagem
    Localizar pedido pelo campo pesquisa rápida                       ${NUMERO PEDIDO FINAL}
    Verificar se gerou aprovação                    
    Verificar tipo Aprovação                                          Faixa de Desconto de 23.01 ate 100.0
    Acessar link de aprovacao do pedido                               RP    ${NUMERO PEDIDO FINAL}    650  
    Verificar se o pedido está com a situação reprovado 


teste aprovacao
    Realizar login    admin
    Abrir listagem
    Acessar link de aprovacao do pedido                                  RP    PPED262758    650 
          
    # Verificar se na web exibe o status de aprovação por usuario       PPED262758    EDUARDO YOKOTA    RP

Caso de teste T309
    [Documentation]     Automação do caso de teste T309: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T309
    [TAGS]              T309    planoRegressao

    Realizar login      admin
    Iniciar um novo pedido quando menu recolhido
    Cabeçalho pedido: Selecionar estabelecimento                  ${estabelecimento.papaiz_301}
    Cabeçalho pedido: Selecionar profissional                     ${profissional.TSUKUMI}
    Cabeçalho pedido: Selecionar unidade                          ${unidade.UDINESE}
    Cabeçalho pedido: Selecionar cliente                          ${clienteVidroBox.codigoCliente}
    Cabeçalho pedido: Selecionar Vertical                         ${vertical.residencial}
    Produtos: Clicar na lupa da cesta de produtos
    Produtos: Buscar produto pelo dialog da cesta                 9302155
    Produtos: Confirmar produtos selecionados
    Clicar no botão cesta
    Validar produto na cesta
    Produtos: Clicar na lupa da cesta de produtos
    Produtos: Buscar produto por descricao                        conf
    Produtos: Selecionar outro produto por descricao conf
    Produtos: Confirmar produtos selecionados
    Clicar no botão cesta
    Validar produtos na cesta T309
    Confirmar produtos da cesta
    Validar se a cor do icone de imposto do segundo item da lista está cinza
    Validar cor do icone de impostos conf T309
	

Caso de teste T310
    [Documentation]     Automação do caso de teste T310: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T310
    [TAGS]              T310   planoRegressão

    Realizar login      admin
    Entrar em vendas
    Cabeçalho pedido: Selecionar estabelecimento                          ${CT_310.estabelecimento}
    Cabeçalho pedido: Selecionar profissional                             ${CT_310.profissional}
    Cabeçalho pedido: Selecionar unidade                                  ${CT_310.unidade}
    Cabeçalho pedido: Selecionar cliente                                  ${CT_310.cliente}
    Cabeçalho pedido: Selecionar Vertical                                 ${CT_310.vertical}
    Produtos: Selecionar na lupa da cesta
    Produtos: Buscar produto pelo dialog da cesta 9302155
    Produtos: Confirmar produtos selecionados
    Produtos: Selecionar na lupa da cesta
    Produtos: Buscar produto por descricao conf
    Produtos: Confirmar produtos selecionados
    Confirmar produtos da cesta
    Validar cor do icone de impostos 
    Selecionar no icone de imposto do produto configurado quando impostos nao estao calculados
    Clicar em atualizar
    Validar mensagem para configurar os produtos
    Clicar em ok
    Selecionar em voltar
    Validar cor do icone de impostos
    Calcular imposto
    Validar mensagem para configurar os produtos
    Clicar em ok 
    Validar cor do icone de impostos
    Selecionar relatorio
    Validar mensagem para configurar os produtos
    Clicar em ok 
    Validar cor do icone de impostos
    Selecionar email
    Validar mensagem para configurar os produtos
    Clicar em ok 
    Validar cor do icone de impostos
    Selecionar em Finalizar
    Validar mensagem para configurar os produtos
    Clicar em ok 
    Validar cor do icone de impostos
    Selecionar gerar pedido
    Validar mensagem para configurar os produtos
    Clicar em ok
    Validar cor do icone de impostos
    Selecionar no icone de impostos no resumo quando falta calculo de imposto em algum produto 
    Validar cor do icone de impostos
	
Caso de teste T333
    [Documentation]     Automação do caso de teste T333: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T333
    [TAGS]              T333    planoRegressao
    
    Desfazer vinculo com operação que faz o calculo de imposto automaticamente     ${unidade.LA_FONTE}
    Realizar login    admin
    Iniciar um novo pedido quando menu recolhido    
    Cabeçalho pedido: Selecionar estabelecimento             ${estabelecimento.aa_201}
    Cabeçalho pedido: Selecionar profissional                ${profissional.LEMAT}
    Cabeçalho pedido: Selecionar unidade                     ${unidade.LA_FONTE}
    Cabeçalho pedido: Selecionar cliente                     ${clienteConstrutora.codigoCliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${frete.CIF}
    Cabeçalho pedido: Selecionar Vertical                    ${vertical.residencial}
    Produtos: Abrir dialog de busca de produtos
    Produtos: Adicionar apenas produto                       95180060-4 
    Produtos: Adicionar apenas produto                       96159069-8
    Produtos: Adicionar apenas produto                       95180028-9
    Produtos: Confirmar produtos selecionados
    Clicar no icone de imposto do primeiro produto da grid
    Clicar em atualizar
    Validar valor total na tela de imposto                    R$ 890,01
    Clicar no botão voltar no dialog imposto
    Validar se só a cor do icone de imposto do primeiro produto inserido na grid está verde
    Clicar no botão relatorio
    Voltar para a aba do pedido 
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está verde
    Clicar no icone de imposto do primeiro produto da grid
    Validar valor total na tela de imposto                    R$ 890,01
    Clicar no botão voltar no dialog imposto
    Alterar a quantidade do primeiro produto da grid          10
    Alterar a quantidade do segundo produto da grid           20
    Alterar a quantidade do terceiro produto da grid          30
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está cinza
    Clicar no botão enviar
    Clicar no botão fechar no dialog enviar
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está verde
    Clicar no icone de imposto do primeiro produto da grid
    Validar valor total na tela de imposto                    R$ 8.900,10
    Clicar no botão voltar no dialog imposto
    Alterar a quantidade do primeiro produto da grid          11
    Alterar a quantidade do segundo produto da grid           20
    Alterar a quantidade do terceiro produto da grid          30
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está cinza
    Calcular imposto
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está verde
    Clicar no icone de imposto do primeiro produto da grid
    Validar valor total na tela de imposto                    R$ 9.790,11
    Clicar no botão voltar no dialog imposto
    Alterar a quantidade do primeiro produto da grid          20
    Alterar a quantidade do segundo produto da grid           20
    Alterar a quantidade do terceiro produto da grid          20
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está cinza
    Clicar no botão Finalizar
    Clicar Nao no dialog de finalização
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está verde
    Clicar no icone de imposto do primeiro produto da grid
    Validar valor total na tela de imposto                    R$ 17.800,20
    Clicar no botão voltar no dialog imposto
    Alterar a quantidade do primeiro produto da grid          11
    Alterar a quantidade do segundo produto da grid           22
    Alterar a quantidade do terceiro produto da grid          33
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está cinza
    Clicar no botão gerar pedido e clicar em não
    Validar se a cor dos icones de imposto dos três produtos inseridos na grid está verde
    Clicar no icone de imposto do primeiro produto da grid
    Validar valor total na tela de imposto                    R$ 9.790,11


teste remover vinculo operacao 
    Desfazer vinculo com operação que faz o calculo de imposto automaticamente     UDINESE
    Inserir o vinculo com operação que faz o calculo de imposto automaticamente    18



Caso de teste T416
    [Documentation]     Automação do caso de teste T416: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T416
    [TAGS]              T416   planoRegressao
    
    Realizar login      admin
    Iniciar um novo pedido quando menu recolhido
    Cabeçalho pedido: Selecionar estabelecimento                          ${estabelecimento.papaiz_301}
    Cabeçalho pedido: Selecionar profissional                             ${profissional.TSUKUMI}
    Cabeçalho pedido: Selecionar unidade                                  ${unidade.UDINESE}
    Cabeçalho pedido: Selecionar cliente                                  ${clienteVidroBox.codigoCliente}
    Cabeçalho pedido: Selecionar Vertical                                 ${vertical.residencial}
    Validar posicao e selecionar icone cliente
    Validar informacoes no icone cliente    
    Clicar no botão ok
    Clicar no botão listar pedidos
    Localizar pedido pelo código do cliente pelo campo pesquisa rápida          ${clienteVidroBox.codigoCliente} 
#Patricia, ver para corrigir aqui!
    Editar Pedido
    Validar posicao e selecionar icone cliente
    Validar informacoes no icone cliente
    Clicar no botão ok
    

Caso de teste T463
    [Documentation]     Automação do caso de teste T463: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T463
    [TAGS]              T463       planoRegressao
    
    Desfazer vinculo com operação que faz o calculo de imposto automaticamente     ${unidade.LA_FONTE}
    Realizar login      admin
    Iniciar um novo pedido quando menu recolhido
    Cabeçalho pedido: Selecionar estabelecimento             ${estabelecimento.aa_201}
    Cabeçalho pedido: Selecionar profissional                ${profissional.LEMAT}
    Cabeçalho pedido: Selecionar unidade                     ${unidade.LA_FONTE}
    Cabeçalho pedido: Selecionar cliente                     ${clienteConstrutora.codigoCliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${frete.CIF}
    Cabeçalho pedido: Selecionar Vertical                    ${vertical.residencial}
    Produtos: Abrir dialog de busca de produtos
    Produtos: Adicionar apenas produto                       05170065-6
    Produtos: Adicionar apenas produto                       01229169-0
    Produtos: Confirmar produtos selecionados
    Calcular imposto
    Pegar numero do pedido do topo da tela de pedido, formatar e setar numa Suite Variable
    Deletar vinculo entre um produto de um pedido na tabela pedidoImposto    ${NUMERO_PEDIDO_FINAL}    05170065-6 
    Clicar no botão listar pedidos
    Localizar pedido pelo campo pesquisa rápida     ${NUMERO_PEDIDO_FINAL}
    Editar Pedido
    Validar se só a cor do icone de imposto do primeiro produto inserido na grid está cinza
    Clicar no icone de imposto do primeiro produto da grid
    Validar se só exibe impostos de fachada 
    Clicar no botão voltar no dialog imposto
    Clicar no botão Finalizar
    Clicar Nao no dialog de finalização
    Validar se a cor do icone de impostos dos dois itens da lista estão verde 
    Clicar no icone de imposto do primeiro produto da grid
    Validar se exibe todos os impostos
    Clicar no botão voltar no dialog imposto
    Deletar vinculo entre um produto de um pedido na tabela pedidoImposto    ${NUMERO_PEDIDO_FINAL}    05170065-6 
    Clicar no botão listar pedidos
    Localizar pedido pelo campo pesquisa rápida     ${NUMERO_PEDIDO_FINAL}
    Editar Pedido
    Validar se só a cor do icone de imposto do primeiro produto inserido na grid está cinza
    Clicar no icone de imposto do primeiro produto da grid
    Validar se só exibe impostos de fachada
    Clicar no botão voltar no dialog imposto
    Clicar no botão relatorio
    Voltar para a aba do pedido
    Validar se a cor do icone de impostos dos dois itens da lista estão verde 
    Clicar no icone de imposto do primeiro produto da grid
    Validar se exibe todos os impostos
    Clicar no botão voltar no dialog imposto
    Deletar vinculo entre um produto de um pedido na tabela pedidoImposto    ${NUMERO_PEDIDO_FINAL}    05170065-6 
    Clicar no botão listar pedidos
    Localizar pedido pelo campo pesquisa rápida     ${NUMERO_PEDIDO_FINAL}
    Editar Pedido
    Validar se só a cor do icone de imposto do primeiro produto inserido na grid está cinza
    Clicar no icone de imposto do primeiro produto da grid
    Validar se só exibe impostos de fachada
    Clicar no botão voltar no dialog imposto
    Clicar no botão enviar
    Clicar no botão cancelar no dialog enviar
    Validar se a cor do icone de impostos dos dois itens da lista estão verde 
    Clicar no icone de imposto do primeiro produto da grid
    Validar se exibe todos os impostos
    Clicar no botão voltar no dialog imposto
    Deletar vinculo entre um produto de um pedido na tabela pedidoImposto    ${NUMERO_PEDIDO_FINAL}    05170065-6 
    Clicar no botão listar pedidos
    Localizar pedido pelo campo pesquisa rápida     ${NUMERO_PEDIDO_FINAL}
    Editar Pedido
    Validar se só a cor do icone de imposto do primeiro produto inserido na grid está cinza
    Clicar no icone de imposto do primeiro produto da grid
    Validar se só exibe impostos de fachada
    Clicar no botão voltar no dialog imposto
    Clicar no botão gerar pedido e clicar em não
    Validar se a cor do icone de impostos dos dois itens da lista estão verde 
    Clicar no icone de imposto do primeiro produto da grid
    Validar se exibe todos os impostos
    Clicar no botão voltar no dialog imposto