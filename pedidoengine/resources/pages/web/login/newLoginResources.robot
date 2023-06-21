*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo do login da platforma web.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/login/locatorsLogin.robot
Resource    ${EXECDIR}/resources/variables/web/global/newGlobalVariables.robot
Resource    ${EXECDIR}/resources/variables/web/login/newlLoginVariables.robot

*** Keywords ***
Realiza login na plataforma web
    [Documentation]    Irá realizar o login na plataforma web utilizando os dados informados nos arquivo resources.

    SeleniumLibrary.Input Text    ${TF_LOGIN}    ${login.usuario}
    SeleniumLibrary.Input Text    ${TF_SENHA}    ${login.senha}
    Click Element    id=${BTN_ENTRAR}
    Sleep    2s

Login com usuario invalido
    [Documentation]    Tenta realizar login na plataforma web utilizando um usuário inválido.

    SeleniumLibrary.Input Text    ${TF_LOGIN}    ${login.usuarioInvalido}
    SeleniumLibrary.Input Text    ${TF_SENHA}    ${login.senha}
    Click Element    id=${BTN_ENTRAR}
    Wait Until Page Contains Element    class=${MSG_LOGIN_INVALIDO}
    ${loginError}    SeleniumLibrary.Get Text    class=${MSG_LOGIN_INVALIDO}
    ${result}    Should Be Equal As Strings    ${loginError}    ${login.msgErro}

Login com senha invalida
    [Documentation]    Tenta realizar login na plataforma web utilizando senha inválida.

    SeleniumLibrary.Input Text    ${TF_LOGIN}    ${login.usuario}
    SeleniumLibrary.Input Text    ${TF_SENHA}    ${login.senhaInvalida}
    Click Element    id=${BTN_ENTRAR}
    Wait Until Page Contains Element    class=${MSG_LOGIN_INVALIDO}
    ${loginError}    SeleniumLibrary.Get Text    class=${MSG_LOGIN_INVALIDO}
    ${result}    Should Be Equal As Strings    ${loginError}    ${login.msgErro}

Login com usuario e senha invalidos
    [Documentation]    Tenta realizar o login na plataforma web utilizando login e senha inválidos.

    SeleniumLibrary.Input Text    ${TF_LOGIN}    ${login.usuarioInvalido}
    SeleniumLibrary.Input Text    ${TF_SENHA}    ${login.senhaInvalida}
    Click Element    id=${BTN_ENTRAR}
    Wait Until Page Contains Element    class=${MSG_LOGIN_INVALIDO}
    ${loginError}    SeleniumLibrary.Get Text    class=${MSG_LOGIN_INVALIDO}
    ${result}    Should Be Equal As Strings    ${loginError}    ${login.msgErro}