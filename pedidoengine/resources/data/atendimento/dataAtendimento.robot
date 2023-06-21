*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar atendimentos.

*** Variables ***
${TIPO_ATENDIMENTO_SQL}    select descricao from tipoatendimento t where idnativo = 1 and (tipoautenticacao = 0 or tipoautenticacao is null)

${JUSTIFICATIVA_SQL}    select descricao from tipojustificativa where idnativo = 1

${PROXIMO_ATENDIMENTO_SQL}    select max(idatendimento)+1 from atendimento

${ULTIMO_ATENDIMENTO_SQL}    select max(idatendimento) from atendimento    

${DATA_HORA_FIM_SQL}    select datafim, horafim from atendimento where idatendimento =