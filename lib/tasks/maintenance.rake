namespace :frenzy do
  task migrate_to_players_and_matches: :environment do
    game = Game.create(name: "Clubs Frenzy")
    users = User.all
    users.each do |user|
      player = Player.create(rosettes: 0, cups: 0, medals: 0, user_id: user.id, game_id: game.id)
      selections = Selection.where(user_id: user.id)
      selections.each do |selection|
        selection.player_id = player.id
        selection.save
      end
      jokers = Joker.where(user_id: user.id)
      jokers.each do |joker|
        joker.player_id = player.id
        joker.save
      end
      rankings = Ranking.where(user_id: user.id)
      rankings.each do |ranking|
        ranking.player_id = player.id
        ranking.save
      end
    end
  end
end
