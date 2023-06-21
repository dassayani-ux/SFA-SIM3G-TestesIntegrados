*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar clientes.

Library    DatabaseLibrary

*** Variables ***
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

SQL Pesquisa Avancada
    [Documentation]    Keyword utilizada para realizar a consulta SQL de acordo com os termos da pesquisa avançada.
    ...    \nValores válidos para o argumento *tipoPessoa* : _None, PF, PJ, Ambos_.
    ...    \nValores válidos para o argumento *situacao* : _None, 0 (inativo), 1 (ativo), Ambos_.

    [Arguments]    ${tipoPessoa}=None    ${situacao}=None

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
    ...                    u3_.idUsuario=1
    ...                    or u3_.idUsuario in (
    ...                        select
    ...                            distinct UH_.idUsuario as y0_ 
    ...                        from
    ...                            UsuarioHierarquia UH_ 
    ...                        inner join Usuario u1_ on UH_.idUsuario=u1_.idUsuario 
    ...                        inner join Usuario us2_ on UH_.idUsuarioSuperior=us2_.idUsuario 
    ...                        where
    ...                            us2_.idUsuario=1
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

    ${countPesquisaAvancada}    Row Count    ${PESQUISA_PADRAO} ${CLAUSULA_TIPO_PESSOA} ${CLAUSULA_SITUACAO}
    ...    order by this_.nomeParceiro asc
    
    Return From Keyword    ${countPesquisaAvancada}