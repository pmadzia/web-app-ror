require_relative "../config/environment"
require "json"
require "securerandom"

path = ARGV[0]
abort("File not found: #{path}") unless File.exist?(path)

BCrypt::Engine.cost = BCrypt::Engine::MIN_COST
data = JSON.parse(File.read(path))

users = data.map do |item|
  User.new(
    item.slice("full_name", "email", "job_positon", "last_seen", "status")
    .merge("password" => SecureRandom.hex(8)))
end

User.import(users, validate: true)
