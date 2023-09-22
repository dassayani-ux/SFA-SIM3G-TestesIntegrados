import requests
from lxml import etree, cssselect
from variables.varLogin import usuario, senha, urlLogin

# URL de login
login_url = urlLogin

# Criar uma sessão
session = requests.Session()

# Realizar o login na sessão
login_data = {
    'usuario': usuario,
    'senha': senha
}
session.post(login_url, data=login_data)

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