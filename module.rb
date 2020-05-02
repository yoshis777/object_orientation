# 稼働スケジュールの割り当て可能かどうか
class Schedule
  def scheduled?(scheduldable, start_date, end_date)
    puts "This #{scheduldable.class}" + " is not scheduled \n" +
        " between #{start_date} and #{end_date}"
    false
  end
end

# 稼働スケジュールが割り当て可能かどうかの共通機能をinclude先に与える（インターフェース）
module Schedulable
  attr_writer :schedule

  def schedule
    @schedule ||= ::Schedule.new
  end

  def scheduled?(start_date, end_date)
    schedule.scheduled?(self, start_date, end_date)
  end

  def schedulable?(start_date, end_date)
    !scheduled?(start_date - lead_days, end_date)
  end


  # フックメソッド
  def lead_days
    0
  end
end

# BicycleはSchedulableに必要な情報を与えるが、scheduleクラスについては何も知らない
class Bicycle
  include Schedulable

  def lead_days
    1
  end
end

class Mechanic
  include Schedulable

  def lead_days
    4
  end
end

require 'Date'
b = Bicycle.new
b.scheduled?(Date.parse('2015/09/04'), Date.parse('2015/11/04'))

m = Mechanic.new
m.scheduled?(Date.parse('2015/09/04'), Date.parse('2015/11/04'))