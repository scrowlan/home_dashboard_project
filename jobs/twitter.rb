require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
Twitter.configure do |config|
  config.consumer_key = 'Q6fpql2qtPEpti7chay1g'
  config.consumer_secret = 'brwoCtKP3BxXOPu3H6wnqL7qdrmhVamy0ayeoB30M8'
  config.oauth_token = '19160753-g1XNpEp2QV9XhCg5AV78SVm3YJWUiw46LKSG5JA'
  config.oauth_token_secret = 'eyX21APdifi4qq4QFWKVBcIrEmqXte18R864xWEkY8'
end

search_term = URI::encode('#tank18')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = Twitter.search("#{search_term}").results

    if tweets
      tweets.map! do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end