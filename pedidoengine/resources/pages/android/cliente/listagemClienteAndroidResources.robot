*** Settings ***
Documentation    Arquivo destinado a armazenar keywords utilizadas em testes na tela de listagem de clientes no ambiente Mobile.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/data/cliente/dataCliente.robot
Resource    ${EXECDIR}/resources/locators/android/cliente/tela360clienteLocators.robot
Resource    ${EXECDIR}/resources/locators/android/cliente/listagemclienteandroidLocators.robot
Resource    ${EXECDIR}/resources/variables/android/pedido/cadastroPedidoAndroidVariables.robot

*** Keywords ***
Ativar pesquisa avancada cliente
    [Documentation]    Utilizada para ativar a pesquisa avançada de clientes no ambiente mobile.

    AppiumLibrary.Click Element    accessibility_id=${telaListagemClientes.opcoesTela}
    AppiumLibrary.Wait Until Element Is Visible    xpath=${telaListagemClientes.pesquisaAvancada}
    AppiumLibrary.Click Element    xpath=${telaListagemClientes.pesquisaAvancada}
    AppiumLibrary.Wait Until Page Contains Element    id=${pesquisaAvancadaCliente.telaPesquisa}

Filtrar cliente por razao social e Matricula e selecionar
    [Documentation]    Irá Filtrar um cliente específico utilizando-se da pesquisa avançada.
    ...    \nQuando não informado cliente e matrícula nos argumentos, será *randomizado* um cliente com base no usuário logado no app.
    [Arguments]    ${nomeCliente}=${EMPTY}    ${matricula}=${EMPTY}

    IF  '${nomeCliente}' == '${EMPTY}' and '${matricula}' == '${EMPTY}'
        ${cliente}=    Retornar razao, matricula e id de parceiro aleatorio    ambiente=Mobile
        ${nomeCliente}=    BuiltIn.Set Variable    ${cliente[0]}
        ${matricula}=    BuiltIn.Set Variable    ${cliente[1]}
        ${dadosPedidoAndroid.idParceiro}=    BuiltIn.Set Variable    ${cliente[2]}
    ELSE
        ${dadosPedidoAndroid.idParceiro}=    Retorna idparceiro    maricula=${matricula}    nomeParceiro=${nomeCliente}
    END

    Ativar pesquisa avancada cliente
    AppiumLibrary.Click Element    id=${pesquisaAvancadaCliente.btnLimpar}
    AppiumLibrary.Input Text    xpath=${pesquisaAvancadaCliente.nomeParceiro}    ${nomeCliente}
    AppiumLibrary.Input Text    xpath=${pesquisaAvancadaCliente.matriculaParceiro}    ${matricula}
    AppiumLibrary.Click Element    id=${pesquisaAvancadaCliente.btnPesquisar}
    BuiltIn.Sleep    1s
    AppiumLibrary.Element Text Should Be    xpath=${clienteFiltrado.nomeParceiro}    ${nomeCliente}    message=Cliente filtrado está incorreto.
    AppiumLibrary.Element Text Should Be    xpath=${clienteFiltrado.matricula}    ${matricula}    message=Cliente filtrado está incorreto.
    BuiltIn.Log To Console    \nCliente filtrado corretamente.
    Clicar no cliente da listagem

Clicar no cliente da listagem
    [Documentation]    Clica no card do primeiro cliente exibido na listagem.

    AppiumLibrary.Click Element    id=${telaListagemClientes.cardCliente}
    AppiumLibrary.Wait Until Element Is Visible    id=${idTela360}