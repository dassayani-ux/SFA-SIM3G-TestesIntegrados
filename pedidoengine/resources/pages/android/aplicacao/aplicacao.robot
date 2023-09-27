*** Settings ***
Documentation    Arquivo utilizado para realizar a abertura da aplicação Android no aparelho configurado.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/variables/android/global/globalVariables.robot

*** Keywords ***
Abrir aplicativo
    Open Application    ${capabilities.urlAppium}
    ...                 automationName=${capabilities.automationName}
    ...                 platformName=${capabilities.platformName}
    ...                 deviceName=${capabilities.deviceName}
    ...                 app=${capabilities.app}
    ...                 udid=${capabilities.udid}
    ...                 autoGrantPermissions=${capabilities.autoGrantPermissions} 
    ...                 appWaitActivity=${capabilities.appWaitActivity}
    ...                 noReset=${capabilities.noReset}