*** Settings ***
# Test Setup          Abrir navegador chrome
# Test Teardown       Fechar navegador

Resource    ../../../resources/pages/web/login/loginResources.robot
Resource    ../../../resources/pages/web/cliente/cadastroClienteResources.robot
Resource    ../../../resources/pages/web/cliente/editarClienteResource.robot
Resource    ../../../resources/pages/web/cliente/listagemClientesResource.robot
Resource    ../../../resources/data/dados_pedido.robot
Resource    ../../../resources/variables/web/cliente/ajustesVinculosLocal.robot
Resource    ../../../resources/variables/web/cliente/ajustesParceiro.robot


Default Tags      Cadastro Cliente

*** Test Cases ***

Caso de teste 01: Abrir navegador 
    [Documentation]    Caso de teste, abrindo a aplicação Web 
    [Tags]    Navegador
    Abrir navegador Chrome

caso de teste 02: Realizar o login Admin
    [Documentation]    Caso de teste, Realizar Login 
    [Tags]    Login
    Realizar login    admin

Caso de teste: Acessar novo Cliente 

    entrar em cliente

Caso de teste: Preenchimento de dados na aba geral

    cadastro cliente geral

Caso de teste: Preenchimento de dados na aba complemento

    cadastro cliente complemento

Caso de teste: Preenchimento de dados na aba geral (local)

    cadastro cliente geral local

Caso de Teste: cadastro Preenchimento dos documentos de identificação

   cadastro cliente documentos de identificação

Caso de teste: Gravar cadastro de cliente

   gravar cadastro