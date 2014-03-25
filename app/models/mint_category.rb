class MintCategory < ActiveRecord::Base

  def self.best_match(name)
    where(name: name).order("import_count, created_at desc").first
  end

end
