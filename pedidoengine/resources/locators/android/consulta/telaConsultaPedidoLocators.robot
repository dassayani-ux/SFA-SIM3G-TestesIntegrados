*** Settings ***
Documentation    Arquivo utilizado para armazenar os localizadores utilizados nos testes que envolvem tela de consulta de pedidos no Android.

*** Variables ***
&{telaConsultaPedidos}
...    quantidadePedidosListados=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[1]/android.view.ViewGroup/android.widget.TextView[1]    #xpath

&{pesquisaAvancadaConsultaPedido}
...    ativaPesquisaAvancada=Pesquisar    #accessibility_id
...    campoNumeroPedido=/hierarchy/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[2]/android.widget.LinearLayout/android.widget.EditText    #xpath
...    btnPesquisar=android:id/button1    #id

&{menuContextoCardConsultaPedidoAndroid}
...    menuContexto=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[2]/android.widget.LinearLayout/android.view.ViewGroup/android.widget.LinearLayout/androidx.recyclerview.widget.RecyclerView/android.widget.LinearLayout/android.widget.LinearLayout/android.widget.LinearLayout[2]/android.widget.LinearLayout[4]/android.widget.LinearLayout[3]/android.widget.ImageButton    #xpath
...    visualizarPedido=/hierarchy/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.ListView/android.widget.TextView[1]    #xpath