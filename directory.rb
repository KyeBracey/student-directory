def interactive_menu
    students = []
    loop do
        puts "1. Input the students"
        puts "2. Show the students"
        puts "9. Exit the program"
        selection = gets.chomp
        case selection
        when "1"
            students = input_students
        when "2"
            print_header
            print(students)
            print_footer(students)
        when "9"
            exit
        else
            puts "I'm not sure what you meant. Please try again."
        end
    end
end

def input_students
    students = []
    cohorts = [
        :january, :february, :march, :april,
        :may, :june, :july, :august, :september,
        :october, :november, :december
        ]
    
    puts "Please enter the names of the students"
    puts "To finish, just hit return twice"
    name = gets.chomp
    while !name.empty? do
        students << {name: name}
        puts "Which cohort is #{name} in?"
        cohort = gets.chomp.downcase.to_sym
            if cohorts.include?(cohort)
                students[(students.count-1)][:cohort] = cohort
            else
                puts "Input not recognised - defaulting to November"
                students[(students.count-1)][:cohort] = :november
            end
        puts "Enter #{name}'s nationality:"
        nationality = gets.chomp
        students[(students.count-1)][:nationality] = nationality
        puts "Enter #{name}'s height:"
        height = gets.chomp
        students[(students.count-1)][:height] = height
        
        puts "Student name: #{name}. Cohort: #{cohort}. Nationality: #{nationality}. Height: #{height}."
        puts "Is this correct? (Y/N)"
        answer = gets.chomp.downcase
        unless answer == "y"
            puts "Removing data. Please enter student's name again."
            students.pop
        end
        puts "Now we have #{students.count} students"
        name = gets.chomp
    end
    students.sort_by!{|student| student[:cohort]}
end

def s_or_p(students)
    return "student" if students.count == 1
    return "students"
end

def print_header
    puts "The students of Villians Academy".center(50)
    puts "-------------".center(50)
end

def print(students)
    if students.count >= 1
        existing_cohorts = students.collect{|student| student[:cohort]}.uniq
        existing_cohorts.each do |cohort|
            puts "#{cohort.capitalize} cohort:".center(50)
            puts "-------------".center(50)
            students.each do |student|
                if student[:cohort] == cohort
                    puts "#{student[:name]}".center(50)
                    puts "Nationality: #{student[:nationality]}.  Height: #{student[:height]}.".center(50)#
                end
            end
            puts "-------------".center(50)
        end
    end
end

def print_footer(students)
    if students.count >= 1
        puts "Overall, we have #{students.count} great #{s_or_p(students)}.".center(50)
    else
        puts "We have no students!".center(50)
    end
end

interactive_menu