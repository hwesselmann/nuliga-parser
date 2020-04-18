# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require_relative '../../app/parser/team_detail_parser.rb'
require_relative '../../app/model/player.rb'
require_relative '../../app/model/club.rb'
require_relative '../../app/model/team.rb'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

class TeamDetailParserTest < Minitest::Test
  def setup
    @parser = TeamDetailParser.new('test/fixtures/files/team_detail.html')
  end

  def test_if_number_of_players_is_correct
    players = @parser.players
    assert_equal(16, players.size)
    assert_instance_of(Player, players.fetch(3))
    assert_equal('W*****n', players.fetch(0).lastname)
    assert_equal('N*****h', players.fetch(0).firstname)
    assert_equal('1234', players.fetch(2).yob)
    assert_equal('1******1', players.fetch(15).dtb_id)
    assert_equal('-', players.fetch(12).lk)
    assert_equal('LK23', players.fetch(11).lk)
    assert_equal('GER', players.fetch(11).nationality)
    assert_equal('Sommer 2017', players.fetch(11).season)
  end

  def test_if_teamname_is_correct
    team = @parser.team
    assert_instance_of(Team, team)
    assert_equal('Gemischt U10 Midcourt 1', team.name)
  end

  def test_for_clubname
    club = @parser.club
    assert_instance_of(Club, club)
    assert_equal('BVH Tennis Dorsten', club.name)
    assert_equal('2041201', club.id)
  end

  def test_for_season
    assert_equal('Sommer 2017', @parser.team.season)
  end
end
