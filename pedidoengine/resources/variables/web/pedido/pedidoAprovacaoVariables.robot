*** Variables ***
&{aprovacao}
...    btn_aprovar=//*[@id="grid_pedidoAprovacao"]/div[5]/div/div[3]/div[8]/a/img
...    btn_reprovar=//*[@id="grid_pedidoAprovacao"]/div[5]/div/div[3]/div[7]/a/img
...    btn_aprovadores=//*[@id="grid_pedidoAprovacao"]/div[5]/div/div[3]/div[6]/a/img
...    btn_historico=//*[@id="grid_pedidoAprovacao"]/div[5]/div/div[3]/div[5]/a/img
...    btn_voltar=//*[@id="btnVoltar"]
...    btn_fechar=//*[@id="popup0"]/div/div/div[1]/div/div[2]/a
...    campoSituacao=//*[@id="grid_pedidoAprovacao"]/div[5]/div/div[3]/div[2]/div/span


&{dialogAprovadores}
...    nome=//*[@id="aprovadores"]/div/ul/li[1]/div/div[2]/p[1]
...    status=//*[@id="aprovadores"]/div/ul/li[5]/div/div[2]/p[2]



&{linkAprovacao}
...    status=/html/body/div[2]/div/div/ul/li/div/div[2]/p[3]