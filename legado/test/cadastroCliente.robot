*** Settings ***


Resource    ../resources/loginResources.robot
Resource    ../variables/globalVariables.robot
Resource    ../resources/cadastroClienteResources.robot

Default Tags      Cadastro Cliente

*** Test Cases ***

Caso de teste 01: Abrir navegador 
    [Documentation]    Caso de teste, abrindo o CRM 
    [Tags]    Navegador
    Abrir navegador chrome

caso de teste 02: Realizar o login
    [Documentation]    Caso de teste, Realizar Login 
    [Tags]    Login
    Realizar login

Caso de teste 03: Acessar novo Cliente 

    entrar em cliente

Caso de teste 04: Preenchimento de dados na aba geral

    cadastro cliente geral

Caso de teste 05: Preenchimento de dados na aba complemento

    cadastro cliente complemento

Caso de teste 06: Preenchimento de dados na aba informações adicionais

    cadastro cliente informações adicionais

Caso de teste 07: Preenchimento de dados na aba geral (local)

    cadastro cliente geral local

Caso de teste 08: Preenchimento de dados na aba documentos de identificação

    cadastro cliente documentos de identificação

Caso de teste 09: Preenchimento de dados na complemento (local)

    cadastro cliente complemento local

Caso de teste 10: Gravar cadastro de cliente

   gravar cadastro
   Fechar navegador
