class ImportableCategory < ActiveRecord::Base

  belongs_to :category, foreign_key: "imported_id", class_name: "Category"

  def self.best_match(name)
    where(name: name).order("import_count, created_at desc").first.try(:category)
  end

end
