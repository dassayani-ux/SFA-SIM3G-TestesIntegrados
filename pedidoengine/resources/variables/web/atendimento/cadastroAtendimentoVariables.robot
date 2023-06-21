*** Settings ***
Documentation    Arquivo utilizado para armazenar variáveis de dados utilizados para cadastro de atendimento.

*** Variables ***
${repositorioImagemAtendimento}    C:\\WS\\Fontes\\SFA-CLIENTE-PedidoEngine\\testes-integrados\\resources\\elements\\atendimento
${nomeImagemAtendimento}    imgAtendimento.jpg

${idAtendimento}    ##Utilizada para armazenar temporariamente o ID do atendimento que será validado

@{dataHoraFimOriginal}    ##Utilizada para armazenar temporariamente a data e hora anterior à edição do atendimento.