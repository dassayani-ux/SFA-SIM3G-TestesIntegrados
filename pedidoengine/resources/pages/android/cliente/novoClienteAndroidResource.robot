*** Settings ***
Documentation    Keywords para cadastro de novo cliente no app Android.
...              Cobre: Dados → Complemento → Local (Dados + Complemento) → Finalizar.

Resource    ${EXECDIR}/pedidoengine/resources/lib/android/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/cliente/novoClienteAndroidLocators.robot

*** Keywords ***
# ==============================================================================
# NAVEGAÇÃO
# ==============================================================================

Abrir formulario de novo cliente
    [Documentation]    Na tela de listagem de clientes, clica nos 3 pontinhos
    ...                e seleciona "Novo cliente".

    AppiumLibrary.Wait Until Element Is Visible    ${novoCliente.maisOpcoes}    10s
    AppiumLibrary.Click Element                    ${novoCliente.maisOpcoes}
    AppiumLibrary.Wait Until Element Is Visible    ${novoCliente.menuItem}      5s
    AppiumLibrary.Click Element                    ${novoCliente.menuItem}
    AppiumLibrary.Wait Until Element Is Visible    ${dadosCliente.radioJuridica}    15s
    Log To Console    \n📋 Formulário de Novo Cliente aberto.

# ==============================================================================
# ABA DADOS (PARCEIRO)
# ==============================================================================

Preencher aba dados do novo cliente
    [Documentation]    Preenche a aba Dados do cadastro de cliente.
    [Arguments]
    ...    ${nome}
    ...    ${fantasia}
    ...    ${matricula}
    ...    ${tipo}=Jurídica

    Log To Console    \n📝 Preenchendo aba Dados...

    # Tipo de pessoa
    IF    '${tipo}' == 'Jurídica'
        AppiumLibrary.Click Element    ${dadosCliente.radioJuridica}
    ELSE
        AppiumLibrary.Click Element    ${dadosCliente.radioFisica}
    END
    Sleep    0.5s

    # Nome / Razão Social
    AppiumLibrary.Wait Until Element Is Visible    ${dadosCliente.nome}    5s
    AppiumLibrary.Clear Text    ${dadosCliente.nome}
    AppiumLibrary.Input Text    ${dadosCliente.nome}    ${nome}

    # Nome Fantasia
    AppiumLibrary.Clear Text    ${dadosCliente.fantasia}
    AppiumLibrary.Input Text    ${dadosCliente.fantasia}    ${fantasia}

    # Matrícula
    AppiumLibrary.Clear Text    ${dadosCliente.matricula}
    AppiumLibrary.Input Text    ${dadosCliente.matricula}    ${matricula}

    # Classificação
    Selecionar spinner android    ${dadosCliente.classificacao}    ${dadosCliente.classificacaoAutomacao}

    Log To Console    ✅ Aba Dados preenchida.

# ==============================================================================
# ABA COMPLEMENTO (PARCEIRO)
# ==============================================================================

Preencher aba complemento do novo cliente
    [Documentation]    Navega para a aba Complemento, preenche apenas o CNPJ
    ...                e avança para a tela de Local clicando em PRÓXIMO.
    [Arguments]    ${cnpj}=${EMPTY}

    Log To Console    \n📝 Preenchendo aba Complemento do cliente...

    AppiumLibrary.Click Element    ${dadosCliente.abaComplemento}
    Sleep    1s

    # CNPJ
    IF    '${cnpj}' != '${EMPTY}'
        AppiumLibrary.Wait Until Element Is Visible    ${complementoCliente.cnpj}    5s
        AppiumLibrary.Clear Text    ${complementoCliente.cnpj}
        AppiumLibrary.Input Text    ${complementoCliente.cnpj}    ${cnpj}
    END

    # Avança para a tela de Local
    AppiumLibrary.Wait Until Element Is Visible    ${btnProximoCliente}    10s
    AppiumLibrary.Click Element                    ${btnProximoCliente}
    AppiumLibrary.Wait Until Element Is Visible    ${local.descricao}      15s
    Sleep    1s
    Log To Console    ✅ Complemento preenchido → tela de Local aberta.

# ==============================================================================
# TELA LOCAL — ABA DADOS
# ==============================================================================

Preencher aba dados do local
    [Documentation]    Preenche os campos da tela de Local (já aberta pelo PRÓXIMO
    ...                da aba Complemento do cliente).
    [Arguments]    ${descricao}    ${cnpj}=${EMPTY}

    Log To Console    \n📝 Preenchendo aba Dados do Local...

    # Descrição
    AppiumLibrary.Clear Text    ${local.descricao}
    AppiumLibrary.Input Text    ${local.descricao}    ${descricao}

    # CNPJ do local (opcional)
    IF    '${cnpj}' != '${EMPTY}'
        AppiumLibrary.Clear Text    ${local.cnpj}
        AppiumLibrary.Input Text    ${local.cnpj}    ${cnpj}
    END

    # Logradouro
    AppiumLibrary.Clear Text    ${local.logradouro}
    AppiumLibrary.Input Text    ${local.logradouro}    R. Pres. Bernardes

    # Número (abre diálogo numérico)
    Preencher campo numerico android    ${local.numero}    2009

    # Bairro
    AppiumLibrary.Clear Text    ${local.bairro}
    AppiumLibrary.Input Text    ${local.bairro}    Centro

    # CEP
    AppiumLibrary.Clear Text    ${local.cep}
    AppiumLibrary.Input Text    ${local.cep}    85810240

    # UF — seleciona PARANA no spinner
    Selecionar spinner android    ${local.uf}    ${local.ufParana}
    Sleep    0.5s

    # Cidade — spinner com campo de pesquisa
    Selecionar cidade android    CASCAVEL

    Log To Console    ✅ Aba Dados do Local preenchida.

# ==============================================================================
# TELA LOCAL — ABA COMPLEMENTO
# ==============================================================================

Preencher aba complemento do local
    [Documentation]    Navega para a aba Complemento do Local e preenche os campos.
    ...                Spinners sem valor definido recebem a primeira opção disponível.

    Log To Console    \n📝 Preenchendo aba Complemento do Local...

    AppiumLibrary.Click Element    ${local.abaComplemento}
    Sleep    1s
    AppiumLibrary.Wait Until Element Is Visible    ${localCompl.tipoLocal}    10s

    # Spinners — seleciona a primeira opção disponível em cada um
    Selecionar primeira opcao spinner android    ${localCompl.tipoLocal}
    Selecionar primeira opcao spinner android    ${localCompl.tipologia}
    Selecionar primeira opcao spinner android    ${localCompl.praca}
    Selecionar primeira opcao spinner android    ${localCompl.tabelaPreco}
    Selecionar primeira opcao spinner android    ${localCompl.condicoesPagamento}
    Selecionar primeira opcao spinner android    ${localCompl.tipoCobranca}
    Selecionar primeira opcao spinner android    ${localCompl.segmento}

    # IE Isento
    AppiumLibrary.Wait Until Element Is Visible    ${localCompl.isento}    5s
    AppiumLibrary.Click Element                    ${localCompl.isento}
    Sleep    0.3s

    # Scroll para ver Preço Base e Observação
    AppiumLibrary.Swipe    540    1400    540    400    800
    Sleep    0.5s

    # Observação
    ${obs_visible}=    Run Keyword And Return Status
    ...    AppiumLibrary.Element Should Be Visible    ${localCompl.observacao}
    IF    ${obs_visible}
        AppiumLibrary.Clear Text    ${localCompl.observacao}
        AppiumLibrary.Input Text    ${localCompl.observacao}    Cadastro via automação
    END

    Log To Console    ✅ Aba Complemento do Local preenchida.

# ==============================================================================
# FINALIZAR
# ==============================================================================

Finalizar e gravar novo cliente
    [Documentation]    Clica em FINALIZAR, seleciona "Gravar e sair" no menu flutuante
    ...                e aguarda retornar à listagem de clientes.

    AppiumLibrary.Wait Until Element Is Visible    ${btnFinalizar}    10s
    AppiumLibrary.Click Element                    ${btnFinalizar}
    AppiumLibrary.Wait Until Element Is Visible    ${menuFlutuante.gravarSair}    5s
    AppiumLibrary.Click Element                    ${menuFlutuante.gravarSair}
    AppiumLibrary.Wait Until Element Is Visible    ${telaListagemClientes.topo}    20s
    Log To Console    \n✅ Cliente gravado e listagem exibida.

# ==============================================================================
# KEYWORD PRINCIPAL
# ==============================================================================

Cadastrar novo cliente android
    [Documentation]    Fluxo completo de cadastro de cliente no app Android.
    ...                Gera nome, matrícula e CNPJ únicos por timestamp.

    ${id_rand}=    Evaluate    str(int(time.time()))[-6:]    time
    ${nome}=       Set Variable    Cliente Automação Android ${id_rand}
    ${fantasia}=   Set Variable    Fantasia Android ${id_rand}
    ${matricula}=  Set Variable    AND${id_rand}
    ${descricao}=  Set Variable    Local Automação Android ${id_rand}

    # Gera CNPJ válido (com dígitos verificadores corretos) usando seed do timestamp
    ${cnpj}=    Gerar CNPJ valido    ${id_rand}

    Log To Console    \n🚀 Iniciando cadastro: ${nome} | CNPJ: ${cnpj}

    Abrir formulario de novo cliente
    Preencher aba dados do novo cliente       ${nome}      ${fantasia}    ${matricula}
    Preencher aba complemento do novo cliente    cnpj=${cnpj}
    Preencher aba dados do local              ${descricao}    cnpj=${cnpj}
    Preencher aba complemento do local
    Finalizar e gravar novo cliente

    Set Suite Variable    ${CLIENTE_ANDROID_NOME}       ${nome}
    Set Suite Variable    ${CLIENTE_ANDROID_MATRICULA}  ${matricula}
    Log To Console    \n🎉 Cadastro concluído! Nome: ${nome} | Matrícula: ${matricula}

# ==============================================================================
# HELPERS
# ==============================================================================

Selecionar spinner android
    [Documentation]    Clica no spinner e seleciona o item pelo locator fornecido.
    [Arguments]    ${spinner_locator}    ${item_locator}

    AppiumLibrary.Click Element    ${spinner_locator}
    Sleep    0.5s
    AppiumLibrary.Wait Until Element Is Visible    ${item_locator}    5s
    AppiumLibrary.Click Element                    ${item_locator}
    Sleep    0.3s

Selecionar primeira opcao spinner android
    [Documentation]    Clica no spinner e seleciona o primeiro item da lista
    ...                (ignora erros — campo pode ser opcional/vazio).
    [Arguments]    ${spinner_locator}

    ${visible}=    Run Keyword And Return Status
    ...    AppiumLibrary.Element Should Be Visible    ${spinner_locator}
    IF    not ${visible}    RETURN

    AppiumLibrary.Click Element    ${spinner_locator}
    Sleep    0.5s
    ${item_exists}=    Run Keyword And Return Status
    ...    AppiumLibrary.Element Should Be Visible
    ...    xpath=//android.widget.ListView/android.widget.TextView[2]
    IF    ${item_exists}
        AppiumLibrary.Click Element
        ...    xpath=//android.widget.ListView/android.widget.TextView[2]
    ELSE
        # Fecha a lista sem selecionar (pressiona Back)
        AppiumLibrary.Press Keycode    4
    END
    Sleep    0.3s

Preencher campo numerico android
    [Documentation]    Abre a calculadora customizada do app, limpa o valor atual e
    ...                digita cada caractere clicando nos botões da calculadora.
    ...                Funciona para inteiros (ex: 10) e decimais (ex: 100000,00).
    [Arguments]    ${campo_locator}    ${valor}

    AppiumLibrary.Click Element    ${campo_locator}
    Sleep    0.5s
    AppiumLibrary.Wait Until Element Is Visible    ${calculadora.display}    5s

    # Limpa o valor atual (botão C), se existir
    ${tem_clear}=    Run Keyword And Return Status
    ...    AppiumLibrary.Element Should Be Visible    xpath=//android.widget.Button[@text="C"]
    IF    ${tem_clear}
        AppiumLibrary.Click Element    xpath=//android.widget.Button[@text="C"]
        Sleep    0.2s
    END

    # Clica botão a botão para cada caractere do valor
    ${chars}=    Split String To Characters    ${valor}
    FOR    ${char}    IN    @{chars}
        AppiumLibrary.Click Element    xpath=//android.widget.Button[@text="${char}"]
        Sleep    0.1s
    END

    # Confirma com Definir
    AppiumLibrary.Click Element    ${calculadora.btnDefinir}
    Sleep    0.3s

Preencher campo monetario android
    [Documentation]    Alias semântico para campos monetários — usa a mesma calculadora.
    [Arguments]    ${campo_locator}    ${valor}

    Preencher campo numerico android    ${campo_locator}    ${valor}

Selecionar cidade android
    [Documentation]    Clica no spinner de Cidade, pesquisa o texto e seleciona
    ...                "CASCAVEL (PR)".
    [Arguments]    ${pesquisa}=CASCAVEL

    AppiumLibrary.Click Element    ${local.cidade}
    Sleep    1s
    AppiumLibrary.Wait Until Element Is Visible    xpath=//android.widget.EditText    5s
    AppiumLibrary.Input Text    xpath=//android.widget.EditText    ${pesquisa}
    Sleep    1s
    AppiumLibrary.Wait Until Element Is Visible    ${local.cidadeCascavel}    5s
    AppiumLibrary.Click Element                    ${local.cidadeCascavel}
    Sleep    0.3s
