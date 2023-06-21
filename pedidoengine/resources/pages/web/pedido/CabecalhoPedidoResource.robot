*** Settings ***

Library     SeleniumLibrary
Library    String
Library    XML
Library    Screenshot
 
Resource    ../../../variables/web/pedido/pedidoVariables.robot
Resource    ../../../data/dados_cliente.robot


*** Keywords ***

Cabeçalho pedido: Selecionar estabelecimento 
    [Arguments]    ${ESTABELECIMENTO_SELECIONADO}

    Wait Until Page Contains Element       id=${cabecalho.comboEstabelecimento}    timeout=90
    Press Keys          id=${cabecalho.comboEstabelecimento}    ${ESTABELECIMENTO_SELECIONADO}
    Sleep   0.2s
    ${ELEMENTO_FORMATADO}       Format String       ${cabecalho.estabelecimento}     Estabelecimento=${ESTABELECIMENTO_SELECIONADO}        
    Click Element       ${ELEMENTO_FORMATADO}  
    Sleep   5s

Cabeçalho pedido: Selecionar profissional 
    [Arguments]    ${PROFISSIONAL_SELECIONADO}

    Aguardar dialog de carregando sumir
    Press Keys      id=${cabecalho.comboProfissional}      ${PROFISSIONAL_SELECIONADO}
    ${ELEMENTO_FORMATADO}       Format String       ${cabecalho.profissional}       Profissional=${PROFISSIONAL_SELECIONADO}     
    Click Element    ${ELEMENTO_FORMATADO}
   
Cabeçalho pedido: Selecionar unidade 
    [Arguments]    ${UNIDADE_SELECIONADA}

    Click Element     id=${cabecalho.comboUnidade}
    ${ELEMENTO_FORMATADO}       Format String       ${cabecalho.unidade}     Unidade=${UNIDADE_SELECIONADA}
    Click Element     ${ELEMENTO_FORMATADO}
    Sleep             0.5s

Cabeçalho pedido: Selecionar cliente 
   [Arguments]    ${CLIENTE_SELECIONADO}

    Set Selenium Speed    2s
    Take Screenshot
    Click Element   xpath=${cabecalho.lupaCliente}
    Take Screenshot
    Press Keys      id=${cabecalho.campoPesquisaRapidaCliente}    ${CLIENTE_SELECIONADO}
    Press Keys      id=${cabecalho.campoPesquisaRapidaCliente}    ENTER
    Aguardar dialog de carregando sumir

Validar posicao e selecionar icone cliente
   Sleep   0.5s
   Page Should Contain Image   xpath=${iconeCliente.icone}
   Click Element    xpath=${iconeCliente.icone}


Aguardar dialog de carregando sumir 
    Wait Until Page Does Not Contain Element    ${dialogCarregando}    timeout=60s


Validar informacoes no icone cliente

    Element Should Contain   xpath=${iconeCliente.informacaoTituloCliente}  Informações do cliente
    Element Should Contain   xpath=${iconeCliente.cliente}  Cliente:
    Element Should Contain   xpath=${iconeCliente.informacaoCliente}   ${clienteVidroBox.nomeCliente} 
    Element Should Contain   xpath=${iconeCliente.nomeFantasia}  Nome fantasia:
    Element Should Contain   xpath=${iconeCliente.informacaoNomeFantasia}  ${clienteVidroBox.nomeFantasia}  
    Element Should Contain   xpath=${iconeCliente.tipoPessoa}   Tipo de pessoa:
    Element Should Contain   xpath=${iconeCliente.informacaoTipoPessoa}   ${clienteVidroBox.tipoPessoa} 
    Element Should Contain   xpath=${iconeCliente.cnpj}  CNPJ:
    Element Should Contain   xpath=${iconeCliente.informacaoCnpj}    ${clienteVidroBox.cnpj}
    Element Should Contain   xpath=${iconeCliente.IE}  Inscrição estadual:
    Element Should Contain   xpath=${iconeCliente.informacaoIE}    ${clienteVidroBox.IE}
    Element Should Contain   xpath=${iconeCliente.grupoCliente}     Grupo de cliente:
    Element Should Contain   xpath=${iconeCliente.informacaoGrupoCliente}  ${clienteVidroBox.grupoCliente}
    Element Should Contain   xpath=${iconeCliente.canalVenda}  Canal de vendas:
    Element Should Contain   xpath=${iconeCliente.informacaoCanalVenda}  ${clienteVidroBox.canalVenda} 
    Element Should Contain   xpath=${iconeCliente.localEntrega}   Local de entrega:
    Element Should Contain   xpath=${iconeCliente.informacaoLocalEntrega}    ${iconeCliente.vazio}
    Element Should Contain   xpath=${iconeCliente.transportadora}  Transportadora:
    Element Should Contain   xpath=${iconeCliente.informacaoTransportadora}  ${clienteVidroBox.transportadora} 
    Element Should Contain   xpath=${iconeCliente.telefone}  Telefone:
    Element Should Contain   xpath=${iconeCliente.informacaoTelefone}    ${clienteVidroBox.telefone} 
    Element Should Contain   xpath=${iconeCliente.email}  E-mail:
    Element Should Contain   xpath=${iconeCliente.informacaoEmail}    ${clienteVidroBox.email} 


Validar informacoes no icone cliente pedido ${PEDIDO}

    Element Should Contain   xpath=${iconeCliente.informacaoTituloCliente}  Informações do cliente
    Element Should Contain   xpath=${iconeCliente.cliente}  Cliente:
    Element Should Contain   xpath=${iconeCliente.informacaoCliente}   ${clienteDMADEIRAS.nomeCliente} 
    Element Should Contain   xpath=${iconeCliente.nomeFantasia}  Nome fantasia:
    Element Should Contain   xpath=${iconeCliente.informacaoNomeFantasia}  ${clienteDMADEIRAS.nomeFantasia}  
    Element Should Contain   xpath=${iconeCliente.tipoPessoa}   Tipo de pessoa:
    Element Should Contain   xpath=${iconeCliente.informacaoTipoPessoa}   ${clienteDMADEIRAS.tipoPessoa} 
    Element Should Contain   xpath=${iconeCliente.cnpj}  CNPJ:
    Element Should Contain   xpath=${iconeCliente.informacaoCnpj}    ${clienteDMADEIRAS.cnpj}
    Element Should Contain   xpath=${iconeCliente.IE}  Inscrição estadual:
    Element Should Contain   xpath=${iconeCliente.informacaoIE}    ${clienteDMADEIRAS.IE}
    Element Should Contain   xpath=${iconeCliente.grupoCliente}    Grupo de cliente:
    Element Should Contain   xpath=${iconeCliente.informacaoGrupoCliente}   ${clienteDMADEIRAS.grupoCliente}
    Element Should Contain   xpath=${iconeCliente.canalVenda}  Canal de vendas:
    Element Should Contain   xpath=${iconeCliente.informacaoCanalVenda}  ${clienteDMADEIRAS.canalVenda} 
    Element Should Contain   xpath=${iconeCliente.localEntrega}   Local de entrega:
    Element Should Contain   xpath=${iconeCliente.informacaoLocalEntrega}    ${iconeCliente.vazio}
    Element Should Contain   xpath=${iconeCliente.transportadora}  Transportadora:
    Element Should Contain   xpath=${iconeCliente.informacaoTransportadora}  ${clienteDMADEIRAS.transportadora} 
    Element Should Contain   xpath=${iconeCliente.telefone}  Telefone:
    Element Should Contain   xpath=${iconeCliente.informacaoTelefone}    ${clienteDMADEIRAS.telefone} 
    Element Should Contain   xpath=${iconeCliente.email}  E-mail:
    Element Should Contain   xpath=${iconeCliente.informacaoEmail}    ${clienteDMADEIRAS.email} 




Cabeçalho pedido: Selecionar Tipo de frete 
   [Arguments]    ${TIPO_FRETE_SELECIONADO}
    # Set Selenium Speed    2s
    Aguardar dialog de carregando sumir
    Click Element       id=${cabecalho.comboTipoFrete}
    ${ELEMENTO_FORMATADO}       Format String       ${cabecalho.tipoFrete}    Frete=${TIPO_FRETE_SELECIONADO}
    Click Element       ${ELEMENTO_FORMATADO}
    Sleep               3s

Cabeçalho pedido: Selecionar Vertical 
   [Arguments]    ${VERTICAL_SELECIONADA}

    Click Element       id=${cabecalho.comboVertical}
    ${ELEMENTO_FORMATADO}       Format String       ${cabecalho.vertical}     Vertical=${VERTICAL_SELECIONADA}
    Click Element       ${ELEMENTO_FORMATADO}
    Sleep               4s

Cabeçalho: Replicar desconto 
    [Arguments]        ${DESCONTO}
    Click Element        ${cabecalho.campoReplicarDesconto}    
    Press keys           ${cabecalho.campoReplicarDesconto}    ${DESCONTO}
    Click Element        ${cabecalho.btnAplicarDesconto}
    # Wait Until Page Contains Element       ${cabecalho.btnSimDesconto}    timeout=15s
    Click Button        ${cabecalho.btnSimDesconto}

Cabeçalho: Clicar no botão Pesquisar
     Click Element     ${cabecalho.btnPesquisaProjetos}

Cabeçalho: Selecionar projeto
    Set Selenium Speed    2s
    Cabeçalho: Clicar no botão Pesquisar    
    Click Element     ${cabecalho.primeiroProjetoGrid}
    Click Element     ${cabecalho.btnConfirmar}

Cabeçalho: Preencher a descricao
     Set Selenium Speed    2s
     Click Element    ${cabecalho.campoDescricaoProjeto}
     Press Keys          ${cabecalho.campoDescricaoProjeto}         TESTE DESCRICAO