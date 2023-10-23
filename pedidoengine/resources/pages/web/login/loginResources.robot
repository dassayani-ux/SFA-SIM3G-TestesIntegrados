*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo do login da platforma web.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/login/locatorsLogin.robot
Variables    ${EXECDIR}/libraries/variables/sfa_variables.py

*** Keywords ***
Realiza login na plataforma web
    [Documentation]    Irá realizar o login na plataforma web utilizando os dados informados nos arquivo resources.

    SeleniumLibrary.Input Text    ${TF_LOGIN}    ${login_web.usuarioWeb}
    SeleniumLibrary.Input Text    ${TF_SENHA}    ${login_web.senhaWeb}
    SeleniumLibrary.Click Element    id=${BTN_ENTRAR}
    Sleep    2s

Login com usuario invalido
    [Documentation]    Tenta realizar login na plataforma web utilizando um usuário inválido.

    SeleniumLibrary.Input Text    ${TF_LOGIN}    ${login_web.usuarioInvalidoWeb}
    SeleniumLibrary.Input Text    ${TF_SENHA}    ${login_web.senhaWeb}
    SeleniumLibrary.Click Element    id=${BTN_ENTRAR}
    SeleniumLibrary.Wait Until Page Contains Element    class=${loginInvalido.locator}
    ${loginError}    SeleniumLibrary.Get Text    class=${loginInvalido.locator}
    ${result}    BuiltIn.Should Be Equal As Strings    ${loginError}    ${loginInvalido.mensagem}

Login com senha invalida
    [Documentation]    Tenta realizar login na plataforma web utilizando senha inválida.

    SeleniumLibrary.Input Text    ${TF_LOGIN}    ${login_web.usuarioWeb}
    SeleniumLibrary.Input Text    ${TF_SENHA}    ${login_web.senhaInvalidaWeb}
    Click Element    id=${BTN_ENTRAR}
    Wait Until Page Contains Element    class=${loginInvalido.locator}
    ${loginError}    SeleniumLibrary.Get Text    class=${loginInvalido.locator}
    ${result}    Should Be Equal As Strings    ${loginError}    ${loginInvalido.mensagem}

Login com usuario e senha invalidos
    [Documentation]    Tenta realizar o login na plataforma web utilizando login e senha inválidos.

    SeleniumLibrary.Input Text    ${TF_LOGIN}    ${login_web.usuarioInvalidoWeb}
    SeleniumLibrary.Input Text    ${TF_SENHA}    ${login_web.senhaInvalidaWeb}
    Click Element    id=${BTN_ENTRAR}
    Wait Until Page Contains Element    class=${loginInvalido.locator}
    ${loginError}    SeleniumLibrary.Get Text    class=${loginInvalido.locator}
    ${result}    Should Be Equal As Strings    ${loginError}    ${loginInvalido.mensagem}

Realizar logoff
    [Documentation]    Realiza logoff na plataforma WEB.
    
    SeleniumLibrary.Click Element    id=${logoff.acoes}
    Sleep    0.3s
    SeleniumLibrary.Click Element    xpath=${logoff.sair}
    SeleniumLibrary.Wait Until Element Is Visible    id=${formularioLogin}