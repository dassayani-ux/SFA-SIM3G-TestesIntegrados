*** Settings ***
Documentation    Arquivo destinado a armazenar keywords utilizadas em testes envolvendo cadastro de pedidos no ambiente Mobile.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/data/local/dataLocal.robot
Resource    ${EXECDIR}/resources/data/pedido/dataPedido.robot
Resource    ${EXECDIR}/resources/data/produto/dataProduto.robot
Resource    ${EXECDIR}/resources/data/cliente/dataCliente.robot
Resource    ${EXECDIR}/resources/locators/android/pedido/cadastroPedidoAndroidLocators.robot
Resource    ${EXECDIR}/resources/variables/android/pedido/cadastroPedidoAndroidVariables.robot

*** Keywords ***
Preencher cabecalho pedido - Android
    [Documentation]    Utilizada para preencher o cabeçalho de um pedido no Android.
    Preencher tabela de preco cabecalho - Android
    Preencher condicao pagamento cabecalho - Android
    Preencher data vencimento cabecalho - Android
    Preencher safra cabecalho - Android
    Popular dicionario de dados do pedido

Preencher tabela de preco cabecalho - Android
    [Documentation]    Utilizada para preencher o campo de tabela de preço no cabeçalho de pedido Android.
    [Tags]    Cabecalho-Pedido-Android

    AppiumLibrary.Click Element    xpath=${cabecalhoPedidoAndroid.comboboxTabelaPreco}
    AppiumLibrary.Wait Until Element Is Visible    id=${popUpOpcoesCombo.idPopUp}
    ${countOpcoes}=    AppiumLibrary.Get Matching Xpath Count    ${popUpOpcoesCombo.opcoesDisponiveis}
    IF  ${countOpcoes} == ${1}
        BuiltIn.Fail    Não há tabela de preço disponível para seleção.
    ELSE IF  ${countOpcoes} == ${2}
        ${opcao}=    BuiltIn.Set Variable    2
    ELSE
        ${opcao}=    BuiltIn.Evaluate    random.randint(2, ${countOpcoes})    random
    END
    ${xpath}    BuiltIn.Set Variable
    ${xpath}    BuiltIn.Catenate    ${popUpOpcoesCombo.opcoesDisponiveis}    [${opcao}]
    AppiumLibrary.Click Element    xpath=${xpath}
    ${tabelaPreco}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxTabelaPreco}
    BuiltIn.Log To Console    Tabela de preço selecionada: ${tabelaPreco}

Preencher condicao pagamento cabecalho - Android
    [Documentation]    Utilizada para preencher o campo de condição de pagamento no cabeçalho de pedido Android.
    [Tags]    Cabecalho-Pedido-Android

    AppiumLibrary.Click Element    xpath=${cabecalhoPedidoAndroid.comboboxCondicaoPagamento}
    AppiumLibrary.Wait Until Element Is Visible    id=${popUpOpcoesCombo.idPopUp}
    ${countOpcoes}=    AppiumLibrary.Get Matching Xpath Count    ${popUpOpcoesCombo.opcoesDisponiveis}
    IF  ${countOpcoes} == ${1}
        BuiltIn.Fail    Não há condição de pagamento disponível para seleção.
    ELSE IF  ${countOpcoes} == ${2}
        ${opcao}=    BuiltIn.Set Variable    2
    ELSE
        ${opcao}=    BuiltIn.Evaluate    random.randint(2, ${countOpcoes})    random
    END
    ${xpath}    BuiltIn.Set Variable
    ${xpath}    BuiltIn.Catenate    ${popUpOpcoesCombo.opcoesDisponiveis}    [${opcao}]
    AppiumLibrary.Click Element    xpath=${xpath}
    ${condicaoPagamento}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxCondicaoPagamento}
    BuiltIn.Log To Console    Condição de pagamento selecionada: ${condicaoPagamento}

Preencher data vencimento cabecalho - Android
    [Documentation]    Utilizada para preencher o campo de data de vencimento no cabeçalho de pedido Android.
    [Tags]    Cabecalho-Pedido-Android

    ${currentdate}=    DateTIme.Get Current Date    result_format=%d-%m-%Y
    AppiumLibrary.Click Element    xpath=${cabecalhoPedidoAndroid.campoDataVencimento}
    AppiumLibrary.Wait Until Element Is Visible    id=${cabecalhoPedidoAndroid.btnDefinirDataVencimento}
    AppiumLibrary.Click Element    id=${cabecalhoPedidoAndroid.btnDefinirDataVencimento}

Preencher safra cabecalho - Android
    [Documentation]    Utilizada para preencher o campo de safra no cabeçalho de pedido Android.
    [Tags]    Cabecalho-Pedido-Android

    ${height}=    AppiumLibrary.Get Window Height
    IF  ${height} <= ${800}
        ${cabecalhoPedidoAndroid.comboboxSafra}    BuiltIn.Set Variable    ${cabecalhoPedidoAndroid.comboboxSafraTelaMenor}

        Rolar tela
    END

    AppiumLibrary.Click Element    xpath=${cabecalhoPedidoAndroid.comboboxSafra}
    AppiumLibrary.Wait Until Element Is Visible    id=${popUpOpcoesCombo.idPopUp}
    ${countOpcoes}=    AppiumLibrary.Get Matching Xpath Count    ${popUpOpcoesCombo.opcoesDisponiveis}
    IF  ${countOpcoes} == ${1}
        BuiltIn.Fail    Não há safra disponível para seleção.
    ELSE IF  ${countOpcoes} == ${2}
        ${opcao}=    BuiltIn.Set Variable    2
    ELSE
        ${opcao}=    BuiltIn.Evaluate    random.randint(2, ${countOpcoes})    random
    END
    ${xpath}    BuiltIn.Set Variable
    ${xpath}    BuiltIn.Catenate    ${popUpOpcoesCombo.opcoesDisponiveis}    [${opcao}]
    AppiumLibrary.Click Element    xpath=${xpath}
    AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=60s
    ${safra}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxSafra}
    BuiltIn.Log To Console    Safra selecionada: ${safra}
    
    IF  ${height} <= ${800}
        Rolar tela    direction=up
    END

Popular dicionario de dados do pedido
    [Documentation]    Utilizada para preencher o dicinário de dados do pedido Android, cujo o qual será utilizado em keywords.
    [Arguments]    ${clone}=False

    # Se caso se tratar de clonagem de pedido, irá preecher o parceiro aqui com base no que é exibido em tela
    IF  '${clone}' == '${True}'
        ${txtNomeParceiro}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.nomeParceiro}
        ${dadosPedidoAndroid.idParceiro}=    Retorna idparceiro    nomeParceiro=${txtNomeParceiro}
    END

    # Número pedido {
    ${txtCabecalhoPedidoNumeroPedido}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.numeroPedido}
    ${finalNumeroPedido}=    String.Remove String    ${txtCabecalhoPedidoNumeroPedido}    Pedido
    ${dadosPedidoAndroid.numeroPedido}=    BuiltIn.Set Variable    ${finalNumeroPedido}
    # }

    # LOCAL {
    ${txtCabecalhoPedidoLocal}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxLocal}
    ${dadosPedidoAndroid.idLocalParceiro}=    Retorna idlocal    descricao=${txtCabecalhoPedidoLocal}    parceiro=${dadosPedidoAndroid.idParceiro}
    # }

    # Filial {
    ${txtCabecalhoPedidoFilial}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxFilial}
    ${dadosPedidoAndroid.idLocalFilial}=    Retorna idLocalFilial    ${txtCabecalhoPedidoFilial}
    # }

    # Tipo pedido {
    ${txtCabecalhoPedidoTipoPedido}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxTipoPedido}
    ${dadosPedidoAndroid.idTipoPedido}=    Retorna idTipoPedido    ${txtCabecalhoPedidoTipoPedido}
    # }

    # Tabela de preço {
    ${txtCabecalhoPedidoTabelaPreco}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxTabelaPreco}
    ${dadosPedidoAndroid.idTabelaPreco}=    Retorna idTabelaPreco    ${txtCabecalhoPedidoTabelaPreco}
    # }

    # Condição de pagamento {
    ${txtCabecalhoPedidoCondicaoPagamento}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxCondicaoPagamento}
    ${dadosPedidoAndroid.idCondicaoPagamento}=    Retorna idCondicaoPagamento    ${txtCabecalhoPedidoCondicaoPagamento}
    #  }

Incluir produtos no pedido - Android
    [Documentation]    Utilizada para incluir produtos no pedido Android.
    ...    \nO argumento *${quantidadeItensProdutos}* define quantos produtos serão inclusos no pedido.
    ...    \nO argumento *${quantidadeMaxima}* define qual a quantidade máxima para os itens.
    [Arguments]    ${quantidadeItensProdutos}=${2}    ${quantidadeMaxima}=${100}

    #Limpando lista de dicionários de produtos
    sfa_lib_mobile.Limpar listas    ${dados_produtos_pedido}

    # Setando para 0 para que bata os valores quando se tratar de inclusao de itens durante uma edicao de pedido de venda.
    ${dadosPedidoAndroid.quantidadeProdutosPedido}=    BuiltIn.Set Variable    ${0}
    ${dadosPedidoAndroid.quantidadeItensPedido}=    BuiltIn.Set Variable    ${0}
    ${dadosPedidoAndroid.valorTotalPedido}=    BuiltIn.Set Variable    ${0}

    ${dadosPedidoAndroid.quantidadeProdutosPedido}=    BuiltIn.Set Variable    ${quantidadeItensProdutos}
    BuiltIn.Sleep   1s
    ${countProdutosTabela}=    Retorna quantidade de itens da tabela    ${dadosPedidoAndroid.idTabelaPreco}
    ${randomProdutos}=    Evaluate    random.sample(range(0, ${countProdutosTabela}), ${quantidadeItensProdutos})    random
    ${produtos}=    Retorna produtos    @{randomProdutos}    tabelaPreco=${dadosPedidoAndroid.idTabelaPreco}
    Log To Console    Produtos selecionados: ${produtos}

    FOR  ${IP}  IN RANGE    ${quantidadeItensProdutos}
        AppiumLibrary.Input Text    class=${guiaProdutoPedidoAndroid.campoPesquisa}    ${produtos[${IP}]}
        BuiltIn.Sleep    1s
        AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=60s
        AppiumLibrary.Wait Until Element Is Visible    xpath=${cardProdutoListagem.expandirCard}    timeout=60s
        AppiumLibrary.Click Element    xpath=${cardProdutoListagem.expandirCard}
        ${precoProdutoDB}=    Retornar preco de tabela do produto    tabelaPreco=${dadosPedidoAndroid.idTabelaPreco}    codigoProduto=${produtos[${IP}]}
        BuiltIn.Log To Console    Preço para o produto de código ${produtos[${IP}]} = R$${precoProdutoDB}
        ${precoProduto}=    sfa_lib_mobile.Formatar valor monetario    ${precoProdutoDB}
        ${getPrecoVendaCard}=    AppiumLibrary.Get Text    xpath=${cardProdutoListagem.precoVenda}
        ${precoVendaCard}=    sfa_lib_mobile.Formatar valor monetario    ${getPrecoVendaCard}

        IF  '${precoProduto}' == '${precoVendaCard}'
            BuiltIn.Log To Console    Preço apresentado em tela está de acordo.
        ELSE
            BuiltIn.Log To Console    Preço apresentado em tela está divergente. R$(${precoVendaCard})
            BuiltIn.Fail
        END

        ${qtdApresentacao}=    Retornar quantidade apresentacao produto    codigoProduto=${produtos[${IP}]}
        ${qtdApresentacao}=    BuiltIn.Convert To Integer    ${qtdApresentacao}     
        IF  ${qtdApresentacao} == ${0}    # Se a quantidade de apresentação for 0 irá utilizar como 1.
            ${qtdApresentacao}=    BuiltIn.Set Variable    ${1}
            ${qtdApresentacao}=    BuiltIn.Convert To Integer    ${qtdApresentacao}
        END
        
        IF  ${qtdApresentacao} > ${quantidadeMaxima}
            ${qtde}=    BuiltIn.Set Variable    ${qtdApresentacao}
        ELSE
            #Randomiza a quantidade em um intervalo de 1 a ${quantidadeMaxima}, desde que a quantidade seja múltipla da quantidade de apresentação.
            ${qtde}=    Evaluate    round(random.randint(1, round(${quantidadeMaxima}/${qtdApresentacao})) * ${qtdApresentacao})    random
        END

        ${dadosPedidoAndroid.quantidadeItensPedido}    BuiltIn.Evaluate    ${dadosPedidoAndroid.quantidadeItensPedido} + ${qtde}
        ${qtde}=    BuiltIn.Convert To String    ${qtde}
        BuiltIn.Log To Console    Quantidade sorteada para o produto ${produtos[${IP}]} = ${qtde}
        ${lenQtd}=    BuiltIn.Get Length    ${qtde}
        AppiumLibrary.Wait Until Element Is Visible    xpath=${cardProdutoListagem.btnCampoQuantidade}
        AppiumLibrary.Click Element    xpath=${cardProdutoListagem.btnCampoQuantidade}
        AppiumLibrary.Wait Until Element Is Visible    xpath=${cardProdutoListagem.inputCampoQuantidade}
        FOR  ${I}  IN RANGE    ${lenQtd}
            AppiumLibrary.Click Element    id=${tecladoQuantidade.prefixoNumeros}${qtde[${I}]}
        END
        AppiumLibrary.Click Element    id=${cardProdutoListagem.btnConfirmarQuantidade}
        AppiumLibrary.Wait Until Element Is Visible    class=${guiaProdutoPedidoAndroid.campoPesquisa}    timeout=60s
        ${precoProdutoSemRound}    Retornar preco de tabela do produto    tabelaPreco=${dadosPedidoAndroid.idTabelaPreco}    codigoProduto=${produtos[${IP}]}    roundConfig=0
        ${casasDecimais}=    sfa_lib_mobile.Retornar casas decimais valores monetarios
        ${valorTotalItemCalculado}=    BuiltIn.Evaluate    round(${precoProdutoSemRound}*${qtde}, ${casasDecimais})
        ${valorTotalItemCalculado}=    BuiltIn.Evaluate    "{:.${casasDecimais}f}".format(${valorTotalItemCalculado})
        ${dadosPedidoAndroid.valorTotalPedido}=    BuiltIn.Evaluate    ${dadosPedidoAndroid.valorTotalPedido} + ${valorTotalItemCalculado}
        ${dadosPedidoAndroid.valorTotalPedido}=    BuiltIn.Evaluate    round(${dadosPedidoAndroid.valorTotalPedido}, ${casasDecimais})
        ${dadosPedidoAndroid.valorTotalPedido}=    BuiltIn.Evaluate    "{:.${casasDecimais}f}".format(${dadosPedidoAndroid.valorTotalPedido})
        ${valorTotalItemCalculado}=    sfa_lib_mobile.Formatar valor monetario    ${valorTotalItemCalculado}
        ${getValorTotalItemCard}=    AppiumLibrary.Get Text    xpath=${cardProdutoListagem.valorTotal}
        ${valorTotalItemCard}=    sfa_lib_mobile.Formatar valor monetario    ${getValorTotalItemCard}

        IF  '${valorTotalItemCalculado}' == '${valorTotalItemCard}'
            BuiltIn.Log To Console    Valor total do produto está correto. (R$${valorTotalItemCard})
        ELSE
            BuiltIn.Log To Console    Valor total do produto está errado. (Valor total card = R$${valorTotalItemCard} | Valor total calculado R$${valorTotalItemCalculado})
            BuiltIn.Fail
        END
        
        AppiumLibrary.Clear Text    class=${guiaProdutoPedidoAndroid.campoPesquisa}

        #Criando o dicionário com dados do produto e adicionando o dicionário a lista.
        Criar dicionario de dados do produto    codigoProduto=${produtos[${IP}]}    quantidadeProduto=${qtde}    precoProduto=${precoProdutoDB}    valorTotalProduto=${valorTotalItemCalculado}
    END

Acessar guia de produtos - Android
    [Documentation]    Utilizada para acessar a guia de listagem de produtos no pedido Android.

    AppiumLibrary.Click Element    xpath=${guiaProdutoPedidoAndroid.guiaProduto}
    BuiltIn.Sleep    0.7s
    AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=60s

Acessar a guia de carrinho - Android
    [Documentation]    Utilizada para acessar a guia de carrinho no pedido Android.

    AppiumLibrary.Click Element    xpath=${guiaCarrinhoidoAndroid.guiaCarrinho}
    BuiltIn.Sleep    0.7s
    AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=60s

Acessar guia de complemento - Android
    [Documentation]    Utilizada para acessar a guia de informações complementares no pedido Android.

    AppiumLibrary.Click Element    xpath=${guiaComplementoPedidoAndroid.guia}

Acessar guia de resumo - Android
    [Documentation]    Utilizada para acessar a guia de resumo no pedido Android.

    AppiumLibrary.Wait Until Element Is Visible    xpath=${guiaResumoPedidoAndroid.guia}
    AppiumLibrary.Click Element    xpath=${guiaResumoPedidoAndroid.guia}

Gravar pedido de venda - Android
    [Documentation]    Utilizada para acessar gravar o pedido Android.
    ...    \nPor enquanto vai ficar responsável também por acessar a guia de complemento e posteriormente a guia de resumo.

    ${tituloGuia}=    AppiumLibrary.Get Text    xpath=${guiaResumoPedidoAndroid.guia}
    BuiltIn.Run Keyword If    '${tituloGuia}' != 'RESUMO'     Acessar guia de complemento - Android
    BuiltIn.Run Keyword If    '${tituloGuia}' != 'RESUMO'     Acessar guia de resumo - Android
    BuiltIn.Run Keyword If    '${tituloGuia}' == 'RESUMO'     Acessar guia de resumo - Android

    AppiumLibrary.Wait Until Element Is Visible    xpath=${guiaResumoPedidoAndroid.btnGravar}
    AppiumLibrary.Click Element    xpath=${guiaResumoPedidoAndroid.btnGravar}
    AppiumLibrary.Wait Until Element Is Visible    xpath=${guiaResumoPedidoAndroid.msg}    timeout=10s
    AppiumLibrary.Element Text Should Be    xpath=${guiaResumoPedidoAndroid.msg}    Pedido gravado com sucesso!
    AppiumLibrary.Click Element    id=${guiaResumoPedidoAndroid.btnOk}
    BuiltIn.Log To Console    \nPedido ${dadosPedidoAndroid.numeroPedido} gravado com sucesso!

Finalizar pedido de venda - Android
    [Documentation]    Utilizada para acessar gravar o pedido Android.

    ${statusGuiaResumo}    BuiltIn.Run Keyword And Return Status    AppiumLibrary.Element Should Be Visible    xpath=${guiaResumoPedidoAndroid.guia}
    BuiltIn.Run Keyword If    '${statusGuiaResumo}' == 'False'     Acessar guia de complemento - Android
    BuiltIn.Run Keyword If    '${statusGuiaResumo}' == 'False'     Acessar guia de resumo - Android

    AppiumLibrary.Wait Until Element Is Visible    xpath=${guiaResumoPedidoAndroid.btnFinalizar}
    AppiumLibrary.Click Element    xpath=${guiaResumoPedidoAndroid.btnFinalizar}
    AppiumLibrary.Wait Until Element Is Visible    xpath=${guiaResumoPedidoAndroid.msgFinalizacao}
    AppiumLibrary.Element Text Should Be    xpath=${guiaResumoPedidoAndroid.msgFinalizacao}    Um pedido finalizado não poderá ser alterado após a sincronização. Tem certeza que deseja finalizar o pedido?
    AppiumLibrary.Click Element    id=${guiaResumoPedidoAndroid.btnOk}
    AppiumLibrary.Wait Until Page Does Not Contain Element    xpath=${guiaResumoPedidoAndroid.guia}    timeout=10s
    BuiltIn.Log To Console    \nPedido ${dadosPedidoAndroid.numeroPedido} finalizado com sucesso!

Validar informacoes da guia resumo
    [Documentation]    Keyword utilizada para validar as informações exibidas na guia Resumo.

    ${quantidadeProdutosGuiaResumo}    AppiumLibrary.Get Text    xpath=${guiaResumoPedidoAndroid.quantidadeProdutos}
    ${quantidadeItensGuiaResumo}    AppiumLibrary.Get Text    xpath=${guiaResumoPedidoAndroid.quantidadeItens}
    ${valorTotalGuiaResumo}    AppiumLibrary.Get Text    xpath=${guiaResumoPedidoAndroid.valorTotalLiquido}

    #Validacao da quantidade de produtos
    IF  '${quantidadeProdutosGuiaResumo}' == '${dadosPedidoAndroid.quantidadeProdutosPedido}'
        BuiltIn.Log To Console    Quantidade de produtos exibida no resumo está correta. (${dadosPedidoAndroid.quantidadeProdutosPedido})
    ELSE
        BuiltIn.Log To Console    Quantidade de produtos exibida na guia resumo está errada. (Correta:${dadosPedidoAndroid.quantidadeProdutosPedido} / Resumo: ${quantidadeProdutosGuiaResumo})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END
    
    #Validacao da quantidade de itens
    ${quantidadeItens}    String.Split String    ${quantidadeItensGuiaResumo}    ,
    IF  '${quantidadeItens[0]}' == '${dadosPedidoAndroid.quantidadeItensPedido}'
        BuiltIn.Log To Console    Quantidade de itens exibida no resumo está correta. (${dadosPedidoAndroid.quantidadeItensPedido})
    ELSE
        BuiltIn.Log To Console    Quantidade de produtos exibida na guia resumo está errada. (Correta:${dadosPedidoAndroid.quantidadeItensPedido} / Resumo: ${quantidadeItens[0]})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END
    
    #Validacao do valor líquido
    ${valorTotalPedidoD}=    sfa_lib_mobile.Formatar valor monetario    ${dadosPedidoAndroid.valorTotalPedido}    #Formata o valor salvo no dicionário
    ${valorTotalPedidoR}=    sfa_lib_mobile.Formatar valor monetario    ${valorTotalGuiaResumo}    #Formata o valor resgatado da guia resumo.

    IF  '${valorTotalPedidoD}' == '${valorTotalPedidoR}'
        BuiltIn.Log To Console    Valor total líquido exibido na guia resumo está correto. (${valorTotalGuiaResumo})
    ELSE
        BuiltIn.Log To Console    Valor total líquido exibido na guia resumo está errado. (Correta:${valorTotalPedidoD} / Resumo: ${valorTotalPedidoR})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END

Remover itens do pedido
    [Documentation]    Utilizada para remover todos os itens presentes no carrinho do pedido de venda.

    ${quantidadeItensCarrinho}    AppiumLibrary.Get Text    xpath=${guiaCarrinhoidoAndroid.guiaCarrinho}
    ${quantidadeItensCarrinho}    String.Split String    ${quantidadeItensCarrinho}    separator=)
    ${quantidadeItensCarrinho}    BuiltIn.Set Variable    ${quantidadeItensCarrinho[0]}
    ${quantidadeItensCarrinho}    String.Remove String    ${quantidadeItensCarrinho}    (
    ${quantidadeItensCarrinho}    BuiltIn.Convert To Integer    ${quantidadeItensCarrinho}

    FOR  ${I}  IN RANGE    ${quantidadeItensCarrinho}
        AppiumLibrary.Click Element    xpath=${guiaCarrinhoidoAndroid.removerItemCarrinho}
        AppiumLibrary.Wait Until Element Is Visible    xpath=${guiaCarrinhoidoAndroid.msg}
        AppiumLibrary.Click Element    id=${guiaCarrinhoidoAndroid.btnSim}
    END
    BuiltIn.Log To Console    Produtos removidos do pedido.
    
Validar cabecalho do pedido clonado
    [Documentation]    Irá verificar se o cabecalho do pedido clonado está identico ao do pedido original. Para isso,
    ...    será feito um clone do dicionário de dados do pedido para armazenar as informacoes originais e, reeprenchido o dicionário de dados com os dados do pedido clonado

    ${dadosPedidoAndroidOriginal}    Collections.Copy Dictionary    ${dadosPedidoAndroid}    #Faz a cópia do dicionário para armazenar as informacoes originais.
    Popular dicionario de dados do pedido    #Preenche o dicionário do pedido com os dados atuais exibidos no pedido clonado.

    BuiltIn.Log To Console    ...::: INÍCIO DA COMPARAÇÃO DOS DADOS DO PEDIDO CLONADO :::...
    Verificar igualdade de idParceiro    ${dadosPedidoAndroidOriginal['idParceiro']}
    Verificar igualdade de idLocalParceiro    ${dadosPedidoAndroidOriginal['idLocalParceiro']}
    Verificar igualdade de idLocalFilial    ${dadosPedidoAndroidOriginal['idLocalFilial']}
    Verificar igualdade de idTipoPedido    ${dadosPedidoAndroidOriginal['idTipoPedido']}
    Verificar igualdade de idTabelaPreco    ${dadosPedidoAndroidOriginal['idTabelaPreco']}
    Verificar igualdade de idCondicaoPagamento    ${dadosPedidoAndroidOriginal['idCondicaoPagamento']}
    BuiltIn.Log To Console    ...::: FIM DA COMPARAÇÃO DOS DADOS DO PEDIDO CLONADO :::...

Verificar igualdade de idParceiro
    [Documentation]    Utilizada para verificar se o idParceiro do argumento é o mesmo que o idParceiro salvo nos dados do pedido. 
    ...    \nUtilizada na validacao dos dados de cabecalho do pedido clonado
    [Arguments]    ${idParceiro}=${EMPTY}

    IF  '${idParceiro}' == '${dadosPedidoAndroid.idParceiro}'
        BuiltIn.Log To Console    Parceiro do pedido clonado é o mesmo que o do pedido original.
    ELSE
        BuiltIn.Log To Console    Parceiro do pedido clonado é diferente do parceiro selecionado no pedido original. (idParceiro original: ${idParceiro} | idParceiro do pedido clonado: ${dadosPedidoAndroid.idParceiro})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END

Verificar igualdade de idLocalParceiro
    [Documentation]    Utilizada para verificar se o idLocalParceiro do argumento é o mesmo que o idLocalParceiro salvo nos dados do pedido. 
    ...    \nUtilizada na validacao dos dados de cabecalho do pedido clonado
    [Arguments]    ${idLocalParceiro}=${EMPTY}

    IF  '${idLocalParceiro}' == '${dadosPedidoAndroid.idLocalParceiro}'
        BuiltIn.Log To Console    Local Parceiro do pedido clonado é o mesmo que o do pedido original.
    ELSE
        BuiltIn.Log To Console    Local Parceiro do pedido clonado é diferente do local parceiro selecionado no pedido original. (idLocalParceiro original: ${idLocalParceiro} | idLocalParceiro do pedido clonado: ${dadosPedidoAndroid.idLocalParceiro})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END

Verificar igualdade de idLocalFilial
    [Documentation]    Utilizada para verificar se o idLocalFilial do argumento é o mesmo que o idLocalFilial salvo nos dados do pedido. 
    ...    \nUtilizada na validacao dos dados de cabecalho do pedido clonado
    [Arguments]    ${idLocalFilial}=${EMPTY}

    IF  '${idLocalFilial}' == '${dadosPedidoAndroid.idLocalFilial}'
        BuiltIn.Log To Console    Filial do pedido clonado é a mesma que a do pedido original.
    ELSE
        BuiltIn.Log To Console    Filial do pedido clonado é diferente da filial selecionada no pedido original. (idLocalFilial original: ${idLocalFilial} | idLocalFilial do pedido clonado: ${dadosPedidoAndroid.idLocalFilial})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END

Verificar igualdade de idTipoPedido
    [Documentation]    Utilizada para verificar se o idTipoPedido do argumento é o mesmo que o idTipoPedido salvo nos dados do pedido. 
    ...    \nUtilizada na validacao dos dados de cabecalho do pedido clonado
    [Arguments]    ${idTipoPedido}=${EMPTY}

    IF  '${idTipoPedido}' == '${dadosPedidoAndroid.idTipoPedido}'
        BuiltIn.Log To Console    Tipo do pedido clonado é o mesmo que o do pedido original.
    ELSE
        BuiltIn.Log To Console    Tipo do pedido clonado é diferente do tipo selecionado no pedido original. (idTipoPedido original: ${idTipoPedido} | idTipoPedido do pedido clonado: ${dadosPedidoAndroid.idTipoPedido})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END

Verificar igualdade de idTabelaPreco
    [Documentation]    Utilizada para verificar se o idTabelaPreco do argumento é o mesmo que o idTabelaPreco salvo nos dados do pedido. 
    ...    \nUtilizada na validacao dos dados de cabecalho do pedido clonado
    [Arguments]    ${idTabelaPreco}=${EMPTY}

    IF  '${idTabelaPreco}' == '${dadosPedidoAndroid.idTabelaPreco}'
        BuiltIn.Log To Console    Tabela de preco do pedido clonado é a mesma que a do pedido original.
    ELSE
        BuiltIn.Log To Console    Tabela de preco do pedido clonado é diferente da tabela de preco selecionada no pedido original. (idTabelaPreco original: ${idTabelaPreco} | idTabelaPreco do pedido clonado: ${dadosPedidoAndroid.idTabelaPreco})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END

Verificar igualdade de idCondicaoPagamento
    [Documentation]    Utilizada para verificar se o idCondicaoPagamento do argumento é o mesmo que o idCondicaoPagamento salvo nos dados do pedido. 
    ...    \nUtilizada na validacao dos dados de cabecalho do pedido clonado
    [Arguments]    ${idCondicaoPagamento}=${EMPTY}

    IF  '${idCondicaoPagamento}' == '${dadosPedidoAndroid.idCondicaoPagamento}'
        BuiltIn.Log To Console    Condicao de pagamento do pedido clonado é a mesma que a do pedido original.
    ELSE
        BuiltIn.Log To Console    Condicao de pagamento do pedido clonado é diferente da condicao de pagamento selecionada no pedido original. (idCondicaoPagamento original: ${idCondicaoPagamento} | idCondicaoPagamento do pedido clonado: ${dadosPedidoAndroid.idCondicaoPagamento})
        BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail
    END

Criar dicionario de dados do produto
    [Documentation]    Essa keyword será utilizada para criar um dicionário com alguns dados do produto que foi 
    ...    incluído no pedido de venda e adicionar esse dicionário em uma lista para posterior utilizacão.
    [Arguments]    ${idProduto}=${EMPTY}    ${codigoProduto}=${EMPTY}    ${descricaoProduto}=${EMPTY}    ${quantidadeProduto}=${EMPTY}    ${precoProduto}=${EMPTY}    ${valorTotalProduto}=${EMPTY}

    #Cria o dicionário para armazenar os dados.
    ${produto}    BuiltIn.Create Dictionary    

    #O bloco de código abaixo verifica cada argumento, adicionando o campo ao dicionário quando o argumento não for vazio.
    IF  '${idProduto}' != '${EMPTY}'
        Collections.Set To Dictionary    ${produto}    id=${idProduto}
    END
    IF  '${codigoProduto}' != '${EMPTY}'
        Collections.Set To Dictionary    ${produto}    codigo=${codigoProduto}
    END
    IF  '${descricaoProduto}' != '${EMPTY}'
        Collections.Set To Dictionary    ${produto}    descricao=${descricaoProduto}
    END
    IF  '${quantidadeProduto}' != '${EMPTY}'
        Collections.Set To Dictionary    ${produto}    quantidade=${quantidadeProduto}
    END
    IF  '${precoProduto}' != '${EMPTY}'
        Collections.Set To Dictionary    ${produto}    preco=${precoProduto}
    END
    IF  '${valorTotalProduto}' != '${EMPTY}'
        Collections.Set To Dictionary    ${produto}    valorTotal=${valorTotalProduto}
    END

    BuiltIn.Log To Console    ${produto}
    
    Collections.Append To List    ${dados_produtos_pedido}    ${produto}