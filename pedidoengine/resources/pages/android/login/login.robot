*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords necessárias no processo de login no Android.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/locators/android/login/loginLocators.robot
Resource    ${EXECDIR}/resources/variables/android/login/loginVariables.robot

*** Keywords ***
Realizar primeiro login no app
    [Documentation]    Realiza o primeiro login no app Android.

    AppiumLibrary.Wait Until Element Is Visible    ${formLogin.inputProfissional}    ${20}
    AppiumLibrary.Input Text    id=${formLogin.inputProfissional}    ${profissional}
    AppiumLibrary.Input Text    id=${formLogin.inputSenha}    ${senha}
    AppiumLibrary.Click Element    id=${formLogin.btnEntrar}

Realizar login no app
    [Documentation]    Esta keyowrd deve ser utilizada para realizar login no app Android após a primeira sincronização já ter sido realizada.
    
    AppiumLibrary.Wait Until Element Is Visible    ${formLogin.inputProfissional}    ${30}
    ${login}=    AppiumLibrary.Get Text    id=${formLogin.inputProfissional}
    IF  '${login}' == '${profissional}'
        Log To Console    \nProfissional logado é o correto.
    ELSE    
        Log To Console    \nProfissional logado está diferente do profissional utilizado na sync.
        Fail
    END
    
    AppiumLibrary.Input Text    id=${formLogin.inputSenha}    ${senha}
    AppiumLibrary.Click Element    id=${formLogin.btnEntrar}

    Sleep    1s
    ${activity}=    AppiumLibrary.Get Activity
    IF  '${activity}' == '${activityMenuPrincipal}'
        Log To Console    Login realizado com sucesso.
    ELSE
        Log To Console    Activity do menu principal não foi encontrada.
        Fail
    END
    