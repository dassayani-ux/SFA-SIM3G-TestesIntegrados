*** Settings ***

Library     SeleniumLibrary
Library     FakerLibrary    locale=pt_BR
Library    DateTime
Library    String
Resource    ../../../variables/web/global/globalVariables.robot
Resource    ../../../variables/web/cliente/cadastroClienteVariables.robot
Resource    ../../../variables/web/menu/menuLateralVariables.robot

*** Keywords ***

entrar em cliente

    Sleep   1.5s

    Wait Until Page Contains Element       id=${CLIENTE MENU}    timeout=50

    Click Element   id=${CLIENTE MENU}

    Sleep   0.5s

    Click Element   id=${MENU CLIENTE CADASTRAR}

    Sleep   0.9s

    Click Element   id=${MENU CLIENTE NOVO}

    Wait Until Page Contains Element    id=${TELA CADASTRO CLIENTE}

cadastro cliente geral

    Sleep   1s
    
    Wait Until Page Contains Element    Xpath=${TIPO PESSOA JURIDICA}

    Click Element   Xpath=${TIPO PESSOA JURIDICA}

    CLick Element   Xpath=${CONTRIBUINTE NÂO}

    ${NOME FAKE}    FakerLibrary.Name

    Press Keys    Name=${NOME CLIENTE}    ${NOME FAKE}

    Click Element   Name=${NOME FANTASIA}

    Press Keys    Name=${NOME FANTASIA}   ${NOME FAKE}

    Sleep   1s

    Click Element   Name=${NUMERO MATRICULA}
    
    ${NUMERO FAKE}  FakerLibrary.Random Number	

    Press Keys  Name=${NUMERO MATRICULA}    ${NUMERO FAKE}

    Click Element   id=${CLASSIFICAÇÂO CLIENTE}

    Sleep   0.6s

    Press Keys   id=${CLASSIFICAÇÂO CLIENTE}   ARROW_DOWN

cadastro cliente complemento

    Sleep   1s

    Click Element	  Name=${VALOR CAPITAL INTEGRAL}

    Click Element	  Name=${NUMERO DE FUNCIONARIOS}

    Sleep   2s
    
    ${CNPJ FAKE}    FakerLibrary.cnpj

    log   ${CNPJ FAKE}

    Press Keys      ${CNPJ}       ${CNPJ FAKE}

    Sleep   1s
    
    Press Keys  Name=${NUMERO DE FUNCIONARIOS}  1500

    Sleep   1s
    
    ${DATA FAKE}    FakerLibrary.Date Between Dates    date_start=-1y  
    
    ${DATA FAKE INICIO}    Convert Date     ${DATA FAKE} 00:00:00       result_format=%d/%m/%Y

    Input Text  Name=${DATA FUNDAÇÂO}   ${DATA FAKE INICIO} 

    ${FATURAMENTO FAKE}     FakerLibrary.Random Number

    Press Keys  Name=${VALOR FATURAMENTO}   ${FATURAMENTO FAKE}

    Press keys  Name=${VALOR CAPITAL SOCIAL}    ${FATURAMENTO FAKE} 

    Press keys  Name=${VALOR CAPITAL SUBSCRITO}     ${FATURAMENTO FAKE}

    Press Keys  Name=${VALOR CAPITAL INTEGRAL}      ${FATURAMENTO FAKE}

    

cadastro cliente informações adicionais

    Scroll Element Into View    id=${CNPJ MATRIZ}

    Press keys      id=${INSTRUÇÂO}     ARROW_DOWN

    Sleep   0.5s

    Press keys      id=${NATUREZA}      ARROW_DOWN

    Sleep   0.5s

    Press keys      id=${GRUPO TRIBUTAÇÂO}      ARROW_DOWN

    ${CNPJ FAKE}    FakerLibrary.cnpj

    Press Keys      id=${CNPJ MATRIZ}       ${CNPJ FAKE}

cadastro cliente geral local

    Sleep   1s
    
    Press Keys      Name=${LOCAL DESCRIÇÂO}     TESTE ROBOT

    Sleep   1s
    
    ${CNPJ FAKE}    FakerLibrary.cnpj

    Press Keys      Name=${CNPJ LOCAL}      ${CNPJ FAKE}

    ${LOGRADOURO FAKE}      FakerLibrary.Street Name

    Sleep   1s
    
    Press Keys      Name=${LOGRADOURO}      ${LOGRADOURO FAKE}

    ${NUMERO LOGRADOURO FAKE}     FakerLibrary.Random Int     min=10     max=20000

    Sleep   1s

    Press Keys      Name=${NUMERO LOGRADOURO}       102

    Press Keys      Name=${BAIRRO}       BAIRRO TESTE

    Press Keys      Name=${COMPLEMENTO}     TESTE COMPLEMENTO 

    ${CEP FAKE}     FakerLibrary.postcode

    Press keys      Name=${CEP}         ${CEP FAKE}

    ${CAIXA POSTAL FAKE}     FakerLibrary.Random Int     min=10     max=2000

    Press keys      Name=${CAIXA POSTAL}    ${CAIXA POSTAL FAKE}

    Sleep   0.9s
    
    Press Keys      id=${UF}    ARROW_DOWN   

    Press Keys      id=${UF}    ARROW_DOWN    

    Sleep   0.9s

    Click Element       id=${CIDADE}

    Press Keys      id=${CIDADE}    ARROW_DOWN

    Press Keys      id=${CIDADE}    ARROW_DOWN

    ${CREDITO FAKE}     FakerLibrary.Random Int     min=10000     max=200000

    Press Keys      id=${LIMITE CREDITO}    ${CREDITO FAKE}

    ${TELEFONE FAKE}    FakerLibrary.Phone Number

    Press Keys      id=${TELEFONE}  ${TELEFONE FAKE}

    Scroll Element Into View    Name=${INSCRIÇÂO SUFRAMA}

    ${EMAIL FAKE}    FakerLibrary.Email

    Press Keys      id=${EMAIL}     ${EMAIL FAKE}   

cadastro cliente documentos de identificação

    ${CREDITO FAKE}     FakerLibrary.Random Int     min=1000000000000     max=9000000000000

    Press Keys      Name=${CARTÂO PRODUTOR}     ${CREDITO FAKE}

    Press Keys      id=${INSCRIÇÂO ESTADUAL}    0121754832766

    Press Keys      Name=${INSCRIÇÂO MUNICIPAL}     ${CREDITO FAKE}

    Press Keys      Name=${INSCRIÇÂO SUFRAMA}       ${CREDITO FAKE}

cadastro cliente complemento local

    Scroll Element Into View    Name=${OBSERVAÇÂO LOCAL}

    Press Keys      id=${TIPO LOCAL}    ARROW_DOWN

    Sleep   0.5s

    Click Element   id=${SEGMENTO} 

    Press Keys     id=${SEGMENTO}      ARROW_DOWN

    Sleep   0.5s

    Click Element   id=${TABELA DE PREÇO}

    Press Keys     id=${TABELA DE PREÇO}      ARROW_DOWN

    Sleep   0.5s

    Click Element   id=${CONDIÇÂO PAGAMENTO}

    Press Keys     id=${CONDIÇÂO PAGAMENTO}     ARROW_DOWN

    Sleep   0.5s

    Click Element   id=${TIPO COBRANÇA}

    Press Keys     id=${TIPO COBRANÇA}      ARROW_DOWN

    ${PREÇO BASE FAKE}     FakerLibrary.Random Int     min=1000000     max=20000000

    Click Element   id=${PREÇO BASE} 

    Press keys      id=${PREÇO BASE}    ${PREÇO BASE FAKE}

    Press keys      Name=${OBSERVAÇÂO LOCAL}    TESTE ROBOT FRAMEWORK

gravar cadastro

    Sleep   1s

    Click Element   id=${GRAVAR}
    
    Sleep   4s

    Element Should Contain      id=${VALIDAÇÂO}      ${TEXTO VALIDAÇÂO}





