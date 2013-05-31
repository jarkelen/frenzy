class Calculator

  def initialize
    @settings = Setting.first
  end

  def process_gameround(gameround_id)
    # Calculate club scores
    results = Result.where(gameround_id: gameround_id)
    results.each do |result|
      calculate_score('home', result, gameround_id)
      calculate_score('away', result, gameround_id)
    end

    # Calculate user rankings
    users = User.all
    users.each do |user|
      calculate_ranking(user, gameround_id)
    end

    gameround = Gameround.find(gameround_id)
    gameround.update_attributes(processed: true)
  end

  def cancel_jokers(line)
    Joker.where(club_id: line[:home_club_id], gameround_id: line[:gameround_id]).destroy_all
    Joker.where(club_id: line[:away_club_id], gameround_id: line[:gameround_id]).destroy_all
  end

  def switch_period
    current_period = @settings.current_period
    puts "CURRENT PERIOD #{current_period}"
    new_period = current_period + 1
    gameround = Gameround.create(number: (1000 + current_period), start_date: DateTime.now, end_date: DateTime.now, processed: true, period_id: current_period)

    users = User.all
    users.each do |user|
      puts "USER #{user.last_name}"
      points_gained = 0
      selections = user.selections
      selections.each do |selection|
        club = selection.club
        puts "CLUB #{club.club_name}-#{club.period1}-#{club.period2}"
        club_gained = club.period2 - club.period1
        puts "GAINED #{club_gained}"
        points_gained += club_gained
      end
      puts "POINTS GAINED #{points_gained}"

      ranking = Ranking.create(gameround_id: gameround, user_id: user, total_score: points_gained)
      puts "ORIG TEAMVAL #{user.team_value}"
      user.update_attributes!(team_value: (user.team_value + points_gained))
      puts "NEW TEAMVAL #{user.team_value}"
    end

    setting = Setting.first
    puts "ORIG PERIOD #{setting.current_period}"
    setting.update_attributes(current_period: new_period)
    puts "NEW PERIOD #{setting.current_period}"
  end

  private
    def calculate_ranking(user, gameround_id)
      total_score = 0

      # Calculate total score
      user.clubs.each do |club|
        club_score = 0

        # Get club scores and joker
        club_scores = club.scores.where(gameround_id: gameround_id)
        club_scores.each do |score|
          club_score += score.score
          club_score += double_score_with_joker(club_score, gameround_id, club.id, user.id)
        end
        total_score += club_score
      end

      Ranking.find_or_create_by_gameround_id_and_user_id(gameround_id: gameround_id, user_id: user.id, total_score: total_score)
    end

    def double_score_with_joker(club_score, gameround_id, club_id, user_id)
      joker = Joker.where(gameround_id: gameround_id, club_id: club_id, user_id: user_id)
      if joker.blank?
        0
      else
        club_score * 2
      end
    end

    def calculate_score(score_type, result, gameround_id)
      score = 0

      # Home club
      if score_type == 'home'
        # Points for win
        score += 3 if result.home_score > result.away_score

        # Points for draw
        score += 1 if result.home_score == result.away_score

        # Points for own goals
        score += result.home_score

        # Points drawn for opponent goals
        score -= result.away_score
        Score.find_or_create_by_gameround_id_and_club_id(gameround_id: gameround_id, club_id: result.home_club_id, score: score)
      end

      # Away club
      if score_type == 'away'
        # Points for win
        score += 3 if result.away_score > result.home_score

        # Points for draw
        score += 1 if result.home_score == result.away_score

        # Points for own goals
        score += (result.away_score * 2)

        # Points drawn for opponent goals
        score -= result.home_score

        Score.find_or_create_by_gameround_id_and_club_id(gameround_id: gameround_id, club_id: result.away_club_id, score: score)
      end
    end

end

