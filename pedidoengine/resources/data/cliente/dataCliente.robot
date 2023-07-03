*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar clientes.

Library    DatabaseLibrary
Library    Collections

*** Variables ***

@{listaSituacaoAprovacacao}    ##Armazenará de maneira temporária os registros de situação aprovação disponíveis.
@{listaSituacaoCadastro}    ##Armazenará de maneira temporária os registros de situação de cadastro disponíveis.

${CLIENTE_ATIVO_SQL}
    ...    select
    ...    distinct this_.idParceiro as y0_,
    ...    this_.nomeParceiro as y1_,
    ...    this_.nomeParceiroFantasia as y2_
    ...    from
    ...    Parceiro this_ 
    ...    left outer join
    ...    TipoSituacaoCadastro tsc6_ 
    ...    on this_.idTipoSituacaoCadastro=tsc6_.idTipoSituacaoCadastro 
    ...    left outer join
    ...    PessoaJuridica pj10_ 
    ...    on this_.idParceiro=pj10_.idPessoaJuridica 
    ...    left outer join
    ...    PessoaFisica pf9_ 
    ...    on this_.idParceiro=pf9_.idPessoaFisica 
    ...    left outer join
    ...    ParceiroLocal locallist17_ 
    ...    on this_.idParceiro=locallist17_.idParceiro 
    ...    left outer join
    ...    Local l1_ 
    ...    on locallist17_.idLocal=l1_.idLocal 
    ...    left outer join
    ...    Cidade c2_ 
    ...    on l1_.idCidade=c2_.idCidade 
    ...    left outer join
    ...    UnidadeFederativa uni3_ 
    ...    on c2_.idUnidadeFederativa=uni3_.idUnidadeFederativa 
    ...    left outer join
    ...    LocalIdentificacao li11_ 
    ...    on l1_.idLocal=li11_.idLocal 
    ...    left outer join
    ...    ParceiroTipoParceiro ptp7_ 
    ...    on this_.idParceiro=ptp7_.idParceiro 
    ...    left outer join
    ...    TipoParceiro tp8_ 
    ...    on ptp7_.idTipoParceiro=tp8_.idTipoParceiro 
    ...    left outer join
    ...    ParceiroAprovacao pa4_ 
    ...    on this_.idParceiro=pa4_.idParceiro 
    ...    left outer join
    ...    TipoSituacaoAprovacao tsa5_ 
    ...    on pa4_.idTipoSituacaoAprovacao=tsa5_.idTipoSituacaoAprovacao 
    ...    left outer join
    ...    Usuario ua12_ 
    ...    on this_.idUsuarioAnonimizacao=ua12_.idUsuario 
    ...    where
    ...    this_.idParceiro in (
    ...    select
    ...    PL_.idParceiro as y0_ 
    ...    from
    ...    ParceiroLocal PL_ 
    ...    inner join
    ...    Local l1_ 
    ...    on PL_.idLocal=l1_.idLocal 
    ...    inner join
    ...    UsuarioLocal ul2_ 
    ...    on l1_.idLocal=ul2_.idLocal 
    ...    inner join
    ...    Usuario u3_ 
    ...    on ul2_.idUsuario=u3_.idUsuario 
    ...    where
    ...    (
    ...    u3_.idUsuario=1
    ...    or u3_.idUsuario in (
    ...    select
    ...    distinct UH_.idUsuario as y0_ 
    ...    from
    ...    UsuarioHierarquia UH_ 
    ...    inner join
    ...    Usuario u1_ 
    ...    on UH_.idUsuario=u1_.idUsuario 
    ...    inner join
    ...    Usuario us2_ 
    ...    on UH_.idUsuarioSuperior=us2_.idUsuario 
    ...    where
    ...    us2_.idUsuario=1
    ...    )
    ...    )
    ...    )
    ...    and (
    ...    this_.idnAtivo=1
    ...    )
    ...    order by
    ...    this_.nomeParceiro asc

*** Keywords ***
Pesquisa rapida sql
    [Documentation]    Retorna a quantidade de registros utilizando o termo será informado na pesquisa rápida.
    [Arguments]    ${termo}
    ${PESQUISA_SQL}    Catenate    SEPARATOR=\n   
        ...    select
        ...        distinct this_.idParceiro as idParceiro,
        ...        this_.nomeParceiro as Nome,
        ...        this_.nomeParceiroFantasia as Fantasia,
        ...        this_.numeroMatricula as Matricula,
        ...        this_.idnAtivo as Ativo,
        ...        tsc6_.sglTipoSituacaoCadastro as SituacaoCadastro,
        ...        tsa5_.sglTipoSituacaoAprovacao as SiglaSituacaoAprovacao,
        ...        tsa5_.idTipoSituacaoAprovacao as idSituacaoAprovacao,
        ...        ua12_.idUsuario as idUsuario,
        ...        this_.sglTipoPessoa as TipoPessoa 
        ...    from Parceiro this_ 
        ...    left outer join TipoSituacaoCadastro tsc6_ on this_.idTipoSituacaoCadastro=tsc6_.idTipoSituacaoCadastro 
        ...    left outer join PessoaJuridica pj10_ on this_.idParceiro=pj10_.idPessoaJuridica 
        ...    left outer join PessoaFisica pf9_ on this_.idParceiro=pf9_.idPessoaFisica 
        ...    left outer join ParceiroLocal locallist17_ on this_.idParceiro=locallist17_.idParceiro 
        ...    left outer join Local l1_ on locallist17_.idLocal=l1_.idLocal 
        ...    left outer join Cidade c2_ on l1_.idCidade=c2_.idCidade 
        ...    left outer join UnidadeFederativa uni3_ on c2_.idUnidadeFederativa=uni3_.idUnidadeFederativa 
        ...    left outer join LocalIdentificacao li11_ on l1_.idLocal=li11_.idLocal 
        ...    left outer join ParceiroTipoParceiro ptp7_ on this_.idParceiro=ptp7_.idParceiro 
        ...    left outer join TipoParceiro tp8_ on ptp7_.idTipoParceiro=tp8_.idTipoParceiro 
        ...    left outer join ParceiroAprovacao pa4_ on this_.idParceiro=pa4_.idParceiro 
        ...    left outer join TipoSituacaoAprovacao tsa5_ on pa4_.idTipoSituacaoAprovacao=tsa5_.idTipoSituacaoAprovacao 
        ...    left outer join Usuario ua12_ on this_.idUsuarioAnonimizacao=ua12_.idUsuario 
        ...    where
        ...        this_.idParceiro in (
        ...            select
        ...                PL_.idParceiro as y0_ 
        ...            from ParceiroLocal PL_ 
        ...            inner join Local l1_ on PL_.idLocal=l1_.idLocal 
        ...            inner join UsuarioLocal ul2_ on l1_.idLocal=ul2_.idLocal 
        ...            inner join Usuario u3_ on ul2_.idUsuario=u3_.idUsuario 
        ...            where
        ...                (
        ...                    u3_.idUsuario=1 
        ...                    or u3_.idUsuario in (
        ...                        select
        ...                            distinct UH_.idUsuario as y0_ 
        ...                        from UsuarioHierarquia UH_ 
        ...                        inner join Usuario u1_ on UH_.idUsuario=u1_.idUsuario 
        ...                        inner join Usuario us2_ on UH_.idUsuarioSuperior=us2_.idUsuario 
        ...                        where
        ...                            us2_.idUsuario=1
        ...                    )
        ...                )
        ...            ) 
        ...            and (
        ...                this_.nomeParceiro ilike '%${termo}%' 
        ...                or this_.nomeParceiroFantasia ilike '%${termo}%' 
        ...                or this_.numeroMatricula ilike '%${termo}%' 
        ...                or l1_.textoPesquisa ilike '%${termo}%'
        ...            ) 
        ...            and (
        ...                this_.idnAtivo=1
        ...            ) 
        ...        order by
        ...            this_.nomeParceiro asc
    
    ${pesquisa}    Row Count    ${PESQUISA_SQL}

    Return From Keyword    ${pesquisa}

Retorna siuacao aprovacao
    [Documentation]    Caso o argumento *_tipo_* for 0, esta keyword irá retornar uma lista com todas as situações disponíveis.
    ...    \nCaso o argumento *_tipo_* for 1, retornar uma uma lista contendo um *ID* e *DESCRICAO* de uma situação de aprovação aleatória.
    [Arguments]    ${tipo}=0

    ${SQL_SITUACAO_APROVACAO}    Catenate    SEPARATOR=\n
    ...    select
    ...        this_.idTipoSituacaoAprovacao as idTipoSi1_1631_0_,
    ...        this_.descricao as descricao,
    ...        this_.sglTipoSituacaoAprovacao as sglTipoS3_1631_0_,
    ...        this_.idnAtivo as idnAtivo4_1631_0_,
    ...        this_.codigoERP as codigoER5_1631_0_
    ...    from
    ...        TipoSituacaoAprovacao this_ 
    ...    where
    ...        this_.idnAtivo=1
    ...    order by
    ...        this_.descricao desc

    ${retornoSituacaoAprovacao}    Query    ${SQL_SITUACAO_APROVACAO}
    ${count}    Row Count    ${SQL_SITUACAO_APROVACAO}

    FOR  ${I}  IN RANGE    ${count}
        Append To List    ${listaSituacaoAprovacacao}    ${retornoSituacaoAprovacao[${I}][1]}
    END
    
    Return From Keyword If    ${tipo} == ${0}    ${listaSituacaoAprovacacao}

    FOR  ${elemento}  IN    @{listaSituacaoAprovacacao}
        Remove Values From List    ${listaSituacaoAprovacacao}    ${elemento}
    END

    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random

    Return From Keyword If    ${tipo} == ${1}    ${retornoSituacaoAprovacao[${index[0]}][0]}    ${retornoSituacaoAprovacao[${index[0]}][1]}
    
Retorna classificacao de parceiro aleatoria
    [Documentation]    Irá retornar uma lista contendo um *ID* e *NOME* de classificação de parceiro aleatória.

    ${SQL_CLASSIFICAO}    Catenate    SEPARATOR=\n
    ...    select
    ...        this_.idClassificacaoParceiro,
    ...        this_.descricao,
    ...        this_.sglClassificacao
    ...    from
    ...        ClassificacaoParceiro this_
    ...    order by
    ...        this_.descricao desc

    ${count}    Row Count    ${SQL_CLASSIFICAO}
    ${classificacao}    Query    ${SQL_CLASSIFICAO}

    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random

    Return From Keyword    ${classificacao[${index[0]}][0]}    ${classificacao[${index[0]}][1]}

Retorna siuacao cadastro
    [Documentation]    Caso o argumento *_tipo_* for 0, esta keyword irá retornar uma lista com todas as situações de cadastros disponíveis.
    ...    \nCaso o argumento *_tipo_* for 1, retornar uma uma lista contendo um *ID* e *DESCRICAO* de uma situação de cadastro aleatória.
    [Arguments]    ${tipo}=0

    ${SQL_SITUACAO_CADASTRO}    Catenate    SEPARATOR=\n
    ...    select
    ...        this_.idTipoSituacaoCadastro,
    ...        this_.idnAtivo,
    ...        this_.idnPadrao,
    ...        this_.descricao,
    ...        this_.sglTipoSituacaoCadastro
    ...    from
    ...        TipoSituacaoCadastro this_
    ...    order by
    ...        this_.descricao desc

    ${retornoSituacaoCadastro}    Query    ${SQL_SITUACAO_CADASTRO}
    ${count}    Row Count    ${SQL_SITUACAO_CADASTRO}

    FOR  ${I}  IN RANGE    ${count}
        Append To List    ${listaSituacaoCadastro}    ${retornoSituacaoCadastro[${I}][3]}
    END
    
    Return From Keyword If    ${tipo} == ${0}    ${listaSituacaoCadastro}

    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random

    Return From Keyword If    ${tipo} == ${1}    ${retornoSituacaoCadastro[${index[0]}][0]}    ${retornoSituacaoCadastro[${index[0]}][3]}

SQL Pesquisa Avancada
    [Documentation]    Keyword utilizada para realizar a consulta SQL de acordo com os termos da pesquisa avançada.
    ...    \nValores válidos para o argumento *tipoPessoa* : _None, PF, PJ, Ambos_.
    ...    \nValores válidos para o argumento *situacao* : _None, 0 (inativo), 1 (ativo), Ambos_.

    [Arguments]    ${tipoPessoa}=None    ${situacao}=None    ${situacaoAprovacao}=None    ${razaoSocial}=None    ${nomeFantasia}=None    ${local}=None    ${documento}=None    ${matricula}=None    ${bairro}=None    ${logradouro}=None    ${estadoUF}=None    ${cidade}=None    ${usuario}=1    ${classificacao}=None    ${situacaoCadastro}=None

    ${PESQUISA_PADRAO}    Catenate    SEPARATOR=\n
    ...    select
    ...        distinct this_.idParceiro as y0_,
    ...        this_.nomeParceiro as y1_,
    ...        this_.nomeParceiroFantasia as y2_,
    ...        this_.numeroMatricula as y3_,
    ...        this_.idnAtivo as y4_,
    ...        tsc6_.sglTipoSituacaoCadastro as y5_,
    ...        tsa5_.sglTipoSituacaoAprovacao as y6_,
    ...        tsa5_.idTipoSituacaoAprovacao as y7_,
    ...        ua12_.idUsuario as y8_,
    ...        this_.sglTipoPessoa as y9_ 
    ...    from
    ...        Parceiro this_ 
    ...    left outer join TipoSituacaoCadastro tsc6_ on this_.idTipoSituacaoCadastro=tsc6_.idTipoSituacaoCadastro 
    ...    left outer join PessoaJuridica pj10_ on this_.idParceiro=pj10_.idPessoaJuridica 
    ...    left outer join PessoaFisica pf9_ on this_.idParceiro=pf9_.idPessoaFisica 
    ...    left outer join ParceiroLocal locallist17_ on this_.idParceiro=locallist17_.idParceiro 
    ...    left outer join Local l1_ on locallist17_.idLocal=l1_.idLocal 
    ...    left outer join Cidade c2_ on l1_.idCidade=c2_.idCidade 
    ...    left outer join UnidadeFederativa uni3_ on c2_.idUnidadeFederativa=uni3_.idUnidadeFederativa 
    ...    left outer join LocalIdentificacao li11_ on l1_.idLocal=li11_.idLocal 
    ...    left outer join ParceiroTipoParceiro ptp7_ on this_.idParceiro=ptp7_.idParceiro 
    ...    left outer join TipoParceiro tp8_ on ptp7_.idTipoParceiro=tp8_.idTipoParceiro 
    ...    left outer join ParceiroAprovacao pa4_ on this_.idParceiro=pa4_.idParceiro 
    ...    left outer join TipoSituacaoAprovacao tsa5_ on pa4_.idTipoSituacaoAprovacao=tsa5_.idTipoSituacaoAprovacao 
    ...    left outer join Usuario ua12_ on this_.idUsuarioAnonimizacao=ua12_.idUsuario 
    ...    where
    ...        this_.idParceiro in (
    ...            select
    ...                PL_.idParceiro as y0_ 
    ...            from
    ...                ParceiroLocal PL_ 
    ...            inner join Local l1_ on PL_.idLocal=l1_.idLocal 
    ...            inner join UsuarioLocal ul2_ on l1_.idLocal=ul2_.idLocal 
    ...            inner join Usuario u3_ on ul2_.idUsuario=u3_.idUsuario 
    ...            where
    ...                (
    ...                    u3_.idUsuario=${usuario}
    ...                    or u3_.idUsuario in (
    ...                        select
    ...                            distinct UH_.idUsuario as y0_ 
    ...                        from
    ...                            UsuarioHierarquia UH_ 
    ...                        inner join Usuario u1_ on UH_.idUsuario=u1_.idUsuario 
    ...                        inner join Usuario us2_ on UH_.idUsuarioSuperior=us2_.idUsuario 
    ...                        where
    ...                            us2_.idUsuario=${usuario}
    ...                    )
    ...                )
    ...            ) 
    ...            and tp8_.sglTipoParceiro='CLI'

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA tipoPessoa
    IF  '${tipoPessoa}' == 'PF' or '${tipoPessoa}' == 'PJ'
        ${CLAUSULA_TIPO_PESSOA}    Catenate    SEPARATOR=\n
        ...    and this_.sglTipoPessoa in ('${tipoPessoa}')
    ELSE IF  '${tipoPessoa}' == 'None' or '${tipoPessoa}' == 'Ambos'
        ${CLAUSULA_TIPO_PESSOA}    Catenate    SEPARATOR=\n
        ...    and this_.sglTipoPessoa in ('PF', 'PJ')
    ELSE    
        Log To Console    ${tipoPessoa} não é um valor válido para o argumento tipoPessoa.
        Log To Console    Consulte a documentação da Keyword para verificar os valores que são aceitos.
        Fail
    END
    # FIM CLÁUSULA tipoPessoa

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA situacao
    IF  '${situacao}' == '${0}' or '${situacao}' == '${1}'
        ${CLAUSULA_SITUACAO}    Catenate    SEPARATOR=\n
        ...    and (this_.idnAtivo=${situacao})
    ELSE IF  '${situacao}' == 'Ambos'
        ${CLAUSULA_SITUACAO}    Catenate    SEPARATOR=\n
        ...    and (this_.idnAtivo=0 OR this_.idnAtivo=1)
    ELSE IF  '${situacao}' == 'None'
        ${CLAUSULA_SITUACAO}    Catenate    SEPARATOR=\n
        ...    and (this_.idnAtivo=1)
    ELSE    
        Log To Console    ${situacao} não é um valor válido para o argumento situacao.
        Log To Console    Consulte a documentação da Keyword para verificar os valores que são aceitos.
        Fail
    END
    # FIM CLÁUSULA situacao

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Situação Aprovação
    IF  '${situacaoAprovacao}' != 'None'
        ${idSituacaoAprovacao}    Query    select idTipoSituacaoAprovacao from TipoSituacaoAprovacao where descricao = '${situacaoAprovacao}'
        ${CLAUSULA_SITUACAO_APROVACAO}    Catenate    SEPARATOR=\n
        ...    and tsa5_.idTipoSituacaoAprovacao in (${idSituacaoAprovacao[0][0]})    
    ELSE
        ${CLAUSULA_SITUACAO_APROVACAO}    Catenate    SEPARATOR=\n    
    END
    # FIM CLÁUSULA Situação Aprovação

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Razão Social
    IF  '${razaoSocial}' != 'None'
        ${CLAUSULA_RAZAO_SOCIAL}    Catenate    SEPARATOR=\n
        ...    and this_.nomeParceiro ilike '%${razaoSocial}%'
    ELSE
        ${CLAUSULA_RAZAO_SOCIAL}    Catenate    SEPARATOR=\n       
    END
    # FIM CLÁUSULA Razão Social

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Nome Fantasia
    IF  '${nomeFantasia}' != 'None'
        ${CLAUSULA_NOME_FANTASIA}    Catenate    SEPARATOR=\n
        ...    and this_.nomeParceiroFantasia ilike '%${nomeFantasia}%'
    ELSE
        ${CLAUSULA_NOME_FANTASIA}    Catenate    SEPARATOR=\n       
    END
    # FIM CLÁUSULA Nome Fantasia

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Local
    IF  '${local}' != 'None'
        ${CLAUSULA_LOCAL}    Catenate    SEPARATOR=\n
        ...    and l1_.idLocal in (${local})
    ELSE
        ${CLAUSULA_LOCAL}    Catenate    SEPARATOR=\n       
    END
    # FIM CLÁUSULA Local

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Documento
    IF  '${documento}' != 'None'
        ${CLAUSULA_DOCUMENTO}    Catenate    SEPARATOR=\n
        ...    and (pj10_.documentoIdentificacao ilike '%${documento}%'
        ...        or pf9_.documentoIdentificacao ilike '%${documento}%'
        ...        or li11_.documentoIdentificacao ilike '%${documento}%'
        ...        or l1_.documentoIdentificacao ilike '%${documento}%')
    ELSE
        ${CLAUSULA_DOCUMENTO}    Catenate    SEPARATOR=\n
    END
    # FIM CLÁUSULA Documento

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Matrícula
    IF  '${matricula}' != 'None'
        ${CLAUSULA_MATRICULA}    Catenate    SEPARATOR=\n
        ...    and this_.numeroMatricula='${matricula}'
    ELSE
        ${CLAUSULA_MATRICULA}    Catenate    SEPARATOR=\n  
    END
    # FIM CLÁUSULA Matrícula

    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Bairro
    IF  '${bairro}' != 'None'
        ${CLAUSULA_BAIRRO}    Catenate    SEPARATOR=\n
        ...    and (l1_.bairro ilike '${bairro}')   
    ELSE
        ${CLAUSULA_BAIRRO}    Catenate    SEPARATOR=\n
    END
    # FIM CLÁUSULA Bairro
    
    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Logradouro
    IF  '${logradouro}' != 'None'
        ${CLAUSULA_LOGRADOURO}    Catenate    SEPARATOR=\n
        ...    and (l1_.logradouro ilike '%${logradouro}%')   
    ELSE
        ${CLAUSULA_LOGRADOURO}    Catenate    SEPARATOR=\n
    END
    # FIM CLÁUSULA Logradouro
    
    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Estado/UF
    IF  '${estadoUF}' != 'None'
        ${idUF}    Query    select u.idunidadefederativa from unidadefederativa u where u.descricao = '${estadoUF}';
        ${CLAUSULA_UF}    Catenate    SEPARATOR=\n
        ...    and uni3_.idUnidadeFederativa in (${idUF[0][0]})
    ELSE
        ${CLAUSULA_UF}    Catenate    SEPARATOR=\n
    END
    # FIM CLÁUSULA Estado/UF
    
    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Cidade
    IF  '${cidade}' != 'None'
        ${idCidade}    Query    select c.idcidade from cidade c where c.descricao ilike '%${cidade}%';
        ${CLAUSULA_CIDADE}    Catenate    SEPARATOR=\n
        ...    and c2_.idCidade in (${idCidade[0][0]})
    ELSE
        ${CLAUSULA_CIDADE}    Catenate    SEPARATOR=\n
    END
    # FIM CLÁUSULA Cidade
    
    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Classificação
    IF  '${classificacao}' != 'None'
        ${CLAUSULA_CLASSIFICACAO}    Catenate    SEPARATOR=\n
        ...    and this_.idClassificacaoParceiro in (${classificacao})
    ELSE
        ${CLAUSULA_CLASSIFICACAO}    Catenate    SEPARATOR=\n
    END
    # FIM CLÁUSULA Classificação
    
    # ------------//------------//------------//------------//------------

    # INÍCIO CLÁUSULA Situação Cadastro
    IF  '${situacaoCadastro}' != 'None'
        ${CLAUSULA_SITUACAO_CADASTRO}    Catenate    SEPARATOR=\n
        ...    and tsc6_.idTipoSituacaoCadastro in (${situacaoCadastro})
    ELSE
        ${CLAUSULA_SITUACAO_CADASTRO}    Catenate    SEPARATOR=\n
    END
    # FIM CLÁUSULA Situação Cadastro
    
    # ------------//------------//------------//------------//------------

    ${countPesquisaAvancada}    Row Count    ${PESQUISA_PADRAO} ${CLAUSULA_TIPO_PESSOA} ${CLAUSULA_SITUACAO} ${CLAUSULA_SITUACAO_APROVACAO} ${CLAUSULA_RAZAO_SOCIAL} ${CLAUSULA_NOME_FANTASIA} ${CLAUSULA_LOCAL} ${CLAUSULA_DOCUMENTO} ${CLAUSULA_MATRICULA} ${CLAUSULA_BAIRRO} ${CLAUSULA_LOGRADOURO} ${CLAUSULA_UF} ${CLAUSULA_CIDADE} ${CLAUSULA_CLASSIFICACAO} ${CLAUSULA_SITUACAO_CADASTRO}
    ...    order by this_.nomeParceiro asc
    
    Return From Keyword    ${countPesquisaAvancada}