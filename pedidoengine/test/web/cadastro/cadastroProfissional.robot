*** Settings ***
Documentation    Testes de Cadastro de Profissional no SFA Web.
...              Cobre: criação completa com hierarquia, carteira e filiais.
...
...              Pré-requisito: banco de dados acessível e usuário admin configurado.
...              Após execução, ${PROF_AUTO_LOGIN} fica disponível como Suite Variable
...              para reutilização nos testes Android.

Resource    ${EXECDIR}/pedidoengine/resources/base_web.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/cadastro/cadastroProfissionalResource.robot

Suite Setup     Run Keywords
...             Conecta ao banco de dados
...             AND    Abre navegador
...             AND    Realiza login na plataforma web

Suite Teardown  Run Keywords
...             Disconnect From Database
...             AND    Close Browser

*** Test Cases ***
Teste 001 ::: Cadastrar profissional com hierarquia, carteira e filiais
    [Documentation]    DTSFASAPP-T1231: Cria um profissional de automação com dados aleatórios,
    ...                grava o cadastro principal e vincula Hierarquia (admin), Carteira de Clientes
    ...                (clientes 'automacao') e Filiais (todas disponíveis).
    ...                Ao final valida a persistência no banco de dados.

    Cadastrar profissional automacao completo
    Valida profissional no banco de dados
