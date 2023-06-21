*** Settings ***

Library     SeleniumLibrary
Library    String
 
Resource    ../../variables/web/globalVariables.robot
Resource    ../../variables/web/menuLateralVariables.robot
Resource    ../../variables/web/pedidoVariables.robot

*** Keywords ***
Entrar em vendas
    Set Selenium Speed    2s

    Wait Until Page Contains Element       ${venda.menu_venda}    timeout=50

    Click Element   ${venda.menu_venda}

    Click Element   ${venda.menu_pedido}

    Click Element   ${venda.pedido_novo}

Novo Pedido
   Click Element   ${venda.pedido_novo}
   Sleep   2s
Cabeçalho pedido: Selecionar estabelecimento 
    [Arguments]    ${ESTABELECIMENTO SELECIONADO}

    Wait Until Page Contains Element       id=${cabecalho.combo_estabelecimento}    timeout=90

    Click Element       ${cabecalho.combo_estabelecimento}

    Press Keys      id=${cabecalho.combo_estabelecimento}   ${ESTABELECIMENTO SELECIONADO}

    Sleep   0.2s

    ${ELEMENTO FORMATADO}       Format String       ${cabecalho.estabelecimento}     Estabelecimento=${ESTABELECIMENTO SELECIONADO}        

    Click Element     ${ELEMENTO FORMATADO}  

   #voltar para 5S
    Sleep   5s

Cabeçalho pedido: Selecionar profissional 
    [Arguments]    ${PROFISSIONAL SELECIONADO}

    Click Element   id=${cabecalho.combo_profissional}

    Press Keys   id=${cabecalho.combo_profissional}      ${PROFISSIONAL SELECIONADO}

    ${ELEMENTO FORMATADO}       Format String       ${cabecalho.profissional}     Profissional=${PROFISSIONAL SELECIONADO}     

    Click Element    ${ELEMENTO FORMATADO}
   
Cabeçalho pedido: Selecionar unidade 
    [Arguments]    ${UNIDADE SELECIONADA}

    Click Element   id=${cabecalho.combo_unidade}

    ${ELEMENTO FORMATADO}       Format String       ${cabecalho.unidade}     Unidade=${UNIDADE SELECIONADA}

    Click Element   ${ELEMENTO FORMATADO}

    Sleep   0.5s

Cabeçalho pedido: Selecionar cliente 
   [Arguments]    ${CLIENTE SELECIONADO}
    Set Selenium Speed    2s

    Click Element   xpath=${cabecalho.lupa_cliente}

    Press Keys  id=${cabecalho.campo_pesquisa_rapida}    ${CLIENTE SELECIONADO}

    Press Keys    id=${cabecalho.campo_pesquisa_rapida}    ENTER

    Sleep       15s

Cabeçalho pedido: Selecionar Tipo de frete 
   [Arguments]    ${TIPO FRETE SELECIONADO}

    Click Element   id=${cabecalho.combo_tipo_frete}

    ${ELEMENTO FORMATADO}       Format String       ${cabecalho.tipo_frete}    Frete=${TIPO FRETE SELECIONADO}

    Click Element   ${ELEMENTO FORMATADO}

    Sleep   3s

Cabeçalho pedido: Selecionar Vertical 
   [Arguments]    ${VERTICAL SELECIONADA}

    Click Element   id=${cabecalho.combo_vertical}

    ${ELEMENTO FORMATADO}       Format String       ${cabecalho.vertical}     Vertical=${VERTICAL SELECIONADA}

    Click Element   ${ELEMENTO FORMATADO}

    Sleep   4s

Produtos: Abrir dialog de busca de produtos

    Scroll Element Into View    xpath=${grid_produto.primeira_coluna}

    Sleep   1s

    Click Element   xpath=${grid_produto.primeira_coluna}

    Sleep   0.5s

    Click Element   xpath=${grid_produto.lupa}

Produtos: Selecionar na lupa da cesta 

    Click Element   xpath=${cesta.cesta_lupa}
    Sleep   0.5s
Produtos: Adicionar apenas produto "${PRODUTO}"

    Produtos: Buscar produto "${PRODUTO}"
    
    Click Element   id=${dialog_busca_produto.btn_adicionar}


Produtos: Adicionar produto "${PRODUTO}" com preço "${NOVO PRECO}" e com quantidade "${NOVA QNTD}"
    
    Produtos: Buscar produto "${PRODUTO}"

    Produtos: Alterar quantidade para "${NOVA QNTD}" 
    
    Alterar preco para "${NOVO PRECO}"
    
    Click Element   id=${dialog_busca_produto.btn_adicionar}


Produtos: Adicionar produto "${PRODUTO}" com quantidade "${NOVA QNTD}" 

    Produtos: Buscar produto "${PRODUTO}"

    Produtos: Alterar quantidade para "${NOVA QNTD}" 
    
    Click Element   id=${dialog_busca_produto.btn_adicionar}


Produtos: Adicionar produto "${PRODUTO}" e alterar preço para "${NOVO PRECO}"
    Produtos: Buscar produto "${PRODUTO}"
    
    Alterar preco para "${NOVO PRECO}"
    
    Click Element   id=${dialog_busca_produto.btn_adicionar}

Produtos: Buscar produto "${PRODUTO}"
    Set Selenium Speed    2s

    Wait Until Page Contains Element       xpath=${dialog_busca_produto.listagem}    timeout=50

    Clear Element Text    id=${dialog_busca_produto.campo_codigo} 

    Press Keys        id=${dialog_busca_produto.campo_codigo}        ${PRODUTO}

    Click Element    xpath=${dialog_busca_produto.btn_pesquisar}

    Click Element   xpath=${dialog_busca_produto.produto}

    Sleep   0.2s

Produtos: Buscar produto pelo dialog da cesta ${PRODUTO}
    Set Selenium Speed    2s

    Wait Until Page Contains Element       xpath=${dialog_busca_produto.listagem}    timeout=50

    Clear Element Text   id=${dialog_busca_produto.campo_codigo} 

    Press Keys        id=${dialog_busca_produto.campo_codigo}        ${PRODUTO}

    Click Element    xpath=${dialog_busca_produto.btn_pesquisar}

    Click Element   xpath=${dialog_busca_produto.selecionar_primeiro_produto_cesta}

    Sleep   0.2s  

Produtos: Buscar produto por descricao ${PRODUTO}
    Set Selenium Speed    2s

    Wait Until Page Contains Element       xpath=${dialog_busca_produto.listagem}    timeout=50

    Clear Element Text   xpath=${dialog_busca_produto.campo_descricao} 

    Press Keys        xpath=${dialog_busca_produto.campo_descricao}        ${PRODUTO}

    Click Element    xpath=${dialog_busca_produto.btn_pesquisar}

    Click Element   xpath=${dialog_busca_produto.selecionar_produto_cesta2}

    Sleep   0.2s  
Produtos: Alterar quantidade para "${NOVA QNTD}"
    Set Selenium Speed    2s

    Press Keys    ${dialog_busca_produto.qntd}    ${NOVA QNTD}

    Press Keys    ${dialog_busca_produto.qntd}    ENTER

Alterar preco para "${PRECO}" 
    Set Selenium Speed    2s

    Press Keys    ${dialog_busca_produto.preco_venda}    ${PRECO}

    Press Keys    ${dialog_busca_produto.preco_venda}    ENTER


Confirmar produtos da cesta
    Click Element   ${cesta.cesta_confimar}
    Wait Until Page Does Not Contain    ${cesta.cesta_confimar}      timeout=25s

Selecionar no icone de imposto do produto configurado quando impostos nao estao calculados 
    Sleep   0.3s
    Scroll Element Into View    xpath=${icone_imposto.selecionar_icone_imposto_produto2}
    Click Element    xpath=${icone_imposto.selecionar_icone_imposto_produto2}
    Wait Until Page Does Not Contain    ${icone_imposto.selecionar_icone_imposto_produto2}      timeout=5s
    Element Should Not Contain    xpath=${validar.sem_impostos}    NATUREZA DA OPERAÇÃO
    Element Should Not Contain    xpath=${validar.sem_impostos}    VALOR TOTAL

Selecionar no icone de impostos no resumo quando falta calculo de imposto em algum produto
    Sleep  0.2s
    Click Element    id=${icone_imposto.selecionar_icone_imposto_resumo}
    Wait Until Page Does Not Contain    id=${icone_imposto.selecionar_icone_imposto_resumo}      timeout=5s
    Element Should Not Contain    xpath=${validar.sem_impostos}    NATUREZA DA OPERAÇÃO
    Clicar em atualizar
    Validar mensagem para configurar os produtos
    Clicar em ok
    Selecionar em voltar

Clicar em atualizar 
    Click Element      ${icone_imposto.btn_atualizar_impostos}   
    Wait Until Page Does Not Contain     ${icone_imposto.btn_atualizar_impostos}     timeout=20s
Selecionar em voltar
   Click Element      ${icone_imposto.btn_voltar}

Selecionar relatorio
    Scroll Element Into View    xpath=${relatorio.selecionar_btn_relatorio}
    Click Element  xpath=${relatorio.selecionar_btn_relatorio}
    Wait Until Page Does Not Contain    ${relatorio.selecionar_btn_relatorio}      timeout=25s

Validar mensagem para configurar os produtos 
   ${dialogVisivel}    Run Keyword And Return Status    Element Should Be Visible   xpath=${validar.txt_informacao_produto_configurado}
   Run Keyword If    ${dialogVisivel}     Validar mensagem para configurar os produtos 
   
Clicar em ok  
   Click Element   xpath=${validar.btn_ok}

Validar cor do icone de impostos 
    Sleep   0.3s
    Scroll Element Into View         xpath=${icone_imposto.selecionar_icone_imposto_produto2}
    Page Should Contain Image        xpath=${icone_imposto.icone_calculado}
    Page Should Contain Image        xpath=${icone_imposto.icone_nao_calculado}

Selecionar email
   Click Element   xpath=${email.selecionar_btn_email}
   Sleep   0.3s
Selecionar em Finalizar
   Click Element    id=${finalizacao.btn_finalizar}
   Sleep   0.3s
Selecionar gerar pedido
   Click Element    id=${finalizacao.btn_gerar_pedido}
   Sleep   0.3s
Produtos: Confirmar produtos selecionados
    Click Element    id=${finalizacao.btn_confirmar}


Entrega: Preencher entrega
    Scroll Element Into View    id=${entrega.campo_transportadora}

    Sleep   3s

    Click Element   id=${entrega.combo_transportadora}

    Click Element   ${entrega.opcao_transporte}

    Sleep   10s

    Press Keys      ${entrega.valor_frete}       10,00

Complemento: Preencher complemento
    Scroll Element Into View    ${complemento.obs_pedido}

    Press Keys      ${complemento.obs_pedido}       Primeiro pedido automatizado

Calcular imposto
    Click Element    ${finalizacao.btn_calcular_imposto} 

     Wait Until Page Does Not Contain    ${finalizacao.btn_calcular_imposto}      timeout=40s
     Sleep   1s
Clicar no botão gerar pedido
    [Arguments]    ${msg_aprovacao}=${None}

    Click Element    id=${finalizacao.btn_gerar_pedido}

    Sleep   2s

    Se tiver mensagem de aprovação clicar em sim no dialog de aprovação de pedido    ${msg_aprovacao}

    Validar se tem dialog de finalização de pedido e clicar em sim

    Separar numero pedido

    ${NUMERO PEDIDO FINAL}    Catenate    PPED${NUMERO PEDIDO FINAL}   

    Set Suite Variable    ${NUMERO PEDIDO FINAL}

    Wait Until Page Contains Element    xpath=${venda.menu_venda}     timeout=25s

    Click Element    ${venda.menu_venda}

Se tiver mensagem de aprovação clicar em sim no dialog de aprovação de pedido
    [Arguments]    ${msg_aprovacao}=${None}

    Run Keyword If    "${msg_aprovacao}" != "${None}"     Clicar Sim no dialog de aprovação    ${msg_aprovacao}


Validar se tem dialog de finalização de pedido e clicar em sim 
    ${dialogVisivel}    Run Keyword And Return Status    Element Should Be Visible   xpath=${dialog_finalizacao.txt_informacao}

    Run Keyword If    ${dialogVisivel}     Clicar Sim no dialog de finalização 


Gravar pedido
    Sleep    2s

    Click Element    id=${finalizacao.btn_gravar}

    Sleep    5s
    
Finalizar pedido sem aprovação

    Scroll Element Into View    id=${finalizacao.btn_finalizar}

    Sleep   1s

    Click Element    id=${finalizacao.btn_finalizar}

    Clicar Sim no dialog de finalização

    Sleep   1.5s

    Click Element    ${venda.menu_venda}

    Separar numero pedido

Finalizar pedido com aprovação
    [Arguments]        ${msg_aprovacao}

    Set Selenium Speed    1s

    Scroll Element Into View    id=${finalizacao.btn_finalizar}

    Click Element    id=${finalizacao.btn_finalizar}

    Clicar Sim no dialog de aprovação    ${msg_aprovacao}

    Clicar Sim no dialog de finalização
    
    Wait Until Page Contains    ${venda.menu_venda}    timeout=40s

    Click Element    ${venda.menu_venda}

    Separar numero pedido



Clicar Sim no dialog de finalização
    Wait Until Page Contains Element    xpath=${dialog_finalizacao.btn_sim}     timeout=25s

    #Element Should Contain    ${DIALOG CONFIRMACAO PEDIDO}    ${TEXTO CONFIRMACAO DE PEDIDO} 

    Sleep   0.5s

    Click Element   xpath=${dialog_finalizacao.btn_sim}


Clicar Sim no dialog de aprovação
    [Arguments]        ${msg_aprovacao}

    Wait Until Page Contains Element    xpath=${dialog_finalizacao.btn_sim}     timeout=25s

    Element Should Contain    ${dialog_aprovacao.txt_informacao}    ${msg_aprovacao} 

    Click Element   xpath=${dialog_aprovacao.btn_sim}

Separar numero pedido

    ${NUMERO PEDIDO}=        Get Text             ${NUMERO PEDIDO}  

    ${NUMERO PEDIDO}=        Remove String        ${NUMERO PEDIDO}  [Pedido 

    ${NUMERO PEDIDO}=        Remove String        ${NUMERO PEDIDO}  ]

    ${NUMERO PEDIDO FINAL}=     Remove String        ${NUMERO PEDIDO}     ${SPACE}

    ${NUMERO PEDIDO FINAL}=     Get Substring    ${NUMERO PEDIDO FINAL}     5
    Log    ${NUMERO PEDIDO}

    Set Suite Variable    ${NUMERO PEDIDO FINAL}


    


