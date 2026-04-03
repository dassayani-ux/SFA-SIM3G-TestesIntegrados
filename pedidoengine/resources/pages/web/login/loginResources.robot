*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo do login da platforma web.

# 1. Caminhos Relativos (Sem EXECDIR)
Resource         ../../../lib/web/lib.robot
Resource         ../../../locators/web/login/locatorsLogin.robot
Variables        ../../../../libraries/variables/sfa_variables.py

*** Keywords ***
Realiza login na plataforma web
    [Documentation]    Irá realizar o login na plataforma web utilizando os dados informados no arquivo de variáveis.

    Input Text       ${TF_LOGIN}    ${login_web.usuarioWeb}
    Input Text       ${TF_SENHA}    ${login_web.senhaWeb}
    Click Element    id=${BTN_ENTRAR}
    Sleep            2s

Login com usuario invalido
    [Documentation]    Tenta realizar login na plataforma web utilizando um usuário inválido.

    Input Text       ${TF_LOGIN}    ${login_web.usuarioInvalidoWeb}
    Input Text       ${TF_SENHA}    ${login_web.senhaWeb}
    Click Element    id=${BTN_ENTRAR}
    
    Validar mensagem de login invalido

Login com senha invalida
    [Documentation]    Tenta realizar login na plataforma web utilizando senha inválida.

    Input Text       ${TF_LOGIN}    ${login_web.usuarioWeb}
    Input Text       ${TF_SENHA}    ${login_web.senhaInvalidaWeb}
    Click Element    id=${BTN_ENTRAR}
    
    Validar mensagem de login invalido

Login com usuario e senha invalidos
    [Documentation]    Tenta realizar o login na plataforma web utilizando login e senha inválidos.

    Input Text       ${TF_LOGIN}    ${login_web.usuarioInvalidoWeb}
    Input Text       ${TF_SENHA}    ${login_web.senhaInvalidaWeb}
    Click Element    id=${BTN_ENTRAR}
    
    Validar mensagem de login invalido

Realizar logoff
    [Documentation]    Realiza logoff na plataforma WEB.
    
    Click Element                    id=${logoff.acoes}
    Sleep                            0.3s
    Click Element                    xpath=${logoff.sair}
    # Adicionado um timeout de 10s de segurança para garantir que a tela de login carregou
    Wait Until Element Is Visible    id=${formularioLogin}    10s


# ==========================================
# KEYWORDS AUXILIARES (Reaproveitamento)
# ==========================================
Validar mensagem de login invalido
    [Documentation]    Aguarda e valida a mensagem de erro padrão de login (Evita repetição de código).
    
    Wait Until Page Contains Element    class=${loginInvalido.locator}    10s
    ${loginError}                       Get Text    class=${loginInvalido.locator}
    Should Be Equal As Strings          ${loginError}    ${loginInvalido.mensagem}