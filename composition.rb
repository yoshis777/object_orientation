class Bicycle
  attr_reader :size, :parts

  def initialize(args={})
    @size = args[:size]
    @parts = args[:parts]
  end

  # パーツの集合オブジェクトに振る舞いを委譲する
  def spares
    parts.spares
  end
end

# Partsは自身のもつ個々のパーツを管理するのに配列(Array)として振る舞いたいが、
# 自身の振る舞い（spares等のメソッド）を行う必要があるため、
# Partsとして振る舞うことに注力しつつ、Arrayの役割(length, each)を部分的に得るためにforwardableを用いる
require 'forwardable'
class Parts
  extend Forwardable
  def_delegators :@parts, :length, :each
  include Enumerable

  # 個々のパーツの配列を受け取る
  def initialize(parts)
    @parts = parts
  end

  # 委譲されることを前提として処理を行うメソッド
  def spares
    select {|part| part.needs_spare }
  end
end

# パーツを作成するためのファクトリーモジュール
# ファクトリーがconfigを知ることによって
  # configは簡潔に表現できる
  # configを使うときには必ずこのファクトリーを経由することを示唆できる
require 'ostruct'
module PartsFactory
  def self.build(config, parts_class = Parts)
    parts_class.new(
                   config.collect do |part_config|
                     create_part(part_config)
                   end
    )
  end

  # 配列
  def self.create_part(part_config)
    OpenStruct.new(
            name: part_config[0],
            description: part_config[1],
            needs_spare: part_config.fetch(2, true)
    )
  end
end

# ファクトリーモジュールがあることによって、設計図を簡潔にできる
road_config = [
    ['chain', '10-speed'],
    ['tire_size', '23'],
    ['tape_color', 'red']
]

mountain_config = [
    ['chain' '10-speed'],
    ['tire_size', '2.1'],
    ['front_shock', 'Manitou', false]
]

road_bike = Bicycle.new(
                       size: 'L',
                       parts: PartsFactory.build(road_config)
)

# class Part
#   attr_reader :name, :description, :needs_spare
#
#   def initialize(args)
#     @name = args[:name]
#     @description = args[:description]
#     @needs_spare = args.fetch(:needs_spare, true)
#   end
# end
#
# # パーツの定義
# chain = Part.new(name: 'chain', description: '10-speed')
# front_shock = Part.new(name: 'front_shock', description: 'Manitou', needs_spare: false)
#
# # コンポジションによる自転車の定義
# road_bike = Bicycle.new(
#                        size: 'L',
#                        parts: Parts.new([chain, front_shock])
# )

