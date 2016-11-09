require 'httparty'
require 'json'
require 'nokogiri'
require 'sinatra'


get "/" do

miami_json = "http://results.enr.clarityelections.com/FL/Dade/64620/180019/json/sum.json"      
miami_response = HTTParty.get(miami_json)
election_json = JSON.parse(miami_response.body)

miami_url = "http://results.enr.clarityelections.com/FL/Dade/64620/180019/en/summary.html"
miami_url_response = HTTParty.get(miami_url)
miami_dom = Nokogiri::HTML(miami_url_response.body)

@last_update = miami_dom.css("span#wlu").inner_html.to_s.split(">").last


fl_url = "http://enight.elections.myflorida.com/Constitutional/Amendment.aspx"
fl_response = HTTParty.get(fl_url)
fl_dom = Nokogiri::HTML(fl_response.body)

flsolar_yes = fl_dom.css(".progressbar")[0].content
flsolar_no = fl_dom.css(".progressbar")[1].content
flweed_yes = fl_dom.css(".progressbar")[2].content
flweed_no = fl_dom.css(".progressbar")[3].content

#############################

#key biscayne 51
kbcouncil = election_json['Contests'][51]
@kbcontest = kbcouncil["C"].capitalize #name of contest
@kbnames = kbcouncil["CH"] #candidates 0..5
@kbpercent = kbcouncil["PCT"] #percentage 0..5
@kbvotes = kbcouncil["V"] #votes 0..5
@kbtotal = kbcouncil["TP"]
@kbreport = kbcouncil["PR"]

#mayor 33
mayor = election_json['Contests'][33]
@mayorcontest = mayor["C"].capitalize #name of contest
@mayornames = mayor["CH"] #candidates 0..1
@mayorpercent = mayor["PCT"] #percentage
@mayorvotes = mayor["V"] #votes
@mayortotal = mayor["TP"]
@mayorreport = mayor["PR"]

#solar 69
solar = election_json['Contests'][69]
@solarcontest = solar["C"].capitalize #name of contest
@solarnames = solar["CH"] #yes - no 0..1
@solarpercent = []
@solarpercent << flsolar_yes << flsolar_no

#weed 70
weed = election_json['Contests'][70]
@weedcontest = weed["C"].capitalize #name of contest
@weednames = weed["CH"] #yes - no 0..1
@weedpercent = []
@weedpercent << flweed_yes << flweed_no



  erb :index
end

#############################