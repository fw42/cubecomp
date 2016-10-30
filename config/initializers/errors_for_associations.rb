# http://iada.nl/blog/article/rails-tip-display-association-validation-errors-fields

# Make sure errors on associations are also set on the _id and _ids fields
module ErrorsForAssociationsPatch
  def error_message
    if @method_name.end_with?('_ids')
      # Check for a has_(and_belongs_to_)many association (these always use the _ids postfix field).
      association = object.class.reflect_on_association(@method_name.chomp('_ids').pluralize.to_sym)
    elsif object.class.respond_to?(:reflect_on_all_associations)
      # Check for a belongs_to association with method_name matching the foreign key column
      association = object.class.reflect_on_all_associations.find do |a|
        a.macro == :belongs_to && a.foreign_key == @method_name
      end
    end

    if association.present?
      object.errors[association.name] + super
    else
      super
    end
  end
end

ActionView::Helpers::ActiveModelInstanceTag.prepend(ErrorsForAssociationsPatch)
