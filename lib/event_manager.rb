require 'csv'
require 'google/apis/civicinfo_v2'
puts 'Event Manager Initialized!'

# Read the file contents
contents = File.read('event_attendees.csv')

# puts contents

# Read the file line by line
# lines = File.readlines('event_attendees.csv')
# lines.each do |line|
#   puts line
# end

# Display the first names of all attendees
# lines = File.readlines('event_attendees.csv')
# lines.each do |line|
#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

# Skipping the header row
# lines = File.readlines('event_attendees.csv')
# lines.each do |line|
#   next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

# second method
# lines = File.readlines('event_attendees.csv')
# row_index = 0
# lines.each do |line|
#   row_index = row_index + 1
#   next if row_index == 1
#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

# Third method
# lines = File.readlines('event_attendees.csv')
# lines.each_with_index do |line, index|
#   next if index == 0
#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

# Switching over to use the CSV library
# contents = CSV.open('event_attendees.csv', headers: true)
# contents.each do |row|
#   name = row[2]
#   puts name
# end

# Accessing columns by their names
# contents = CSV.open(
#   'event_attendees.csv',
#    headers: true,
#    header_converters: :symbol
# )

# contents.each do |row|
#   name = row[:email_address]
#   puts name
# end

# Displaying the zip codes of all attendees
# contents = CSV.open(
#   "event_attendees.csv",
#   headers: true,
#   header_converters: :symbol
# )

# contents.each do |row|
#   first_name = row[:first_name]
#   last_name = row[:last_name]
#   full_name = "#{first_name} #{last_name}"
#   zipcode = row[:zipcode]

#   puts "#{full_name}: #{zipcode}"
# end

# Moving clean zipcodes to a method
# def clean_zipcode(zipcode)
   # Handle missing zip codes
  # if zipcode.nil?
  #   zipcode = '00000'
  # elsif zipcode.length < 5
  #   zipcode = zipcode.rjust(5,'0')
  # elsif zipcode.length > 5
  #   zipcode = zipcode[0..4]
  # else
  #   zipcode
  # end
  # zipcode.to_s.rjust(5,'0')[0..4]
# end

# Cleaning up our zip codes
# contents = CSV.open(
#   "event_attendees.csv",
#   headers: true,
#   header_converters: :symbol
# )

# contents.each do |row|
#   first_name = row[:first_name]
#   last_name = row[:last_name]
#   full_name = "#{first_name} #{last_name}"
#   zipcode = clean_zipcode(row[:zipcode])
#   # p zipcode.length

#   puts "#{full_name}: #{zipcode}"
# end

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end

  puts "#{name} #{zipcode} #{legislators}"
end
