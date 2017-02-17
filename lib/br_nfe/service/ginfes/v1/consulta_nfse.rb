module BrNfe
	module Service
		module Ginfes
			module V1
				class ConsultaNfse < BrNfe::Service::Ginfes::V1::Base
					include BrNfe::Service::Concerns::Rules::ConsultaNfse
					
					def method_wsdl
						:consultar_nfse_v3
					end
					
					def xml_builder
						render_xml 'servico_consultar_nfse_envio'
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'ConsultarNfseV3'
					end

					def message_namespaces
						super.merge({'xmlns:ns3' =>  "http://www.ginfes.com.br/servico_consultar_nfse_envio_v03.xsd",})
					end

				private

					def set_response
						@response = BrNfe::Service::Response::Build::ConsultaNfse.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [:consultar_nfse_response], # Caminho inicial da resposta / Chave pai principal
							body_xml_path:  nil,
							xml_encode:     response_encoding, # Codificação do xml de resposta
							
							#//Envelope/Body/ConsultarLoteRpsEnvioResponse/ConsultarLoteRpsResposta
							nfe_xml_path:                '//*/*/*/*',
							
							invoices_path:               [:consultar_nfse_result, :lista_nfse, :comp_nfse],
							message_errors_path:         [:consultar_nfse_result, :lista_mensagem_retorno, :mensagem_retorno]
						).response
					end
					def response_class
						BrNfe::Service::Response::ConsultaNfse
					end
				end
			end
		end
	end
end