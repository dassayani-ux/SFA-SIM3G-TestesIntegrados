*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar usuários.

Library    DatabaseLibrary

*** Variables ***
${SQL_USUARIO}    select
...        this_.idUsuario,
...        this_.login,
...        this_.nome,
...        this_.idPerfilAcesso
...    from Usuario this_
...    where
...        this_.idUsuario in (
...            select
...                distinct a_.idUsuario as y0_
...            from Usuario a_
...            left outer join UsuarioHierarquia a_0x1_ on a_.idUsuario=a_0x1_.idUsuario
...            left outer join Usuario a_1x2_ on a_0x1_.idUsuarioSuperior=a_1x2_.idUsuario
...            where
...                (
...                    (
...                        a_.idUsuario=1
...                        or a_1x2_.idUsuario=1
...                    )
...                    and a_.idnAtivo=1
...                )
...        )
...    order by
...        this_.nome asc