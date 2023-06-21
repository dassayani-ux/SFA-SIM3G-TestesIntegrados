*** Settings ***
  
Library    DatabaseLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot

*** Keywords ***


Consultar idOperacaoSegmento na tabela operacaoSegmento, buscando pelo idSegmento e idOperacao 
    [Arguments]     ${CODIGO_SEGMENTO}    ${SGL_OPERACAO}

    Connect
    ${Query}      Catenate     select * from operacaoSegmento where idSegmento in (select idSegmento from segmento where codigo ='${CODIGO_SEGMENTO}') 
    ...    and idOperacao in (select idoperacao from operacao where sglTipoOperacao = '${SGL_OPERACAO}');
    ${responseQuery}    Query    selectStatement=${Query}
    [Return]    ${responseQuery[0][0]} 
    Disconnect


Deletar registro da tabela operacaoSegmento
    [Arguments]     ${CODIGO_SEGMENTO}    ${SGL_OPERACAO}

    Connect
    ${Query}      Catenate     delete from operacaoSegmento where idSegmento in (select idSegmento from segmento where codigo ='${CODIGO_SEGMENTO}')
    ...    and idOperacao in (select idoperacao from operacao where sglTipoOperacao = '${SGL_OPERACAO}');
    Execute Sql String    ${Query}
    Disconnect


Inserir registro na tabela operacaoSegmento
    [Arguments]     ${idSegmento}    ${idOperacao}

    Connect
    ${Query}      Catenate     INSERT INTO public.operacaosegmento (idoperacaosegmento, idoperacao, idsegmento, valor, valorminimo, valormaximo, codigoerp, wsversao)
    ...  VALUES(nextval('seqpkoperacaosegmento'), ${idOperacao}, ${idSegmento}, NULL, NULL, NULL, NULL, 75);
    Execute Sql String    ${Query}
    Disconnect