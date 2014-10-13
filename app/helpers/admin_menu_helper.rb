module AdminMenuHelper
  def admin_user_menu
    items = [
      {
        label: 'Competitions',
        controller: Admin::CompetitionsController,
        url: admin_competitions_path,
        css: 'fa-wrench'
      },
      {
        label: 'Users',
        controller: Admin::UsersController,
        url: admin_users_path,
        css: 'fa-user'
      },
      {
        label: 'Themes',
        controller: [Admin::ThemesController, Admin::ThemeFileTemplatesController],
        url: admin_themes_path,
        css: 'fa-files-o'
      }
    ]

    MenuItem.parse(controller, items)
  end

  def regular_user_menu
    items = [
      {
        label: 'Dashboard',
        controller: Admin::DashboardController,
        url: admin_competition_dashboard_index_path(current_competition),
        css: 'fa-dashboard'
      },
      {
        label: 'Competitors',
        controller: Admin::CompetitorsController,
        url: admin_competition_competitors_path(current_competition),
        css: 'fa-list-alt'
      },
      {
        label: 'Events',
        controller: [Admin::EventsController, Admin::EventRegistrationsController],
        url: admin_competition_events_path(current_competition),
        css: 'fa-table'
      },
      {
        label: 'News',
        controller: Admin::NewsController,
        url: admin_competition_news_index_path(current_competition),
        css: 'fa-star'
      },
      {
        label: 'Theme',
        controller: Admin::ThemeFilesController,
        url: admin_competition_theme_files_path(current_competition),
        css: 'fa-files-o'
      },
      {
        label: 'Settings',
        controller: Admin::CompetitionsController,
        actions: ['edit'],
        url: edit_admin_competition_path(current_competition),
        css: 'fa-wrench'
      }
    ]

    MenuItem.parse(controller, items)
  end
end
