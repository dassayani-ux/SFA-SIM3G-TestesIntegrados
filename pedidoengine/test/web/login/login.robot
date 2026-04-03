*** Settings ***
Documentation    Arquivo utilizado para realizar os testes de acesso na plataforma web.

# O nosso arquivo centralizador fazendo o trabalho pesado invisível
Resource         ../../../resources/base_web.robot

Suite Setup      Abre navegador

*** Test Cases ***
Teste 001 ::: Login usuario invalido
    Login com usuario invalido

Teste 002 ::: Login senha Invalida
    Login com senha invalida

Teste 003 ::: Login usuario e senha invalidos
    Login com usuario e senha invalidos

Teste 004 ::: Login valido e Logoff
    Realiza login na plataforma web
    Sleep    2s
    Realizar logoff
    Sleep    3s