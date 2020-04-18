# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

# class for parsing a team-detail page
class TeamDetailParser
  def initialize(file)
    @page = Nokogiri::HTML(open(file))
    @team_meta = @page.css('h1')
  end

  def get_players
    @page.css('table.result-set')[2].css('tr')
  end

  def get_club_name
    @team_meta.text.split('(')[0].lstrip.chop
  end

  def get_club_id
    @team_meta.text.split('(')[1][0..6]
  end

  def get_team_name
    team_name = @team_meta.text.split(')')[1].lstrip
    team_name.split(',')[0].strip
  end

  def get_season
    team_name = @team_meta.text.split(')')[1].lstrip
    team_name.split(',')[1].strip.reverse.chop.reverse
  end
end

#result = parser.get_players(input)
#result.each do |tr|
#  next if tr.css('td').empty?

#  puts 'Rang: ' + tr.css('td')[0].text.strip
#  puts 'Mannschaft: ' + tr.css('td')[1].text.strip
#  puts 'LK: ' + tr.css('td')[2].text
#  puts 'DTB-ID: ' + tr.css('td')[3].text.chop
#  name = tr.css('td')[4].css('a')[0].text
#  puts 'Nachname: ' + name.split(',')[0]
#  puts 'Vorname: ' + name.split(',')[1]
#  yob_index = tr.css('td')[4].text.index('(')
#  puts 'Jahrgang: ' + tr.css('td')[4].text[yob_index + 1..yob_index + 4]
#  puts 'Nationalitaet: ' + tr.css('td')[5].text.chop
#  puts 'Spielgemeinschaft: ' + tr.css('td')[6].text.chop
#  puts 'Einzel: ' + tr.css('td')[7].text
#  puts 'Doppel: ' + tr.css('td')[8].text
#  puts 'Gesamt: ' + tr.css('td')[9].text
#  puts '----------------------------------------------'
#end
