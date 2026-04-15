*** Settings ***
Documentation    Arquivo central para importar todas as dependências da automação Web.

# 1. Bibliotecas Globais
Library    SeleniumLibrary    screenshot_root_directory=${EXECDIR}/Prints de teste
Library    DatabaseLibrary

# 2. Variáveis de Ambiente
Variables  ../libraries/variables/sfa_variables.py

# 3. Conexão com Banco
Resource   database/conectionDatabase.robot

# 4. Importação das Pages (Motores e Mapas)
Resource   pages/web/navegador/navegadorResources.robot
Resource   pages/web/login/loginResources.robot
Resource   pages/web/cliente/cadastroClienteResource.robot
Resource   pages/web/cliente/listagemClientesResource.robot
Resource   pages/web/cadastro/cadastroProfissionalResource.robot