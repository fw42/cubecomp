require 'test_helper'

class ThemeCopyServiceTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:german_open)
    @theme = themes(:default)
  end

  test '#replace_theme' do
    service(@theme.files).replace_theme

    ## this will fail because of https://github.com/rails/rails/issues/18573
    # @competition.save!
  end

  test "#remove_existing_theme_files_from_competition" do
    service.remove_existing_theme_files_from_competition
    assert @competition.theme_files.all?(&:marked_for_destruction?)

    assert_difference '@competition.theme_files.count', -@competition.theme_files.count do
      @competition.save!
    end
  end

  test "#copy_theme_to_competition from theme" do
    @competition.theme_files.each(&:destroy!)
    @competition.reload

    service(@theme.files).copy_theme_to_competition

    assert_equal @theme.files.map{ |file| [ file.filename, file.content ] },
      @competition.theme_files.map{ |file| [ file.filename, file.content ] }

    assert_difference '@competition.theme_files.count', @theme.files.count do
      @competition.save!
    end
  end

  test "#copy_theme_to_competition from another competition" do
    @competition.theme_files.each(&:destroy!)
    @competition.reload

    other_competition = competitions(:aachen_open)
    service(other_competition.theme_files).copy_theme_to_competition

    assert_equal other_competition.theme_files.map{ |file| [ file.filename, file.content ] },
      @competition.theme_files.map{ |file| [ file.filename, file.content ] }

    assert_difference '@competition.theme_files.count', other_competition.theme_files.count do
      @competition.save!
    end
  end

  private

  def service(from = nil)
    @service ||= ThemeCopyService.new(@competition.theme_files, from)
  end
end
