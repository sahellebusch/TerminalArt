# Matrix replication in a terminal.
#
# Author	=> Sean Hellebusch
# Date		=> 11.2.2014
# Version	=> 1


require 'io/console'
require 'highline'
require 'colorize'

# returns the window size
def winsize
	IO.console.winsize
rescue LoadError
	[Integer(`tput li`), Integer(`tput co`)]
end

# print the first screen
def print_intro(rows, hello)
	for i in 0..rows
		if i == rows/2
			print hello.colorize(:color => :green)
		else
			puts
		end
		sleep(SLEEP_INTRO)
	end
end

# create the first matrix hash with random
# ints and nil for chars as a placeholder
def create_matrix_with_ints(cols)
	matrix = []
	for i in 0..cols-1
		hash = {:step => rand(0..MAX_STEP),
				:char => nil}
		matrix << hash
	end
	return matrix
end

# fills the matrix hash with random chars
def fill_with_chars(cols, matrix)
	chars = Array.new(cols){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
	for i in 0..cols-1
		matrix[i][:char] = chars[i]
	end
	return matrix
end

# gets a random color for each char
def get_rand_color
	i = rand(1..NUM_COLORS)
	if i == 1
		color = :light_white
	elsif i == 2
		color = :light_green
	else
		color = :green
	end
	return color
end

# prints out a line
def matrix!(matrix, cols)
	matrix = fill_with_chars(cols, matrix)
	matrix.each { |char|
		if(char[:step] > 0)
			print char[:char].colorize(:color => get_rand_color)
			char[:step] = char[:step] - 1
		elsif(char[:step] == 0)
			wait = rand(-MAX_STEP..-1)
			char[:step] = wait
			print char[:char]
		elsif(char[:step] == -1)
			print " ".colorize(:color => get_rand_color)
			char[:step] = rand(0..MAX_STEP)
		else
			print " "
			char[:step] = char[:step] + 1
		end
	}
end

SLEEP_SHORT = 0.03
SLEEP_LONG  = 2
SLEEP_INTRO = 0.01
MAX_STEP    = 50
NUM_COLORS  = 3

rows, cols = winsize
blank_line = "\s" * cols
num_spaces = (cols - 6) / 2
space_str  = "\s" * num_spaces
hello 	   = "#{space_str}" + 'Hello.' + "#{space_str}"

print_intro(rows, hello)
sleep(SLEEP_LONG)
matrix = create_matrix_with_ints(cols)
matrix = fill_with_chars(cols, matrix)
loop do
	matrix!(matrix, cols)
	sleep(SLEEP_SHORT)
end
