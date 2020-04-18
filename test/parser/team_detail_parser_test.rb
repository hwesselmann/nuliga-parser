# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require_relative '../../app/parser/team_detail_parser.rb'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

class TeamDetailParserTest < Minitest::Test
  def setup
    @parser = TeamDetailParser.new('test/fixtures/files/team_detail.html')
  end

  def test_if_number_of_players_is_correct
    assert_equal(17, @parser.players.size)
  end

  def test_if_teamname_is_correct
    assert_equal('Gemischt U10 Midcourt 1', @parser.team_name)
  end

  def test_for_clubname
    assert_equal('BVH Tennis Dorsten', @parser.club_name)
  end

  def test_for_club_id
    assert_equal('2041201', @parser.club_id)
  end

  def test_for_season
    assert_equal('Sommer 2017', @parser.season)
  end
end
