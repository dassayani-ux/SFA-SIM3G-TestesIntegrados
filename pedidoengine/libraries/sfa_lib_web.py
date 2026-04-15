import requests
import string as _string
import random as _random
from lxml import etree, cssselect
from variables.sfa_variables import login_web, imagemWeb
from selenium.webdriver.common.by import By
from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword, not_keyword
from selenium import webdriver

# ==============================================================================
# CNPJ ALFANUMÉRICO — Instrução Normativa RFB nº 2.119 / SERPRO
# Algoritmo: Módulo 11, pesos 2-9 da direita p/ esquerda, reinicia no 8º char
# Valor de cada char = ord(char.upper()) - 48  (ASCII - 48)
# ==============================================================================
_PESOS_DV_CNPJ = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

def _calcular_digito_cnpj(chars: str) -> int:
    """Calcula 1 dígito verificador para uma string de 12 ou 13 chars."""
    n = len(chars)
    soma = sum(
        (ord(c.upper()) - 48) * _PESOS_DV_CNPJ[len(_PESOS_DV_CNPJ) - n + i]
        for i, c in enumerate(chars)
    )
    resto = soma % 11
    return 0 if resto < 2 else 11 - resto

@keyword('Calcular DV CNPJ Alfanumerico')
def calcular_dv_cnpj_alfanumerico(base_12: str) -> str:
    """Recebe os 12 primeiros chars do CNPJ alfanumérico (sem formatação, maiúsculas)
    e retorna os 2 dígitos verificadores como string de 2 chars."""
    base_12 = base_12.upper().replace('.', '').replace('/', '').replace('-', '')
    if len(base_12) != 12:
        raise ValueError(f"Base do CNPJ deve ter 12 caracteres. Recebeu: {len(base_12)}")
    dv1 = _calcular_digito_cnpj(base_12)
    dv2 = _calcular_digito_cnpj(base_12 + str(dv1))
    return f"{dv1}{dv2}"

@keyword('Gerar CNPJ Alfanumerico Valido')
def gerar_cnpj_alfanumerico_valido() -> str:
    """Gera um CNPJ alfanumérico válido com DVs corretos (14 chars sem formatação).
    Garante ao menos uma letra na base para diferenciar do CNPJ numérico."""
    chars = _string.ascii_uppercase + _string.digits
    while True:
        base = ''.join(_random.choices(chars, k=12))
        if any(c.isalpha() for c in base):
            dv = calcular_dv_cnpj_alfanumerico(base)
            return base + dv

@keyword('Formatar CNPJ Alfanumerico')
def formatar_cnpj_alfanumerico(cnpj_14: str) -> str:
    """Formata CNPJ alfanumérico de 14 chars sem pontuação para SS.SSS.SSS/SSSS-NN."""
    c = cnpj_14.replace('.', '').replace('/', '').replace('-', '').upper()
    if len(c) != 14:
        raise ValueError(f"CNPJ deve ter 14 caracteres. Recebeu: {len(c)}")
    return f"{c[0:2]}.{c[2:5]}.{c[5:8]}/{c[8:12]}-{c[12:14]}"

@keyword('Validar CNPJ Alfanumerico')
def validar_cnpj_alfanumerico(cnpj: str) -> bool:
    """Retorna True se o CNPJ alfanumérico (com ou sem formatação) é válido."""
    c = cnpj.upper().replace('.', '').replace('/', '').replace('-', '')
    if len(c) != 14:
        return False
    if all(ch == '0' for ch in c):
        return False
    import re
    if not re.match(r'^[A-Z0-9]{12}[0-9]{2}$', c):
        return False
    dv_calculado = calcular_dv_cnpj_alfanumerico(c[:12])
    return dv_calculado == c[12:14]

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
        if title == 'TOTVS CRM SFA | Dashboard' or title == 'TOTVS CRM SFA | Gestao de Clientes':
            driver.close()

@keyword('Limpar dicionario')
def clean_dictionary(data):
    if not isinstance(data, dict):
        raise ValueError("O tipo de dado deve ser um dicionário.")

    # Limpa todos os valores, mantendo as chaves
    cleaned_data = {k: "" for k, v in data.items()}
    return cleaned_data