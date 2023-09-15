*** Settings ***
Documentation    Arquivo utilizado para armazenar variaveis com informações de inscrição estadual necessárias no processo de cadastro de lead.

*** Variables ***
&{goias}
...    estado=GOIAS
...    cidade=ANHANGUERA
...    inscricao=10.325.630-0

&{tocantins}
...    estado=TOCANTINS
...    cidade=PALMAS
...    inscricao=43988352-0

&{acre}
...    estado=ACRE
...    cidade=RIO BRANCO
...    inscricao=0140801714279

&{alagoas}
...    estado=ALAGOAS
...    cidade=Maceió
...    inscricao=248637223

&{amapa}
...    estado=AMAPA
...    cidade=Macapá
...    inscricao=036099619

&{amazonas}
...    estado=AMAZONAS
...    cidade=Manaus
...    inscricao=39.420.337-2

&{bahia}
...    estado=BAHIA
...    cidade=Salvador
...    inscricao=5542022-91

&{ceara}
...    estado=CEARA
...    cidade=Fortaleza
...    inscricao=69489108-8

&{distrito_federal}
...    estado=DISTRITO FEDERAL
...    cidade=Brasília
...    inscricao=07988894001-19

&{espirito_santo}
...    estado=ESPIRITO SANTO
...    cidade=Vitória
...    inscricao=89000805-1

&{maranhao}
...    estado=MARANHAO
...    cidade=São Luís
...    inscricao=12044991-9

&{mato_grosso}
...    estado=MATO GROSSO
...    cidade=Cuiabá
...    inscricao=3922188072-6

&{mato_grosso_do_sul}
...    estado=MATO GROSSO DO SUL
...    cidade=Campo Grande
...    inscricao=28161333-8

&{minas_gerais}
...    estado=MINAS GERAIS
...    cidade=Belo Horizonte
...    inscricao=500.686.931/4817

&{para}
...    estado=PARA
...    cidade=Belém
...    inscricao=15-632241-2

&{paraiba}
...    estado=PARAIBA
...    cidade=João Pessoa
...    inscricao=35717962-5

&{parana}
...    estado=PARANA
...    cidade=Curitiba
...    inscricao=562.36435-83

&{pernambuco}
...    estado=PERNAMBUCO
...    cidade=Recife
...    inscricao=5354307-60

&{piaui}
...    estado=PIAUI
...    cidade=Teresina
...    inscricao=37239788-3

&{rio_de_janeiro}
...    estado=RIO DE JANEIRO 
...    cidade=Macaé
...    inscricao=48.276.08-3

&{rio_grande_do_norte}
...    estado=RIO GRANDE DO NORTE
...    cidade=Natal
...    inscricao=20.313.500-8

&{rio_grande_do_sul}
...    estado=RIO GRANDE DO SUL
...    cidade=Porto Alegre
...    inscricao=343/2036983

&{rondonia}
...    estado=RONDONIA
...    cidade=Porto Velho
...    inscricao=4437014066558-7

&{roraima}
...    estado=RORAIMA
...    cidade=Boa Vista
...    inscricao=24172081-7

&{santa_catarina}
...    estado=SANTA CATARINA
...    cidade=Florianópolis
...    inscricao=987.264.397

&{sao_paulo}
...    estado=SAO PAULO
...    cidade=Campinas
...    inscricao=518.390.515.277

&{sergipe}
...    estado=SERGIPE
...    cidade=Aracaju
...    inscricao=94243587-7
   

@{inscricoes}    
...    ${rio_grande_do_sul}
...    ${acre}
...    ${alagoas}
...    ${amapa}
...    ${amazonas}
...    ${bahia}
...    ${ceara}
...    ${distrito_federal}
...    ${espirito_santo}
...    ${goias}
...    ${maranhao}
...    ${mato_grosso}
...    ${mato_grosso_do_sul}
...    ${minas_gerais}
...    ${para}
...    ${paraiba}
...    ${parana}
...    ${pernambuco}
...    ${piaui}
...    ${rio_de_janeiro}
...    ${rio_grande_do_norte}
...    ${rondonia}
...    ${roraima}
...    ${santa_catarina}
...    ${sao_paulo}
...    ${sergipe}
...    ${tocantins}