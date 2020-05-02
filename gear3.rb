class Gear
  attr_reader :chainring, :cog, :wheel, :observer

  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @wheel = args[:wheel]
    @observer = args[:observer]
  end

  # 責任が「比を計算する」という一つのため、メソッド名が性質を表す（コメントが不要）
  def ratio
    chainring / cog.to_f
  end

  # diameterizableな（直径を計算する役割をもった）wheel（依存オブジェクト）
  def gear_inches
    ratio * wheel.diameter
  end

  # observerパターン（ギアが変わったら、observer（ここではライダー）に変更結果を伝える）
  # setterの上書き（但し、cog=(new_cog)による書き方が一般的）
  def set_cog(new_cog)
    @cog = new_cog
    changed
  end

  # observerパターン（ギアが変わったら、observer（ここではライダー）に変更結果を伝える）
  def set_chainring(new_chainring)
    @chainring = new_chainring
    changed
  end

  # observerパターン（の委譲の部分）
  def changed
    observer.changed(chainring, cog)
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
