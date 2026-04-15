*** Settings ***
Documentation    Arquivo utilizado para armazenar os testes que envolvem cliente no Android.
...              Cobre: cadastro de novo cliente, filtro de clientes, navegação 360° e pedido.

Resource    ${EXECDIR}/pedidoengine/resources/pages/android/login/login.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/menu/menuAndroid.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/aplicacao/aplicacao.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/sincronizacao/sincronizacao.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/cliente/listagemClienteAndroidResources.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/cliente/tela360ClienteAndroid.Resources.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/android/cliente/novoClienteAndroidResource.robot
Resource    ${EXECDIR}/pedidoengine/resources/database/conectionDatabase.robot

Suite Setup    Run Keywords
...    Conecta ao banco de dados
...    AND    Abrir aplicativo
...    AND    Realizar login no app

Suite Teardown    Disconnect From Database

*** Test Cases ***
Teste 001 ::: Cadastrar novo cliente pelo app
    [Documentation]    Abre o menu de opções na listagem de clientes, cria um novo cliente
    ...                Jurídico com dados de automação, preenche Dados, Complemento, Local
    ...                (Dados + Complemento) e grava via "Gravar e sair".
    Acessar a guia de clientes no menu
    Cadastrar novo cliente android

Teste 002 ::: Lançar pedido pela tela 360° do cliente
    [Documentation]    Acessa a listagem de clientes, filtra um cliente aleatório via pesquisa
    ...                avançada, abre a tela 360°, inicia atendimento e lança um novo pedido.
    [Setup]    Run Keywords
    ...    Voltar para tela principal se necessario
    ...    AND    Acessar a guia de clientes no menu
    Filtrar cliente por razao social e Matricula e selecionar
    Iniciar atendimento tela 360
    Iniciar novo pedido tela 360
    Finalizar atendimento tela 360