Pasta utilizada para armazenar os casos de testes automatizados do produto padrão **PEDIDOENGINE**.

# ⚠ IMPORTANTE
Por motivos de segurança, arquivos que possuem dados de acesso à plataforma e ao banco de dados são ignorados no commit, portanto, caso queira rodar o projeto em sua máquina é necessário seguir as instruções abaixo:

1. Criar um arquivo chamado **globalVariables.robot** no direório: **pedidoengine/resources/variables/web/global**.

    Usar o seguinte template como exemplo:

    _Obs.: Após criar o aquivo seguindo o template abaixo, basta substituir as informações de acordo com os dados utilizados por você._
```
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
urlLogin = 'http://localhost:8080/automacao/login.logar.ws?redirecturl='
```

3. Criar um arquivo chamado **globalVariables.robot** no direório **pedidoengine/resources/variables/android/global**.
    Usar o seguinte template como exemplo:

    _Obs.: Após criar o aquivo seguindo o template abaixo, basta substituir as informações de acordo com os dados utilizados por você._
```
*** Settings ***
Documentation    Arquivo utilizado para armazenar variáveis globais que não possuem tipagem predefinida.

*** Variables ***
&{capabilities}    # Utilizados para inicializar a conexão com o Appium Server
...    urlAppium=http://localhost:4723/wd/hub
...    automationName=UiAutomator2
...    platformName=Android
...    deviceName=Emulador
...    app=C:/Users/paulo.hvargas/Documents/Versoes/AUTOMACAO/dev/android/sim3g.cliente.pedidoengine.android.apk-pedidoEngine-release.apk
...    udid=RQ8MB06FLHV
...    autoGrantPermissions=true
...    appWaitActivity=com.wealthsystems.sim3g.modulo.controleacesso.android.api.LoginActivity
...    noReset=true
```

4. Criar um arquivo chamado **loginVariables.robot** no direório **pedidoengine/resources/variables/android/login**.
    Usar o seguinte template como exemplo:

    _Obs.: Após criar o aquivo seguindo o template abaixo, basta substituir as informações de acordo com os dados utilizados por você._
```
*** Settings ***
Documentation    Arquivo utilizado para armazenar variáveis utilizadas no login.

*** Variables ***
${profissional}    123
${senha}    123
```

5. Criar um arquivo chamado **syncVariables.robot** no direório **pedidoengine/resources/variables/android/sincronizacao**.
    Usar o seguinte template como exemplo:

    _Obs.: Após criar o aquivo seguindo o template abaixo, basta substituir as informações de acordo com os dados utilizados por você._
```
*** Settings ***
Documentation    Arquivo utilizado para armazenar variáveis necessárias para realizar a sync no app Android.

*** Variables ***
${ipServer}    192.1.1.1:40921
```

# ❗Atenção
Para  evitar conflitos em caminhos de diretórios, todos devem realizar o **pull** deste repositório na seguinte hierarquia de pasta:

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