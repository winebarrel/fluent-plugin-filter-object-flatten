describe Fluent::ObjectFlattenFilter do
  let(:driver) { create_driver(fluentd_conf) }
  let(:fluentd_conf) { {} }
  let(:time) { Time.parse('2015/05/24 18:30 UTC').to_i }
  let(:obj) { described_class }

  before do
    driver.emit(obj, time)
    driver.run
  end

  subject { driver.emits }

  context({}) do
    it { is_expected.to be_empty }
  end

  context("foo"=>"bar") do
    it do
      is_expected.to eq [
        ["test.default", time, {"foo"=>"bar"}]
      ]
    end
  end

  context("foo"=>"bar", "bar"=>"zoo") do
    it do
      is_expected.to eq [
        ["test.default", time, {"foo"=>"bar"}],
        ["test.default", time, {"bar"=>"zoo"}]
      ]
    end
  end

  context("foo"=>["bar", "zoo"]) do
    it do
      is_expected.to eq [
        ["test.default", time, {"foo"=>"bar"}],
        ["test.default", time, {"foo"=>"zoo"}]
      ]
    end
  end

  context("foo"=>{"bar1"=>"zoo", "bar2"=>"baz"}) do
    it do
      is_expected.to eq [
        ["test.default", time, {"foo.bar1"=>"zoo"}],
        ["test.default", time, {"foo.bar2"=>"baz"}]
      ]
    end
  end

  context("foo"=>{"bar1"=>"zoo", "bar2"=>"baz"}) do
    let(:fluentd_conf) { {separator: '/'} }

    it do
      is_expected.to eq [
        ["test.default", time, {"foo/bar1"=>"zoo"}],
        ["test.default", time, {"foo/bar2"=>"baz"}]
      ]
    end
  end

  context("foo1"=>{"bar1"=>"zoo", "bar2"=>"baz"},
          "foo2"=>{"bar"=>["zoo","baz"], "zoo"=>"baz"}) do
    it do
      is_expected.to eq [
        ["test.default", time, {"foo1.bar1"=>"zoo"}],
        ["test.default", time, {"foo1.bar2"=>"baz"}],
        ["test.default", time, {"foo2.bar"=>"zoo"}],
        ["test.default", time, {"foo2.bar"=>"baz"}],
        ["test.default", time, {"foo2.zoo"=>"baz"}]
      ]
    end
  end

  context("foo1"=>{"bar"=>{"zoo1"=>"baz", "zoo2"=>"baz"}},
          "foo2"=>{"bar"=>{"zoo"=>["baz1","baz2"]}}) do
    it do
      is_expected.to eq [
        ["test.default", time, {"foo1.bar.zoo1"=>"baz"}],
        ["test.default", time, {"foo1.bar.zoo2"=>"baz"}],
        ["test.default", time, {"foo2.bar.zoo"=>"baz1"}],
        ["test.default", time, {"foo2.bar.zoo"=>"baz2"}]
      ]
    end
  end

  context("f oo1"=>{"b/ar1"=>"zoo", "b ar2"=>"baz"},
          "f/oo2"=>{"b ar"=>["zoo","baz"], "z/oo"=>"baz"}) do
    let(:fluentd_conf) { {tr: [' /', '__']} }

    it do
      is_expected.to eq [
        ["test.default", time, {"f_oo1.b_ar1"=>"zoo"}],
        ["test.default", time, {"f_oo1.b_ar2"=>"baz"}],
        ["test.default", time, {"f_oo2.b_ar"=>"zoo"}],
        ["test.default", time, {"f_oo2.b_ar"=>"baz"}],
        ["test.default", time, {"f_oo2.z_oo"=>"baz"}]
      ]
    end
  end
end
