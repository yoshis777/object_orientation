class Gear
  attr_reader :chainring, :cog, :wheel, :observer

  def initialize(chainring, cog, wheel=nil)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  # 責任が「比を計算する」という一つのため、メソッド名が性質を表す（コメントが不要）
  def ratio
    chainring / cog.to_f
  end

  # diameterizableな（直径を計算する役割をもった）wheel（依存オブジェクト）
  def gear_inches
    ratio * wheel.diameter
  end
end

class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end

  def circumference
    diameter * Math::PI
  end
end

# 車輪の円周については車輪クラスに任せる
@wheel = Wheel.new(26, 1.5)
puts @wheel.circumference

# ギアのギアインチについては車輪クラスを用いてギアクラスに任せる
puts Gear.new(52, 11, @wheel).gear_inches
puts Gear.new(52, 11).ratio

# この設計では、これはダメ（gear_inchesメソッドが車輪に依存している）
puts Gear.new(52, 11).gear_inches # エラーになる
