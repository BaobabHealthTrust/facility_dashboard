#!/usr/bin/env ruby

require "rubygems"

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def yellow(text); colorize(text, 33); end
def blue(text); colorize(text, 34); end
def magenta(text); colorize(text, 35); end
def cyan(text); colorize(text, 36); end


def start

    system("clear")
    puts ""
    print magenta("\tEnter Order Group: ")
    order_group = gets.chomp
    system("clear")
    puts ""
    print magenta("\tEnter description: ")
    description = gets.chomp
    system("clear")
    puts ""
    print magenta("\tEnter duration: ")
    duration = gets.chomp
    system("clear")

    add(order_group,description,duration)
end


def add(order_group, description, duration)

  exists = FlowOrder.find_by_order_group(order_group)

  if exists.blank?

    FlowOrder.create(
        {
            :order_group => order_group,
            :description => description,
            :duration => duration.to_f,
            :creator => 1
        }
    )
  end

end

start
