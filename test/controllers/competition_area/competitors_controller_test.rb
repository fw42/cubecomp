require 'test_helper'

class CompetitionArea::CompetitorsControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @locale = locales(:aachen_open_german)

    @new_competitor_params = {
      wca: "2015BOB01",
      first_name: "Bob",
      last_name: "Bobsen",
      email: "bob@bobsen.com",
      :"birthday(2i)" => "2",
      :"birthday(3i)" => "2",
      :"birthday(1i)" => "1997",
      country_id: countries(:germany).id,
      local: true,
      male: true,
      user_comment: "awesomesauce",
      days: {
        days(:aachen_open_day_one).id.to_s => {
          status: "guest",
          events: {
            events(:aachen_open_rubiks_cube).id.to_s => { status: "not_registered" },
            events(:aachen_open_rubiks_professor).id.to_s => { status: "not_registered" }
          }
        },
        days(:aachen_open_day_two).id.to_s => {
          status: "competitor",
          events: {
            events(:aachen_open_rubiks_revenge_day_two).id.to_s => { status: "registered" },
          }
        }
      }
    }
  end

  test '#create creates a competitor and redirects back with notice' do
    assert_difference '@competition.competitors.count', +1 do
      assert_difference '@competition.event_registrations.count', +1 do
        assert_difference '@competition.day_registrations.count', +2 do
          request.env["HTTP_REFERER"] = "/foo/"
          post :create,
            competition_handle: @competition.handle,
            theme_file: "foobar.html",
            competitor: @new_competitor_params,
            locale: @locale.handle
        end
      end
    end

    assert_response :redirect
    assert_redirected_to request.env["HTTP_REFERER"]
    bob = @competition.competitors.find_by(wca: '2015BOB01')
    expected = @new_competitor_params.except(:"birthday(1i)", :"birthday(2i)", :"birthday(3i)", :days)
    assert_attributes(expected, bob)
    assert_equal @new_competitor_params[:"birthday(1i)"].to_i, bob.birthday.year
    assert_equal @new_competitor_params[:"birthday(2i)"].to_i, bob.birthday.month
    assert_equal @new_competitor_params[:"birthday(3i)"].to_i, bob.birthday.day
  end

  test "#create can't set admin fields" do
    @new_competitor_params[:paid] = true

    assert_no_difference 'Competitor.count' do
      assert_raises(ActionController::UnpermittedParameters) do
        post :create,
          competition_handle: @competition.handle,
          theme_file: "foobar.html",
          competitor: @new_competitor_params,
          locale: @locale.handle
      end
    end
  end

  test '#create renders same theme_file with errors on validation error' do
    @new_competitor_params.delete(:first_name)
    @competition.theme_files.create(filename: 'foobar.html', content: "foobar \n {{ registration_form }}")

    post :create,
      competition_handle: @competition.handle,
      theme_file: "foobar.html",
      competitor: @new_competitor_params,
      locale: @locale.handle

    assert_response :ok
    assert_match /#{Regexp.escape('<div class="field_with_errors">')}/, response.body
    assert_match /#{Regexp.escape('<div class="registration-errors">')}/, response.body
  end

  test '#create does not allow you to register for events that are not for registration' do
    event = events(:aachen_open_rubiks_cube_round_two)

    @new_competitor_params.delete(:days)
    @new_competitor_params[:days] = {
      event.day.id.to_s => {
        "status" => "competitor",
        "events" => {
          event.id.to_s => { "status" => "registered" },
        }
      }
    }

    assert_no_difference 'Competitor.count' do
      post :create,
        competition_handle: @competition.handle,
        competitor: @new_competitor_params,
        locale: @locale.handle

      assert_response :forbidden
    end
  end

  test '#create does not allow you to register for events for which registration is already closed' do
    event = events(:aachen_open_rubiks_revenge_day_two)
    event.update_attributes(state: 'registration_closed')

    assert_no_difference 'Competitor.count' do
      post :create,
        competition_handle: @competition.handle,
        competitor: @new_competitor_params,
        locale: @locale.handle

      assert_response :forbidden
    end
  end

  test '#create does not allow you to register (without status "waiting") for waiting list events' do
    event = events(:aachen_open_rubiks_revenge_day_two)
    event.update_attributes(state: 'open_with_waiting_list')

    assert_no_difference 'Competitor.count' do
      post :create,
        competition_handle: @competition.handle,
        competitor: @new_competitor_params,
        locale: @locale.handle

      assert_response :forbidden
    end
  end

  test '#create puts competitor on waiting list when registering for a waiting list event' do
    event = events(:aachen_open_rubiks_revenge_day_two)
    event.update_attributes(state: 'open_with_waiting_list')
    @new_competitor_params[:days][event.day.id.to_s][:events][event.id.to_s][:status] = 'waiting'

    assert_difference '@competition.competitors.count', +1 do
      assert_difference '@competition.event_registrations.count', +1 do
        request.env["HTTP_REFERER"] = "/foo/"
        post :create,
          competition_handle: @competition.handle,
          competitor: @new_competitor_params,
          locale: @locale.handle
      end
    end

    assert_response :redirect
    assert_redirected_to request.env["HTTP_REFERER"]
    assert_equal true, @competition.competitors.last.event_registrations.first.waiting
  end
end
