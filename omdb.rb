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

result=JSON.parse(response.body)


  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
 
result["Search"].each {|movie_hash| 
 html_str += "<li>Title: #{movie_hash["Title"]}, Year: #{movie_hash["Year"]}</li>"
}

#trying out the links:
#result["Search"].each {|movie_hash| 
 #html_str += "<li>Title: #{movie_hash["Title"]}, Year: #{movie_hash["Year"]}</li>"
#}

#<a href="http://www.w3schools.com/"> way to get link 

html_str += "</ul></body></html>"
end 


get '/poster/:imdb' do |imdb_id|
  # Make another api call here to get the url of the poster.
  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<h3>#{imdb_id}</h3>"
  html_str += '<br /><a href="/">New Search</a></body></html>'
  #html_str = Typhoeus.get("www.imdb.com/images/M/#{imdb_id}", :params=> {:s =>search_str})

end