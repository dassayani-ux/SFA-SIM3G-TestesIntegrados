*** Settings ***
Documentation    Arquivo utilizado para armazenar a localização dos componentes na tela de login na plataforma web.

*** Variables ***
# ID    
${formularioLogin}    login_form
${TF_LOGIN}    formusuario     
${TF_SENHA}    formsenha
${BTN_ENTRAR}    btnGravar
${MSG_LOGIN_INVALIDO}    loginerror

# Logoff
&{logoff}
...    acoes=userInfoArrow    #id
...    sair=/html/body/header/div[4]/div/div[4]/a[3]