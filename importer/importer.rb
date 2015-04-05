class Importer
  def initialize(competition)
    @competition = competition
  end

  def assign_values(new, old, mapping)
    mapping.each do |new_key, old_key|
      new.public_send("#{new_key}=", old.send(old_key))
    end

    new.created_at = old.created_at
    new.updated_at = old.updated_at

    new
  end
end
