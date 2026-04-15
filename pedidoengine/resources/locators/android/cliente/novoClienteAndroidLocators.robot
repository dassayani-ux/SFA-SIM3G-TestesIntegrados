*** Settings ***
Documentation    Localizadores da tela de Novo Cliente no app Android.

*** Variables ***
# ==============================================================================
# MENU SUPERIOR / AÇÕES
# ==============================================================================
${novoCliente.maisOpcoes}       accessibility_id=Mais opções
${novoCliente.menuItem}         xpath=//android.widget.TextView[@resource-id="com.wealthsystems.sim3g.cliente.pedidoengine.app:id/title" and @text="Novo cliente"]

# ==============================================================================
# TELA NOVO CLIENTE — ABA DADOS
# ==============================================================================
${dadosCliente.radioJuridica}       xpath=//android.widget.RadioButton[@text="Jurídica"]
${dadosCliente.radioFisica}         xpath=//android.widget.RadioButton[@text="Física"]
${dadosCliente.nome}                xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[1]/android.widget.EditText
${dadosCliente.fantasia}            xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[2]/android.widget.EditText
${dadosCliente.matricula}           xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[3]/android.widget.EditText
${dadosCliente.classificacao}       xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[4]/android.widget.Spinner
${dadosCliente.homepage}            xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[5]/android.widget.EditText
${dadosCliente.cnae}                xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[9]/android.widget.EditText
${dadosCliente.abaComplemento}      xpath=//android.widget.TextView[@text="COMPLEMENTO"]

# Valores de classificação conhecidos
${dadosCliente.classificacaoAutomacao}    xpath=//android.widget.TextView[@text="CLASSIFICACAO AUTOMACAO"]

# ==============================================================================
# TELA NOVO CLIENTE — ABA COMPLEMENTO
# ==============================================================================
${complementoCliente.cnpj}               xpath=//android.widget.EditText
${complementoCliente.numFuncionarios}    xpath=//android.widget.Button[@text="0"]
${complementoCliente.dataFundacao}       xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[3]/android.widget.Button
${complementoCliente.faturamento}        xpath=(//android.widget.Button[@text="0,00"])[1]
${complementoCliente.capitalSocial}      xpath=(//android.widget.Button[@text="0,00"])[2]
${complementoCliente.capitalSubscrito}   xpath=(//android.widget.Button[@text="0,00"])[3]
${complementoCliente.capitalIntegral}    xpath=(//android.widget.Button[@text="0,00"])[4]

# ==============================================================================
# BOTÃO PRÓXIMO (avança para tela de Local)
# ==============================================================================
${btnProximoCliente}    xpath=//android.widget.Button[@text="PRÓXIMO"]

# ==============================================================================
# TELA LOCAL — ABA DADOS
# ==============================================================================
${local.descricao}      xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[1]/android.widget.EditText
${local.cnpj}           xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[2]/android.widget.EditText
${local.logradouro}     xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[3]/android.widget.EditText
${local.numero}         xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[4]/android.widget.Button
${local.bairro}         xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[5]/android.widget.EditText
${local.complemento}    xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[6]/android.widget.EditText
${local.cep}            xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[7]/android.widget.EditText
${local.caixaPostal}    xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[8]/android.widget.EditText
${local.uf}             xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[9]/android.widget.Spinner
${local.cidade}         xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[10]/android.widget.Spinner
${local.abaComplemento}    xpath=//android.widget.TextView[@text="COMPLEMENTO"]

# Valores UF / Cidade
${local.ufParana}          xpath=//android.widget.TextView[@text="PARANA"]
${local.cidadeCascavel}    xpath=//android.widget.TextView[@text="CASCAVEL (PR)"]

# ==============================================================================
# TELA LOCAL — ABA COMPLEMENTO
# ==============================================================================
${localCompl.tipoLocal}             xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[1]/android.widget.Spinner
${localCompl.tipologia}             xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[2]/android.widget.Spinner
${localCompl.praca}                 xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[3]/android.widget.Spinner
${localCompl.tabelaPreco}           xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[4]/android.widget.Spinner
${localCompl.condicoesPagamento}    xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[5]/android.widget.Spinner
${localCompl.tipoCobranca}          xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[6]/android.widget.Spinner
${localCompl.segmento}              xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[7]/android.widget.Spinner
${localCompl.cartProdutor}          xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[9]/android.widget.LinearLayout[1]/android.widget.EditText
${localCompl.ie}                    xpath=//android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[9]/android.widget.LinearLayout[2]/android.widget.EditText
${localCompl.isento}                xpath=//android.widget.CheckBox[@text="Isento"]
${localCompl.precoBase}             xpath=//androidx.viewpager.widget.ViewPager/android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[5]/android.widget.Button
${localCompl.observacao}            xpath=//androidx.viewpager.widget.ViewPager/android.widget.ScrollView/android.widget.LinearLayout/android.widget.LinearLayout[6]/android.widget.ScrollView/android.widget.EditText

# ==============================================================================
# FINALIZAR
# ==============================================================================
${btnFinalizar}                  xpath=//android.widget.Button[@text="FINALIZAR"]
${menuFlutuante.gravarSair}      xpath=//android.widget.TextView[@text="Gravar e sair"]
${telaListagemClientes.topo}     xpath=//*[@resource-id="com.wealthsystems.sim3g.cliente.pedidoengine.app:id/menu_top"]

# ==============================================================================
# CALCULADORA NUMÉRICA (abre ao clicar em campos de número/valor)
# ==============================================================================
${calculadora.display}      xpath=//android.widget.TextView[@resource-id="com.wealthsystems.sim3g.cliente.pedidoengine.app:id/tclnum_display"]
${calculadora.btnDefinir}   xpath=//android.widget.Button[@resource-id="android:id/button1"]
