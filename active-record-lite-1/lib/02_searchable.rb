require_relative 'db_connection'
require_relative '01_sql_object'
require "byebug"

module Searchable
  def where(params)
    where_line = params.keys.map {|key| "#{key} = ?"}.join(" AND ")
    params_values = params.values
    hashes = DBConnection.execute(<<-SQL, *params_values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    result = hashes.map {|hash| self.new(hash)}
    result
  end
end

class SQLObject
  extend Searchable
end
