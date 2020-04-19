# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

require_relative '../model/player.rb'
require_relative '../model/club.rb'
require_relative '../model/team.rb'

#
# class for parsing a team-detail page
#
class TeamDetailParser
  def initialize(file)
    html_data = File.read(file)
    @page = Nokogiri::HTML(html_data)
    @team_meta = @page.css('h1')
  end

  def players
    players = []
    player_block = @page.css('table.result-set')[2].css('tr')
    player_block.each do |tr|
      next if tr.css('td').empty?

      player = map_to_player(tr)
      players.push player
    end
    players
  end

  def club
    club = Club.new
    club.name = @team_meta.text.split('(')[0].lstrip.chop
    club.id = @team_meta.text.split('(')[1][0..6]
    club
  end

  def team
    team = Team.new
    team_name = @team_meta.text.split(')')[1].lstrip
    team.name = team_name.split(',')[0].strip
    team.season = season
    team
  end

  private

  def map_to_player(node)
    name = node.css('td')[4].css('a')[0].text
    yob_index = node.css('td')[4].text.index('(')

    fill_player_data(node, name, yob_index)
  end

  def fill_player_data(node, name, yob)
    data = node.css('td')
    player = Player.new
    player.lk = data[2].text
    player.dtb_id = data[3].text.chop
    player.lastname = name.split(',').first.strip
    player.firstname = name.split(',')[1].strip
    player.yob = data[4].text[yob + 1..yob + 4]
    player.nationality = data[5].text.chop
    player.season = season
    player.team = team.name
    player.team_rank = data[0].text.strip
    player.singles = data[7].text
    player.doubles = data[8].text
    player
  end

  def season
    team_name = @team_meta.text.split(')')[1].lstrip
    team_name.split(',')[1].strip.reverse.chop.reverse
  end
end
