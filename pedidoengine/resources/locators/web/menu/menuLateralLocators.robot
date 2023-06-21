*** Variables ***

&{venda}
...    menuVenda=//*[@id="pedido.menu"]/span
...    menuPedido=//*[@id="menu.venda.pedido"]/span
...    pedidoCockpit=//*[@id="menu.venda.pedido.dashboarddefault"]/a
...    pedidoListar=//*[@id="menu.venda.pedido.listagem"]/a
...    pedidoNovo=//*[@id="menu.venda.pedido.novo"]/a



&{cliente}
...    menuCliente=cliente.menuMain
...    subMenuCliente=menu.cliente.cadastrar
...    novoCliente=menu.cliente.cadastrar.novo
...    menuClienteListar=menu.cliente.cadastrar.listar

&{atendimento}
...    menuAtendimento=atendimento.modulo    #id
...    novoAtendimento=atendimento.modulo.cadastrar.novo    #id
...    listarAtendimento=atendimento.modulo.cadastrar.listar    #id