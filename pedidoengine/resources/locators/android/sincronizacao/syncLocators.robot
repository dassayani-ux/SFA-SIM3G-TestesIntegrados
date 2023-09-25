*** Settings ***
Documentation    Arquivo utilizado para armazenar os locators presentes na página de login no app Android.

*** Variables ***
&{msgSyncInicial}
...    txtMsg=Informe o endereço do servidor de sincronização
...    btnDigitar=android:id/button2    #id

${inputServer}    com.wealthsystems.sim3g.cliente.pedidoengine.app:id/id_0    #id
${btnSincronizar}    com.wealthsystems.sim3g.cliente.pedidoengine.app:id/sync_btnsincronizar    #id

${txtProgresso}    /hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[2]/android.widget.LinearLayout/android.widget.LinearLayout/android.widget.TextView[1]    #xpath
${porcentagemProgresso}    	/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[2]/android.widget.LinearLayout/android.widget.LinearLayout/android.widget.LinearLayout[2]/android.widget.TextView    #xpath

&{msgSyncFinalizada}
...    locatorMsg=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.FrameLayout/androidx.appcompat.widget.LinearLayoutCompat/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.TextView    #xpath
...    msg=Sincronização finalizada com sucesso!
...    btnOk=android:id/button1    #id
...    msgReaberturaApp=O sistema recebeu uma atualização e será reaberto.