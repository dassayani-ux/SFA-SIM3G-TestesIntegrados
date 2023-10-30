import requests
from lxml import etree, cssselect
from variables.sfa_variables import login_web, imagemWeb
from selenium.webdriver.common.by import By
from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword, not_keyword
from selenium import webdriver

# URL de login
login_url = login_web.urlLoginWeb

# Criar uma sessão
session = requests.Session()

# Realizar o login na sessão
login_data = {
    'usuario': login_web.usuarioWeb,
    'senha': login_web.senhaWeb
}
session.post(login_url, data=login_data)

@keyword("Retornar xpath do elemento pai")
def return_xpath_parent(css_class, url):
    """Utiliza a classe passada em *css_class* para retornar uma lista contendo o *xpath* do elemento pai de todos
    os elementos que possuem a classe passada como argumento."""
    response = session.get(url)
    html_content = response.content.decode('utf-8')
    tree = etree.ElementTree(etree.HTML(html_content))
    selector = cssselect.CSSSelector('.' + css_class)
    elements = selector(tree)
    xpaths = []
    for element in elements:
        parent_element = element.getparent()
        xpath = tree.getpath(parent_element)
        xpaths.append(xpath)
    return xpaths

@keyword("Incluir imagem atendimento")
def incluir_imagem_atendimento(url):
    """Esta keyword realiza a inclusão de imagem no atendimento."""
    selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary')
    driver = selenium_lib.driver
    driver.get(url)
    file_input = driver.find_element(By.ID, "imageUpload")
    file_input.send_keys(imagemWeb.dirImagemAtendimento)

@keyword('Fechar guia de Dashboard')
def fechar_guia_dashboard():
    """Utilizada para fechar a guia Dashboard que é aberta constatemente pelo robot."""
    selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary')
    driver = selenium_lib.driver
    window_handles = driver.window_handles
    for handle in window_handles:
        driver.switch_to.window(handle)
        title = driver.title
        if title == 'TOTVS CRM SFA | Dashboard':
            driver.close()