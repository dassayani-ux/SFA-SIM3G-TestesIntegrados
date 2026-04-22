*** Settings ***
Documentation    Keywords para o fluxo de Cadastro de Profissional no SFA Web.
...              Cobre: navegação, preenchimento, gravação e vinculação de
...              Hierarquia, Carteira de Clientes e Filiais.

Resource    ${EXECDIR}/pedidoengine/resources/lib/web/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/cadastro/cadastroProfissionalLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/cliente/cadastroClienteResource.robot

Variables   ${EXECDIR}/pedidoengine/libraries/variables/sfa_variables.py

Library     String

*** Variables ***
${PROF_AUTO_LOGIN}    ${EMPTY}
${PROF_AUTO_SENHA}    ${EMPTY}
${PROF_AUTO_NOME}     ${EMPTY}

*** Keywords ***

# ==============================================================================
# NAVEGAÇÃO
# ==============================================================================

Acessar tela de cadastro de profissional
    [Documentation]    Navega pelo menu lateral até a tela de listagem de profissionais.

    Go To    ${aplicacao_web.urlWeb}
    Wait Until Element Is Not Visible    class=minimalist-loading-background    30s
    Fecha Todos Os Popups

    # 1. Rola o container do menu lateral até o item "Cadastro" e clica
    Wait Until Page Contains Element    ${menuCadastro.titulo}    15s
    Execute Javascript
    ...    var menuEl = document.querySelector("span[title='Cadastro']");
    ...    var container = menuEl.parentElement;
    ...    while (container && container !== document.body) {
    ...        var style = window.getComputedStyle(container);
    ...        if (style.overflowY === 'auto' || style.overflowY === 'scroll') break;
    ...        container = container.parentElement;
    ...    }
    ...    if (container && container !== document.body) { container.scrollTop = menuEl.offsetTop; }
    ...    else { menuEl.scrollIntoView({block:'center'}); }
    Sleep    0.5s
    Execute Javascript    document.querySelector("span[title='Cadastro']").click();
    Sleep    1s

    # 2. Expande o toggle "Profissional" correto — o que é pai do link-alvo
    Execute Javascript
    ...    var target = document.getElementById('cadastro.modulo.usuario.cadastro');
    ...    if (target) {
    ...        var toggleLi = target.parentElement.parentElement;
    ...        var toggle = toggleLi ? toggleLi.querySelector("span.toggle") : null;
    ...        if (toggle) { toggle.scrollIntoView({block:'center'}); toggle.click(); }
    ...    }
    Sleep    0.8s

    # 3. Clica no link Profissional
    Wait Until Page Contains Element    ${menuCadastro.linkProfissional}    10s
    Execute Javascript
    ...    var el = document.getElementById('cadastro.modulo.usuario.cadastro');
    ...    if (el) { var a = el.querySelector('a'); if (a) { a.scrollIntoView({block:'center'}); a.click(); } }

    Wait Until Element Is Visible    ${listaProfissionais.btnAdicionar}    15s
    Log To Console    \n✅ Tela de listagem de profissionais acessada.

# ==============================================================================
# FORMULÁRIO PRINCIPAL
# ==============================================================================

Preencher formulario profissional
    [Documentation]    Clica em Adicionar e preenche todos os campos obrigatórios
    ...                com dados gerados dinamicamente.
    ...                Retorna um dicionário com: login, nome, cpf, telefone, email.

    Click Element    ${listaProfissionais.btnAdicionar}
    Sleep    1.5s

    ${id_rand}=    Evaluate    str(__import__('random').randint(100000, 999999))
    ${login}=      Set Variable    qa_${id_rand}
    ${nome}=       Set Variable    Profissional Automação ${id_rand}
    ${cpf_fmt}=    FakerLibrary.Cpf
    ${cpf}=        Remove String    ${cpf_fmt}    .    -
    ${telefone}=   Set Variable    45999${id_rand}
    ${email}=      Set Variable    automacao${id_rand}@totvs.com.br

    Wait Until Element Is Visible    ${formProfissional.login}    10s
    Input Text    ${formProfissional.login}          ${login}
    Input Text    ${formProfissional.senha}           ${login}
    Input Text    ${formProfissional.confirmaSenha}   ${login}
    Input Text    ${formProfissional.nome}            ${nome}

    # CPF com blur para o SFA processar validações de máscara
    Input Text    ${formProfissional.cpf}    ${cpf}
    Press Keys    ${formProfissional.cpf}    TAB
    Sleep    1.5s

    # Telefone — usa JS para setar valor + dispatch blur (campo pode ter máscara)
    Wait Until Page Contains Element    ${formProfissional.telefone}    10s
    Execute Javascript
    ...    var el = document.querySelector("[name='usuario.telefonepadrao']");
    ...    if (el) {
    ...        el.focus();
    ...        el.value = '${telefone}';
    ...        el.dispatchEvent(new Event('input', {bubbles:true}));
    ...        el.dispatchEvent(new Event('change', {bubbles:true}));
    ...        el.blur();
    ...    }

    Input Text    ${formProfissional.email}    ${email}

    Log To Console    \n📋 Profissional gerado: login=${login} | nome=${nome}

    &{dados}=    Create Dictionary
    ...    login=${login}
    ...    nome=${nome}
    ...    cpf=${cpf}
    ...    telefone=${telefone}
    ...    email=${email}
    RETURN    ${dados}

Gravar profissional e aguardar edicao
    [Documentation]    Clica em Gravar, aguarda mensagem de sucesso e reload
    ...                para o modo de edição (URL com idUsuarioEdicao).

    Scroll Element Into View    ${formProfissional.btnGravar}
    Click Element    ${formProfissional.btnGravar}

    Wait Until Page Contains    sucesso    20s
    Wait Until Location Contains    idUsuarioEdicao    20s
    Wait Until Element Is Visible    id=usuariohierarquia.listar    30s
    Sleep    2s
    Log To Console    \n✅ Profissional gravado. Modo de edição ativo.

# ==============================================================================
# HELPERS DE ABA
# ==============================================================================

Clicar aba e aguardar painel
    [Arguments]    ${tab_id}    ${painel_xpath}
    [Documentation]    Rola até a aba, clica via SeleniumLibrary e aguarda o painel ficar visível.
    ...                Após o reload do gravar, a aba pode precisar de scroll para ser visível.

    Execute Javascript    document.getElementById('${tab_id}').scrollIntoView({block:'center'});
    Sleep    0.5s
    Click Element    id=${tab_id}
    Sleep    2s
    Wait Until Element Is Visible    ${painel_xpath}    15s

# ==============================================================================
# ABA HIERARQUIA
# ==============================================================================

Vincular hierarquia ao profissional
    [Documentation]    Acessa a aba Hierarquia, busca 'admin', seleciona e salva.

    Clicar aba e aguardar painel
    ...    usuariohierarquia.listar
    ...    xpath=//div[@id="tab_usuariohierarquia.listar"]//div[contains(@class,"div-l")]

    # Digita no campo de busca via SeleniumLibrary (digitação real, não JS)
    ${campo_busca}=    Set Variable    xpath=//div[@id="tab_usuariohierarquia.listar"]//div[contains(@class,"div-l")]//*[@name="termo"]
    Wait Until Element Is Visible    ${campo_busca}    10s
    Click Element    ${campo_busca}
    Input Text       ${campo_busca}    admin

    # Pesquisa
    ${btn_pesquisar}=    Set Variable    xpath=//div[@id="tab_usuariohierarquia.listar"]//div[contains(@class,"div-l")]//*[@id="btnPesquisar"]
    Click Element    ${btn_pesquisar}

    # Aguarda resultados
    Wait Until Element Is Visible
    ...    xpath=//div[@id="tab_usuariohierarquia.listar"]//div[contains(@class,"div-l")]//div[contains(@class,"slick-row")]
    ...    15s
    Sleep    0.5s

    # Seleciona TODOS os checkboxes das linhas visíveis
    # Usa getElementById para evitar problemas de escape de ponto no seletor CSS jQuery
    Execute Javascript
    ...    var tab = document.getElementById('tab_usuariohierarquia.listar');
    ...    var inputs = tab.querySelectorAll('.div-l .slick-row .slick-cell-checkboxsel input[type="checkbox"]');
    ...    Array.from(inputs).forEach(function(cb) {
    ...        cb.checked = true;
    ...        cb.dispatchEvent(new MouseEvent('click', {bubbles: true, cancelable: true, view: window}));
    ...        $(cb).trigger('click');
    ...    });
    Sleep    1s

    # Seta para o lado direito
    Execute Javascript
    ...    var tab = document.getElementById('tab_usuariohierarquia.listar');
    ...    $(tab).find('.div-m .btn-R').click();
    Sleep    2s

    # Valida que registros foram movidos para o lado direito antes de gravar
    Wait Until Element Is Visible
    ...    xpath=//div[@id="tab_usuariohierarquia.listar"]//div[contains(@class,"div-r")]//div[contains(@class,"slick-row")]
    ...    10s

    # Clica Gravar no painel direito
    Execute Javascript
    ...    var tab = document.getElementById('tab_usuariohierarquia.listar');
    ...    $(tab).find('.div-r #grid-button-gravar').click();

    Wait Until Page Contains    Gravado com sucesso    15s
    Log To Console    \n✅ Hierarquia vinculada.

# ==============================================================================
# ABA CARTEIRA DE CLIENTES
# ==============================================================================

Vincular carteira ao profissional
    [Documentation]    Acessa a aba Carteira, busca 'automacao', seleciona e salva.
    ...                Se não houver resultados, ignora com aviso.

    Clicar aba e aguardar painel
    ...    usuariolocal.listar
    ...    xpath=//div[contains(@class,"usuarioLocal-grid")]//div[contains(@class,"div-l")]

    # Digita no campo de busca via SeleniumLibrary
    ${campo_busca}=    Set Variable    xpath=//div[contains(@class,"usuarioLocal-grid")]//div[contains(@class,"div-l")]//*[@name="termo"]
    Wait Until Element Is Visible    ${campo_busca}    10s
    Click Element    ${campo_busca}
    Input Text       ${campo_busca}    automação

    # Pesquisa
    ${btn_pesquisar}=    Set Variable    xpath=//div[contains(@class,"usuarioLocal-grid")]//div[contains(@class,"div-l")]//*[@id="btnPesquisar"]
    Click Element    ${btn_pesquisar}
    Sleep    2s

    # Verifica resultados
    ${resultados}=    Get Element Count
    ...    xpath=//div[contains(@class,"usuarioLocal-grid")]//div[contains(@class,"div-l")]//div[contains(@class,"slick-row")]

    IF    ${resultados} == 0
        Log To Console    \n⚠️  Nenhum cliente 'automacao' encontrado. Etapa de Carteira ignorada.
    ELSE
        Execute Javascript
        ...    var inputs = document.querySelectorAll('.usuarioLocal-grid .div-l .slick-row .slick-cell-checkboxsel input[type="checkbox"]');
        ...    Array.from(inputs).forEach(function(cb) {
        ...        cb.checked = true;
        ...        cb.dispatchEvent(new MouseEvent('click', {bubbles: true, cancelable: true, view: window}));
        ...        $(cb).trigger('click');
        ...    });
        Sleep    1s
        Execute Javascript
        ...    $(".usuarioLocal-grid .div-m .btn-R").click();
        Sleep    2s

        # Valida que registros foram movidos para o lado direito antes de gravar
        Wait Until Element Is Visible
        ...    xpath=//div[contains(@class,"usuarioLocal-grid")]//div[contains(@class,"div-r")]//div[contains(@class,"slick-row")]
        ...    10s

        Execute Javascript
        ...    $(".usuarioLocal-grid .div-r #grid-button-gravar").click();

        Wait Until Page Contains    Gravado com sucesso    15s
        Log To Console    \n✅ Carteira de clientes vinculada.
    END

# ==============================================================================
# ABA FILIAIS
# ==============================================================================

Vincular filiais ao profissional
    [Documentation]    Acessa a aba Filiais, pesquisa todas, seleciona e salva.

    Clicar aba e aguardar painel
    ...    usuariofilial.listar
    ...    xpath=//div[@id="tab_usuariofilial.listar"]//div[contains(@class,"div-l")]

    # Pesquisa sem filtro
    ${btn_pesquisar}=    Set Variable    xpath=//div[@id="tab_usuariofilial.listar"]//div[contains(@class,"div-l")]//*[@id="btnPesquisar"]
    Wait Until Element Is Visible    ${btn_pesquisar}    10s
    Click Element    ${btn_pesquisar}

    # Aguarda resultados
    Wait Until Element Is Visible
    ...    xpath=//div[@id="tab_usuariofilial.listar"]//div[contains(@class,"div-l")]//div[contains(@class,"slick-row")]
    ...    15s
    Sleep    0.5s

    # Seleciona todos os checkboxes das linhas visíveis
    # Usa getElementById para evitar problemas de escape de ponto no seletor CSS jQuery
    Execute Javascript
    ...    var tab = document.getElementById('tab_usuariofilial.listar');
    ...    var inputs = tab.querySelectorAll('.div-l .slick-row .slick-cell-checkboxsel input[type="checkbox"]');
    ...    Array.from(inputs).forEach(function(cb) {
    ...        cb.checked = true;
    ...        cb.dispatchEvent(new MouseEvent('click', {bubbles: true, cancelable: true, view: window}));
    ...        $(cb).trigger('click');
    ...    });
    Sleep    1s

    # Seta para o lado direito
    Execute Javascript
    ...    var tab = document.getElementById('tab_usuariofilial.listar');
    ...    $(tab).find('.div-m .btn-R').click();
    Sleep    2s

    # Valida que registros foram movidos para o lado direito antes de gravar
    Wait Until Element Is Visible
    ...    xpath=//div[@id="tab_usuariofilial.listar"]//div[contains(@class,"div-r")]//div[contains(@class,"slick-row")]
    ...    10s

    # Gravar
    Execute Javascript
    ...    var tab = document.getElementById('tab_usuariofilial.listar');
    ...    $(tab).find('.div-r #grid-button-gravar').click();

    Wait Until Page Contains    Gravado com sucesso    15s
    Log To Console    \n✅ Filiais vinculadas.

# ==============================================================================
# PONTO GPS
# ==============================================================================

Definir ponto GPS do profissional
    [Documentation]    Após a primeira gravação (modo edição), rola ao topo,
    ...                clica no botão Ponto GPS, pesquisa o endereço fixo do
    ...                profissional automação, clica no mapa e grava.

    # Rola ao topo para garantir visibilidade do botão
    Execute Javascript    window.scrollTo(0, 0);
    Sleep    0.5s

    # Clica no botão Ponto GPS via JS (o span fica dentro de um botão/anchor)
    Wait Until Page Contains Element    ${formProfissional.btnPontoGPS}    10s
    Execute Javascript
    ...    var span = document.querySelector('span.ui-sim3g-icon-ponto-central-white');
    ...    if (!span) throw new Error('Botão Ponto GPS não encontrado');
    ...    var btn = span.closest('button, a, [onclick]') || span.parentElement;
    ...    btn.click();
    Sleep    2s

    # Aguarda o popup do mapa abrir (Google Maps pode demorar)
    Wait Until Element Is Visible    ${mapaProfissional.searchInput}    30s
    Sleep    1s

    # Pesquisa o endereço fixo do profissional automação
    Click Element    ${mapaProfissional.searchInput}
    Input Text    ${mapaProfissional.searchInput}    R. Pres. Bernardes, 2009, Cascavel
    Sleep    2s
    Wait Until Element Is Visible    ${mapaProfissional.pacItem}    10s
    Click Element    ${mapaProfissional.pacItem}
    Sleep    2s

    # Clica no mapa para confirmar o ponto e aceita eventual alerta
    Click Element At Coordinates    ${mapaProfissional.gmStyle}    0    0
    Sleep    1s
    Run Keyword And Ignore Error    Handle Alert    ACCEPT
    Sleep    1s

    # Rola o popup para expor os botões Gravar/Voltar
    Execute Javascript
    ...    var popup = document.querySelector('#popup0 .minimalist-popup-div');
    ...    if (popup) popup.scrollTop = popup.scrollHeight;
    Sleep    0.5s

    # Grava o mapeamento
    Wait Until Element Is Visible    ${mapaProfissional.btnGravar}    10s
    Click Forcado JS    ${mapaProfissional.btnGravar}
    Sleep    1s

    # Fecha o popup clicando em Voltar dentro do #popup0
    Execute Javascript
    ...    var popup = document.querySelector('#popup0');
    ...    if (popup) {
    ...        var btn = popup.querySelector("[id='btnVoltar']");
    ...        if (btn) btn.click();
    ...    }
    Wait Until Element Is Not Visible    css=.minimalist-popup-background    15s
    Sleep    1s
    Log To Console    \n✅ Ponto GPS do profissional definido com sucesso!

# ==============================================================================
# KEYWORD PRINCIPAL
# ==============================================================================

Cadastrar profissional automacao completo
    [Documentation]    Fluxo completo: navega, preenche, grava, define ponto GPS
    ...                e vincula Hierarquia, Carteira e Filiais.

    Acessar tela de cadastro de profissional
    ${dados}=    Preencher formulario profissional
    Gravar profissional e aguardar edicao
    Definir ponto GPS do profissional
    Vincular hierarquia ao profissional
    Vincular carteira ao profissional
    Vincular filiais ao profissional

    Set Suite Variable    ${PROF_AUTO_LOGIN}    ${dados.login}
    Set Suite Variable    ${PROF_AUTO_SENHA}    ${dados.login}
    Set Suite Variable    ${PROF_AUTO_NOME}     ${dados.nome}
    Log To Console    \n🎉 Profissional Automação criado com sucesso!
    Log To Console    \n   Login : ${dados.login}
    Log To Console    \n   Nome  : ${dados.nome}

Valida profissional no banco de dados
    [Documentation]    Confirma no banco que o profissional foi persistido e
    ...                garante que ele tem uma filial padrão configurada
    ...                (necessário para consultas de clientes no mobile).

    ${res}=    DatabaseLibrary.Query
    ...    SELECT idusuario FROM usuario WHERE login = '${PROF_AUTO_LOGIN}'
    Should Not Be Empty    ${res}
    ...    msg=❌ Profissional '${PROF_AUTO_LOGIN}' não encontrado no banco de dados!
    Log To Console    \n✅ Profissional '${PROF_AUTO_LOGIN}' validado no banco.

    # Garante que uma das filiais vinculadas seja a filial padrão (idnpadrao = 1).
    # Usa a filial com menor ID dentre as vinculadas ao profissional.
    ${sql_filial}=    Catenate    SEPARATOR=\n
    ...    UPDATE usuariofilial SET idnpadrao = 1
    ...    WHERE idusuario = (SELECT idusuario FROM usuario WHERE login = '${PROF_AUTO_LOGIN}')
    ...    AND idlocalfilial = (
    ...        SELECT MIN(idlocalfilial) FROM usuariofilial
    ...        WHERE idusuario = (SELECT idusuario FROM usuario WHERE login = '${PROF_AUTO_LOGIN}')
    ...    )
    DatabaseLibrary.Execute Sql String    ${sql_filial}
    Log To Console    \n✅ Filial padrão definida no banco para '${PROF_AUTO_LOGIN}'.
