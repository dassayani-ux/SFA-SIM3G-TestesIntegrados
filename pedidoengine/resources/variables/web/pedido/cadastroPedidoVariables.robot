*** Settings ***
Documentation    Arquivo utilizado para armazenar variáveis de dados que contribuem nos testes de cadastro de pedido de venda.

*** Variables ***
# Listas temporárias utilizadas no cabeçalho do pedido
@{listaLocais}
@{listaFiliais}
@{listaTipoPedido}
@{listaTabelaPreco}
@{listaCondicaoPagamento}
@{listaTipoCobranca}

# Listas temporárias utilizadas ma validação do pedido
@{produtosOriginais}
@{produtosAlterados}

# Dicionário de dados do pedido
&{dadosPedido}
...    numeroPedido=
...    idParceiro=
...    idLocalParceiro=
...    idLocalFilial=
...    idTipoPedido=
...    idTabelaPreco=
...    idCondicaoPagamento=
...    idTipoCobranca=

${quantideItensPedido}    ${2}    ## Variável utilizada para determinar quantos itens serão inclusos no pedido de venda.
${quantidadeMaximaProduto}    ${50}    ## Variável utilizada para armazenar a quantidade máxima que um item poderá ter dentro do pedido.