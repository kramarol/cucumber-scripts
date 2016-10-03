require 'json'

unless File.exist? ARGV[0]
  puts "Report #{ARGV[0]} doesn't exist!"
  exit 0
end

json = File.read(ARGV[0])
parsed = JSON.parse(json)
parsed.each do |content|
  content['elements'].each do |element|
    element.delete('before')
    unless element['after'].nil?
        element['after'].each do |after|
            embedding = after['embeddings']
            unless embedding.nil?
                element['steps'].each do |step|
                    unless step['result']['error_message'].nil?
                        step['embeddings'] = embedding
                    end
                end
            end
        end
    end
    element.delete('after')
  end
end

File.open(ARGV[0], 'w') {|f| f.write(parsed.to_json) }
