from fordev.generators import people, uf
from fordev.generators import cpf, cnpj as generateCNPJ, state_registration as generateIE



class Generator:

    def fake_pessoa(self):
        estado = uf()
        pessoa = people(uf_code=estado[0], formatting=False)
        return pessoa

    def valida_email(self, email):
        if(len(email) > 40):
            return False

        return True
    

    def get_email(self):
        pessoa = self.fake_pessoa()
        email = pessoa.get('email')
        
        
        while(self.valida_email(email) == False):
            pessoa = self.fake_pessoa()
            email = pessoa.get('email')
    
            
        return pessoa.get('email').replace("..",".")

    def get_nome(self):
        pessoa = self.fake_pessoa()
        return pessoa.get('nome')

    def get_password(self):
        pessoa = self.fake_pessoa()
        return pessoa.get('senha')

    def get_ddd(self):
        pessoa = self.fake_pessoa()
        telefone = pessoa.get('celular').split()
        telefone = telefone[0]
        return telefone[0:2]

    def get_telefone(self):
        pessoa = self.fake_pessoa()
        telefone = pessoa.get('celular').split()
        telefone = telefone[0]
        return telefone[1:12]

    def get_cnpj(self):
        cnpj = generateCNPJ(formatting=False)
        return cnpj

    def get_ie(self):
        ie = generateIE(uf_code='PR', formatting = True, data_only = True)
        return ie

    def get_cpf(self):    
        pessoa = self.fake_pessoa()
        return pessoa.get('cpf')

    def get_data(self):
        pessoa = self.fake_pessoa()
        return pessoa.get ('data_nasc')

    def get_sexo(self):
        pessoa = self.fake_pessoa()
        return pessoa.get ('sexo')


    def get_cep(self):
        pessoa = self.fake_pessoa()
        return pessoa.get ('cep')

    def get_endereco(self):
        pessoa = self.fake_pessoa()
        return pessoa.get ('endereco')



    



