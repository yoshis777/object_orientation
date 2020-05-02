require './inheritance'
require 'minitest/autorun'

module BicycleInterfaceTest
  def test_respond_to_default_tire_size
    assert_respond_to(@object, :default_tire_size)
  end

  def test_respond_to_default_chain
    assert_respond_to(@object, :default_chain)
  end

  def test_respond_to_chain
    assert_respond_to(@object, :chain)
  end

  def test_respond_to_size
    assert_respond_to(@object, :size)
  end

  def test_respond_to_tire_size
    assert_respond_to(@object, :tire_size)
  end

  def test_respond_to_spares
    assert_respond_to(@object, :spares)
  end
end

class BicycleTest < MiniTest::Test
  include BicycleInterfaceTest

  def setup
    # スーパークラスは基本的に抽象クラスのため、基本的にはオブジェクト化が難しい
    # （今回はタイヤサイズさえ与えてあげればnewできる）
    @bike = @object = Bicycle.new({tire_size: 0})
    # 具象クラスであるサブクラスのオブジェクトを生成し、スーパークラスのみの責任を満たすかチェックする
    @stubbed_bike = StubbedBike.new
  end

  def test_forces_subclesses_to_implement_default_tire_size
    assert_raises(NotImplementedError) do
      @bike.default_tire_size # スタブを使った場合、こちらは不要（というか抽象クラスのBicycle.newができないときにスタブを用いる）
      @stubbed_bike.default_tire_size
    end
  end

  def test_includes_local_spares_in_spares
    assert_equal @stubbed_bike.spares, {
        tire_size: 0,
        chain: '10-speed',
        saddle: 'painful'
    }
  end
end

# サブクラスがサブクラスに実装を期待しているメソッドをもつかどうか
module BicycleSubclassTest
  def test_responds_to_post_initialize
    assert_respond_to(@object, :post_initialize)
  end

  def test_responds_to_local_spares
    assert_respond_to(@object, :local_spares)
  end

  def test_responds_to_default_tire_size
    assert_respond_to(@object, :default_tire_size)
  end
end

# スーパークラスは基本的に抽象クラスのため、オブジェクト化が難しいため、
# 具象クラスであるサブクラスのオブジェクト（スタブ）を生成し、スーパークラスのみの責任を満たすかチェックする
class StubbedBike < Bicycle
  attr_reader :anything
  def default_tire_size
    0
  end

  def local_spares
    {saddle: 'painful'}
  end
end

# スタブ自体がサブクラスの要件を満たすかどうか
class StubbedBikeTest < MiniTest::Test
  include BicycleSubclassTest

  def setup
    @object = StubbedBike.new
  end
end

class RoadBikeTest < MiniTest::Test
  include BicycleInterfaceTest # スーパークラスの責任をみたすこと
  include BicycleSubclassTest # サブクラスの責任をみたすこと

  def setup
    @bike = @object = RoadBike.new({tape_color: 'red'})
  end

  # サブクラスが用いるメソッドのテスト（road_bikeはlocal_sparesを用いる）
  def test_puts_tape_color_in_local_spares
    assert_equal 'red', @bike.local_spares[:tape_color]
  end
end
