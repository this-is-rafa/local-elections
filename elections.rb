require 'httparty'
require 'json'
require 'nokogiri'
require 'sinatra'

get "/" do

#Because they do some strange URL changes every time they update the results, we grab this base URL and see where it redirects us. 
#For the next election, I assume this 'miami_split' URL will need to be updated, specifically the number at the end.

miami_split = "http://results.enr.clarityelections.com/FL/Dade/64620/"
split_response = HTTParty.get(miami_split)
split_dom = Nokogiri::HTML(split_response.body)
redirect = split_dom.css("script")[0]['src'].split("/")[1]


miami_json = "#{miami_split}#{redirect}/json/sum.json"      
miami_response = HTTParty.get(miami_json)
election_json = JSON.parse(miami_response.body)

miami_url = "#{miami_split}#{redirect}/en/summary.html"
miami_url_response = HTTParty.get(miami_url)
miami_dom = Nokogiri::HTML(miami_url_response.body)

@last_update = miami_dom.css("span#wlu").inner_html.to_s.split(">").last

@contests = election_json['Contests']

  erb :index
end
