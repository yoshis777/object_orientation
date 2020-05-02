class Bicycle
  attr_reader :size, :chain, :tire_size

  def initialize(args={})
    @size = args[:size]
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size

    post_initialize(args)
  end

  # オーバーライド前提のメソッド群
  # フックメソッド
  # 一部のサブクラスが新規に必要とするもの
  def post_initialize(args)
    nil
  end

  # 全ての自転車がtire_sizeとchainの情報を必要とするスペアをもつ
  def spares
    {
      tire_size: tire_size,
      chain: chain
    }.merge(local_spares)
  end

  # フックメソッド
  # 一部のサブクラスが新規に必要とする情報
  def local_spares
    {}
  end

  # テンプレートメソッド
  # 全てのサブクラスが固有に実装を必要とするもの（必ずオーバーライドで実装）
  def default_tire_size
    raise NotImplementedError
  end

  # 共通のデフォルト値
  def default_chain
    '10-speed'
  end
end

class RoadBike < Bicycle
  attr_reader :tape_color

  def post_initialize(args)
    @tape_color = args[:tape_color]
  end

  def local_spares
    {
      tape_color: tape_color
    }
  end

  def default_tire_size
    '23'
  end
end

class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def post_initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
  end

  def local_spares
    {
      rear_shock: rear_shock
    }
  end

  def default_tire_size
    '2.1'
  end
end

mb = MountainBike.new(front_shock: 'mountain_front_shock')
puts mb.spares.inspect
