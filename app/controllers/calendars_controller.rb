class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
   

    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    @plans = Plan.where(date: @todays_date..@todays_date + 365)

    365.times do |x|
      plans = []
      plan = @plans.map do |plan|
        plans.push(plan.plan) if plan.date == @todays_date + x
      end
      wday_num = Date.today.wday + x #Date.today.wdaysを利用して添字となる数値を得る
      #もしもwday_numが7以上であれば、7を引く
      52.times do  
        if wday_num >= 7
          wday_num = wday_num - 7
        end
      end


      month_num = (Date.today + x).month
      day_num = (Date.today + x).day

      if month_num == 2 then
        #29日まである月
        if day_num >= 30
          day_num = day_num - 29
        end
      elsif  month_num == 4|| month_num == 6 || month_num == 9 || month_num == 11  then
        #30日まである月
        if day_num >= 31
          day_num = day_num - 30
        end
      else
        #31日まである月
        if day_num >= 32
          day_num = day_num - 31
        end
      end

      days = { month: month_num, date: day_num, wdays: wdays[wday_num], plans: plans }
      @week_days.push(days)
    end
  end
end

# 1 3 5 7 10 
# :wdays => wdays[(@todays_date + x).wday]

# :wdays => wdays[0++x]
