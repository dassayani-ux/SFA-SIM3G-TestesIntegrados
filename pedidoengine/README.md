Pasta utilizada para armazenar os casos de testes automatizados do produto padrão **PEDIDOENGINE**.

# ⚠ IMPORTANTE
Por motivos de segurança, o arquivo **sfa_variables.py**, que contem informações de acesso a aplicação e ao banco de dados é ignorado no commit, portanto, caso queira rodar o projeto em sua máquina é necessário seguir as instuções abaixo:

1. Realizar uma cópia do arquivo **sfa_variables.py.template** do direório: **pedidoengine/libraries/variables**;

_Obs.: A cópia deve ser criada na mesma pasta do .template_

2. Renomear esse novo arquivo criado para **sfa_variables.py**;
3. Preencher as variáveis de acordo com os dados utilizados por você.

# Atenção
Para evitar conflitos em caminhos de diretórios, todos devem realizar o **pull** deste repositório seguindo a hierarquia abaixo:

**C:\WS\Fontes\SFA-SIM3G-TestesIntegrados**

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

### Android Studio
https://developer.android.com/studio

### Node JS
https://nodejs.org/en

### Appium Server
https://github.com/appium/appium-desktop/releases

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

### Appium Library
    pip install robotframework-appiumlibrary
http://serhatbolsu.github.io/robotframework-appiumlibrary/AppiumLibrary.html

# 📚 Bibliotecas Python

<p>Essas são as bibliotecas necessárias para que as libs customizadas criadas no projeto rodem sem erros.</p>

### Requests
    pip install requests

### LXML
    pip install lxml

### Cssselect
    pip install cssselect

### Unidecode
    pip install unidecode