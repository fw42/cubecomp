require 'test_helper'

class Admin::ThemeFileTemplatesControllerTest < ActionController::TestCase
  setup do
    @template = theme_file_templates(:default_index)
    @theme = @template.theme
  end

  test "#new" do
    get :new, theme_id: @theme.id
    assert_response :success
  end

  test "#create" do
    params = {
      filename: 'foobar.html',
      content: 'foobar'
    }

    assert_difference('ThemeFileTemplate.count') do
      post :create, theme_id: @theme.id, theme_file_template: params
    end

    assert_redirected_to edit_admin_theme_file_template_path(assigns(:template))
    assert_attributes(params, ThemeFileTemplate.last)
  end

  test "#edit" do
    get :edit, id: @template
    assert_response :success
  end

  test "#update" do
    params = {
      filename: 'foobar.html',
      content: 'foobar'
    }

    patch :update, id: @template, theme_file_template: params

    assert_redirected_to edit_admin_theme_file_template_path(assigns(:template))
    assert_attributes(params, @template.reload)
  end

  test "#destroy" do
    assert_difference('ThemeFileTemplate.count', -1) do
      delete :destroy, id: @template
    end

    assert_redirected_to admin_theme_path(@template.theme)
  end
end
