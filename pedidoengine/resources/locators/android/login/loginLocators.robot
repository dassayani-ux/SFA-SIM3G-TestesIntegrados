*** Settings ***
Documentation    Arquivo utilizado para armazenar a localização dos componentes na tela de login no Android.

*** Variables ***
&{formLogin}
...    inputProfissional=com.wealthsystems.sim3g.cliente.pedidoengine.app:id/login_txtuser    #id
...    inputSenha=com.wealthsystems.sim3g.cliente.pedidoengine.app:id/login_txtpwd    #id
...    btnEntrar=com.wealthsystems.sim3g.cliente.pedidoengine.app:id/login_btnentrar    #id

${activityMenuPrincipal}    com.wealthsystems.sim3g.modulo.menu.android.api.PrincipalActivity    #Activity