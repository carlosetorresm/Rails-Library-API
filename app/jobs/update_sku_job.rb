require 'net/http'
class UpdateSkuJob < ApplicationJob
  queue_as :default

  def perform(book)
    uri= URI('http://localhost:4572/update_sku')
    req= Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {sku: '123', name: book}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
    end
  end
end
