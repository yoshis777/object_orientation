# 最適な旅行を用意するクラス
# ポリモーフィズム：多岐にわたるオブジェクトが同じメッセージに応答する
# ダックタイピング（ポリモーフィズムの１つ）
class Trip
  attr_reader :bicycles, :customers, :vehicle

  # preparerに任せれば個々のクラスが役割を果たす
  # 新しいpreparerが増えてもTripクラスには影響がない（Tripクラスはpreparerについて知らない）
  def prepare(preparers)
    preparers.each do |preparer|
      preparer.prepare_trip(self)
    end
  end
end

# それぞれのクラスはpreparerとしての役割をもつ（暗黙のpreparerインターフェースによりprepare_tripを実装することを期待される）
class Mechanic
  # 旅行のために必要なものを揃える（整備士の役割の範囲で）
  def prepare_trip(trip)
    trip.bicycles.each do |bicycle|
      prepare_bycicle(bicycle)
    end
  end
end

class TripCoodinator
  # 旅行のために必要なものを揃える（プランナーの役割の範囲で）
  def prepare_trip(trip)
    buy_food(trip.customers)
  end
end

class Driver
  # 旅行のために必要なものを揃える（ドライバーの役割の範囲で）
  def prepare_trip(trip)
    vehicle = trip.vehicle
    gas_up(vehicle)
    fill_water_tank(vehicle)
  end
end