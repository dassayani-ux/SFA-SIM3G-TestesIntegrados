*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords necessárias no processo de login no Android.

Resource    ${EXECDIR}/pedidoengine/resources/lib/android/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/login/loginLocators.robot
Variables    ${EXECDIR}/pedidoengine/libraries/variables/sfa_variables.py

*** Keywords ***
Realizar primeiro login no app
    [Documentation]    Realiza o primeiro login no app Android.

    AppiumLibrary.Wait Until Element Is Visible    ${formLogin.inputProfissional}    ${20}
    AppiumLibrary.Input Text    id=${formLogin.inputProfissional}    ${login_mobile.usuarioMobile}
    AppiumLibrary.Input Text    id=${formLogin.inputSenha}    ${login_mobile.senhaMobile}
    AppiumLibrary.Click Element    id=${formLogin.btnEntrar}

Realizar login no app com usuario automacao
    [Documentation]    Realiza login no app Android usando o profissional de automação
    ...                buscado no banco (variáveis ${USUARIO_MOBILE} e ${SENHA_MOBILE}).
    ...                Deve ser chamada após Buscar usuario automacao no banco.

    AppiumLibrary.Wait Until Element Is Visible    ${formLogin.inputProfissional}    ${30}
    AppiumLibrary.Clear Text    id=${formLogin.inputProfissional}
    AppiumLibrary.Input Text    id=${formLogin.inputProfissional}    ${USUARIO_MOBILE}
    AppiumLibrary.Input Text    id=${formLogin.inputSenha}           ${SENHA_MOBILE}
    AppiumLibrary.Click Element    id=${formLogin.btnEntrar}

    Sleep    1s
    ${activity}=    AppiumLibrary.Get Activity
    IF    '${activity}' == '${activityMenuPrincipal}'
        Log To Console    \n✅ Login realizado com sucesso. Usuário: ${USUARIO_MOBILE}
    ELSE
        Log To Console    \n❌ Activity do menu principal não encontrada após login.
        Fail
    END

Realizar login no app
    [Documentation]    Realiza login no app Android após a sincronização.
    ...                Se o app já estiver no menu principal (noReset=true preserva estado),
    ...                apenas loga e continua. Se estiver na tela de login, digita a senha e entra.

    ${activity}=    AppiumLibrary.Get Activity
    IF    '${activity}' == '${activityMenuPrincipal}'
        Log To Console    \nApp já está no menu principal — login não necessário.
        RETURN
    END

    # App está na tela de login — verifica usuário e digita senha
    AppiumLibrary.Wait Until Element Is Visible    ${formLogin.inputProfissional}    ${30}
    ${userLogado}=    AppiumLibrary.Get Text    id=${formLogin.inputProfissional}
    IF    '${userLogado}' == '${login_mobile.usuarioMobile}'
        Log To Console    \nProfissional logado é o correto: ${userLogado}
    ELSE
        Log To Console    \nProfissional esperado: ${login_mobile.usuarioMobile} | Encontrado: ${userLogado}
        Fail    Profissional no app é diferente do configurado em sfa_variables.py
    END

    AppiumLibrary.Input Text    id=${formLogin.inputSenha}    ${login_mobile.senhaMobile}
    AppiumLibrary.Click Element    id=${formLogin.btnEntrar}
    Sleep    1s

    ${activity}=    AppiumLibrary.Get Activity
    IF    '${activity}' == '${activityMenuPrincipal}'
        Log To Console    \nLogin realizado com sucesso.
    ELSE
        Log To Console    \nActivity do menu principal não encontrada após login.
        Fail    Login não concluído — activity atual: ${activity}
    END
    