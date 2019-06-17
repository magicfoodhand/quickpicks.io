require '../../../core/etl'

def california_lottery(basedir, url, cookie)
  basic_request basedir, url, cookie do |response|
    map_text_response response, "\r\n", 5 do |line|
      row = line.split(/\s\s+/)
      {
          draw_number: row.first.to_i,
          draw_date: Date.parse(row[1]),
          balls: row.slice(2..-1).map(&:to_i)
      }
    end
  end
end
