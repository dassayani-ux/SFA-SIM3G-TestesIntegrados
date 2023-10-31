*** Settings ***
Documentation    Arquivo utilizado para realizar a abertura da aplicação Android no aparelho configurado.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Variables    ${EXECDIR}/libraries/variables/sfa_variables.py

*** Keywords ***
Abrir aplicativo
    Open Application    ${capabilities_mobile.urlAppium}
    ...                 automationName=${capabilities_mobile.automationName}
    ...                 platformName=${capabilities_mobile.platformName}
    ...                 deviceName=${capabilities_mobile.deviceName}
    ...                 app=${capabilities_mobile.app}
    ...                 udid=${capabilities_mobile.udid}
    ...                 autoGrantPermissions=${capabilities_mobile.autoGrantPermissions} 
    ...                 appWaitActivity=${capabilities_mobile.appWaitActivity}
    ...                 noReset=${capabilities_mobile.noReset}