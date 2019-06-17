require '../../../core/etl'

URL = URI("https://www.idaholottery.com/games/winning-numbers-history/%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20Lucky%20for%20Life")
COOKIE = 'PHPSESSID=8e8k65rm3q412abggmf222scj4; exp_last_visit=1245388732; exp_last_activity=1560748732; exp_csrf_token=cbfffc7e5ded658d573d517c5d9ce5217d4bcc7f'

basic_request ARGV.first, URL, COOKIE do |response|
    map_html_response response, "tr", 1 do |line|
        row = line.text.split(/\s+/).drop(1)
        {
            draw_date: row[0],
            balls: row.slice(1..5).map(&:to_i),
            lb: row[8].to_i
        }
    end
end
