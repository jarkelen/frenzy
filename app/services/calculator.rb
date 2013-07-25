class Calculator

  def initialize
    @settings = Setting.first
  end

  def process_gameround(gameround_id)
    # Calculate club scores
    results = Result.where(gameround_id: gameround_id)
    results.each do |result|
      # Calculate home score
      score = calculate_club_score('home', result, gameround_id)
      Score.create(gameround_id: gameround_id, club_id: result.home_club_id, score: score)

      # Calculate away score
      score = calculate_club_score('away', result, gameround_id)
      Score.create(gameround_id: gameround_id, club_id: result.away_club_id, score: score)
    end

    # Calculate player scores
    players = Player.all
    players.each do |player|
      total_score = calculate_player_score(player, gameround_id)
      Ranking.create(gameround_id: gameround_id, player_id: player.id, total_score: total_score)
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
    new_period = current_period + 1
    gameround = Gameround.create(number: (1000 + current_period), start_date: DateTime.now, end_date: DateTime.now, processed: true, period_id: current_period)

    users = User.all
    users.each do |user|
      points_gained = 0
      selections = user.selections
      selections.each do |selection|
        club = selection.club
        club_gained = club.period2 - club.period1
        points_gained += club_gained
      end

      ranking = Ranking.create(gameround_id: gameround.id, user_id: user.id, total_score: points_gained)
      user.update_attributes!(team_value: (user.team_value + points_gained))
    end

    setting = Setting.first
    setting.update_attributes(current_period: new_period)
  end

  def calculate_total_ranking(type)
    found_rankings = []
    game = Game.default_game
    players = Player.where(game_id: game.id)
    players.each do |player|
      player_score = 0

      if type == "general"
        rankings = player.rankings
      elsif type == "period"
        settings = Setting.first
        period_gamerounds = Gameround.where(period_id: settings.current_period).pluck(:id)
        rankings = player.rankings.where(gameround_id: period_gamerounds)
      end

      rankings.each do |ranking|
        player_score += ranking.total_score
      end
      found_rankings << [player, player_score]
    end
    found_rankings.sort {|a,b| b[1] <=> a[1]}
  end

  def calculate_player_score(player, gameround_id)
    total_score = 0

    # Calculate total score
    player.clubs.each do |club|
      club_score = 0

      # Get club scores and joker
      club_scores = club.scores.where(gameround_id: gameround_id)
      club_scores.each do |score|
        club_score += score.score
        club_score += double_score_with_joker(club_score, gameround_id, club.id, player.id)
      end
      total_score += club_score
    end
    total_score
  end

  def double_score_with_joker(club_score, gameround_id, club_id, player_id)
    joker = Joker.where(gameround_id: gameround_id, club_id: club_id, player_id: player_id)
    if joker.blank?
      0
    else
      club_score
    end
  end

  def calculate_club_score(score_type, result, gameround_id)
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
    end
    score
  end

end

