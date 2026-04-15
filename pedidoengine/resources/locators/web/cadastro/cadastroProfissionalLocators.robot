*** Settings ***
Documentation    Locators da tela de Cadastro de Profissional (SFA Web).

*** Variables ***

# --- Menu Lateral ---
${menuCadastro.titulo}              css=span[title='Cadastro']
${menuCadastro.linkProfissional}    xpath=//li[@id='cadastro.modulo.usuario.cadastro']/a

# --- Listagem de Profissionais ---
${listaProfissionais.btnAdicionar}    id=grid-button-adicionar

# --- Formulário Principal ---
${formProfissional.login}           name=usuario.login
${formProfissional.senha}           name=senha
${formProfissional.confirmaSenha}   name=confirmaSenha
${formProfissional.nome}            name=usuario.nome
${formProfissional.cpf}             name=usuario.documentoIdentificacao
${formProfissional.telefone}        name=usuario.telefonepadrao
${formProfissional.email}           name=usuario.emailpadrao
${formProfissional.btnGravar}       id=btnGravar
${formProfissional.btnPontoGPS}    css=span.ui-sim3g-icon-ponto-central-white

# --- Mapa / Ponto GPS ---
${mapaProfissional.searchInput}    css=.gmap-searchInput
${mapaProfissional.btnGravar}      id=btnGravarMapeamento
${mapaProfissional.pacItem}        css=.pac-item
${mapaProfissional.gmStyle}        css=.gm-style

# --- Aba Hierarquia ---
${abaHierarquia.tab}              id=usuariohierarquia.listar
${abaHierarquia.painelBusca}      xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-l')]
${abaHierarquia.painelDir}        xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-r')]
${abaHierarquia.btnSeta}          xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-m')]//button[contains(@class,'btn-R')]
${abaHierarquia.slickRow}         xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-l')]//div[contains(@class,'slick-row')]
${abaHierarquia.checkboxTodos}    xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-l')]//div[contains(@class,'slick-column-name')]//input[@type='checkbox']
${abaHierarquia.slickRowDir}      xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-r')]//div[contains(@class,'slick-row')]
${abaHierarquia.btnGravar}        xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-r')]//*[@id='grid-button-gravar']
${abaHierarquia.campoBusca}       xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-l')]//*[@name='termo']
${abaHierarquia.btnPesquisar}     xpath=//div[@id='tab_usuariohierarquia.listar']//div[contains(@class,'div-l')]//*[@id='btnPesquisar']

# --- Aba Carteira de Clientes ---
${abaCarteira.tab}              id=usuariolocal.listar
${abaCarteira.painelBusca}      xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-l')]
${abaCarteira.painelDir}        xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-r')]
${abaCarteira.btnSeta}          xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-m')]//button[contains(@class,'btn-R')]
${abaCarteira.slickRow}         xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-l')]//div[contains(@class,'slick-row')]
${abaCarteira.checkboxTodos}    xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-l')]//div[contains(@class,'slick-column-name')]//input[@type='checkbox']
${abaCarteira.slickRowDir}      xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-r')]//div[contains(@class,'slick-row')]
${abaCarteira.btnGravar}        xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-r')]//*[@id='grid-button-gravar']
${abaCarteira.campoBusca}       xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-l')]//*[@name='termo']
${abaCarteira.btnPesquisar}     xpath=//div[contains(@class,'usuarioLocal-grid')]//div[contains(@class,'div-l')]//*[@id='btnPesquisar']

# --- Aba Filiais ---
${abaFiliais.tab}              id=usuariofilial.listar
${abaFiliais.painelBusca}      xpath=//div[@id='tab_usuariofilial.listar']//div[contains(@class,'div-l')]
${abaFiliais.painelDir}        xpath=//div[@id='tab_usuariofilial.listar']//div[contains(@class,'div-r')]
${abaFiliais.btnSeta}          xpath=//div[@id='tab_usuariofilial.listar']//div[contains(@class,'div-m')]//button[contains(@class,'btn-R')]
${abaFiliais.slickRow}         xpath=//div[@id='tab_usuariofilial.listar']//div[contains(@class,'div-l')]//div[contains(@class,'slick-row')]
${abaFiliais.checkboxTodos}    xpath=//div[@id='tab_usuariofilial.listar']//div[contains(@class,'div-l')]//div[contains(@class,'slick-column-name')]//input[@type='checkbox']
${abaFiliais.slickRowDir}      xpath=//div[@id='tab_usuariofilial.listar']//div[contains(@class,'div-r')]//div[contains(@class,'slick-row')]
${abaFiliais.btnGravar}        xpath=//div[@id='tab_usuariofilial.listar']//div[contains(@class,'div-r')]//*[@id='grid-button-gravar']
${abaFiliais.btnPesquisar}     xpath=//div[@id='tab_usuariofilial.listar']//div[contains(@class,'div-l')]//*[@id='btnPesquisar']
