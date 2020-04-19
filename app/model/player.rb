# frozen_string_literal: true

#
# A tennis player with all data needed for team competition.
#
class Player
  attr_accessor :lastname, :firstname, :dtb_id, :lk, :nationality
  attr_accessor :yob, :season, :team, :team_rank, :singles, :doubles
end
