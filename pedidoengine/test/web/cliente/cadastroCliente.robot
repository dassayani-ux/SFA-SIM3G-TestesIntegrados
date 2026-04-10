*** Settings ***
Documentation    Arquivo utilizado para armazenar os testes relativos a cadastro de clientes.
Resource         ${EXECDIR}/pedidoengine/resources/base_web.robot

Suite Setup      Run Keywords    Conecta ao banco de dados
...              AND             Configura parametros padroes do sistema
...              AND             Abre navegador
...              AND             Realiza login na plataforma web

Suite Teardown   Disconnect From Database

*** Test Cases ***
Teste 001 ::: Valida campos obrigatórios cadastro cliente
    [Documentation]    DTSFASAPP-T59: Tenta gravar cadastro vazio e valida mensagens de erro.
    Acessa tela de cadastro de cliente
    Valida campos obrigatorios do cliente

Teste 002 ::: Cadastro de cliente Pessoa Jurídica
   [Documentation]    DTSFASAPP-T76: Realiza o fluxo completo de cadastro de PJ e valida no BD.
   Acessa tela de cadastro de cliente
   Cadastra cliente juridico
   Valida cliente no banco de dados

Teste 003 ::: Cadastro de cliente Pessoa Física com Contato
    [Documentation]    Fluxo E2E importado do Cypress: Cria PF, insere contato e valida no BD.
    Acessa tela de cadastro de cliente
    Cadastra cliente fisico

Teste 004 ::: Edição de cliente - altera homepage
    [Documentation]    DTSFASAPP-T1130: Pesquisa um cliente, edita o homepage e valida gravação com sucesso.
    Acessa listagem de clientes
    Pesquisa e edita cliente    automação
    Edita homepage do cliente    www.google.com.br
    Valida gravacao com sucesso

Teste 005 ::: Cadastro de Cliente - Adição de Anexo
   [Documentation]    DTSFASAPP-T1135: Fluxo completo de anexos em 3 partes.
   ...                Setup: limpa anexos anteriores no BD.
   ...                Parte 1 - Upload de imagem e gravação (mantém arquivo).
   ...                Parte 2 - Seleciona e remove o arquivo da Parte 1.
   ...                Parte 3 - Upload individual de imagem e PDF (gravação separada),
   ...                          valida 2 registros na grid ao final.
   Prepara dados para teste de anexo
   Acessa listagem de clientes
   Pesquisa e edita cliente por nome de banco de anexo
   Parte 1 Adiciona imagem ao cliente
   Parte 2 Remove anexo do cliente
   Parte 3 Upload multiplo de anexos

Teste 006 ::: Cadastro de Cliente - Adição de Logotipo
    [Documentation]    DTSFASAPP-T1136: Busca cliente no BD, limpa logotipo anterior,
    ...                faz upload via UI e valida gravação na tabela parceiroimagem.
    Prepara dados para teste de logotipo
    Acessa listagem de clientes
    Pesquisa e edita cliente por nome de banco de logotipo
    Adiciona logotipo ao cliente
    Valida logotipo gravado no banco

Teste 007 ::: Edição de Cliente - Adicionar Novo Local
    [Documentation]    DTSFASAPP-T1134: Busca cliente no BD, acessa edição e adiciona
    ...                novo local via popup, validando mensagem de sucesso.
    Prepara dados para teste de novo local
    Acessa listagem de clientes
    Pesquisa e edita cliente    ${nome_parceiro_novo_local}
    Adiciona novo local ao cliente
    Valida novo local adicionado com sucesso

Teste 008 ::: Cadastro de Cliente - Inativar na tela e validar no Banco
    [Documentation]    DTSFASAPP-T1131: Reativa cliente no BD, acessa edição,
    ...                inativa via UI (rdAtivonao) e valida idnativo=0 no banco.
    Prepara dados para teste de inativacao
    Acessa listagem de clientes
    Pesquisa e edita cliente    ${nome_parceiro_inativacao}
    Inativa cliente na tela
    Valida cliente inativo no banco