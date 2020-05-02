class Gear
  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog

    # rim, tireの組み合わせが車輪を表す
    @wheel = Wheel.new(rim, tire)
  end

  # 責任が「比を計算する」という一つのため、メソッド名が性質を表す（コメントが不要）
  def ratio
    chainring / cog.to_f
  end

  #
  def gear_inches
    ratio * wheel.diameter
  end

  # 現状は車輪はギアクラスからしか用いない（と暗黙的に示している）
  Wheel = Struct.new(:rim, :tire) do
    def diameter
      rim + (tire * 2)
    end
  end
end
