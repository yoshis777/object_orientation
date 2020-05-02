require './gear3'
require './duck_typing'
require 'minitest/autorun'

# 自身のクラスの責任のみに注力してテストすること（冗長としないこと）
class GearTest < MiniTest::Unit::TestCase
  def setup
    @observer = MiniTest::Mock.new
    @gear = Gear.new(
        chainring: 52,
        cog: 11,
        observer: @observer
    )
  end

  def test_notifies_observers_when_cogs_change
    # 対象メソッド、戻り値、与えられる引数
    @observer.expect(:changed, true, [52, 27]) # changedメソッドが走ること（のみ）
    @gear.set_cog(27)
    @observer.verify
  end

  def test_notifies_observers_when_cogs_change
    # 対象メソッド、戻り値、与えられる引数
    @observer.expect(:changed, true, [42, 11]) # changedメソッドが走ること
    @gear.set_chainring(42)
    @observer.verify
  end

  def test_calculates_gear_inches
    gear = Gear.new(
        chainring: 52,
        cog: 11,
        wheel: DiameterDouble.new
    )

    assert_in_delta(47.27, gear.gear_inches, 0.01)
  end
end

# テストダブル（依存オブジェクトとして注入され、テスト対象の最終的な戻り値に影響する場合に用いる
class DiameterDouble
  # diameterのメソッド名が変更された場合でも成功してしまうので、Diameterizableインターフェースのテストを作成する
  def diameter
    10
  end
end

module DiameterizableInterfaceTest
  # diameterの役割を果たすこと
  def test_implements_the_diameterizable_interface
    assert_respond_to(@object, :diameter)
  end
end

class WheelTest < MiniTest::Unit::TestCase
  include DiameterizableInterfaceTest # テストを見れば、依存性の注入でdiameterの役割をもつということがわかる
  def setup
    @wheel = @object = Wheel.new(26, 1.5)
  end

  # diameterの役割を果たすこと
  # （こちらに記載した場合、WheelはGearの依存オブジェクトとなり、現時点で唯一のdiameterを果たす安定したオブジェクトであると暗黙的に伝えている）
  # def test_implements_the_diameterizable_interface
  #   assert_respond_to(@wheel, :diameter)
  # end
end

class TripTest < MiniTest::Unit::TestCase
  def test_requests_trip_preparation
    @preparer = MiniTest::Mock.new
    @trip = Trip.new
    @preparer.expect(:prepare_trip, nil, [@trip])

    @trip.prepare([@preparer])
    @preparer.verify
  end
end

# preparerの役割をもつクラスが対象のメソッドを実装していること
module PreparerInterfaceTest
  def test_implements_the_preparer_interface
    assert_respond_to(@object, :prepare_trip)
  end
end

class MechanicTest < Minitest::Unit::TestCase
  include PreparerInterfaceTest # テストを見れば、ダックタイピングで暗黙になっていたpreparerの役割をもつということがわかる

  def setup
    @mechanic = @object = Mechanic.new
  end
end

class MechanicTest < Minitest::Unit::TestCase
  include PreparerInterfaceTest

  def setup
    @mechanic = @object = Mechanic.new
  end
end

class TripCoodinatorTest < Minitest::Unit::TestCase
  include PreparerInterfaceTest

  def setup
    @mechanic = @object = TripCoodinator.new
  end
end

class DriverTest < Minitest::Unit::TestCase
  include PreparerInterfaceTest

  def setup
    @mechanic = @object = Driver.new
  end
end
