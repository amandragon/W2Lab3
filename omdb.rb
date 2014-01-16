require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

#shouldn't have to modify this part at all
get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end
#^shouldn't have to modify

#search for the name



post '/result' do
search_str = params[:movie] #that gets back the movie we're requesting
response= Typhoeus.get("www.omdbapi.com", :params=> {:s =>search_str})

result=JSON.parse(response.body) #creating object and passing response as an argument


  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
 
result["Search"].each do |movie_hash| 
 html_str += "<a href='/poster/#{movie_hash["imdbID"]}'><li>Title: #{movie_hash["Title"]}, Year: #{movie_hash["Year"]}</li></a>"
end

#trying out the links:
#result["Search"].each {|movie_hash| 
 #html_str += "<li><a href="http://www.google.com/"> Title: #{movie_hash["Title"]}, Year: #{movie_hash["Year"]}/a></li>"
#}


html_str += "</ul></body></html>"
end 


get '/poster/:imdb' do |imdb_id|
id=params[:imdb]
response_ID= Typhoeus.get("www.omdbapi.com", :params=> {:i =>id})
result_ID=JSON.parse(response_ID.body) #this means that the information is in the body

  # Make another api call here to get the url of the poster.
  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<h3><img src=#{result_ID["Poster"]}></h3>"
  html_str += '<br /><a href="/">New Search</a></body></html>'
  
  #api call
  #search_str = params[:movie]
  #response= Typhoeus.get("www.omdbapi.com", :params=> {:i =>search_str})
  #result=JSON.parse(response.body)

end
