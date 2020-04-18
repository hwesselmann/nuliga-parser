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
    @page = Nokogiri::HTML(open(file))
    @team_meta = @page.css('h1')
  end

  def players
    players = []
    player_block = @page.css('table.result-set')[2].css('tr')
    player_block.each do |tr|
      next if tr.css('td').empty?

      name = tr.css('td')[4].css('a')[0].text
      yob_index = tr.css('td')[4].text.index('(')

      player = Player.new
      player.lk = tr.css('td')[2].text
      player.dtb_id = tr.css('td')[3].text.chop
      player.lastname = name.split(',').first.strip
      player.firstname = name.split(',')[1].strip
      player.yob = tr.css('td')[4].text[yob_index + 1..yob_index + 4]
      player.nationality = tr.css('td')[5].text.chop
      player.season = season
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

  def season
    team_name = @team_meta.text.split(')')[1].lstrip
    team_name.split(',')[1].strip.reverse.chop.reverse
  end
end

#  puts 'Rang: ' + tr.css('td')[0].text.strip
#  puts 'Mannschaft: ' + tr.css('td')[1].text.strip
#  puts 'Spielgemeinschaft: ' + tr.css('td')[6].text.chop
#  puts 'Einzel: ' + tr.css('td')[7].text
#  puts 'Doppel: ' + tr.css('td')[8].text
#  puts 'Gesamt: ' + tr.css('td')[9].text
