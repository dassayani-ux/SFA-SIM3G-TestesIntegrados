from robot.api.deco import keyword, not_keyword
from libraries.variables.sfa_variables import login_mobile, banco_de_dados
import psycopg2
from AppiumLibrary import AppiumLibrary
from robot.libraries.BuiltIn import BuiltIn

@not_keyword
def retorna_lista_ordem_menu_mobile():
    """Esta keyword retorna uma lista contendo a ordem do menu lateral no app Android."""
    stringBD = executar_sql("select c.ordemmenu from configuracaomenu c where c.contexto = 'MOBILE';")
    ordenacaoBD = stringBD[0][0].split("#")
    ordenacaoFormat = []
    for elemento in ordenacaoBD:
        if elemento == 'atendimento.cliente.modulo':
            ordenacaoFormat.append('Cliente')
        if elemento == 'registro.ponto':
            ordenacaoFormat.append('Registro de ponto')
        if elemento == 'catalogo.titulo':
            ordenacaoFormat.append('Catálogo de produtos')
        if elemento == 'cadastro.modulo.atendimento.rota':
            ordenacaoFormat.append('Rota')
        if elemento == 'atendimento.aba.consulta':
            ordenacaoFormat.append('Consulta')
        if elemento == 'menu.dashboard':
            ordenacaoFormat.append('Dashboard')
        if elemento == 'standard.demanda.titulo':
            ordenacaoFormat.append('Geração de demanda')
        if elemento == 'agenda.titulo':
            ordenacaoFormat.append('Agenda')
        if elemento == 'cadastro.modulo.viagem':
            ordenacaoFormat.append('Viagem')
        if elemento == 'mensagem.titulo':
            ordenacaoFormat.append('Mensagem')
        if elemento == 'pesquisacrm.pesquisa.titulo':
            ordenacaoFormat.append('Formulário')
        if elemento == 'mobile.relatorio':
            ordenacaoFormat.append('Relatório')
        if  elemento == 'sync.label.status':
            ordenacaoFormat.append('Sincronização')
        if  elemento == 'notificacao':
            ordenacaoFormat.append('Notificação')
        if  elemento == 'atendimento.registro.horario':
            ordenacaoFormat.append('Resumo mensal')
        
    return ordenacaoFormat

@not_keyword
def executar_sql(sql):
    try:
        conn = psycopg2.connect(
            dbname=banco_de_dados.dbName,
            user=banco_de_dados.dbUser,
            password=banco_de_dados.dbPass,
            host=banco_de_dados.dbHost,
            port=banco_de_dados.dbPort
        )

        cursor = conn.cursor()
        cursor.execute(sql)
        res = cursor.fetchall()
    except psycopg2.Error as e:
        print(f"Erro ao conectar ao banco de dados:", e)
    finally:
        cursor.close()
        conn.close()
    
    return res

@not_keyword
def retornar_perfil_acesso(userLogin):
    sql = f"select u.idperfilacesso from usuario u where u.login = '{userLogin}'"
    result = executar_sql(sql)
    return  result[0][0]

@not_keyword
def retornar_regra_principal_mobile():
    sql = f"select r.idregra from regra r where r.chave = 'mobile.regra.acesso'"
    result = executar_sql(sql)
    return result[0][0]

@not_keyword
def retornar_permissoes_filhas(perfil, regra_pai):
    sql = f"""select r.chave from perfilacessoregra p
    inner join regra r on r.idregra = p.idregra and r.idregrasuperior = {regra_pai}
    where p.idperfilacesso = {perfil}"""
    result = executar_sql(sql)
    return result

@not_keyword
def retorna_lista_permissao_mobile():
    perfil_acesso = retornar_perfil_acesso(login_mobile.usuarioMobile)
    regra_pai = retornar_regra_principal_mobile()
    permissoes = retornar_permissoes_filhas(perfil_acesso, regra_pai)
    permisao_format = []

    for elemento in permissoes:
        per = elemento[0]

        if per == 'mobile.regra.acesso.relatorio':
            permisao_format.append('Relatório')
        if per == 'mobile.regra.acesso.cliente':
            permisao_format.append('Cliente')
        if per == 'mobile.regra.acesso.rota':
            permisao_format.append('Rota')
        if per == 'mobile.regra.acesso.catalogo':
            permisao_format.append('Catálogo de produtos')
        if per == 'mobile.regra.acesso.consulta':
            permisao_format.append('Consulta')
        if per == 'mobile.regra.acesso.dashboard':
            permisao_format.append('Dashboard')
        if per == 'mobile.regra.acesso.agenda':
            permisao_format.append('Agenda')
        if per == 'mobile.regra.acesso.viagem':
            permisao_format.append('Viagem')
        if per == 'mobile.regra.acesso.mensagem':
            permisao_format.append('Mensagem')
        if per == 'mobile.regra.acesso.pesquisa':
            permisao_format.append('Formulário')
        if per == 'mobile.regra.acesso.demanda':
            permisao_format.append('Geração de demanda')
        if per == 'mobile.regra.acesso.resumomensal':
            permisao_format.append('Resumo mensal')
        if per == 'mobile.regra.acesso.removerlicenca':
            permisao_format.append('Remover licença')
        if per == 'mobile.regra.acesso.registro.ponto':
            permisao_format.append('Registro de ponto')
        if per == 'mobile.regra.acesso.oportunidade':
            permisao_format.append('Oportunidade')
        if per == 'mobile.regra.acesso.lead':
            permisao_format.append('Lead')
        if per == 'mobile.regra.acesso.notificacao':
            permisao_format.append('Notificação')

    return permisao_format

@keyword("Retornar ordem menu mobile")
def retorna_ordem_menu_mobile():
    ordenacao = retorna_lista_ordem_menu_mobile()
    permissoes = retorna_lista_permissao_mobile()

    menus = []

    for elemento in ordenacao:
        count = permissoes.count(elemento)
        if count == 1:
            menus.append(elemento)
        if elemento == 'Sincronização':
            menus.append(elemento)

    menus.append('Sair')
    return menus

@keyword("Retornar casas decimais valores monetarios")
def return_decimals_monetario():
    """Esta keyword retorna o valor para o parâmetro QTD_CASAS_DECIMAIS_MONETARIO"""

    sql = f"select p.valor from parametro p where p.chave = 'QTD_CASAS_DECIMAIS_MONETARIO';"
    casas = executar_sql(sql)
    casas_str = casas[0][0]
    casas_int = int(casas_str)

    return casas_int

@keyword("Retornar casas decimais quantidade fracionada")
def return_decimals_quantidade_fracionada():
    """Esta keyword retorna o valor para o parâmetro QTD_CASAS_DECIMAIS_QUANTIDADE_FRACIONADA"""

    sql = f"select p.valor from parametro p where p.chave = 'QTD_CASAS_DECIMAIS_QUANTIDADE_FRACIONADA';"
    casas = executar_sql(sql)
    casas_str = casas[0][0]
    casas_int = int(casas_str)

    return casas_int

@keyword("Formatar valor monetario")
def format_valor_monetario(value):
    """Esta keyword recebe um valor e remove pontos, vírgulas, R$ e espaços. 
    Feito isso, adiciona a vírgula seguindo o valor do parametro que define a quantidade de casas decimais monetárias (QTD_CASAS_DECIMAIS_MONETARIO)"""

    value_str = str(value)
    casas = return_decimals_monetario()

    valueRemove = value_str.replace(".","").replace(",","").replace("R$","").replace(" ","")

    # Inserir a vírgula na posição correta
    parte_inteira = valueRemove[:-casas]
    parte_decimal = valueRemove[-casas:]

    print(f"Valor sem vírgula: [", valueRemove, "]")
    print(f"Parte inteira: [", parte_inteira, "]")
    print(f"Parte decimal: [", parte_decimal, "]")
    
    value_final= f"{parte_inteira},{parte_decimal}"
    return value_final

@keyword("Formatar quantidade fracionada")
def format_quantidade_fracionada(value):
    """Esta keyword recebe um valor e remove pontos, vírgulas  e espaços. 
    Feito isso, adiciona a vírgula seguindo o valor do parametro que define a quantidade de casas decimais de quantidade fracionada (QTD_CASAS_DECIMAIS_QUANTIDADE_FRACIONADA)"""

    value_str = str(value)
    casas = return_decimals_quantidade_fracionada()

    valueRemove = value_str.replace(".","").replace(",","").replace(" ","")

    # Inserir a vírgula na posição correta
    parte_inteira = valueRemove[:-casas]
    parte_decimal = valueRemove[-casas:]

    print(f"Valor sem vírgula: [", valueRemove, "]")
    print(f"Parte inteira: [", parte_inteira, "]")
    print(f"Parte decimal: [", parte_decimal, "]")
    
    value_final= f"{parte_inteira},{parte_decimal}"
    return value_final

@keyword("Rolar tela")
def scroll_screan(direction='down', duration=1000):
    """
    Rola a tela do dispositivo móvel usando o driver do Appium criado pelo Robot Framework.

    :param direction: Direção do scroll, 'up' para cima e 'down' para baixo.
    :param duration: Duração do scroll em milissegundos.
    """
    appium_lib = BuiltIn().get_library_instance('AppiumLibrary')
    driver = appium_lib._current_application()
    
    window_rect = driver.get_window_rect()
    width = window_rect['width']
    height = window_rect['height']

    start_x = width // 2
    start_y = height * 0.8 if direction == 'down' else height * 0.3
    end_x = width // 2
    end_y = height * 0.2 if direction == 'down' else height * 0.8

    driver.swipe(start_x, start_y, end_x, end_y, duration)

@keyword("Limpar listas")
def clear_list(input_list):
    """
    Remove todos os itens da lista passada como argumento.

    :param input_list: A lista que será limpa.
    """
    input_list.clear()