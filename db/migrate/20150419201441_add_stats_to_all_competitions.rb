class AddStatsToAllCompetitions < ActiveRecord::Migration
  def change
    ThemeFile.where(filename: 'competitors.html').find_each do |file|
      new_stuff = <<-HTML
<p>
  <a href="{{ 'stats' | theme_file_url }}">{{ "stats.title" | translate }}</a>
</p>

{{ competitors }}
HTML

      file.content = file.content.gsub(/{{\s*competitors\s*}}/, new_stuff)
      file.save!
    end

    Competition.find_each do |competition|
      create_stats_file(competition.theme_files)
    end

    Theme.find_each do |theme|
      create_stats_file(theme.files)
    end
  end

  def create_stats_file(rel)
    file = rel.where(filename: 'stats.html').first_or_initialize
    file.content = <<-HTML
<h2>{{ "stats.title" | translate }}</h2>

{{ stats }}
HTML

    file.save!
  end
end
