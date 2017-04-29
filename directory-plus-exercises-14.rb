# This code has all of the step 14 exercises implemented.
# I wish I had made a separate copy for each one! But it was fun to get them
# all fitting together in one file.

require 'csv'

@students = []
def interactive_menu
    loop do
        print_menu
        process(STDIN.gets.chomp)
    end
end

def process(selection)
    case selection
        when "1" then input_students
        when "2" then show_students
        when "3"
            puts "Enter filename to save to (or hit enter for students.csv)"
            save_students(STDIN.gets.chomp)
        when "4"
            puts "Enter filename to load from (or hit enter for students.csv)"
            load_students(STDIN.gets.chomp)
        when "9"
            puts "Exiting program..."
            exit
        else puts "I'm not sure what you meant. Please try again."
    end
end

def print_menu
    puts "1. Input the students"
    puts "2. Show the students"
    puts "3. Save the list to disk"
    puts "4. Load a student list from disk (replaces current list)"
    puts "9. Exit the program"
end

def show_students
    print_header
    print_students_list
    print_footer
end

def input_students
    puts "Please enter the names of the students"
    puts "To finish, just hit return twice"
    name = STDIN.gets.chomp
    while !name.empty? do
        add_student(name, "november")
        puts "Now we have #{@students.count} students"
        name = STDIN.gets.chomp
    end
end

def add_student(name, cohort)
    @students << {name: name, cohort: cohort.to_sym}
end

def try_load_students
    filename = ARGV.first
    filename = "students.csv" if filename.nil?
    if File.exists?(filename)
        load_students(filename)
        puts "Loaded students from #{filename}"
    else
        puts "Sorry, #{filename} does not exist."
        exit
    end
end

def load_students(filename)
    @students = [] #clears current list
    filename = find_file(filename)
    CSV.foreach(filename) do |row|
        name, cohort = row
        add_student(name, cohort)
    end
    puts "Student list successfully loaded from #{filename}"
end

def save_students(filename)
    filename = find_file(filename)
    CSV.open(filename, "wb") do |row|
        @students.each do |student|
            row << [student[:name], student[:cohort]]
        end
    end
    puts "Student list successfully saved to students.csv"
end

def find_file(filename)
    filename = "students.csv" if filename.empty?
    unless File.exists?(filename)
        puts "Sorry, #{filename} does not exist. Defaulting to students.csv"
        filename = "students.csv"
    end
    filename
end

def singular_plural
    return "student" if @students.count == 1
    return "students"
end

def print_header
    puts "The students of Villians Academy"
    puts "-------------"
end

def print_students_list
    @students.each do |student|
        puts "#{student[:name]} (#{student[:cohort]} cohort)"
    end
end

def print_footer
    if @students.count >= 1
        puts "Overall, we have #{@students.count} great #{singular_plural}."
    else
        puts "We have no students!"
    end
end

try_load_students
interactive_menu