puts 'Event Manager Initialized!'

# Read the file contents
contents = File.read('event_attendees.csv')

# puts contents

# Read the file line by line
lines = File.readlines('event_attendees.csv')
lines.each do |line|
  puts line
end
