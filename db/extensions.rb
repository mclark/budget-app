
%w(pg_trgm fuzzystrmatch).each do |extension|
  puts "installing extension '#{extension}'"
  ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS #{extension};")
end