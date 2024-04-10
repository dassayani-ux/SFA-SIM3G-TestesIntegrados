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
        ${opcao}=    BuiltIn.Set Variable    [2]
    ELSE
        ${opcao}=    BuiltIn.Evaluate    random.sample(range(2, ${countOpcoes}), 1)    random
    END
    AppiumLibrary.Click Element    xpath=${popUpOpcoesCombo.opcoesDisponiveis}${opcao}
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
        ${opcao}=    BuiltIn.Set Variable    [2]
    ELSE
        ${opcao}=    BuiltIn.Evaluate    random.sample(range(2, ${countOpcoes}), 1)    random
    END
    AppiumLibrary.Click Element    xpath=${popUpOpcoesCombo.opcoesDisponiveis}${opcao}
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

    AppiumLibrary.Click Element    xpath=${cabecalhoPedidoAndroid.comboboxSafra}
    AppiumLibrary.Wait Until Element Is Visible    id=${popUpOpcoesCombo.idPopUp}
    ${countOpcoes}=    AppiumLibrary.Get Matching Xpath Count    ${popUpOpcoesCombo.opcoesDisponiveis}
    IF  ${countOpcoes} == ${1}
        BuiltIn.Fail    Não há safra disponível para seleção.
    ELSE IF  ${countOpcoes} == ${2}
        ${opcao}=    BuiltIn.Set Variable    [2]
    ELSE
        ${opcao}=    BuiltIn.Evaluate    random.sample(range(2, ${countOpcoes}), 1)    random
    END
    AppiumLibrary.Click Element    xpath=${popUpOpcoesCombo.opcoesDisponiveis}${opcao}
    AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=60s
    ${safra}=    AppiumLibrary.Get Text    xpath=${cabecalhoPedidoAndroid.comboboxSafra}
    BuiltIn.Log To Console    Safra selecionada: ${safra}

Popular dicionario de dados do pedido
    [Documentation]    Utilizada para preencher o dicinário de dados do pedido Android, cujo o qual será utilizado em keywords.

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
    ...    \nO argumento *${quantidadeItens}* define quantos produtos serão inclusos no pedido.
    ...    \nO argumento *${quantidadeMaxima}* define qual a quantidade máxima para os itens.
    [Arguments]    ${quantidadeItens}=${2}    ${quantidadeMaxima}=${100}

    Acessar guia de produtos - Android
    BuiltIn.Sleep   1s
    ${countProdutosTabela}=    Retorna quantidade de itens da tabela    ${dadosPedidoAndroid.idTabelaPreco}
    ${randomProdutos}=    Evaluate    random.sample(range(0, ${countProdutosTabela}), ${quantidadeItens})    random
    ${produtos}=    Retorna produtos    @{randomProdutos}    tabelaPreco=${dadosPedidoAndroid.idTabelaPreco}
    Log To Console    Produtos selecionados: ${produtos}

    FOR  ${I}  IN RANGE    ${quantidadeItens}
        AppiumLibrary.Input Text    class=${guiaProdutoPedidoAndroid.campoPesquisa}    ${produtos[${I}]}
        BuiltIn.Sleep    1s
        AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=60s
        AppiumLibrary.Wait Until Element Is Visible    xpath=${cardProdutoListagem.expandirCard}    timeout=60s
        AppiumLibrary.Click Element    xpath=${cardProdutoListagem.expandirCard}
        ${qtdApresentacao}=    Retornar quantidade apresentacao produto    codigoProduto=${produtos[${I}]}
        ${qtdApresentacao}=    BuiltIn.Convert To Integer    ${qtdApresentacao}
        ${qtde}=    Evaluate    round(random.randint(1, round(${quantidadeMaxima}/${qtdApresentacao})) * ${qtdApresentacao})    random    #Randomiza a quantidade em um intervalo de 1 a ${quantidadeMaxima}, desde
        ${qtde}=    BuiltIn.Convert To String    ${qtde}                                                                                  #que a quantidade seja múltipla da quantidade de apresentação.
        BuiltIn.Log To Console    Quantidade sorteada para o produto ${produtos[${I}]} = ${qtde}
        ${lenQtd}=    BuiltIn.Get Length    ${qtde}
        AppiumLibrary.Wait Until Element Is Visible    xpath=${cardProdutoListagem.btnCampoQuantidade}
        AppiumLibrary.Click Element    xpath=${cardProdutoListagem.btnCampoQuantidade}
        AppiumLibrary.Wait Until Element Is Visible    xpath=${cardProdutoListagem.inputCampoQuantidade}
        FOR  ${I}  IN RANGE    ${lenQtd}
            AppiumLibrary.Click Element    id=${tecladoQuantidade.prefixoNumeros}${qtde[${I}]}
        END
        AppiumLibrary.Click Element    id=${cardProdutoListagem.btnConfirmarQuantidade}
        AppiumLibrary.Wait Until Element Is Visible    class=${guiaProdutoPedidoAndroid.campoPesquisa}    timeout=60s
        AppiumLibrary.Clear Text    class=${guiaProdutoPedidoAndroid.campoPesquisa}
    END

Acessar guia de produtos - Android
    [Documentation]    Utilizada para acessar a guia de listagem de produtos no pedido Android.

    AppiumLibrary.Click Element    xpath=${guiaProdutoPedidoAndroid.guiaProduto}

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