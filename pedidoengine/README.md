Pasta utilizada para armazenar os casos de testes automatizados do produto padrão **PEDIDOENGINE**.

# ⚠ IMPORTANTE
Por motivos de segurança, arquivos que possuem dados de acesso à plataforma e ao banco de dados são ignorados no commit, portanto, caso queira rodar o projeto em sua máquina é necessário seguir as instruções abaixo:

1. Criar um arquivo chamado **newGlobalVariables.robot** no direório: **pedidoengine/resources/variables/web/global**.

    Usar o seguinte template como exemplo:

    _Obs.: Após criar o aquivo seguindo o template abaixo, basta substituir as informações de acordo com os dados utilizados por você._
```
*** Settings ***
Documentation    Arquivo utilizado para realizar a configuraçao de aceesso ao banco de dados do Omni.
...    Este arquivo não está presente no repositório, portanto necessário criá-lo e configurá-lo corretamente para rodar os testes.

*** Variables ***
*** Settings ***
Documentation    Arquivo utilizado para armazenar variáveis globais que não possuem tipagem predefinida.

*** Variables ***
${NAVEGADOR}    Chrome
${WEB_URL}    http://localhost:8080/automacao

# Acesso ao banco de dados
${DBHost}         localhost
${DBName}         automacao
${DBPass}         password
${DBPort}         5432
${DBUser}         user
${DBDriver}       psycopg2


## Imagens Sikuly
${dirSikully}    ${EXECDIR}\\resources\\elements
```

2. Criar um arquivo chamado **varLogin.py** no direório: **pedidoengine/libraries/variables**.

    Usar o seguinte template como exemplo:

    _Obs.: Após criar o aquivo seguindo o template abaixo, basta substituir variáveis **usuario** e **senha** de acordo com os dados utilizados por você._
```
usuario = 'user'    
senha = 'password'
usuarioInvalido = '123'
senhaInvalida = '123'
msgErro = 'Informações preenchidas incorretamente'
```

# ❗Recomendação
Para tentar evitar conflitos em caminhos de diretórios, recomento que todos que façam o **pull** deste repositório o façam seguindo a mesma hierarquia de pasta, pois assim é mais
difícil ocorrer problemas de referência.

Hierarquia sugerida:   **C:\WS\Fontes\SFA-SIM3G-TestesIntegrados**

<p>
    --------------------------------------------------
</p>

# 🖥 Tecnologias 
### Python 3.11.0 
https://www.python.org/downloads/
  
### Robot Framework 6.0.1 
    pip install robotframework
https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html
### Java 8
https://javadl.oracle.com/webapps/download/AutoDL?BundleId=247136_10e8cce67c7843478f41411b7003171c

<p>
    --------------------------------------------------
</p>

# 🗄 Acesso ao banco de dados:
### Psycopg2
    pip install psycopg2

<p>
    --------------------------------------------------
</p>

# 📚 Bibliotecas
### Database Library
    pip install robotframework-databaselibrary
_Não foi encontrado link com a documentação das keywords dessa biblioteca._
  
### Sikuli Library 
    pip install robotframework-SikuliLibrary
https://rainmanwy.github.io/robotframework-SikuliLibrary/doc/SikuliLibrary.html
  
### Selenium Library
    pip install robotframework-seleniumlibrary
https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html

### Faker Library
    pip install robotframework-faker
https://guykisel.github.io/robotframework-faker/

# 📚 Bibliotecas Python

<p>Essas são as bibliotecas necessárias para que as libs customizadas criadas no projeto rodem sem erros.</p>

### Requests
    pip install requests

### LXML
    pip install lxml

### Cssselect
    pip install cssselect