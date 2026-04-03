*** Settings ***
Documentation    Arquivo central para importar todas as dependências da automação Web.

# 1. Bibliotecas Globais
Library    SeleniumLibrary
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