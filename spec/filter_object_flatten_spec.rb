describe Fluent::Plugin::ObjectFlattenFilter do
  include Fluent::Test::Helpers

  let(:driver) { create_driver(fluentd_conf) }
  let(:fluentd_conf) { {} }
  let(:time) { event_time('2015/05/24 18:30 UTC') }
  let(:obj) { described_class }

  before do
    driver.run(default_tag: 'test.default') do
      driver.feed(time, obj)
    end
  end

  subject { driver.filtered }

  context({}) do
    it { is_expected.to be_empty }
  end

  context("foo"=>"bar") do
    it do
      is_expected.to eq [
        [time, {"foo"=>"bar"}]
      ]
    end
  end

  context("foo"=>"bar", "bar"=>"zoo") do
    it do
      is_expected.to eq [
        [time, {"foo"=>"bar"}],
        [time, {"bar"=>"zoo"}]
      ]
    end
  end

  context("foo"=>["bar", "zoo"]) do
    it do
      is_expected.to eq [
        [time, {"foo"=>"bar"}],
        [time, {"foo"=>"zoo"}]
      ]
    end
  end

  context("foo"=>{"bar1"=>"zoo", "bar2"=>"baz"}) do
    it do
      is_expected.to eq [
        [time, {"foo.bar1"=>"zoo"}],
        [time, {"foo.bar2"=>"baz"}]
      ]
    end
  end

  context("foo"=>{"bar1"=>"zoo", "bar2"=>"baz"}) do
    let(:fluentd_conf) { {separator: '/'} }

    it do
      is_expected.to eq [
        [time, {"foo/bar1"=>"zoo"}],
        [time, {"foo/bar2"=>"baz"}]
      ]
    end
  end

  context("foo1"=>{"bar1"=>"zoo", "bar2"=>"baz"},
          "foo2"=>{"bar"=>["zoo","baz"], "zoo"=>"baz"}) do
    it do
      is_expected.to eq [
        [time, {"foo1.bar1"=>"zoo"}],
        [time, {"foo1.bar2"=>"baz"}],
        [time, {"foo2.bar"=>"zoo"}],
        [time, {"foo2.bar"=>"baz"}],
        [time, {"foo2.zoo"=>"baz"}]
      ]
    end
  end

  context("foo1"=>{"bar"=>{"zoo1"=>"baz", "zoo2"=>"baz"}},
          "foo2"=>{"bar"=>{"zoo"=>["baz1","baz2"]}}) do
    it do
      is_expected.to eq [
        [time, {"foo1.bar.zoo1"=>"baz"}],
        [time, {"foo1.bar.zoo2"=>"baz"}],
        [time, {"foo2.bar.zoo"=>"baz1"}],
        [time, {"foo2.bar.zoo"=>"baz2"}]
      ]
    end
  end

  context("f oo1"=>{"b/ar1"=>"zoo", "b ar2"=>"baz"},
          "f/oo2"=>{"b ar"=>["zoo","baz"], "z/oo"=>"baz"}) do
    let(:fluentd_conf) { {tr: [' /', '__']} }

    it do
      is_expected.to eq [
        [time, {"f_oo1.b_ar1"=>"zoo"}],
        [time, {"f_oo1.b_ar2"=>"baz"}],
        [time, {"f_oo2.b_ar"=>"zoo"}],
        [time, {"f_oo2.b_ar"=>"baz"}],
        [time, {"f_oo2.z_oo"=>"baz"}]
      ]
    end
  end
end
