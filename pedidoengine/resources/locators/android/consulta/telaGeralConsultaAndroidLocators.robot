*** Settings ***
Documentation    Arquivo utilizado para armazenar os localizadores utilizados nos testes que envolvem tela de consultas.

*** Variables ***
${painelMsgCarregando}    android:id/body    #id

&{telaConsultaGeralAndroid}
...    titulo=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[1]/android.view.ViewGroup/android.widget.TextView    #xpath

&{opcoesConsulta}
...    pedidos=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[2]/androidx.drawerlayout.widget.DrawerLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.LinearLayout/android.widget.ListView/android.widget.LinearLayout[4]/android.widget.LinearLayout/android.widget.TextView    #xpath