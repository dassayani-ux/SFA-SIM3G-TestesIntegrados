*** Settings ***


Resource    ../resources/pedidoResources.robot
Resource    ../resources/loginResources.robot
Resource    ../variables/globalVariables.robot

Default Tags      Pedido

*** Test Cases ***

Caso de teste 01: Abrir navegador 
    [Documentation]    Caso de teste, abrindo o CRM 
    
    Abrir navegador chrome

caso de teste 02: Realizar o login
    [Documentation]    Caso de teste, Realizar Login 
    
    Realizar login

caso de teste 03: Acessar a tela de pedido
    [Documentation]    Caso de teste, acessar tela de pedido
    
    entrar em vendas
    cabeçalho pedido

Caso de teste 04: Adicionar produtos ao pedido
    [Documentation]    Caso de teste, adicionar produtos
    
    produtos
    adicionar produtos

Caso de teste 05: Finalizar Pedido
    [Documentation]    Caso de teste, finalizar pedido e navegador
    finalizar pedido
    Fechar navegador