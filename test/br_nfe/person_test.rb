require 'test_helper'

describe BrNfe::Person do
	subject { FactoryGirl.build(:person, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 

	describe "validations" do
		it { must validate_presence_of(:cpf_cnpj) }
		it { must validate_presence_of(:razao_social) }
		it { must validate_inclusion_of(:codigo_regime_tributario).in_array(['1', '2', '3', 1, 2, 3]).allow_blank }
	end

	it "deve ter alias attribute com cpf, cnpj e cpf_cnpj" do
		subject.cpf_cnpj = '123'
		subject.cpf.must_equal '123'
		subject.cnpj.must_equal '123'

		subject.cnpj = '665'
		subject.cpf_cnpj.must_equal '665'
		subject.cpf.must_equal '665'
	end
	
	describe "#endereco" do
		class OtherClassEndereco < BrNfe::ActiveModelBase
		end
		it "deve ter incluso o module HaveAddress" do
			subject.class.included_modules.must_include BrNfe::Association::HaveAddress
		end
		it "o método endereco por padrão deve retornar um objeto da class BrNfe::Endereco" do
			subject.endereco.must_be_kind_of BrNfe::Endereco
		end
		it "a classe de endereço deve derivar da configuração endereco_class" do
			BrNfe.endereco_class.must_equal BrNfe::Endereco
			BrNfe.endereco_class = OtherClassEndereco
			subject.endereco.must_be_kind_of OtherClassEndereco

			# É necessário voltar a configuração original para não falhar outros testes
			BrNfe.endereco_class =  BrNfe::Endereco
		end
	end

	describe "#razao_social" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.razao_social = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.razao_social.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

	describe "#nome_fantasia" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.nome_fantasia = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.nome_fantasia.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

	describe "#optante_simples_nacional?" do
		it "se o CRT for 1 deve ser true" do
			subject.codigo_regime_tributario = 1
			subject.optante_simples_nacional?.must_equal true
		end
		it "se o CRT for 2 deve ser true" do
			subject.codigo_regime_tributario = '2'
			subject.optante_simples_nacional?.must_equal true
		end
		it "se o CRT for 3 deve ser false" do
			subject.codigo_regime_tributario = 3
			subject.optante_simples_nacional?.must_equal false
		end		
	end

end