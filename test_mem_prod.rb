require "net/http"

def do_request
  uri = URI("https://whispering-sierra-88360.herokuapp.com/jobs")
  Net::HTTP.get(uri)
end

  (1..50).map do |n|
    puts "Request #{n}..."
    do_request
  end
