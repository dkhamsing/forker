require 'forker'

puts 'forker test'

url = 'https://github.com/dkhamsing/DKCategories'
url1 = url
puts "getting content from #{url}"
content = Forker::net_content_for_url url

puts 'getting links'
links_to_check, * = Forker::net_find_links content
links_found1 = links_to_check.count
puts "links found: #{links_found1}"

puts 'getting repos'
repos = Forker::github_get_repos links_to_check
puts "repos found: #{repos.count}"
expect  = 4
exit 1 if repos.count != expect
puts 'got expected repo count  ✅'

url = 'https://github.com/dkhamsing/open-source-ios-apps'
url2 = url
puts "getting content from #{url}"
content = Forker::net_content_for_url url

puts 'getting links'
links_to_check, * = Forker::net_find_links content
links_found2 = links_to_check.count
puts "links found: #{links_found2}"

puts 'checking get links for list'
expect = links_found1 + links_found2
urls = [url1, url2]
value = Forker::net_get_links_for_list(urls).count
exit 1 if expect != value
puts 'verified get links for list ✅'

puts 'getting repos'
repos = Forker::github_get_repos links_to_check
puts "repos found: #{repos.count}"

user = ENV['USER']
pass = ENV['PASSWORD']
puts 'creating client'
client = Forker::github_client_user_pass user, pass

repo_to_fork = 'mozilla/firefox-ios'
Forker::fork client, repo_to_fork
puts 'fork success ✅'

repo = 'firefox-ios'
fork = "#{Forker::github_user client}/#{repo}"
puts 'checking fork'
exit 1 unless Forker::github_repo_exist(client, fork)
puts 'fork exists ✅'
