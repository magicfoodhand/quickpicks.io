require 'uri'
require 'net/http'
require 'date'
require 'json'
require 'rubygems'
require 'nokogiri'
require 'titleize'

PAGE_MAX = 25
LATEST_MAX = 5

def basic_request(base_directory, url, cookie, &create_lines)
  check_usage base_directory, $0
  change_directory base_directory
  lines = create_lines.call http_request(url,cookie)
  write_latest lines
  write_pages lines
  name = $0.split(/_|.rb/).join(' ').titleize
  write_summary lines, name 
end

def check_usage(base_directory, filename)
  if base_directory.nil?
    puts "Usage: ruby #{filename} <base_directory>"
    exit
  end
end

def change_directory(base_directory); Dir.chdir base_directory end

def http_request(url,cookie)
  http = Net::HTTP.new url.host, url.port
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new url
  request["cookie"] = cookie

  response = http.request request
  response.read_body
end

def map_text_response(response_body, split, drop=0, &adapter)
  response_body.split(split).drop(drop).map(&adapter)
end

def map_html_response(response_body, selector, drop=0, &adapter)
  page = Nokogiri::HTML response_body
  page.css(selector).drop(drop).map(&adapter)
end

def write_file(filename, contents)
  File.open filename,"w" do |f|
    f.write contents.to_json
  end
end

def write_latest(lines)
  latest = lines.first LATEST_MAX
  write_file 'latest.json', latest
end

def write_pages(lines)
  index = lines.count / PAGE_MAX + 1
  lines.each_slice PAGE_MAX do |l|
    write_file "page-#{index}.json", l
    index -= 1
  end
end

def write_summary(lines, lottery_name)
  summary = {
      drawings: lines.count,
      last: lines.first,
      pages: lines.count / PAGE_MAX + 1,
      last_updated: Time.now.utc,
      lottery: lottery_name
  }
  write_file 'summary.json', summary
end
