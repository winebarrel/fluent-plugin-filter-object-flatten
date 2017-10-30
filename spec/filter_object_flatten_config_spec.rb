describe 'Fluent::Plugin::ObjectFlattenFilter#configure' do
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

  describe 'tr' do
    context 'default' do
      it { is_expected.to be_nil }
    end

    context '/ -> _' do
      let(:fluentd_conf) { {tr: ['/', '_']} }
      it { is_expected.to eq ['/', '_'] }
    end

    context 'invalid length' do
      let(:fluentd_conf) { {tr: []} }

      it do
        expect {
          subject
        }.to raise_error('tr: wrong length (0 for 2)')
      end
    end
  end
end
