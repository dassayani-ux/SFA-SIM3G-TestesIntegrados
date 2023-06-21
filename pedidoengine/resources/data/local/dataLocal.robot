*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar local.

*** Variables ***
${LOCAL_CLIENTE_SQL}    select p.idlocal from parceirolocal p where idparceiro =
${DESCRICAO_LOCAL_SQL}    select descricao from local where idlocal =
