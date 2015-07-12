describe 'Fluent::ObjectFlattenFilter#configure' do
  subject do |example|
    param = example.full_description.split(/\s+/)[1]
    create_driver(fluentd_conf).instance.send(param)
  end

  let(:fluentd_conf) { {} }

  describe 'separator' do
    context 'default' do
      it { is_expected.to eq '.' }
    end

    context '/' do
      let(:fluentd_conf) { {separator: '/'} }
      it { is_expected.to eq '/' }
    end
  end
end
