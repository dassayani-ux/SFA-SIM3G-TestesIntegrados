#### seção de dados de teste || cabeçalho de seção   ####
*** Settings ***
Documentation     global variables android
Library           AppiumLibrary

*** Variables ***


*** Keywords ***

abrir aplicativo
    Open Application    http://localhost:4723/wd/hub
    ...                 automationName=UiAutomator2
    ...                 platformName=Android
    ...                 noReset=false
    ...                 deviceName=teste
    ...                 app=${EXECDIR}\\app\\TOTVS CRMSFA.apk
    ...                 udid=emulator-5554

