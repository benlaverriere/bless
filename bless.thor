#!/usr/bin/env ruby
require 'rubygems'
require 'date'
require 'thor'

class Bless < Thor
  include Thor::Actions
  class_option :litany, default: 'litany.txt'

  desc 'tidy', 'a tiny ritual between tasks or attempts'
  def tidy
    create_file(options[:litany], verbose: false) unless File.exists? options[:litany]
    say 'Breathe.'
    notate 'What have you just completed?', 'done'

    clean = false
    until clean do
      clean = yes? 'Have you cleared your space of your previous work?'
    end

    notate 'What comes next?', 'next'
    incant
  end

  desc 'review', 'reflecting at the end of the day, or after a period of one kind of work'
  def review
    say "Here's how today went."
    run("cat #{options[:litany]} | sed 's/^/  /'", verbose: false)
    notate 'How did that feel?', 'felt'
    notate 'What was left undone?', 'left'
    notate 'What do you want for the future?', 'want'
    incant
    run("mv #{options[:litany]} #{DateTime.now}-#{options[:litany]}", verbose: false)
  end

  no_tasks do
    def incant
      say 'Great work.'
    end

    def notate(prompt, prefix)
      append_to_file options[:litany], verbose: false do
        result = ask prompt
        "#{prefix}: #{result}\n"
      end
    end
  end
end
