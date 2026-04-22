*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar pedido.

Library    DatabaseLibrary
Library    Collections

*** Variables ***
${itensTabelaPreco_SQL}    select p.idproduto, p.codigo, p.descricao, tpp.preco 
    ...    from tabelaprecoproduto tpp 
    ...    join tabelapreco tp on tp.idtabelapreco = tpp.idtabelapreco and tp.idnativo = 1
    ...    join produto p on p.idproduto = tpp.idproduto and p.idnativo = 1
    ...    where tp.idtabelapreco = 

${sqlPesquisaCabecalhoTipoCobranca}    select nivel.idwsconfigpedidonivel, nivel.idnativo
    ...    from wsconfigpedidocampo campo
    ...    inner join wsconfigpedidonivel nivel on nivel.idwsconfigpedidocampo = campo.idwsconfigpedidocampo
    ...    where campo.contexto = 'CABECALHO' 
    ...    and campo.nomeentidade = 'TIPO_COBRANCA' 
    ...    and campo.idnativo = 1

${sqlUltimoPedidoNF}    select cast(p.numeropedido as integer) from pedido p
    ...    inner join tiposituacaopedido tp on tp.idtiposituacaopedido = p.idtiposituacaopedido
    ...    where tp.sgltiposituacaopedido = 'NF'
    ...    and p.numeropedido ~ '^[0-9]+$'
    ...    order by p.datapedido desc, cast(p.numeropedido as integer) desc
    ...    limit 1

${sqlUltimoPedido}    select p.numeropedido from pedido p order by p.datapedido desc, p.numeropedido desc limit 1

*** Keywords ***
Configura padrao cabecalho pedido
    [Documentation]    Garante que a configuração do cabeçalho do pedido esteja no estado padrão
    ...                esperado pelos testes automatizados, independente do banco de dados usado.
    ...                Campos ativos/obrigatórios: PROFISSIONAL, FILIAL_VENDA, CLIENTE, LOCAL,
    ...                TIPO_PEDIDO, TABELA_PRECO, CONDICAO_PAGAMENTO.
    ...                Todos os outros campos ficam inativos (idnativo=0).
    ${sql}=    Catenate    SEPARATOR=\n
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='TABELA_PRECO', label='standard.pedidoconfig.campo.lbl.tabelapreco', idnativo=1, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=1, idnunion=0, idnexiberelatorio=1, ordem=50, codigoerp=NULL, wsversao=167, sglordenacao=NULL WHERE idwsconfigpedidocampo=8;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CONTROLEFLEX', label='standard.pedidoconfig.campo.lbl.flex', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=111, sglordenacao=NULL WHERE idwsconfigpedidocampo=12;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='OPERACAO', label='standard.pedidoconfig.campo.lbl.operacao', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=112, sglordenacao=NULL WHERE idwsconfigpedidocampo=13;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_NUMEROPEDIDOERP', label='standard.pedidoconfig.campo.lbl.numeropedidoerp', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=113, sglordenacao=NULL WHERE idwsconfigpedidocampo=15;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_NUMEROPEDIDOORIGEM', label='standard.pedidoconfig.campo.lbl.numeropedidoorigem', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=114, sglordenacao=NULL WHERE idwsconfigpedidocampo=16;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_NUMERONOTAFISCALORIGEM', label='standard.pedidoconfig.campo.lbl.numeronotafiscalorigem', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=115, sglordenacao=NULL WHERE idwsconfigpedidocampo=18;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_1', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=116, sglordenacao=NULL WHERE idwsconfigpedidocampo=20;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_2', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=117, sglordenacao=NULL WHERE idwsconfigpedidocampo=21;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_3', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=118, sglordenacao=NULL WHERE idwsconfigpedidocampo=22;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_4', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=119, sglordenacao=NULL WHERE idwsconfigpedidocampo=23;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_5', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=120, sglordenacao=NULL WHERE idwsconfigpedidocampo=24;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_6', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=121, sglordenacao=NULL WHERE idwsconfigpedidocampo=25;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='TIPO_DESCONTO', label='standard.pedidoconfig.campo.lbl.tipodesconto', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=122, sglordenacao=NULL WHERE idwsconfigpedidocampo=55;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='TIPO_PRODUTO', label='standard.pedidoconfig.campo.lbl.tipoproduto', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=123, sglordenacao=NULL WHERE idwsconfigpedidocampo=54;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='COMISSAO', label='standard.pedidoconfig.campo.lbl.comissao', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=124, sglordenacao=NULL WHERE idwsconfigpedidocampo=33;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_TIPO_FRETE', label='standard.pedidoconfig.campo.lbl.tipofrete', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=127, sglordenacao=NULL WHERE idwsconfigpedidocampo=31;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_DATA_ENTREGA', label='standard.pedidoconfig.campo.lbl.dataentrega', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=128, sglordenacao=NULL WHERE idwsconfigpedidocampo=30;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_LOCAL_ENTREGA', label='standard.pedidoconfig.campo.lbl.localentrega', idnativo=0, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=275, sglordenacao=NULL WHERE idwsconfigpedidocampo=32;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='LOCAL_COBRANCA', label='standard.pedidoconfig.campo.lbl.localcobranca', idnativo=0, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=1, ordem=100, codigoerp=NULL, wsversao=276, sglordenacao=NULL WHERE idwsconfigpedidocampo=5;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_10', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=129, sglordenacao=NULL WHERE idwsconfigpedidocampo=29;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_9', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=130, sglordenacao=NULL WHERE idwsconfigpedidocampo=28;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_8', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=131, sglordenacao=NULL WHERE idwsconfigpedidocampo=27;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_CAMPO_7', label='standard.pedidoconfig.lbl.nao.implementado', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=132, sglordenacao=NULL WHERE idwsconfigpedidocampo=26;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_DATAPEDIDO', label='standard.pedidoconfig.campo.lbl.datapedido', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=133, sglordenacao=NULL WHERE idwsconfigpedidocampo=19;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='TIPO_COBRANCA', label='standard.pedidoconfig.campo.lbl.tipocobranca', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=134, sglordenacao=NULL WHERE idwsconfigpedidocampo=9;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_NUMEROPEDIDOCLIENTE', label='standard.pedidoconfig.campo.lbl.numeropedidocliente', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=136, sglordenacao=NULL WHERE idwsconfigpedidocampo=14;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='FILIAL_VENDA', label='Estabelecimento', idnativo=1, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=1, idnunion=0, idnexiberelatorio=1, ordem=10, codigoerp=NULL, wsversao=138, sglordenacao=NULL WHERE idwsconfigpedidocampo=3;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CLIENTE', label='standard.pedidoconfig.campo.lbl.cliente', idnativo=1, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=1, idnunion=0, idnexiberelatorio=1, ordem=20, codigoerp=NULL, wsversao=139, sglordenacao=NULL WHERE idwsconfigpedidocampo=2;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='LOCAL', label='standard.pedidoconfig.campo.lbl.local', idnativo=1, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=1, idnunion=0, idnexiberelatorio=1, ordem=30, codigoerp=NULL, wsversao=140, sglordenacao=NULL WHERE idwsconfigpedidocampo=4;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='TIPO_PEDIDO', label='standard.pedidoconfig.campo.lbl.tipopedido', idnativo=1, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=1, idnunion=0, idnexiberelatorio=1, ordem=40, codigoerp=NULL, wsversao=141, sglordenacao=NULL WHERE idwsconfigpedidocampo=10;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='MOEDA', label='standard.pedidoconfig.campo.lbl.moeda', idnativo=0, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=143, sglordenacao=NULL WHERE idwsconfigpedidocampo=76;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='PROFISSIONAL', label='standard.pedidoconfig.campo.lbl.profissional', idnativo=1, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=1, idnunion=0, idnexiberelatorio=1, ordem=1, codigoerp=NULL, wsversao=144, sglordenacao=NULL WHERE idwsconfigpedidocampo=6;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CONDICAO_PAGAMENTO', label='standard.pedidoconfig.campo.lbl.condicaopagamento', idnativo=1, idnvisivel=1, idneditavel=1, idneditavelcomitens=1, idnobrigatorio=1, idnunion=0, idnexiberelatorio=1, ordem=60, codigoerp=NULL, wsversao=145, sglordenacao=NULL WHERE idwsconfigpedidocampo=1;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='SEGMENTO', label='standard.pedidoconfig.campo.lbl.segmento', idnativo=1, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=234, sglordenacao=NULL WHERE idwsconfigpedidocampo=7;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='TIPOLOGIA', label='standard.pedidoconfig.campo.lbl.tipologia', idnativo=1, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=235, sglordenacao=NULL WHERE idwsconfigpedidocampo=11;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='GRUPO_PARCEIRO', label='standard.pedidoconfig.campo.lbl.grupoparceiro', idnativo=1, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=157, sglordenacao=NULL WHERE idwsconfigpedidocampo=52;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='GRUPO_PRODUTO', label='standard.pedidoconfig.campo.lbl.grupoproduto', idnativo=1, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=100, codigoerp=NULL, wsversao=158, sglordenacao=NULL WHERE idwsconfigpedidocampo=53;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='TIPO_ESTOQUE', label='standard.pedidoconfig.campo.lbl.tipoestoque', idnativo=1, idnvisivel=0, idneditavel=0, idneditavelcomitens=1, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=104, codigoerp=NULL, wsversao=159, sglordenacao=NULL WHERE idwsconfigpedidocampo=73;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_NUMEROPEDIDUSUARIO', label='Nº Pedido Vendedor', idnativo=0, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=70, codigoerp=NULL, wsversao=163, sglordenacao=NULL WHERE idwsconfigpedidocampo=17;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CABECALHO_DATAPREVISTAFATURAMENTO', label='standard.pedidoconfig.campo.lbl.dataprevistafaturamento', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=105, codigoerp=NULL, wsversao=245, sglordenacao=NULL WHERE idwsconfigpedidocampo=70;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='AGRUPADOR_CONFIG', label='standard.pedidoconfig.campo.lbl.agrupadorconfig', idnativo=0, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=0, codigoerp=NULL, wsversao=260, sglordenacao=NULL WHERE idwsconfigpedidocampo=88;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='CULTURA', label='standard.pedidoconfig.campo.lbl.cultura', idnativo=0, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=0, codigoerp=NULL, wsversao=261, sglordenacao=NULL WHERE idwsconfigpedidocampo=89;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='SAFRA', label='standard.pedidoconfig.campo.lbl.safra', idnativo=0, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=0, codigoerp=NULL, wsversao=262, sglordenacao=NULL WHERE idwsconfigpedidocampo=90;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='COTACAO_INDEXADOR', label='standard.pedidoconfig.campo.lbl.cotacao.indexador', idnativo=0, idnvisivel=0, idneditavel=0, idneditavelcomitens=0, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=0, codigoerp=NULL, wsversao=264, sglordenacao=NULL WHERE idwsconfigpedidocampo=92;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='MOEDAORIGEM', label='standard.pedidoconfig.campo.lbl.moeda.origem', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=1, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=0, codigoerp=NULL, wsversao=270, sglordenacao=NULL WHERE idwsconfigpedidocampo=98;
    ...    UPDATE public.wsconfigpedidocampo SET contexto='CABECALHO', nomeentidade='REGIAO', label='REGIAO', idnativo=0, idnvisivel=1, idneditavel=1, idneditavelcomitens=1, idnobrigatorio=0, idnunion=0, idnexiberelatorio=0, ordem=0, codigoerp=NULL, wsversao=271, sglordenacao=NULL WHERE idwsconfigpedidocampo=99;
    DatabaseLibrary.Execute Sql String    ${sql}
    Log To Console    \n✅ Configuração padrão de cabeçalho de pedido aplicada (38 campos atualizados).

Configura padrao filtros pedido
    [Documentation]    Garante que a configuração de filtros do pedido (wsconfigpedidofiltro) esteja
    ...                no estado padrão esperado pelos testes automatizados, independente do banco usado.
    ${sql}=    Catenate    SEPARATOR=\n
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=6, idwsconfigpedidotipofiltro=NULL, fieldname='HIERARQUIA_USUARIOLOGADO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=1 WHERE idwsconfigpedidofiltro=1;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=6, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=2, operador=3, codigoerp=NULL, wsversao=2 WHERE idwsconfigpedidofiltro=2;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDUSUARIOPROFISSIONAL', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=3 WHERE idwsconfigpedidofiltro=4;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=0, ordem=2, operador=0, codigoerp=NULL, wsversao=6 WHERE idwsconfigpedidofiltro=16;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PARCEIRO_IDPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=7 WHERE idwsconfigpedidofiltro=15;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='TABELAPRECO_IDTABELAPRECO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=8 WHERE idwsconfigpedidofiltro=22;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=49, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=1, operador=3, codigoerp=NULL, wsversao=9 WHERE idwsconfigpedidofiltro=26;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=37, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=1, operador=3, codigoerp=NULL, wsversao=14 WHERE idwsconfigpedidofiltro=48;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=37, idwsconfigpedidotipofiltro=NULL, fieldname='IDNPADRAO', valordefault='1', idnativo=1, idnvalornull=0, ordem=2, operador=3, codigoerp=NULL, wsversao=15 WHERE idwsconfigpedidofiltro=49;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCALFILIAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=16 WHERE idwsconfigpedidofiltro=53;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=10, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=1, operador=3, codigoerp=NULL, wsversao=17 WHERE idwsconfigpedidofiltro=55;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=10, idwsconfigpedidotipofiltro=NULL, fieldname='IDNPADRAO', valordefault='1', idnativo=1, idnvalornull=0, ordem=2, operador=3, codigoerp=NULL, wsversao=18 WHERE idwsconfigpedidofiltro=56;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='TIPOPEDIDO_IDTIPOPEDIDO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=19 WHERE idwsconfigpedidofiltro=57;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='TIPOPEDIDO_IDTIPOPEDIDO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=20 WHERE idwsconfigpedidofiltro=59;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=1, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=1, operador=3, codigoerp=NULL, wsversao=21 WHERE idwsconfigpedidofiltro=60;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=1, idwsconfigpedidotipofiltro=NULL, fieldname='IDNPADRAO', valordefault='1', idnativo=1, idnvalornull=0, ordem=2, operador=3, codigoerp=NULL, wsversao=22 WHERE idwsconfigpedidofiltro=61;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=23 WHERE idwsconfigpedidofiltro=64;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PARCEIRO_IDPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=2, operador=0, codigoerp=NULL, wsversao=24 WHERE idwsconfigpedidofiltro=65;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=39, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=1, operador=3, codigoerp=NULL, wsversao=25 WHERE idwsconfigpedidofiltro=67;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PARCEIRO_IDPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=27 WHERE idwsconfigpedidofiltro=69;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=0, ordem=2, operador=0, codigoerp=NULL, wsversao=28 WHERE idwsconfigpedidofiltro=70;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='SGLTIPOLIMITECREDITO', valordefault='LCP', idnativo=1, idnvalornull=0, ordem=1, operador=15, codigoerp=NULL, wsversao=29 WHERE idwsconfigpedidofiltro=71;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=2, operador=3, codigoerp=NULL, wsversao=30 WHERE idwsconfigpedidofiltro=72;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=50, idwsconfigpedidotipofiltro=NULL, fieldname='TABELAPRECO_IDTABELAPRECO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=31 WHERE idwsconfigpedidofiltro=75;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=8, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=1, operador=3, codigoerp=NULL, wsversao=32 WHERE idwsconfigpedidofiltro=18;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=8, idwsconfigpedidotipofiltro=NULL, fieldname='VIGENCIA', valordefault='', idnativo=1, idnvalornull=0, ordem=2, operador=0, codigoerp=NULL, wsversao=33 WHERE idwsconfigpedidofiltro=19;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=3, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=1, operador=3, codigoerp=NULL, wsversao=34 WHERE idwsconfigpedidofiltro=95;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCALFILIAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=0, ordem=2, operador=0, codigoerp=NULL, wsversao=35 WHERE idwsconfigpedidofiltro=89;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='VIGENCIA', valordefault='', idnativo=1, idnvalornull=0, ordem=3, operador=0, codigoerp=NULL, wsversao=38 WHERE idwsconfigpedidofiltro=23;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCALFILIAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=39 WHERE idwsconfigpedidofiltro=119;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCALFILIAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=40 WHERE idwsconfigpedidofiltro=120;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDREGIAO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=41 WHERE idwsconfigpedidofiltro=121;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDREGIAO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=42 WHERE idwsconfigpedidofiltro=122;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDUNIDADEFEDERATIVA', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=43 WHERE idwsconfigpedidofiltro=123;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDUNIDADEFEDERATIVA', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=44 WHERE idwsconfigpedidofiltro=124;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDUSUARIOPROFISSIONAL', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=45 WHERE idwsconfigpedidofiltro=125;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDUSUARIOPROFISSIONAL', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=46 WHERE idwsconfigpedidofiltro=126;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PARCEIRO_IDPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=47 WHERE idwsconfigpedidofiltro=129;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PARCEIRO_IDPARCEIRO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=48 WHERE idwsconfigpedidofiltro=130;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=49 WHERE idwsconfigpedidofiltro=131;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=50 WHERE idwsconfigpedidofiltro=132;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDPRODUTO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=51 WHERE idwsconfigpedidofiltro=136;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDPRODUTO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=52 WHERE idwsconfigpedidofiltro=137;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='TABELAPRECO_IDTABELAPRECO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=53 WHERE idwsconfigpedidofiltro=138;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='TABELAPRECO_IDTABELAPRECO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=54 WHERE idwsconfigpedidofiltro=139;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='CONDICAOPAGAMENTO_IDCONDICAOPAGAMENTO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=55 WHERE idwsconfigpedidofiltro=140;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='CONDICAOPAGAMENTO_IDCONDICAOPAGAMENTO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=56 WHERE idwsconfigpedidofiltro=141;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDPERFIL_USUARIOPROFISSIONAL', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=57 WHERE idwsconfigpedidofiltro=142;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDPERFIL_USUARIOPROFISSIONAL', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=58 WHERE idwsconfigpedidofiltro=143;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDTIPOPEDIDO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=59 WHERE idwsconfigpedidofiltro=146;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDTIPOPEDIDO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=60 WHERE idwsconfigpedidofiltro=147;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='CLASSIFICACAOPARCEIRO_IDCLASSIFICACAOPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=61 WHERE idwsconfigpedidofiltro=150;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='CLASSIFICACAOPARCEIRO_IDCLASSIFICACAOPARCEIRO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=62 WHERE idwsconfigpedidofiltro=151;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDGRUPOUSUARIO_PROFISSIONAL', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=63 WHERE idwsconfigpedidofiltro=145;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDCIDADE', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=64 WHERE idwsconfigpedidofiltro=148;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDCIDADE', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=65 WHERE idwsconfigpedidofiltro=149;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDTIPOFRETE', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=66 WHERE idwsconfigpedidofiltro=152;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDTIPOFRETE', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=67 WHERE idwsconfigpedidofiltro=153;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='SEGMENTO_IDSEGMENTO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=68 WHERE idwsconfigpedidofiltro=156;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='SEGMENTO_IDSEGMENTO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=69 WHERE idwsconfigpedidofiltro=157;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDGRUPOUSUARIO_PROFISSIONAL', valordefault='', idnativo=1, idnvalornull=0, ordem=3, operador=0, codigoerp=NULL, wsversao=70 WHERE idwsconfigpedidofiltro=158;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDTIPOESTOQUE', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=71 WHERE idwsconfigpedidofiltro=160;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDTIPOESTOQUE', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=72 WHERE idwsconfigpedidofiltro=161;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDEMBALAGEM', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=73 WHERE idwsconfigpedidofiltro=162;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDEMBALAGEM', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=74 WHERE idwsconfigpedidofiltro=163;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=66, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDPRODUTO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=75 WHERE idwsconfigpedidofiltro=164;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDTIPOPRODUTO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=76 WHERE idwsconfigpedidofiltro=165;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDTIPOPRODUTO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=77 WHERE idwsconfigpedidofiltro=166;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDTIPOLOGIA', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=78 WHERE idwsconfigpedidofiltro=167;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDTIPOLOGIA', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=79 WHERE idwsconfigpedidofiltro=168;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCALFILIAL_IDTIPOLOGIA', valordefault='', idnativo=1, idnvalornull=0, ordem=3, operador=0, codigoerp=NULL, wsversao=80 WHERE idwsconfigpedidofiltro=169;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDTIPOLOGIA', valordefault='', idnativo=1, idnvalornull=0, ordem=5, operador=0, codigoerp=NULL, wsversao=81 WHERE idwsconfigpedidofiltro=171;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCALFILIAL_IDTIPOLOGIA', valordefault='', idnativo=1, idnvalornull=1, ordem=4, operador=0, codigoerp=NULL, wsversao=82 WHERE idwsconfigpedidofiltro=170;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDTIPOLOGIA', valordefault='', idnativo=1, idnvalornull=1, ordem=6, operador=0, codigoerp=NULL, wsversao=83 WHERE idwsconfigpedidofiltro=172;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDTIPOLOGIA', valordefault='', idnativo=1, idnvalornull=0, ordem=7, operador=0, codigoerp=NULL, wsversao=84 WHERE idwsconfigpedidofiltro=173;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDTIPOLOGIA', valordefault='', idnativo=1, idnvalornull=1, ordem=8, operador=0, codigoerp=NULL, wsversao=85 WHERE idwsconfigpedidofiltro=174;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCALFILIAL_IDREGIAO', valordefault='', idnativo=1, idnvalornull=1, ordem=4, operador=0, codigoerp=NULL, wsversao=86 WHERE idwsconfigpedidofiltro=176;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCALFILIAL_IDREGIAO', valordefault='', idnativo=1, idnvalornull=0, ordem=3, operador=0, codigoerp=NULL, wsversao=87 WHERE idwsconfigpedidofiltro=175;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='GRUPOPARCEIRO_IDGRUPOPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=88 WHERE idwsconfigpedidofiltro=180;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='GRUPOPARCEIRO_IDGRUPOPARCEIRO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=89 WHERE idwsconfigpedidofiltro=181;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDGRUPOPRODUTO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=90 WHERE idwsconfigpedidofiltro=182;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDGRUPOPRODUTO', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=91 WHERE idwsconfigpedidofiltro=183;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDLINHA', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=92 WHERE idwsconfigpedidofiltro=188;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PRODUTO_IDLINHA', valordefault='', idnativo=1, idnvalornull=1, ordem=2, operador=0, codigoerp=NULL, wsversao=93 WHERE idwsconfigpedidofiltro=189;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PARCEIRO_IDPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=94 WHERE idwsconfigpedidofiltro=190;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='LOCAL_IDLOCAL', valordefault='', idnativo=1, idnvalornull=0, ordem=2, operador=0, codigoerp=NULL, wsversao=95 WHERE idwsconfigpedidofiltro=191;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='SGLTIPOLOCAL', valordefault='ENT', idnativo=1, idnvalornull=0, ordem=1, operador=15, codigoerp=NULL, wsversao=97 WHERE idwsconfigpedidofiltro=33;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PARCEIRO_IDPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=107 WHERE idwsconfigpedidofiltro=199;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='SGLTIPOLOCAL', valordefault='PRI', idnativo=1, idnvalornull=0, ordem=1, operador=15, codigoerp=NULL, wsversao=108 WHERE idwsconfigpedidofiltro=202;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=4, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=1, operador=3, codigoerp=NULL, wsversao=110 WHERE idwsconfigpedidofiltro=204;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=2, operador=3, codigoerp=NULL, wsversao=111 WHERE idwsconfigpedidofiltro=205;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='PARCEIRO_IDPARCEIRO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=112 WHERE idwsconfigpedidofiltro=207;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDNATIVO', valordefault='1', idnativo=1, idnvalornull=0, ordem=2, operador=3, codigoerp=NULL, wsversao=113 WHERE idwsconfigpedidofiltro=208;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDNPADRAO', valordefault='1', idnativo=1, idnvalornull=0, ordem=3, operador=3, codigoerp=NULL, wsversao=114 WHERE idwsconfigpedidofiltro=211;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=51, idwsconfigpedidotipofiltro=NULL, fieldname='VIGENCIA', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=116 WHERE idwsconfigpedidofiltro=107;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='TIPOPEDIDO_IDTIPOPEDIDO', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=118 WHERE idwsconfigpedidofiltro=219;
    ...    UPDATE public.wsconfigpedidofiltro SET idwsconfigpedidocampo=NULL, idwsconfigpedidotipofiltro=NULL, fieldname='IDUSUARIOPROFISSIONAL', valordefault='', idnativo=1, idnvalornull=0, ordem=1, operador=0, codigoerp=NULL, wsversao=120 WHERE idwsconfigpedidofiltro=222;
    DatabaseLibrary.Execute Sql String    ${sql}
    Log To Console    \n✅ Configuração padrão de filtros de pedido aplicada (80 filtros atualizados).

Retorna idTipoPedido
    [Documentation]    Irá retornar o ID do Tipo Pedido utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idTipoPedido}=    Query    select t.idtipopedido from tipopedido t where t.descricao = '${descricao}' and t.idnativo = 1

    Return From Keyword    ${idTipoPedido[0][0]}

Retorna idTabelaPreco
    [Documentation]    Irá retornar o ID da Tabela de Preço utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idTabelaPreco}=    Query    select t.idtabelapreco from tabelapreco t where t.descricao = '${descricao}' and t.idnativo = 1

    Return From Keyword    ${idTabelaPreco[0][0]}

Retorna idCondicaoPagamento
    [Documentation]    Irá retornar o ID da Condição de Pagamento utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idCondicaoPagamento}=    Query    select c.idcondicaopagamento from condicaopagamento c where c.descricao = '${descricao}' and c.idnativo = 1

    Return From Keyword    ${idCondicaoPagamento[0][0]}

Retorna idTipoCobranca
    [Documentation]    Irá retornar o ID do Tipo de Cobrança utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idTipoCobranca}=    Query    select t.idtipocobranca from tipocobranca t where t.idnativo = 1 and t.descricao = '${descricao}'

    Return From Keyword    ${idTipoCobranca[0][0]}

Retorna quantidade de itens da tabela
    [Documentation]    Irá retornar a quantidade de produtos presentes na tabela de preço passada no argumento *tabelaPreco*;
    [Arguments]    ${tabelaPreco}

    ${countTabela}=    Row Count    ${itensTabelaPreco_SQL}${tabelaPreco}

    Return From Keyword    ${countTabela}

Retorna produtos
    [Documentation]    Irá retornar o(s) código(s) do(s) produto(s) presente(s) na lista \@{lista}.
    ...    \nEspera-se que seja passada uma lista como argumento.
    [Arguments]    @{lista}    ${tabelaPreco}

    @{listaAux}=    Set Variable    @{lista}
    FOR  ${element}  IN    @{lista}
        Remove Values From List    ${lista}    ${element}
    END
    ${lenght}=    Get Length    ${listaAux}
    ${produtos}=    Query    ${itensTabelaPreco_SQL}${tabelaPreco}

    FOR  ${I}  IN RANGE    ${lenght}
        Append To List    ${lista}    ${produtos[${listaAux[${I}]}][1]}
    END

    Return From Keyword    @{lista}

Validar parceiro do pedido
    [Documentation]    Irá validar se o parceiro do pedido salvo no banco de dados está de acordo com o argumento *idParceiro*.
    [Arguments]    ${numeroPedido}    ${idParceiro}

    ${data}    Query    select idparceiro from pedido where numeropedido = '${numeroPedido}'
    Should Be Equal As Strings    ${data[0][0]}    ${idParceiro}
    ...    Parceiro diverge no pedido ${numeroPedido}: esperado ${idParceiro}, banco retornou ${data[0][0]}

Validar local do pedido
    [Documentation]    Irá validar se o localParceiro do pedido salvo no banco de dados está de acordo com o argumento *idLocal*.
    [Arguments]    ${numeroPedido}    ${idLocal}

    ${data}    Query    select idlocal from pedido where numeropedido = '${numeroPedido}'
    Should Be Equal As Strings    ${data[0][0]}    ${idLocal}
    ...    Local diverge no pedido ${numeroPedido}: esperado ${idLocal}, banco retornou ${data[0][0]}

Validar se o pedido consta no banco de dados
    [Documentation]    Verifica se o pedido consta no banco de dados.
    [Arguments]    ${numeroPedido}=None

    IF  '${numeroPedido}' != 'None'
        ${result}    DatabaseLibrary.Check If Exists In Database    select * from pedido where numeropedido = '${numeroPedido}'
        IF  '${result}' == 'None'
            Log To Console    Registro do pedido número ${numeroPedido} encontrado no banco de dados.
        ELSE
            Log To Console    Registro do pedido número ${numeroPedido} não foi encontrado no banco de dados.
            Fail
        END
        
    END

Validar filial do pedido
    [Documentation]    Irá validar se a filial do pedido salva no banco de dados está de acordo com o argumento *idFilial*.
    [Arguments]    ${numeroPedido}    ${idFilial}

    ${data}    Query    select idlocalfilialvenda from pedido where numeropedido = '${numeroPedido}'
    Should Be Equal As Strings    ${data[0][0]}    ${idFilial}
    ...    Filial diverge no pedido ${numeroPedido}: esperado ${idFilial}, banco retornou ${data[0][0]}

Validar tipo do pedido
    [Documentation]    Irá validar se o Tipo do pedido salvo no banco de dados está de acordo com o argumento *idTipoPedido*.
    [Arguments]    ${numeroPedido}    ${idTipoPedido}

    ${data}    Query    select idtipopedido from pedido where numeropedido = '${numeroPedido}'
    Should Be Equal As Strings    ${data[0][0]}    ${idTipoPedido}
    ...    Tipo pedido diverge no pedido ${numeroPedido}: esperado ${idTipoPedido}, banco retornou ${data[0][0]}

Validar tabela de preço
    [Documentation]    Irá validar se a Tabela de preço salva no banco de dados está de acordo com o argumento *idTabelaPreco*.
    [Arguments]    ${numeroPedido}    ${idTabelaPreco}

    ${data}    Query    select idtabelapreco from pedido where numeropedido = '${numeroPedido}'
    Should Be Equal As Strings    ${data[0][0]}    ${idTabelaPreco}
    ...    Tabela de preço diverge no pedido ${numeroPedido}: esperado ${idTabelaPreco}, banco retornou ${data[0][0]}

Validar condicao de pagamento
    [Documentation]    Irá validar se a Condição de pagamento salva no banco de dados está de acordo com o argumento *idCondicaoPagamento*.
    [Arguments]    ${numeroPedido}    ${idCondicaoPagamento}

    ${data}    Query    select idcondicaopagamento from pedido where numeropedido = '${numeroPedido}'
    Should Be Equal As Strings    ${data[0][0]}    ${idCondicaoPagamento}
    ...    Condição de pagamento diverge no pedido ${numeroPedido}: esperado ${idCondicaoPagamento}, banco retornou ${data[0][0]}

Validar tipo cobranca
    [Documentation]    Irá validar se o Tipo de Cobrança salvo no banco de dados está de acordo com o argumento *idTipoCobranca*.
    ...                Validação ignorada quando idTipoCobranca estiver vazio (campo inativo no cabeçalho).
    [Arguments]    ${numeroPedido}    ${idTipoCobranca}

    IF    '${idTipoCobranca}' == '${EMPTY}'
        BuiltIn.Log To Console    ?? Tipo cobrança não está ativo no cabeçalho — validação ignorada.
        RETURN
    END
    ${data}    Query    select idtipocobranca from pedido where numeropedido = '${numeroPedido}'
    Should Be Equal As Strings    ${data[0][0]}    ${idTipoCobranca}
    ...    Tipo cobrança diverge no pedido ${numeroPedido}: esperado ${idTipoCobranca}, banco retornou ${data[0][0]}

Retornar numero ultimo pedido NF
    [Documentation]    Esta keyword retorna o número do último pedido lançado que possui situação = NÃO FINALIZADO.

    ${numeroPedido}    Query    ${sqlUltimoPedidoNF} 

    Log To Console    \nPedido número ${numeroPedido[0][0]}
    Return From Keyword    ${numeroPedido[0][0]} 

Retornar numero ultimo pedido
    [Documentation]    Esta keyword retorna o número do último pedido lançado.

    ${numeroPedido}    Query    ${sqlUltimoPedido} 

    Log To Console    \nPedido número ${numeroPedido[0][0]}
    Return From Keyword    ${numeroPedido[0][0]} 

Retornar informações dos produtos do pedido
    [Documentation]    Esta keyword retorna uma lista contendo informações do pedido de venda.
    [Arguments]    ${numeroPedido}
    
    ${sql}=    Set Variable
    ${sql}    Catenate    SEPARATOR=\n    
    ...    select pro.idproduto, pro.codigo, pp.quantidade, pp.precovenda 
    ...    from pedidoproduto pp
    ...    inner join pedido p on p.idpedido = pp.idpedido
    ...    inner join produto pro on pro.idproduto = pp.idproduto
    ...    where p.numeropedido = '${numeroPedido}'
    ...    order by pp.idproduto

    ${produtos}    Query    ${sql}    return_dict=True
    Return From Keyword    ${produtos}

Retornar situacao do pedido
    [Documentation]    Retorna a sigla do status do pedido passado como argumento.
    [Arguments]    ${numeroPedido}=None

    IF  '${numeroPedido}' != 'None'
        ${sql}=    Set Variable
        ${sql}    Catenate    SEPARATOR=\n
        ...    select tp.sgltiposituacaopedido from pedido p
        ...    inner join tiposituacaopedido tp on tp.idtiposituacaopedido = p.idtiposituacaopedido
        ...    where p.numeropedido = '${numeroPedido}'
    ELSE
        Log To Console    Nenhum pedido foi passado como argumento.
        Fail
    END

    ${situacaoPedido}    Query    ${sql}
    Return From Keyword    ${situacaoPedido[0][0]}

Retornar dados do pedido
    [Documentation]    Esta keyword retorna um dicionário contendo alguns dados do pedido passado como argumento.
    [Arguments]    ${numeroPedido}=None

    IF  '${numeroPedido}' != 'None'
        ${sql}=    Catenate    SEPARATOR=\n
        ...    select p.idparceiro as parceiro, p.idlocal as local, 
        ...    p.idlocalfilialvenda as filial,
        ...    p.idtipopedido as tipoPedido, p.idtabelapreco as tabelaPreco,
        ...    p.idcondicaopagamento as condicaoPagamento,
        ...    p.idtipocobranca as tipoCobranca
        ...    from pedido p where p.numeropedido = '${numeroPedido}'
    ELSE
        Log To Console    Nenhum pedido passado de argumento.
        Fail
    END
    
    ${dadosPedido}    Query    ${sql}    return_dict=True
    Return From Keyword    ${dadosPedido}

Retornar situacao de campo do cabecalho
    [Documentation]    Retorna o valor do campo idnativo para a entidade passada no argumento *entidade*.
    [Arguments]    ${entidade}

    ${sql}=    BuiltIn.Set Variable    select idwsconfigpedidocampo as id, idnativo from wsconfigpedidocampo where contexto = 'CABECALHO' and nomeentidade = '${entidade}' 
    ${situacao}    DatabaseLibrary.Query    selectStatement=${sql}    return_dict=True
    Return From Keyword    ${situacao[0]}

Retornar id parceiro do Pedido
    [Documentation]    Retorna o id do parceiro vinculdo ao pedido passado no argumento *numeroPedido*.
    [Arguments]    ${numeroPedido}

    ${sql}=    BuiltIn.Set Variable    select idparceiro from pedido where numeropedido = '${numeroPedido}'
    ${parceiro}=    DatabaseLibrary.Query    ${sql}

    BuiltIn.Return From Keyword    ${parceiro[0][0]}

Habilita finalizar pedido na listagem
    [Documentation]    Garante que o botão "Finalizar" esteja visível na grid de listagem de pedidos.
    ...                O parâmetro 'sim3g.desabilita.finalizar.listagem.pedido' com valor '1' EXIBE o botão.
    DatabaseLibrary.Execute Sql String
    ...    UPDATE parametro SET valor = '1' WHERE chave = 'sim3g.desabilita.finalizar.listagem.pedido'
    Log To Console    \n✅ Parâmetro finalizar-na-listagem habilitado.

Configura wsconfigpedido no banco
    [Documentation]    Garante que todos os campos e filtros padrão de pedido existam nas tabelas
    ...                wsconfigpedidocampo e wsconfigpedidofiltro com os valores corretos.
    ...                Usa INSERT ... ON CONFLICT DO UPDATE (upsert) — idempotente, seguro para re-execução.
    Log To Console    \n⚙️ Configurando wsconfigpedidocampo (upsert 53 campos)...
    ${sql_campos}=    Catenate    SEPARATOR=\n
    ...    INSERT INTO wsconfigpedidocampo
    ...    (idwsconfigpedidocampo,contexto,nomeentidade,"label",idnativo,idnvisivel,idneditavel,idneditavelcomitens,idnobrigatorio,idnunion,ordem,codigoerp,wsversao,idnexiberelatorio,sglordenacao,sglcomponente)
    ...    VALUES
    ...    (1001,'CABECALHO','CABECALHO_NUMEROPEDIDOCLIENTE','standard.pedidoconfig.campo.lbl.numeropedidocliente',0,1,1,1,0,0,43,NULL,1258,0,NULL,NULL),
    ...    (1002,'CABECALHO','CABECALHO_NUMEROPEDIDOERP','standard.pedidoconfig.campo.lbl.numeropedidoerp',0,1,1,1,0,0,44,NULL,1259,0,NULL,NULL),
    ...    (1003,'CABECALHO','CABECALHO_NUMEROPEDIDOORIGEM','standard.pedidoconfig.campo.lbl.numeropedidoorigem',0,1,1,1,0,0,45,NULL,1260,0,NULL,NULL),
    ...    (1004,'CABECALHO','CABECALHO_NUMEROPEDIDUSUARIO','standard.pedidoconfig.campo.lbl.numeropedidousuario',0,1,1,1,0,0,46,NULL,1261,0,NULL,NULL),
    ...    (1005,'CABECALHO','CABECALHO_NUMERONOTAFISCALORIGEM','standard.pedidoconfig.campo.lbl.numeronotafiscalorigem',0,1,1,1,0,0,47,NULL,1262,0,NULL,NULL),
    ...    (1006,'CABECALHO','CABECALHO_DATAPEDIDO','standard.pedidoconfig.campo.lbl.datapedido',0,1,1,1,0,0,48,NULL,1263,0,NULL,NULL),
    ...    (1010,'CABECALHO','MOEDAORIGEM','standard.pedidoconfig.campo.lbl.moeda.origem',0,0,0,0,0,0,52,NULL,1267,0,NULL,NULL),
    ...    (1012,'CABECALHO','CABECALHO_DATAPREVISTAFATURAMENTO','standard.pedidoconfig.campo.lbl.dataprevistafaturamento',0,0,0,0,0,0,54,NULL,1269,0,NULL,NULL),
    ...    (1017,'CABECALHO','TIPO_PRODUTO','standard.pedidoconfig.campo.lbl.tipoproduto',0,1,1,0,0,0,59,NULL,1274,0,NULL,NULL),
    ...    (1018,'CABECALHO','TIPO_DESCONTO','standard.pedidoconfig.campo.lbl.tipodesconto',0,1,1,0,0,0,60,NULL,1275,0,NULL,NULL),
    ...    (1033,'CABECALHO','TIPO_ESTOQUE','standard.pedidoconfig.campo.lbl.tipoestoque',0,0,0,0,0,0,75,NULL,1290,0,NULL,NULL),
    ...    (1041,'CABECALHO','MOEDA','standard.pedidoconfig.campo.lbl.moeda',0,0,0,0,0,0,83,NULL,1298,0,NULL,NULL),
    ...    (1043,'CABECALHO','AGRUPADOR_CONFIG','standard.pedidoconfig.campo.lbl.agrupadorconfig',0,0,0,0,0,0,85,NULL,1300,0,NULL,NULL),
    ...    (1044,'CABECALHO','CULTURA','standard.pedidoconfig.campo.lbl.cultura',0,0,0,0,0,0,86,NULL,1301,0,NULL,NULL),
    ...    (1045,'CABECALHO','SAFRA','standard.pedidoconfig.campo.lbl.safra',0,0,0,0,0,0,87,NULL,1302,0,NULL,NULL),
    ...    (1047,'CABECALHO','COTACAO_INDEXADOR','standard.pedidoconfig.campo.lbl.cotacao.indexador',0,0,0,0,0,0,89,NULL,1304,0,NULL,NULL),
    ...    (1011,'CABECALHO','OPERACAO','standard.pedidoconfig.campo.lbl.operacao',0,1,1,0,0,0,53,NULL,1268,0,NULL,NULL),
    ...    (1016,'CABECALHO','GRUPO_PRODUTO','standard.pedidoconfig.campo.lbl.grupoproduto',0,1,1,0,0,0,58,NULL,1273,0,NULL,NULL),
    ...    (1009,'CABECALHO','REGIAO','standard.pedidoconfig.campo.lbl.regiao',1,0,0,0,1,0,51,NULL,1431,0,NULL,NULL),
    ...    (1015,'CABECALHO','GRUPO_PARCEIRO','standard.pedidoconfig.campo.lbl.grupoparceiro',1,1,0,0,0,0,57,NULL,1436,1,NULL,NULL),
    ...    (8,'CABECALHO','TABELA_PRECO','standard.pedidoconfig.campo.lbl.tabelapreco',1,1,1,0,1,0,50,NULL,2369,1,NULL,NULL),
    ...    (12,'CABECALHO','CONTROLEFLEX','standard.pedidoconfig.campo.lbl.flex',0,1,1,0,0,0,100,NULL,2370,0,NULL,NULL),
    ...    (13,'CABECALHO','OPERACAO','standard.pedidoconfig.campo.lbl.operacao',0,1,1,0,0,0,100,NULL,2371,0,NULL,NULL),
    ...    (15,'CABECALHO','CABECALHO_NUMEROPEDIDOERP','standard.pedidoconfig.campo.lbl.numeropedidoerp',0,1,1,0,0,0,100,NULL,2372,0,NULL,NULL),
    ...    (16,'CABECALHO','CABECALHO_NUMEROPEDIDOORIGEM','standard.pedidoconfig.campo.lbl.numeropedidoorigem',0,1,1,0,0,0,100,NULL,2373,0,NULL,NULL),
    ...    (18,'CABECALHO','CABECALHO_NUMERONOTAFISCALORIGEM','standard.pedidoconfig.campo.lbl.numeronotafiscalorigem',0,1,1,0,0,0,100,NULL,2374,0,NULL,NULL),
    ...    (20,'CABECALHO','CABECALHO_CAMPO_1','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2375,0,NULL,NULL),
    ...    (21,'CABECALHO','CABECALHO_CAMPO_2','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2376,0,NULL,NULL),
    ...    (22,'CABECALHO','CABECALHO_CAMPO_3','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2377,0,NULL,NULL),
    ...    (23,'CABECALHO','CABECALHO_CAMPO_4','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2378,0,NULL,NULL),
    ...    (24,'CABECALHO','CABECALHO_CAMPO_5','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2379,0,NULL,NULL),
    ...    (25,'CABECALHO','CABECALHO_CAMPO_6','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2380,0,NULL,NULL),
    ...    (33,'CABECALHO','COMISSAO','standard.pedidoconfig.campo.lbl.comissao',0,1,1,0,0,0,100,NULL,2381,0,NULL,NULL),
    ...    (31,'CABECALHO','CABECALHO_TIPO_FRETE','standard.pedidoconfig.campo.lbl.tipofrete',0,1,1,0,0,0,100,NULL,2382,0,NULL,NULL),
    ...    (30,'CABECALHO','CABECALHO_DATA_ENTREGA','standard.pedidoconfig.campo.lbl.dataentrega',0,1,1,0,0,0,100,NULL,2383,0,NULL,'CB'),
    ...    (32,'CABECALHO','CABECALHO_LOCAL_ENTREGA','standard.pedidoconfig.campo.lbl.localentrega',0,0,0,0,0,0,100,NULL,2384,0,NULL,NULL),
    ...    (5,'CABECALHO','LOCAL_COBRANCA','standard.pedidoconfig.campo.lbl.localcobranca',0,0,0,0,0,0,100,NULL,2385,1,NULL,NULL),
    ...    (29,'CABECALHO','CABECALHO_CAMPO_10','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2386,0,NULL,'DT'),
    ...    (28,'CABECALHO','CABECALHO_CAMPO_9','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2387,0,NULL,NULL),
    ...    (27,'CABECALHO','CABECALHO_CAMPO_8','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2388,0,NULL,NULL),
    ...    (26,'CABECALHO','CABECALHO_CAMPO_7','standard.pedidoconfig.lbl.nao.implementado',0,1,1,0,0,0,100,NULL,2389,0,NULL,NULL),
    ...    (19,'CABECALHO','CABECALHO_DATAPEDIDO','standard.pedidoconfig.campo.lbl.datapedido',0,1,1,0,0,0,100,NULL,2390,0,NULL,NULL),
    ...    (9,'CABECALHO','TIPO_COBRANCA','standard.pedidoconfig.campo.lbl.tipocobranca',0,1,1,0,0,0,100,NULL,2391,0,NULL,NULL),
    ...    (14,'CABECALHO','CABECALHO_NUMEROPEDIDOCLIENTE','standard.pedidoconfig.campo.lbl.numeropedidocliente',0,1,1,0,0,0,100,NULL,2392,0,NULL,NULL),
    ...    (3,'CABECALHO','FILIAL_VENDA','Estabelecimento',1,1,1,0,1,0,10,NULL,2393,1,NULL,NULL),
    ...    (2,'CABECALHO','CLIENTE','standard.pedidoconfig.campo.lbl.cliente',1,1,1,0,1,0,20,NULL,2394,1,NULL,NULL),
    ...    (4,'CABECALHO','LOCAL','standard.pedidoconfig.campo.lbl.local',1,1,1,0,1,0,30,NULL,2395,1,NULL,NULL),
    ...    (10,'CABECALHO','TIPO_PEDIDO','standard.pedidoconfig.campo.lbl.tipopedido',1,1,1,0,1,0,40,NULL,2396,1,NULL,NULL),
    ...    (6,'CABECALHO','PROFISSIONAL','standard.pedidoconfig.campo.lbl.profissional',1,1,1,0,1,0,1,NULL,2397,1,NULL,NULL),
    ...    (1,'CABECALHO','CONDICAO_PAGAMENTO','standard.pedidoconfig.campo.lbl.condicaopagamento',1,1,1,1,1,0,60,NULL,2398,1,NULL,NULL),
    ...    (7,'CABECALHO','SEGMENTO','standard.pedidoconfig.campo.lbl.segmento',1,0,0,0,0,0,100,NULL,2399,0,NULL,NULL),
    ...    (11,'CABECALHO','TIPOLOGIA','standard.pedidoconfig.campo.lbl.tipologia',1,0,0,0,0,0,100,NULL,2400,0,NULL,NULL),
    ...    (17,'CABECALHO','CABECALHO_NUMEROPEDIDUSUARIO','Nº Pedido Vendedor',0,0,0,0,0,0,70,NULL,2401,0,NULL,NULL)
    ...    ON CONFLICT (idwsconfigpedidocampo) DO UPDATE SET
    ...    nomeentidade=EXCLUDED.nomeentidade,"label"=EXCLUDED."label",
    ...    idnativo=EXCLUDED.idnativo,idnvisivel=EXCLUDED.idnvisivel,
    ...    idneditavel=EXCLUDED.idneditavel,idneditavelcomitens=EXCLUDED.idneditavelcomitens,
    ...    idnobrigatorio=EXCLUDED.idnobrigatorio,idnunion=EXCLUDED.idnunion,
    ...    ordem=EXCLUDED.ordem,codigoerp=EXCLUDED.codigoerp,wsversao=EXCLUDED.wsversao,
    ...    idnexiberelatorio=EXCLUDED.idnexiberelatorio,
    ...    sglordenacao=EXCLUDED.sglordenacao,sglcomponente=EXCLUDED.sglcomponente;
    DatabaseLibrary.Execute Sql String    ${sql_campos}
    Log To Console    ✅ wsconfigpedidocampo configurado (53 linhas upsert)!

    Log To Console    \n⚙️ Configurando wsconfigpedidofiltro — lote 1/3...
    ${sql_filtros1}=    Catenate    SEPARATOR=\n
    ...    INSERT INTO wsconfigpedidofiltro
    ...    (idwsconfigpedidofiltro,idwsconfigpedidocampo,idwsconfigpedidotipofiltro,fieldname,valordefault,idnativo,idnvalornull,ordem,operador,codigoerp,wsversao)
    ...    VALUES
    ...    (3,28,NULL,'TABELAPRECO_IDTABELAPRECO','',1,0,1,0,NULL,3),
    ...    (6,3,NULL,'IDNATIVO','1',1,0,1,3,NULL,5),
    ...    (7,4,NULL,'IDNATIVO','1',1,0,1,3,NULL,6),
    ...    (8,5,NULL,'IDNATIVO','1',1,0,1,3,NULL,7),
    ...    (10,1,NULL,'IDNATIVO','1',1,0,1,3,NULL,9),
    ...    (11,8,NULL,'IDNATIVO','1',1,0,1,3,NULL,10),
    ...    (12,8,NULL,'VIGENCIAOUSEMVIGENCIA','',1,0,2,0,NULL,11),
    ...    (14,11,NULL,'IDNATIVO','1',1,0,1,3,NULL,13),
    ...    (21,NULL,5,'LOCAL_IDLOCAL','',1,0,1,0,NULL,20),
    ...    (31,NULL,10,'LOCAL_IDLOCAL','',1,0,2,0,NULL,27),
    ...    (33,NULL,NULL,'SGLTIPOLOCAL','ENT',1,0,1,15,NULL,723),
    ...    (34,NULL,13,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,32),
    ...    (35,NULL,14,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,33),
    ...    (39,NULL,15,'IDUSUARIOPROFISSIONAL','',1,0,1,0,NULL,37),
    ...    (43,12,NULL,'FLEX_VIGENCIA','',1,0,2,0,NULL,41),
    ...    (47,NULL,17,'TIPOPARCEIRO_SGLTIPOPARCEIRO','TRA',1,0,1,3,NULL,45),
    ...    (48,37,NULL,'IDNATIVO','1',1,0,1,3,NULL,721),
    ...    (49,37,NULL,'IDNPADRAO','1',1,0,2,3,NULL,722),
    ...    (50,NULL,20,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,86),
    ...    (13,9,NULL,'IDNATIVO','1',0,0,1,3,NULL,142),
    ...    (15,NULL,NULL,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,720),
    ...    (1001,6,NULL,'IDUSUARIOLOGADO','',1,0,1,0,NULL,49),
    ...    (1024,10,NULL,'IDNPADRAO','1',1,0,3,3,NULL,106),
    ...    (1027,31,NULL,'IDNPADRAO','1',1,0,1,3,NULL,87),
    ...    (1037,9,NULL,'IDNPADRAO','1',0,0,2,3,NULL,143),
    ...    (1039,10,NULL,'SGLTIPOPEDIDO','SUFR',1,0,4,4,NULL,107),
    ...    (1041,10,NULL,'IDNATIVO','1',1,0,2,3,NULL,108),
    ...    (1064,28,NULL,'LOCAL_IDUNIDADEFEDERATIVA','',0,0,2,0,NULL,135),
    ...    (1072,NULL,1033,'IDNPADRAO','1',1,0,1,3,NULL,140),
    ...    (1075,NULL,1034,'SGLTIPOLOCAL','UEM#BRO#IND',1,0,1,3,NULL,149),
    ...    (1076,NULL,1036,'SEGMENTO_IDSEGMENTO','',1,0,1,0,NULL,150),
    ...    (1077,NULL,1036,'IDUSUARIOPROFISSIONAL','',1,0,2,0,NULL,146),
    ...    (1080,6,NULL,'IDNATIVO','1',1,0,2,3,NULL,161),
    ...    (1081,NULL,1037,'USUARIO_IDUSUARIO','',0,0,1,0,NULL,181),
    ...    (1082,1046,NULL,'VIGENCIA','',1,0,1,0,NULL,164),
    ...    (1083,1046,NULL,'IDNATIVO','1',0,0,2,3,NULL,184),
    ...    (1091,NULL,1040,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,176),
    ...    (1094,NULL,1037,'GRUPOUSUARIO_IDGRUPOUSUARIO','',1,0,2,0,NULL,180),
    ...    (1120,NULL,1054,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,218),
    ...    (1137,NULL,1058,'CODIGO','OFER',1,0,1,5,NULL,592),
    ...    (1138,NULL,1059,'CONTROLECOTA_IDCONTROLECOTA','',1,0,1,0,NULL,421),
    ...    (1156,NULL,1060,'PRODUTO_IDPRODUTO','',1,0,1,0,NULL,589),
    ...    (1157,NULL,1060,'PRODUTO_FAIXAQUANTIDADE','',0,0,2,0,NULL,461),
    ...    (1158,NULL,1065,'FILIAL_IDLOCAL','',1,0,1,0,NULL,295),
    ...    (1159,NULL,1066,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,296),
    ...    (1160,NULL,1067,'CODIGO','TABPAD',1,0,1,5,NULL,298),
    ...    (1163,NULL,1068,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,0,1,0,NULL,353),
    ...    (1164,NULL,1068,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,354),
    ...    (1167,NULL,1071,'CODIGO','CANAL',1,0,1,3,NULL,356),
    ...    (1169,NULL,1072,'LOCALFILIAL_IDUNIDADEFEDERATIVA','',1,0,2,0,NULL,314)
    ...    ON CONFLICT (idwsconfigpedidofiltro) DO UPDATE SET
    ...    idwsconfigpedidocampo=EXCLUDED.idwsconfigpedidocampo,
    ...    idwsconfigpedidotipofiltro=EXCLUDED.idwsconfigpedidotipofiltro,
    ...    fieldname=EXCLUDED.fieldname,valordefault=EXCLUDED.valordefault,
    ...    idnativo=EXCLUDED.idnativo,idnvalornull=EXCLUDED.idnvalornull,
    ...    ordem=EXCLUDED.ordem,operador=EXCLUDED.operador,
    ...    codigoerp=EXCLUDED.codigoerp,wsversao=EXCLUDED.wsversao;
    DatabaseLibrary.Execute Sql String    ${sql_filtros1}
    Log To Console    ✅ Filtros lote 1/3 configurados!

    Log To Console    \n⚙️ Configurando wsconfigpedidofiltro — lote 2/3...
    ${sql_filtros2}=    Catenate    SEPARATOR=\n
    ...    INSERT INTO wsconfigpedidofiltro
    ...    (idwsconfigpedidofiltro,idwsconfigpedidocampo,idwsconfigpedidotipofiltro,fieldname,valordefault,idnativo,idnvalornull,ordem,operador,codigoerp,wsversao)
    ...    VALUES
    ...    (1170,NULL,1072,'LOCAL_IDUNIDADEFEDERATIVA','',1,0,1,0,NULL,315),
    ...    (1171,NULL,1072,'PRODUTO_IDPRODUTO','',1,0,3,0,NULL,316),
    ...    (1172,NULL,1073,'CODIGO','IMPOSTO',1,0,1,3,NULL,317),
    ...    (1173,NULL,1074,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,318),
    ...    (1174,NULL,1074,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,319),
    ...    (1175,NULL,1074,'ACRESCIMOS','',1,0,3,0,NULL,320),
    ...    (1176,NULL,1075,'CODIGO','ACORCONT',1,0,1,3,NULL,321),
    ...    (1177,NULL,1076,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',0,0,1,0,NULL,401),
    ...    (1178,NULL,1076,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,323),
    ...    (1179,NULL,1076,'PRODUTO_FAIXAQUANTIDADE','',1,0,3,0,NULL,324),
    ...    (1180,NULL,1076,'DESCONTOS','',1,0,4,0,NULL,325),
    ...    (1181,NULL,1077,'PRODUTO_IDPRODUTO','',1,0,3,0,NULL,391),
    ...    (1183,NULL,1077,'PRODUTO_FAIXAQUANTIDADE','',1,0,1,0,NULL,412),
    ...    (1184,NULL,1078,'CODIGO','ESCALPRODP',1,0,1,3,NULL,407),
    ...    (1185,NULL,1079,'CODIGO','FRETECLI',1,0,1,3,NULL,330),
    ...    (1186,NULL,1080,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,331),
    ...    (1187,NULL,1068,'TABELAPRECO_IDTABELAPRECO','',1,0,3,0,NULL,352),
    ...    (1188,NULL,1081,'TABELAPRECO_IDTABELAPRECO','',1,0,1,0,NULL,337),
    ...    (1189,NULL,1082,'CODIGO','ESCALPROD',1,0,1,3,NULL,400),
    ...    (1190,NULL,1083,'TABELAPRECO_IDTABELAPRECO','',1,0,1,0,NULL,339),
    ...    (1191,NULL,1084,'TABELAPRECO_IDTABELAPRECO','',1,0,1,0,NULL,397),
    ...    (1193,NULL,1086,'TABELAPRECO_IDTABELAPRECO','',1,0,1,0,NULL,342),
    ...    (1198,NULL,1080,'IDTIPOFRETE','',1,0,2,0,NULL,357),
    ...    (1201,NULL,1089,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,0,1,0,NULL,360),
    ...    (1202,NULL,1089,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,361),
    ...    (1204,NULL,1091,'TABELAPRECO_IDTABELAPRECO','',1,0,1,0,NULL,363),
    ...    (1205,NULL,1092,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,365),
    ...    (1206,NULL,1092,'LOCAL_IDLOCAL','',1,0,2,0,NULL,366),
    ...    (1207,NULL,1092,'VIGENCIA','',1,0,3,0,NULL,367),
    ...    (1211,NULL,1096,'CODIGO','SOLDESC',1,0,1,5,NULL,570),
    ...    (1212,NULL,1097,'SGLTIPODESCONTO','SOLDESC',1,0,1,3,NULL,496),
    ...    (1213,NULL,1097,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,572),
    ...    (1219,NULL,1077,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,0,4,0,NULL,413),
    ...    (1221,NULL,1077,'DESCONTOS','',1,0,5,0,NULL,409),
    ...    (1223,NULL,1101,'IDUSUARIOPROFISSIONAL','',1,0,1,0,NULL,414),
    ...    (1224,NULL,1101,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,415),
    ...    (1225,NULL,1102,'VIGENCIA','',1,0,1,0,NULL,416),
    ...    (1226,NULL,1103,'SGLTIPODESCONTO','BLQ_SOL',1,0,1,3,NULL,419),
    ...    (1227,NULL,1103,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,443),
    ...    (1228,NULL,1105,'GRUPOPRODUTO_IDGRUPOPRODUTOPRODUTO','',1,0,1,0,NULL,422),
    ...    (1229,NULL,1106,'REGIAO_IDREGIAO','',1,0,1,0,NULL,423),
    ...    (1233,NULL,1109,'LOCAL_IDLOCAL','',1,0,1,0,NULL,431),
    ...    (1234,NULL,1110,'PRODUTO_IDPRODUTO','',1,0,1,0,NULL,432),
    ...    (1235,42,NULL,'VIGENCIA','',1,0,1,0,NULL,433),
    ...    (1236,NULL,1111,'LOCALFILIAL_IDLOCAL','',1,0,1,0,NULL,434),
    ...    (1237,NULL,1111,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,435),
    ...    (1238,NULL,1112,'VIGENCIA','',1,0,1,0,NULL,436),
    ...    (1239,NULL,1101,'LOCALFILIAL_IDLOCAL','',1,1,3,0,NULL,437),
    ...    (1240,NULL,1111,'IDUSUARIOPROFISSIONAL','',1,0,3,0,NULL,440),
    ...    (1241,NULL,1113,'SGLTIPODESCONTO','FLEXACRE',1,0,1,5,NULL,481),
    ...    (1242,NULL,1114,'PARCEIRO_IDPARCEIRO','',1,0,1,0,NULL,445)
    ...    ON CONFLICT (idwsconfigpedidofiltro) DO UPDATE SET
    ...    idwsconfigpedidocampo=EXCLUDED.idwsconfigpedidocampo,
    ...    idwsconfigpedidotipofiltro=EXCLUDED.idwsconfigpedidotipofiltro,
    ...    fieldname=EXCLUDED.fieldname,valordefault=EXCLUDED.valordefault,
    ...    idnativo=EXCLUDED.idnativo,idnvalornull=EXCLUDED.idnvalornull,
    ...    ordem=EXCLUDED.ordem,operador=EXCLUDED.operador,
    ...    codigoerp=EXCLUDED.codigoerp,wsversao=EXCLUDED.wsversao;
    DatabaseLibrary.Execute Sql String    ${sql_filtros2}
    Log To Console    ✅ Filtros lote 2/3 configurados!

    Log To Console    \n⚙️ Configurando wsconfigpedidofiltro — lote 3/3...
    ${sql_filtros3}=    Catenate    SEPARATOR=\n
    ...    INSERT INTO wsconfigpedidofiltro
    ...    (idwsconfigpedidofiltro,idwsconfigpedidocampo,idwsconfigpedidotipofiltro,fieldname,valordefault,idnativo,idnvalornull,ordem,operador,codigoerp,wsversao)
    ...    VALUES
    ...    (1246,NULL,1113,'DESCONTOS','',0,0,2,0,NULL,497),
    ...    (1249,NULL,1060,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',0,0,3,0,NULL,587),
    ...    (1251,1035,NULL,'ESTOQUE_IDPRODUTO','',1,0,1,0,NULL,458),
    ...    (1252,1035,NULL,'ESTOQUE_IDLOCALFILIAL','',1,0,2,0,NULL,459),
    ...    (1253,NULL,1120,'CODIGO','FRETPRD',1,0,1,3,NULL,462),
    ...    (1254,NULL,1121,'PRODUTO_IDPRODUTO','',1,0,1,0,NULL,463),
    ...    (1255,NULL,1121,'TABELAPRECO_IDTABELAPRECO','',1,0,2,0,NULL,464),
    ...    (1256,NULL,1121,'LOCAL_IDUNIDADEFEDERATIVA','',1,0,3,0,NULL,465),
    ...    (1257,NULL,1122,'SGLTIPODESCONTO','FRETPRD',1,0,1,3,NULL,466),
    ...    (1259,NULL,1125,'CODIGO','ENUM',1,0,1,3,NULL,471),
    ...    (1260,NULL,1126,'CODIGO','FLEXACRE',1,0,1,3,NULL,501),
    ...    (1261,NULL,1127,'CODIGO','FLEXDESC',1,0,1,3,NULL,473),
    ...    (1262,NULL,1113,'PRODUTO_IDPRODUTO','',1,0,3,0,NULL,474),
    ...    (1263,NULL,1113,'PRODUTO_IDGRUPOPRODUTO','',1,0,4,0,NULL,475),
    ...    (1264,NULL,1113,'LOCALFILIAL_IDLOCAL','',0,0,5,0,NULL,578),
    ...    (1265,NULL,1117,'PRODUTO_IDPRODUTO','',1,0,3,0,NULL,477),
    ...    (1267,NULL,1117,'PRODUTO_IDGRUPOPRODUTO','',1,0,5,0,NULL,500),
    ...    (1268,NULL,1117,'SGLTIPODESCONTO','FLEXDESC',1,0,6,3,NULL,480),
    ...    (1277,NULL,1137,'COTA_IDCOTA','',1,0,1,0,NULL,502),
    ...    (1279,NULL,1060,'COTA_IDCOTA','',0,0,4,0,NULL,590),
    ...    (1281,1030,NULL,'IDNATIVO','0',1,0,2,4,NULL,508),
    ...    (1282,NULL,1112,'IDNATIVO','1',1,0,2,3,NULL,509),
    ...    (1283,NULL,1139,'CODIGO','OFERTADESC',1,0,1,3,NULL,510),
    ...    (1284,NULL,1140,'PARCEIRO_IDPARCEIRO','',1,0,4,0,NULL,553),
    ...    (1285,NULL,1140,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,1,5,0,NULL,558),
    ...    (1286,NULL,1140,'PRODUTO_IDPRODUTO','',1,0,6,0,NULL,550),
    ...    (1287,NULL,1140,'COTA_IDCOTA','',1,0,7,0,NULL,551),
    ...    (1288,NULL,1141,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,1,1,0,NULL,593),
    ...    (1289,NULL,1141,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,517),
    ...    (1290,NULL,1141,'COTA_IDCOTA','',1,0,3,0,NULL,518),
    ...    (1291,NULL,1142,'CODIGO','OFERTADESC',1,0,1,3,NULL,519),
    ...    (1292,NULL,1143,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,1,1,0,NULL,523),
    ...    (1293,NULL,1143,'PRODUTO_IDPRODUTO','',1,0,2,0,NULL,521),
    ...    (1294,NULL,1143,'COTA_IDCOTA','',1,0,3,0,NULL,522),
    ...    (1295,NULL,1143,'PARCEIRO_IDPARCEIRO','',1,1,4,0,NULL,524),
    ...    (1296,NULL,1144,'CODIGO','OFERTADESC',1,0,1,3,NULL,525),
    ...    (1297,NULL,1141,'PARCEIRO_IDPARCEIRO','',1,1,4,0,NULL,526),
    ...    (1298,NULL,1140,'IDUSUARIOPROFISSIONAL','',1,0,3,0,NULL,554),
    ...    (1299,NULL,1140,'LOCALFILIAL_IDLOCAL','',1,0,2,0,NULL,548),
    ...    (1300,NULL,1141,'IDUSUARIOPROFISSIONAL','',1,1,5,0,NULL,595),
    ...    (1301,NULL,1141,'LOCALFILIAL_IDLOCAL','',1,0,6,0,NULL,530),
    ...    (1302,NULL,1143,'IDUSUARIOPROFISSIONAL','',1,0,5,0,NULL,594),
    ...    (1303,NULL,1143,'LOCALFILIAL_IDLOCAL','',1,0,6,0,NULL,532),
    ...    (1304,NULL,1140,'SGLTIPODESCONTO','OFERTACOTA',1,0,1,3,NULL,542),
    ...    (1308,NULL,1147,'IDUSUARIOPROFISSIONAL','',1,0,1,0,NULL,563),
    ...    (1309,NULL,1147,'TIPOPEDIDO_IDTIPOPEDIDO','',1,0,2,0,NULL,564),
    ...    (1310,NULL,1147,'IDNATIVO','1',1,0,3,3,NULL,565),
    ...    (1315,NULL,1097,'PRODUTO_IDGRUPOPRODUTO','',1,0,3,0,NULL,579),
    ...    (1316,NULL,1097,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,0,4,0,NULL,581),
    ...    (1317,NULL,1151,'VIGENCIA','',1,0,1,0,NULL,575),
    ...    (1318,NULL,1151,'IDNATIVO','1',1,0,2,3,NULL,576),
    ...    (1319,NULL,1117,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,0,7,0,NULL,582),
    ...    (1320,NULL,1113,'GRUPOPARCEIRO_IDGRUPOPARCEIRO','',1,0,6,0,NULL,583),
    ...    (1321,NULL,1085,'TABELAPRECO_IDTABELAPRECO','',1,0,1,0,NULL,596),
    ...    (1322,NULL,1074,'IDUSUARIOPROFISSIONAL','',1,0,4,0,NULL,597),
    ...    (1328,NULL,1155,'VIGENCIA','',1,0,1,0,NULL,603),
    ...    (1329,NULL,1155,'IDNATIVO','1',1,0,2,3,NULL,604),
    ...    (1330,NULL,1156,'TABELAPRECO_IDTABELAPRECO','',1,0,1,0,NULL,605),
    ...    (1331,NULL,1156,'IDUSUARIOPROFISSIONAL','',1,0,2,0,NULL,606),
    ...    (1332,NULL,1156,'LOCALFILIAL_IDLOCAL','',1,0,3,0,NULL,607),
    ...    (1333,NULL,1156,'PRODUTO_IDPRODUTO','',1,0,4,0,NULL,608),
    ...    (1334,NULL,1157,'IDNATIVO','1',1,0,1,3,NULL,609),
    ...    (1335,NULL,1158,'IDNATIVO','1',1,0,1,3,NULL,610),
    ...    (1336,NULL,1159,'IDNATIVO','1',1,0,1,3,NULL,724)
    ...    ON CONFLICT (idwsconfigpedidofiltro) DO UPDATE SET
    ...    idwsconfigpedidocampo=EXCLUDED.idwsconfigpedidocampo,
    ...    idwsconfigpedidotipofiltro=EXCLUDED.idwsconfigpedidotipofiltro,
    ...    fieldname=EXCLUDED.fieldname,valordefault=EXCLUDED.valordefault,
    ...    idnativo=EXCLUDED.idnativo,idnvalornull=EXCLUDED.idnvalornull,
    ...    ordem=EXCLUDED.ordem,operador=EXCLUDED.operador,
    ...    codigoerp=EXCLUDED.codigoerp,wsversao=EXCLUDED.wsversao;
    DatabaseLibrary.Execute Sql String    ${sql_filtros3}
    Log To Console    ✅ Filtros lote 3/3 configurados!
    Log To Console    ✅ wsconfigpedidofiltro configurado (140 linhas upsert)!
