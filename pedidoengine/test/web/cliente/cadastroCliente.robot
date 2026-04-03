*** Settings ***
Documentation    Arquivo utilizado para armazenar os testes relativos a cadastro de clientes.
Resource         ${EXECDIR}/pedidoengine/resources/base_web.robot

# Setup elegante: Banco -> Padronização -> Navegador -> Login
Suite Setup      Run Keywords    Conecta ao banco de dados
...              AND             Configura parametros padroes do sistema
...              AND             Abre navegador
...              AND             Realiza login na plataforma web

Suite Teardown   Disconnect From Database

*** Test Cases ***
# Teste 001 ::: Valida campos obrigatórios cadastro cliente
#     [Documentation]    DTSFASAPP-T59
#     Acessa tela de cadastro de cliente
#     Valida campos obrigatorios do cliente

Teste 002 ::: Cadastro de cliente Pessoa Jurídica
    [Documentation]    DTSFASAPP-T76: Realiza o fluxo completo de cadastro de PJ e valida no BD.
    Acessa tela de cadastro de cliente
    Cadastra cliente juridico
    Valida cliente no banco de dados

# Teste 003 ::: Valida tipo cobrança cliente
#     [Documentation]    DTSFASAPP-T89
#     Acessa tela de listagem de clientes
#     Ativa pesquisa avancada
#     Valida tipo cobranca padrao

# Teste 004 ::: Cadastro de cliente - todas as incrições estaduais 
#     [Documentation]    DTSFASAPP-T815
#     Cadastra cliente juridico para cada inscrição estadual

Teste 005 ::: Cadastro de cliente Pessoa Física com Contato
    [Documentation]    Fluxo E2E importado do Cypress: Cria PF, insere contato e valida no BD.
    Acessa tela de cadastro de cliente
    Cadastra cliente fisico