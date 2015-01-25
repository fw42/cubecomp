class EmailTemplatesImportService
  def initialize(competition_from, competition_to)
    @competition_from = competition_from
    @competition_to = competition_to
  end

  def replace!
    remove_existing_email_templates
    @competition_to.save!

    copy_email_templates
    @competition_to.save!
  end

  private

  def copy_email_templates
    @competition_from.email_templates.each do |email_template|
      new_email_template = email_template.dup
      new_email_template.competition_id = nil
      @competition_to.email_templates.build(new_email_template.attributes)
    end
  end

  def remove_existing_email_templates
    @competition_from.email_templates.each(&:mark_for_destruction)
  end
end
