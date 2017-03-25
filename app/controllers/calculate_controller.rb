class CalculateController < ApplicationController

  def index
    # TODO 実装方針を固める
    # pay_much(rate=50, score)
  end

  # @param [hash]
  # {
  #   user1: 12500,
  #   user2: 17500,
  #   user3: 10600,
  #   user4: 59400
  # }
  # @param return [hash]
  # {
  #   :user3=>-29,
  #   :user1=>-22,
  #   :user2=>-7,
  #   :user4=>58
  # }
  def scoring(score, initial_point, return_point=30000, uma=[-10, -5, 5, 10])
    # initial_point: 持ち点
    # return_point: 返し点
    correct_score?(score, initial_point)
    result ||= {}
    score.map do |opponent, score|
      point = (score-return_point).to_f # 返し点を引く
      result[opponent] = gosya_rokunyu(point)
    end

    consider_prize(result, uma)
  end

  def gosya_rokunyu(point)
    BigDecimal((point/1000).to_s).round(0, BigDecimal::ROUND_HALF_DOWN).to_i
  end

  def correct_score?(score, set_point=nil)
    if set_point.nil?
      return true if score.values.inject(:+).zero?
    else
      return true if score.values.inject(:+) == set_point * 4
    end
    raise StandardError.new("得点が一致しません. score=#{score}")
  end

  def consider_prize(score_result, uma)
    top_score ||= 0
    include_prize_result ||= {}

    score_result.sort { |(_opponent1, score1), (_opponent2, score2)| score1 <=> score2 }.each.with_index do |r, i|
      if i == 3
        include_prize_result[r[0]] = top_score
      else
        include_prize_result[r[0]] = r[1] + uma[i]
        if include_prize_result[r[0]] > 0
          top_score += include_prize_result[r[0]]
        else
          top_score -= include_prize_result[r[0]]
        end
      end
    end

    correct_score?(include_prize_result)
    include_prize_result
  end

  # @param rate [interger]
  # rate -> テンイチ: 10, テンニ: 20, テンサン: 30, テンゴ: 50, テンピン: 100
  # @param return [hash]
  # {
  #   :user3=>-1450,
  #   :user1=>-1100,
  #   :user2=>-350,
  #   :user4=>2900
  # }
  def pay_much(rate=50, score)
    score.map { |k, v| [k, (v * rate)] }.to_h
  end

end
