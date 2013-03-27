class FrenzyCalculator

  def initialize
  end

  def process_gameround(gameround)




  end

  private

end


=begin

// Bereken club en teamscores
if (isset($_POST['bereken_scores'])){
  // Cycle alle uitslagen voor speelronde
  $uitslagen = mysql_query("SELECT * FROM uitslagen WHERE speelronde = " . $_POST['speelronde']);
  while ($row = mysql_fetch_array($uitslagen)){
    // Bereken score voor thuis club
    $score = 0;

    // Punten voor overwinning of gelijkspel
    if ($row['score_thuis'] > $row['score_uit']){
      $score = $score + 3;
    }
    elseif ($row['score_thuis'] == $row['score_uit']){
      $score = $score + 1;
    }

    // Punten voor doelpunten
    $score = $score + $row['score_thuis'];

    // Aftrek voor tegendoelpunten
    $score = $score - $row['score_uit'];

    // Voeg score toe aan database
    $query = "INSERT INTO clubscores (speelronde, club_id, score, periode) VALUES ('{$_POST['speelronde']}', '{$row['club_thuis']}', '{$score}','{$periode}')";
    mysql_query($query) or die (mysql_error());

    // Bereken score voor uit club
    $score = 0;

    // Punten voor overwinning of gelijkspel
    if ($row['score_uit'] > $row['score_thuis']){
      $score = $score + 3;
    }
    elseif ($row['score_thuis'] == $row['score_uit']){
      $score = $score + 1;
    }

    // Punten voor doelpunten
    $uit = $row['score_uit'] * 2;
    $score = $score + $uit;

    // Aftrek voor tegendoelpunten
    $score = $score - $row['score_thuis'];

    // Voeg score toe aan database
    $query = "INSERT INTO clubscores (speelronde, club_id, score, periode) VALUES ('{$_POST['speelronde']}', '{$row['club_uit']}', '{$score}','{$periode}')";
    mysql_query($query) or die (mysql_error());
  }
  mysql_free_result($uitslagen);

  //Bereken teamscores door alle teams te cyclen
  $teams = mysql_query("SELECT team_id FROM teams");
  while ($row1 = mysql_fetch_array($teams)){
    // Cycle clubs van teams
    $teamscore = 0;
    $aantal_jokers = 0;
    $teamclubs = mysql_query("SELECT club_id FROM deelname WHERE team_id = " . $row1['team_id']);
    while ($row2 = mysql_fetch_array($teamclubs)){
      // Haal score op van deze club voor deze speelronde
      $score = mysql_fetch_array(mysql_query("SELECT score FROM clubscores WHERE club_id = " . $row2['club_id'] . " AND speelronde = " . $_POST['speelronde']));
      $clubscore = $score['score'];

      // Haal joker op en voeg eventueel score toe
      $joker = mysql_fetch_array(mysql_query("SELECT club_id FROM jokers WHERE club_id = " . $row2['club_id'] . " AND speelronde = " . $_POST['speelronde'] . " AND team_id = " . $row1['team_id']));
      if ($joker['club_id'] != ""){
        $clubscore = $clubscore * 2;
        $aantal_jokers = $aantal_jokers + 1;
      }
      $teamscore = $teamscore + $clubscore;
    }
    mysql_free_result($teamclubs);

    // Boek gebruikte jokers af
    $jokers = mysql_fetch_array(mysql_query("SELECT beschikbare_jokers FROM teams WHERE team_id = " . $row1['team_id']));
    $beschikbare_jokers = $jokers['beschikbare_jokers'] - $aantal_jokers;
    $query = "UPDATE teams SET beschikbare_jokers = " . $beschikbare_jokers . " WHERE team_id = " . $row1['team_id'];
    mysql_query($query) or die (mysql_error());

    // Sla de teamscore op
    $query = "INSERT INTO teamscores (team_id, speelronde, score_type, score, jokers, periode) VALUES ('{$row1['team_id']}', '{$_POST['speelronde']}', 'speelronde','{$teamscore}', '{$aantal_jokers}', '{$periode}')";
    mysql_query($query) or die (mysql_error());

    $laatste = mysql_fetch_array(mysql_query("SELECT speelronde FROM klassement WHERE team_id = " . $row1['team_id'] . " AND periode = " . $periode));
    if($laatste['speelronde'] != ""){
      $klassementperiode = $periode;
      $speelronde = $_POST['speelronde'] - 1;
    }
    else{
      $klassementperiode = $periode - 1;
      $speelronde = "99";
    }

    // Update klassement, haal eerst laatste klassement score op
    $totaalscore = mysql_fetch_array(mysql_query("SELECT totaalscore FROM klassement WHERE team_id = " . $row1['team_id'] . " AND speelronde = " . $speelronde . " AND periode = " . $klassementperiode));
    $nieuwetotaalscore = $totaalscore['totaalscore'] + $teamscore;

    // Update klassement, voeg nieuwe totaalscore toe aan tabel
    $query = "INSERT INTO klassement (team_id, speelronde, totaalscore, periode) VALUES ('{$row1['team_id']}', '{$_POST['speelronde']}', '{$nieuwetotaalscore}', '{$periode}')";
    mysql_query($query) or die (mysql_error());
  }
  mysql_free_result($teams);

  // Zet speelronde op verwerkt
  $query = "UPDATE speelrondes SET verwerkt = 'ja' WHERE speelronde = " . $_POST['speelronde'];
  mysql_query($query) or die (mysql_error());

  // Zet intro tekst
  $copyandpaste = "[size=10pt]Hieronder de scores en klassement van speelronde " . $_POST['speelronde'] . ". Ga voor meer overzichten en statistieken naar de [url=www.dutchaddick.com/clubsfrenzy]Clubs Frenzy website[/url][/size]";

  // Creeer tabel voor copy and paste naar phoenix, eerst de uitslag van de laatste speelronde
  $speelronde = mysql_fetch_array(mysql_query("SELECT * FROM speelrondes WHERE speelronde = " . $_POST['speelronde']));
  $copyandpaste = $copyandpaste . "[b][size=14pt]Uitslag speelronde " . $speelronde['speelronde'] . " (" . $speelronde['datum'] . ")[/size][/b]";
  $copyandpaste = $copyandpaste . "[table]";
  $copyandpaste = $copyandpaste . "[tr][td][b]Positie[/b][/td][td][b]Team[/b][/td][td][center][b]Score[/b][/center][/td][td][center][b]Jokers[/b][/center][/td][/tr]";

  $counter = 1;
  $teamscores = mysql_query("SELECT * FROM teamscores WHERE speelronde = " . $_POST['speelronde'] . " ORDER BY score DESC");
  while ($row = mysql_fetch_array($teamscores)){
    $team = mysql_fetch_array(mysql_query("SELECT * FROM teams WHERE team_id = " . $row['team_id']));
    $copyandpaste = $copyandpaste . "[tr][td][center][b]" . $counter . ".[/b][/center][/td][td][color=Red][b]" . $team['teamnaam'] . " (" . $team['nickname'] . ")[/b][/color][/td][td][center][color=Blue][b]" . $row['score'] . "[/b][/color][/center][/td][td][center][color=Green][b]" . $row['jokers'] . "[/b][/color][/center][/td][/tr]";
    $counter = $counter + 1;
  }
  mysql_free_result($teamscores);

  $copyandpaste = $copyandpaste . "[/table]";

  // Dan een tabel met het totaalklassement
  $speelronde = mysql_fetch_array(mysql_query("SELECT * FROM speelrondes WHERE speelronde = " . $_POST['speelronde']));
  $copyandpaste = $copyandpaste . "[b][size=14pt]Klassement na speelronde " . $speelronde['speelronde'] . " (" . $speelronde['datum'] . ")[/size][/b]";
  $copyandpaste = $copyandpaste . "[table]";
  $copyandpaste = $copyandpaste . "[tr][td][b]Positie[/b][/td][td][b]Team[/b][/td][td][center][b]Score[/b][/center][/td][/tr]";

  $counter = 1;
  $totaalscores = mysql_query("SELECT * FROM klassement WHERE speelronde = " . $_POST['speelronde'] . " ORDER BY totaalscore DESC");
  while ($row = mysql_fetch_array($totaalscores)){
    $team = mysql_fetch_array(mysql_query("SELECT * FROM teams WHERE team_id = " . $row['team_id']));
    $copyandpaste = $copyandpaste . "[tr][td][center][b]" . $counter . ".[/b][/center][/td][td][color=Red][b]" . $team['teamnaam'] . " (" . $team['nickname'] . ")[/b][/color][/td][td][center][color=Blue][b]" . $row['totaalscore'] . "[/b][/color][/center][/td][/tr]";
    $counter = $counter + 1;
  }
  mysql_free_result($totaalcores);

  $copyandpaste = $copyandpaste . "[/table]";

  // Bevestig verwerking
  $status = "compleet";
  $statustext = "De scores zijn berekend!";
}

// Switch periode
if (isset($_POST['switch_period'])){
  // Bepaal nieuwe periode
  $nieuweperiode = $periode + 1;

  // Cycle alle teams uit het klassement
  $counter = 1;
  $laatstespeelronde = mysql_fetch_array(mysql_query("SELECT max(speelronde) FROM klassement WHERE periode = " . $periode));
  $klassement = mysql_query("SELECT * FROM klassement WHERE speelronde = " . $laatstespeelronde[0] . " ORDER BY totaalscore DESC");
  while ($row = mysql_fetch_array($klassement)){
    // Haal teamgegevens op
    $team = mysql_fetch_array(mysql_query("SELECT * FROM teams WHERE team_id = " . $row['team_id']));

    // Bereken toegenomen waarde van de clubs in team door alle deelname clubs te cyclen
    $cumwaardetoename = 0;
    $deelnameclubs = mysql_query("SELECT club_id FROM deelname WHERE team_id = " . $row['team_id']);
    while ($row1 = mysql_fetch_array($deelnameclubs)){
      // Haal de nieuw en oude waarde op van deze club
      $oudewaarde = mysql_fetch_array(mysql_query("SELECT periode" . $periode . " FROM clubs WHERE club_id = " . $row1['club_id']));
      $oudewaarde = $oudewaarde[0];
      $nieuwewaarde = mysql_fetch_array(mysql_query("SELECT periode" . $nieuweperiode . " FROM clubs WHERE club_id = " . $row1['club_id']));
      $nieuwewaarde = $nieuwewaarde[0];
      $waardetoename = $nieuwewaarde - $oudewaarde;
      $cumwaardetoename = $cumwaardetoename + $waardetoename;
    }
    mysql_free_result($deelnameclubs);

    // Bestaand maxteamwaarde ophalen en updaten
    $team = mysql_fetch_array(mysql_query("SELECT maxteamwaarde FROM teams WHERE team_id = " . $row['team_id']));
    $nieuwmaxteamwaarde = $team['maxteamwaarde'] + $cumwaardetoename;
    $query = "UPDATE teams SET maxteamwaarde = " . $nieuwmaxteamwaarde . " WHERE team_id = " . $row['team_id'];
    mysql_query($query) or die (mysql_error());

    $counter = $counter + 1;
  }
  mysql_free_result($klassement);

  // Update periode
  $query = "UPDATE instellingen SET periode = " . $nieuweperiode;
  mysql_query($query) or die (mysql_error());

  // Bevestig verwerking
  $status = "compleet";
  $statustext = "De nieuwe periode is vastgelegd!";
}
// Annuleren jokers
if (isset($_POST['annuleren_jokers'])){
  $counter = 1;
  while ($counter <= 12){
    if ($_POST['club_thuis'.$counter] != ""){
      $query = "DELETE FROM jokers WHERE club_id = " . $_POST['club_thuis'.$counter] . " AND speelronde = " . $_POST['speelronde'];
      mysql_query($query) or die (mysql_error());

      $query = "DELETE FROM jokers WHERE club_id = " . $_POST['club_uit'.$counter] . " AND speelronde = " . $_POST['speelronde'];
      mysql_query($query) or die (mysql_error());

      $status = 'compleet';
      $statustext = 'De jokers zijn geannuleerd!';
    }
    $counter = $counter + 1;
  }
}

// Annuleren speelronde scores
if (isset($_POST['annuleren_scores'])){
  $query = "DELETE FROM clubscores WHERE speelronde = " . $_POST['speelronde'];
  mysql_query($query) or die (mysql_error());

  $query = "DELETE FROM klassement WHERE speelronde = " . $_POST['speelronde'];
  mysql_query($query) or die (mysql_error());

  $query = "DELETE FROM teamscores WHERE speelronde = " . $_POST['speelronde'];
  mysql_query($query) or die (mysql_error());

  $query = "UPDATE speelrondes SET verwerkt = '' WHERE speelronde = " . $_POST['speelronde'];
  mysql_query($query) or die (mysql_error());

  $status = 'compleet';
  $statustext = 'De speelronde scores zijn geannuleerd!';
}

=end