class BackfillPsychSheets < ActiveRecord::Migration
  def change
    ThemeFile.where(filename: 'competitors.html').find_each do |file|
      new_stuff = <<-HTML
  <a href="{{ 'comparison' | theme_file_url }}">{{ "comparison.title" | translate }}</a>
</p>

{{ competitors }}
HTML

      file.content = file.content.gsub(/<\/p>\s*{{\s*competitors\s*}}/, new_stuff)
      file.save!
    end

    Competition.find_each do |competition|
      create_comparison_file(competition.theme_files)
    end

    Theme.find_each do |theme|
      create_comparison_file(theme.files)
    end
  end

  def create_comparison_file(rel)
    file = rel.where(filename: 'comparison.html').first_or_initialize
    file.content = <<-HTML
<h2>{{ "comparison.title" | translate }}</h2>

{{ comparison }}
HTML

    file.save!
  end
end
