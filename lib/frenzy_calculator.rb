class FrenzyCalculator

  def initialize
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
    current_period = $current_period
    new_period += current_period
  puts "CURRENT #{current_period}"
  puts "NEW #{new_period}"
    users = User.all
    users.for_each do |user|
      points_gained = 0
      selections = user.selections
      selections.for_each do |selection|
        club = selection.club
        club_gained = club.period2 - club.period1
        points_gained += club_gained
  puts "POINTS GAINED #{points_gained}"
      end

      # Save it as score
    end





    # Get current period
    # Calculate points gained/lost per team, by cycling all clubs in team and get old and new value
    # Add those points as new score as extra gameround to current old period
    # Make a gameround overview with period winners
    # Update curent in settings


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

          joker = Joker.where(gameround_id: gameround_id, club_id: club.id, user_id: user.id)
          unless joker.blank?
            club_score *= 2
          end
        end
        total_score += club_score
      end

      Ranking.find_or_create_by_gameround_id_and_user_id(gameround_id: gameround_id, user_id: user.id, total_score: total_score)
    end

    def calculate_score(score_type, result, gameround_id)
      score = 0

      # Home club
      if score_type == 'home'
        # Points for win
        if result.home_score > result.away_score
          score += 3
        end

        # Points for draw
        if result.home_score == result.away_score
          score += 1
        end

        # Points for own goals
        score += result.home_score

        # Points drawn for opponent goals
        score -= result.away_score

        Score.find_or_create_by_gameround_id_and_club_id(gameround_id: gameround_id, club_id: result.home_club_id, score: score)
      end

      # Away club
      if score_type == 'away'
        # Points for win
        if result.away_score > result.home_score
          score += 3
        end

        # Points for draw
        if result.home_score == result.away_score
          score += 1
        end

        # Points for own goals
        score += (result.away_score * 2)

        # Points drawn for opponent goals
        score -= result.home_score

        Score.find_or_create_by_gameround_id_and_club_id(gameround_id: gameround_id, club_id: result.away_club_id, score: score)
      end
    end

end

