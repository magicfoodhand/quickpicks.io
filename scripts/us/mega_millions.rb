require '../core/etl'

URL = URI("https://www.calottery.com/sitecore/content/Miscellaneous/download-numbers/?GameName=mega-millions&Order=No")
COOKIE = 'website%23sc_wede=1; BNES_website%23sc_wede=jK35WmRnfsn19RQC4Rv%2FGbX41aI8DjiniYQQ3QqxJMllPSYZXZU%2BVRALYbXpKNHf'

basic_request ARGV.first, URL, COOKIE do |response|
  map_text_response response, "\r\n", 5 do |line|
    row = line.split(/\s\s+/)
    {
        draw_number: row.first.to_i,
        draw_date: Date.parse(row[1]),
        balls: row.slice(2, 6).map(&:to_i),
        megaball: row.last.to_i
    }
  end
end
