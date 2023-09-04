*** Settings ***
Documentation    Arquivo utilizado para armazenar os casos de testes relativos à listagem de pedidos na web.

Resource    ${EXECDIR}/resources/database/conectionDatabase.robot
Resource    ${EXECDIR}/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/pedido/listagemPedidoResources.robot

Suite Setup    Run Keywords    Conecta ao banco de dados    Abre Navegador    Realiza login na plataforma web
Suite Teardown    Run Keywords    Realizar logoff    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Filtrar pedido, editar e finalizar
    [Documentation]    DTSFASAPP-T705 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T705
    Acessar tela de listagem de pedidos
    ${numeroPedido}=    Retornar numero ultimo pedido NF
    Filtrar pedido por numero definido    ${numeroPedido}
    Editar pedido de venda    ${numeroPedido}
    Excluir itens originais e incluir novos
    Finalizar pedido de venda

Teste 002 ::: Filtrar pedido e finalizar na listagem
    [Documentation]    DTSFASAPP-T704 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T704 - Passo 4
    Acessar tela de listagem de pedidos
    ${numeroPedido}=    Retornar numero ultimo pedido NF
    Filtrar pedido por numero definido    ${numeroPedido}
    Finalizar pedido de venda na listagem    ${numeroPedido}

Teste 003 ::: Filtrar pedido e cancelar pela grid
    [Documentation]    DTSFASAPP-T704 (1.0): https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T704 - Passo 5
    Acessar tela de listagem de pedidos
    ${numeroPedido}=    Retornar numero ultimo pedido NF
    Filtrar pedido por numero definido    ${numeroPedido}
    Cancelar pedido de venda pela listagem    ${numeroPedido}

Teste 004 ::: Clonar pedido de venda
    [Documentation]    DTSFASAPP-T410 (1.0) : https://jiraproducao.totvs.com.br/secure/Tests.jspa#/testCase/DTSFASAPP-T410
    Acessar tela de listagem de pedidos
    ${numeroPedido}=    Retornar numero ultimo pedido
    Filtrar pedido por numero definido    ${numeroPedido}
    Clonar pedido de venda    ${numeroPedido}
    Verificar informações do pedido clonado    ${numeroPedido}