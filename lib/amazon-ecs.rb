#!/usr/bin/env ruby

require 'time'
require 'uri'
require 'openssl'
require 'base64'
require 'json'
require 'pp'

# Your Access Key ID, as taken from the Your Account page
ACCESS_KEY_ID = "AKIAIDZTT3WCPPLJPAUA"

# Your Secret Key corresponding to the above ID, as taken from the Your Account page
SECRET_KEY = "nfBx5nt3Rv+vzeKj21/Eqxa/sSLpfhZhgBcrZZhq"

# The region you are interested in
ENDPOINT = "webservices.amazon.com.mx"

REQUEST_URI = "/onca/xml"

params = {
  "Service" => "AWSECommerceService",
  "Operation" => "ItemLookup",
  "AWSAccessKeyId" => "AKIAIDZTT3WCPPLJPAUA",
  "AssociateTag" => "1083f5-20",
  "ItemId" => "B013LJQJ5Q",
  "IdType" => "ASIN",
  "ResponseGroup" => "Images,ItemAttributes,Offers"
}

# Set current timestamp if not set
params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")

# Generate the canonical query
canonical_query_string = params.sort.collect do |key, value|
  [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
end.join('&')

# Generate the string to be signed
string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"

# Generate the signature required by the Product Advertising API
signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), SECRET_KEY, string_to_sign)).strip()

# Generate the signed URL
request_url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"

buffer = open(request_url).read
# Convert the String response into a plain old Ruby array. It is faster and saves you time compared to the standard Ruby libraries too.
#result = JSON.parse(buffer)
# An example of how to take a random sample of elements from an array. Pass the number of elements you want into .sample() method. It's probably a better idea for the server to limit the results before sending, but you can use basic Ruby skills to trim & modify the data however you'd like.
#result = result.sample(1)

# Loop through each of the elements in the 'result' Array & print some of their attributes.
respond_to do |format|
   format.html
   format.js {} 
   format.json { 
      render json: {:result => result}
  } 
end
