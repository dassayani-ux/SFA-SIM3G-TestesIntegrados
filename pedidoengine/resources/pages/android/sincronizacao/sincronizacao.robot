*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords utilizadas no processo de sincronização do app Android.

Resource    ${EXECDIR}/pedidoengine/resources/lib/android/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/sincronizacao/syncLocators.robot
Variables    ${EXECDIR}/pedidoengine/libraries/variables/sfa_variables.py

*** Keywords ***
Realizar primeira sincronizacao
    [Documentation]    Utilizada para realizar a primeira sync no app Android.
    
    AppiumLibrary.Wait Until Page Contains    ${msgSyncInicial.txtMsg}
    AppiumLibrary.Click Element    id=${msgSyncInicial.btnDigitar}
    AppiumLibrary.Wait Until Element Is Visible    id=${inputServer}
    AppiumLibrary.Input Text    id=${inputServer}    ${sync_mobile.ipServer}
    AppiumLibrary.Wait Until Element Is Visible    id=${btnSincronizar}
    AppiumLibrary.Click Element    id=${btnSincronizar}

    AppiumLibrary.Wait Until Element Is Visible    xpath=${msgSyncFinalizada.locatorMsg}    timeout=600    #10 minutos
    AppiumLibrary.Element Should Contain Text    xpath=${msgSyncFinalizada.locatorMsg}    ${msgSyncFinalizada.msg}
    AppiumLibrary.Click Element    id=${msgSyncFinalizada.btnOk}
    # Sleep    1s
    # AppiumLibrary.Element Should Contain Text    xpath=${msgSyncFinalizada.locatorMsg}    ${msgSyncFinalizada.msgReaberturaApp}
    # AppiumLibrary.Click Element    id=${msgSyncFinalizada.btnOk}