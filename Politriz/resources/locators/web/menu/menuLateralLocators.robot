*** Settings ***
Documentation    Arquivo utilizado para armazenar os localizadores de elementos necessários para manipular o menu lateral principal da web

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

&{atendimento}
...    menuAtendimento=atendimento.modulo    #id
...    novoAtendimento=atendimento.modulo.cadastrar.novo    #id
...    listarAtendimento=atendimento.modulo.cadastrar.listar    #id


&{lead}
...    menuLead=lead.menu        #id
...    novoLead=lead.menu.novo        #id
