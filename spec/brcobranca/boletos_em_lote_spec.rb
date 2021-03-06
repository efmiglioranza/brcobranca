# -*- encoding: utf-8 -*-
require 'spec_helper'

RSpec.describe 'Muúltiplos boletos' do #:nodoc:[all]
  before do
    @valid_attributes = {
      especie_documento: 'DM',
      moeda: '9',
      data_documento: Date.today,
      dias_vencimento: 1,
      aceite: 'S',
      quantidade: 1,
      valor: 0.0,
      local_pagamento: 'QUALQUER BANCO ATÉ O VENCIMENTO',
      cedente: 'Kivanio Barbosa',
      documento_cedente: '12345678912',
      sacado: 'Claudio Pozzebom',
      sacado_documento: '12345678900',
      agencia: '4042',
      conta_corrente: '61900',
      convenio: 12_387_989,
      numero_documento: '777700168'
    }
  end

  it 'imprimir múltiplos boleto em lote' do
    boleto_1 = Brcobranca::Boleto::BancoBrasil.new(@valid_attributes)
    boleto_2 = Brcobranca::Boleto::Bradesco.new(@valid_attributes)
    boleto_3 = Brcobranca::Boleto::BancoBrasil.new(@valid_attributes)

    boletos = [boleto_1, boleto_2, boleto_3]

    %w(pdf jpg tif png).each do |format|
      file_body = Brcobranca::Boleto::Base.lote(boletos, formato: "#{format}".to_sym)
      tmp_file = Tempfile.new('foobar.' << format)
      tmp_file.puts file_body
      tmp_file.close
      expect(File.exist?(tmp_file.path)).to be_truthy
      expect(File.stat(tmp_file.path).zero?).to be_falsey
      expect(File.delete(tmp_file.path)).to eql(1)
      expect(File.exist?(tmp_file.path)).to be_falsey
    end
  end
end
