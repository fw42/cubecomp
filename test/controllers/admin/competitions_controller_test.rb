require 'test_helper'

class Admin::CompetitionsControllerTest < ActionController::TestCase
  setup do
    login_as(users(:admin))
    @competition = competitions(:aachen_open)

    @days_attributes = {
      '0' => {
        'date(2i)' => '1',
        'date(3i)' => '2',
        'date(1i)' => '2019',
        'entrance_fee_competitors' => '5',
        'entrance_fee_guests' => '6.7'
      }
    }

    @new_competition_params = {
      city_name: 'Gütersloh',
      country_id: countries(:germany).id,
      handle: 'go15',
      name: 'German Open 2015',
      staff_email: 'german-open@cubecomp.de',
      locales_attributes: {
        "0" => {
          competition_id: "",
          handle: "en",
          _destroy: 0
        }
      },
      days_attributes: @days_attributes,
      owner_user_id: users(:flo).id,
    }

    @update_params = {
      cc_staff: true,
      city_name: 'Aix la chapelle',
      city_name_short: 'AAC',
      country_id: countries(:germany).id,
      handle: 'aac14',
      name: 'Aachen Winter Open 2014',
      registration_open: true,
      staff_email: 'ao-winter@cubecomp.de',
      staff_name: 'aachen team',
      venue_address: 'rwth',
      delegate_user_id: users(:delegate).id,
      owner_user_id: @competition.users.first.id,
    }
  end

  test '#index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:competitions)
  end

  test '#index without permission renders forbidden' do
    mock_create_competitions_not_allowed
    get :index
    assert_response :forbidden
  end

  test '#new' do
    get :new
    assert_response :success
  end

  test '#new without permissions renders forbidden' do
    mock_create_competitions_not_allowed
    get :new
    assert_response :forbidden
  end

  test '#create' do
    assert_difference 'Competition.count' do
      assert_difference 'Day.count' do
        assert_difference 'Locale.count' do
          assert_difference 'Permission.count' do
            post :create, competition: @new_competition_params
          end
        end
      end
    end

    competition = Competition.find_by(handle: @new_competition_params[:handle])

    assert_redirected_to admin_competitions_path

    assert_attributes(@new_competition_params.except(:locales_attributes, :days_attributes), competition)
    assert_equal @new_competition_params[:locales_attributes]['0'][:handle], competition.locales.first.handle

    day = competition.days.last
    assert_equal Date.parse('2019-01-02'), day.date
    assert_equal 5.0, day.entrance_fee_competitors
    assert_equal 6.7, day.entrance_fee_guests

    assert_equal true, competition.owner.policy.login?(competition)
  end

  test '#create without permission renders forbidden' do
    mock_create_competitions_not_allowed

    assert_no_difference 'Competition.count' do
      post :create, competition: @new_competition_params
    end

    assert_response :forbidden
  end

  test '#edit' do
    get :edit, id: @competition.id
    assert_response :success
  end

  test '#edit renders 404 with invalid competition id' do
    get :edit, id: 17
    assert_response :not_found
  end

  test '#edit without login permission renders forbidden' do
    mock_login_not_allowed(@competition)
    get :edit, id: @competition.id
    assert_response :forbidden
  end

  test '#update' do
    patch :update, id: @competition.id, competition: @update_params
    assert_redirected_to edit_admin_competition_path(@competition)
    assert_attributes(@update_params, @competition.reload)
  end

  test '#update without permission renders forbidden' do
    mock_login_not_allowed(@competition)
    patch :update, id: @competition.id, competition: @update_params
    assert_response :forbidden
  end

  test '#update nested attributes for adding a locale' do
    @competition.locales.where(handle: 'de').each(&:destroy!)
    @competition.reload

    params = {
      locales_attributes: {
        '0' => {
          handle: 'de',
          _destroy: '0'
        }
      }
    }

    assert_difference 'Locale.count', +1 do
      assert_difference '@competition.reload.locales.count', +1 do
        patch :update, id: @competition.id, competition: params
      end
    end

    assert_equal 'de', @competition.locales.last.handle
  end

  test '#update nested attributes for removing a locale' do
    locale = @competition.locales.first

    params = {
      locales_attributes: {
        '0' => {
          id: locale.id,
          handle: locale.handle,
          _destroy: '1'
        }
      }
    }

    assert_difference 'Locale.count', -1 do
      assert_difference '@competition.reload.locales.count', -1 do
        patch :update, id: @competition.id, competition: params
      end
    end

    refute Locale.where(id: locale.id).exists?
  end

  test '#update to change the default locale' do
    @competition.update_attributes(default_locale: locales(:aachen_open_german))
    patch :update, id: @competition.id, competition: { default_locale_handle: locales(:aachen_open_english).handle }
    assert_equal 'en', @competition.reload.default_locale.handle
  end

  test '#update nested attributes for removing default locale sets remaining locale as default' do
    locale = @competition.default_locale

    params = {
      locales_attributes: {
        '0' => {
          id: locale.id,
          handle: locale.handle,
          _destroy: '1'
        }
      }
    }

    assert_difference 'Locale.count', -1 do
      assert_difference '@competition.reload.locales.count', -1 do
        patch :update, id: @competition.id, competition: params
      end
    end

    @competition.reload
    assert_equal @competition.locales.first, @competition.default_locale
  end

  test '#update nested attributes for adding a day' do
    params = { days_attributes: @days_attributes }

    assert_difference 'Day.count', +1 do
      assert_difference '@competition.reload.days.count', +1 do
        patch :update, id: @competition.id, competition: params
      end
    end

    day = @competition.days.last
    assert_equal Date.parse('2019-01-02'), day.date
    assert_equal 5.0, day.entrance_fee_competitors
    assert_equal 6.7, day.entrance_fee_guests
  end

  test '#update nested attributes for removing a day' do
    day = @competition.days.first

    params = {
      days_attributes: {
        '0' => {
          'date(2i)' => '1',
          'date(3i)' => '2',
          'date(1i)' => '2019',
          'id' => day.id,
          '_destroy' => '1'
        }
      }
    }

    assert_difference 'Day.count', -1 do
      assert_difference '@competition.reload.days.count', -1 do
        patch :update, id: @competition.id, competition: params
      end
    end

    refute Day.where(id: day).exists?
  end

  test '#update nested attributes for changing a day' do
    day = @competition.days.first

    params = {
      days_attributes: {
        '0' => {
          'id' => day.id,
          'date(2i)' => '1',
          'date(3i)' => '2',
          'date(1i)' => '2019',
          'entrance_fee_competitors' => '5',
          'entrance_fee_guests' => '6.7'
        }
      }
    }

    assert_no_difference 'Day.count' do
      patch :update, id: @competition.id, competition: params
    end

    day.reload
    assert_equal Date.parse('2019-01-02'), day.date
    assert_equal 5.0, day.entrance_fee_competitors
    assert_equal 6.7, day.entrance_fee_guests
  end

  test '#destroy' do
    assert_difference 'Competition.count', -1 do
      delete :destroy, id: @competition.id
    end

    assert_redirected_to admin_competitions_path
  end

  test '#destroy without permission renders forbidden' do
    mock_destroy_competition_not_allowed(@competition)
    assert_no_difference 'Competition.count' do
      delete :destroy, id: @competition.id
    end
    assert_response :forbidden
  end
end
