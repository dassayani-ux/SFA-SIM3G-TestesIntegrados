*** Settings ***
Documentation       Essa suite de testes, testa o pedido log DTSFASAPP-2957
Test Setup          Abrir navegador chrome
# Test Teardown       Fechar navegador   

Resource    ../../../resources/pages/web/pedido/pedidoResources.robot
Resource    ../../../resources/pages/web/login/loginResources.robot
Resource    ../../../resources/variables/web/global/globalVariables.robot
Resource    ../../../resources/data/dados_pedido.robot
Resource    ../../../resources/pages/web/pedido/CabecalhoPedidoResource.robot
Resource    ../../../resources/pages/web/pedido/ListagemPedidosResource.robot
Resource    ../../../resources/pages/web/menu/menuLateralVendas.robot
Default Tags      Pedidolog

*** Variables ***

*** Test Cases ***

aso de teste T499
#Falta validar o passo 8 do caso de teste
    [Documentation]     Automação do caso de teste T499: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T499
    [TAGS]        Pedidolog      T499    
    Realizar login    admin
    Iniciar um novo pedido quando menu recolhido
    Cabeçalho pedido: Selecionar estabelecimento             ${estabelecimento.aa_201}
    Cabeçalho pedido: Selecionar profissional                ${profissional.LEMAT}
    Cabeçalho pedido: Selecionar unidade                     ${unidade.LA_FONTE}
    Cabeçalho pedido: Selecionar cliente                     ${cliente2Inclusive.codigoCliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${frete.CIF}
    Cabeçalho pedido: Selecionar Vertical                    ${vertical.residencial}
    # Cabeçalho pedido: Selecionar projeto                     ${projeto.aa_99}
    Cabeçalho: Selecionar projeto
    Cabeçalho: Preencher a descricao
    Produtos: Abrir dialog de busca de produtos
    Produtos: Buscar produto         95770028 
    Produtos: Confirmar produtos selecionados
    FOR    ${i}    IN RANGE   2
        Calcular imposto    
    END

Caso de teste T501
#Falta validar o passo 9 do caso de teste
    [Documentation]     Automação do caso de teste T501: https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T501
    [TAGS]        Pedidolog      T501   
    
    Realizar login    admin
    Iniciar um novo pedido quando menu recolhido
    Cabeçalho pedido: Selecionar estabelecimento             ${estabelecimento.aa_201}
    Cabeçalho pedido: Selecionar profissional                ${profissional.LEMAT}
    Cabeçalho pedido: Selecionar unidade                     ${unidade.LA_FONTE}
    Cabeçalho pedido: Selecionar cliente                     ${clienteConstrutora.codigoCliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${frete.CIF}
    Cabeçalho pedido: Selecionar Vertical                    ${vertical.residencial}
    Cabeçalho: Selecionar projeto
    Cabeçalho: Preencher a descricao
    Produtos: Abrir dialog de busca de produtos
    Produtos: Buscar produto         96164001-3    
    Produtos: Confirmar produtos selecionados
    FOR    ${i}    IN RANGE   300
        Clicar no botão Finalizar  
        Clicar Nao no dialog de finalização
    END

Teste 2 para o defeito 2957
    Realizar login    admin
    Iniciar um novo pedido quando menu recolhido
    Cabeçalho pedido: Selecionar estabelecimento             ${estabelecimento.aa_201}
    Cabeçalho pedido: Selecionar profissional                ${profissional.LEMAT}
    Cabeçalho pedido: Selecionar unidade                     ${unidade.LA_FONTE}
    Cabeçalho pedido: Selecionar cliente                     ${cliente2Inclusive.codigoCliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${frete.CIF}
    Cabeçalho pedido: Selecionar Vertical                    ${vertical.residencial}
    Cabeçalho: Selecionar projeto
    Cabeçalho: Preencher a descricao
    Produtos: Abrir dialog de busca de produtos
    Produtos: Buscar produto         95552008 
    Produtos: Confirmar produtos selecionados
    Calcular imposto
    FOR    ${i}    IN RANGE   40
    Novo Pedido
    Cabeçalho pedido: Selecionar estabelecimento             ${estabelecimento.aa_201}
    Cabeçalho pedido: Selecionar profissional                ${profissional.LEMAT}
    Cabeçalho pedido: Selecionar unidade                     ${unidade.LA_FONTE}
    Cabeçalho pedido: Selecionar cliente                     ${cliente2Inclusive.codigoCliente}
    Cabeçalho pedido: Selecionar Tipo de frete               ${frete.CIF}
    Cabeçalho pedido: Selecionar Vertical                    ${vertical.residencial}
    Cabeçalho: Selecionar projeto
    Cabeçalho: Preencher a descricao
    Produtos: Abrir dialog de busca de produtos
    Produtos: Buscar produto         95987008
    Produtos: Confirmar produtos selecionados
    Calcular imposto
    END