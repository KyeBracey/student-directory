@students = []
def interactive_menu
    loop do
        try_load_students
        print_menu
        process(STDIN.gets.chomp)
    end
end

def process(selection)
    case selection
    when "1"
        input_students
    when "2"
        show_students
    when "3"
        save_students
    when "4"
        load_students
    when "9"
        exit
    else
        puts "I'm not sure what you meant. Please try again."
    end
end

def print_menu
    puts "1. Input the students"
    puts "2. Show the students"
    puts "3. Save the list to students.csv"
    puts "4. Load the list from students.csv"
    puts "9. Exit the program"
end

def show_students
    print_header
    print_students_list
    print_footer
end

def input_students
    cohorts = [
        :january, :february, :march, :april,
        :may, :june, :july, :august, :september,
        :october, :november, :december
        ]
    puts "Please enter the names of the students"
    puts "To finish, just hit return twice"
    name = STDIN.gets.chomp
    while !name.empty? do
        @students << {name: name}
        puts "Which cohort is #{name} in?"
        cohort = STDIN.gets.chomp.downcase.to_sym
            if cohorts.include?(cohort)
                @students[(@students.count-1)][:cohort] = cohort
            else
                puts "Input not recognised - defaulting to November"
                @students[(@students.count-1)][:cohort] = :november
            end
        puts "Enter #{name}'s nationality:"
        nationality = STDIN.gets.chomp
        @students[(@students.count-1)][:nationality] = nationality
        puts "Enter #{name}'s height:"
        height = STDIN.gets.chomp
        @students[(@students.count-1)][:height] = height
        
        puts "Student name: #{name}. Cohort: #{cohort}. Nationality: #{nationality}. Height: #{height}."
        puts "Is this correct? (Y/N)"
        answer = STDIN.gets.chomp.downcase
        unless answer == "y"
            puts "Removing data. Please enter student's name again."
            @students.pop
        end
        puts "Now we have #{@students.count} students"
        name = STDIN.gets.chomp
    end
    @students.sort_by!{|student| student[:cohort]}
end

def try_load_students
    filename = ARGV.first
    return if filename.nil?
    if File.exists?(filename)
        load_students(filename)
        puts "Loaded students from #{filename}"
    else
        puts "Sorry, #{filename} does not exist."
        exit
    end
end

def load_students(filename = "students.csv")
    file = File.open(filename, "r")
    file.readlines.each do |line|
        name, cohort = line.chomp.split(",")
        @students << {name: name, cohort: cohort.to_sym}
    end
    file.close
end

def save_students
    file = File.open("students.csv", "w")
    @students.each do |student|
        student_data = [student[:name], student[:cohort]]
        csv_line = student_data.join(",")
        file.puts csv_line
    end
    file.close
end

def s_or_p
    return "student" if @students.count == 1
    return "students"
end

def print_header
    puts "The students of Villians Academy".center(50)
    puts "-------------".center(50)
end

def print_students_list
    if @students.count >= 1
        existing_cohorts = @students.collect{|student| student[:cohort]}.uniq
        existing_cohorts.each do |cohort|
            puts "#{cohort.capitalize} cohort:".center(50)
            puts "-------------".center(50)
            @students.each do |student|
                if student[:cohort] == cohort
                    puts "#{student[:name]}".center(50)
                    puts "Nationality: #{student[:nationality]}.  Height: #{student[:height]}.".center(50)#
                end
            end
            puts "-------------".center(50)
        end
    end
end

def print_footer
    if @students.count >= 1
        puts "Overall, we have #{@students.count} great #{s_or_p}.".center(50)
    else
        puts "We have no students!".center(50)
    end
end

interactive_menu