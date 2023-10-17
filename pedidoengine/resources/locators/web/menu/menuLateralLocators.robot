*** Variables ***

&{venda}
...    menuVenda=pedido.menu    #id
...    subMenuPedido=menu.venda.pedido    #id
...    listarPedido=menu.venda.pedido.listagem    #id
...    novoPedido=menu.venda.pedido.novo    #id

&{cliente}
...    menuCliente=cliente.menuMain
...    subMenuCliente=menu.cliente.cadastrar
...    novoCliente=menu.cliente.cadastrar.novo
...    menuClienteListar=menu.cliente.cadastrar.listar

&{menuAtendimento}
...    menuAtendimento=atendimento.modulo    #id
...    novoAtendimento=atendimento.modulo.cadastrar.novo    #id
...    listarAtendimento=atendimento.modulo.cadastrar.listar    #id