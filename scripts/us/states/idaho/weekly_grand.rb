require 'uri'
require 'net/http'
require 'date'
require 'json'
require 'rubygems'
require 'nokogiri'

if ARGV.length != 1
    puts "Usage: ruby weekly_grand.rb <base_directory>"
    exit
end

Dir.chdir ARGV.first

url = URI("https://www.idaholottery.com/games/winning-numbers-history/%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20Weekly%20Grand")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["cookie"] = 'PHPSESSID=8e8k65rm3q412abggmf222scj4; exp_last_visit=1245388732; exp_last_activity=1560750915; exp_csrf_token=cbfffc7e5ded658d573d517c5d9ce5217d4bcc7f'

response = http.request(request)

page = Nokogiri::HTML(response.read_body)

lines = page.css('tr').drop(1).map do |line|
    row = line.text.split(/\s+/).drop(1)
    {
        draw_date: row[0],
        balls: row.slice(1..5)
    }
end

def write_file(filename, contents) 
    File.open(filename,"w") do |f|
        f.write(contents.to_json)
    end
end

latest = lines.first(5)
write_file('latest.json', latest)

index = 1
lines.each_slice(25) do |l| 
    write_file("page-#{index}.json", l)
    index += 1
end

summary = {
    drawings: lines.count,
    last: lines.first,
    pages: index,
    lottery: 'Weekly Grand'
}
write_file('summary.json', summary)



