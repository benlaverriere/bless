#!/usr/bin/env ruby
require 'rubygems'
require 'date'
require 'thor'

class Bless < Thor
  include Thor::Actions
  class_option :litany, default: 'litany.txt'

  desc 'begin', 'starting the day with hope and intention'
  def begin
    with_litany_in_hand
    say 'Hello!'
    notate 'What are the top few things you want to accomplish today?', 'goal'
    notate 'Might anything stand in your way?', 'risk'
    incant
  end

  desc 'tidy', 'a tiny ritual between tasks or attempts'
  def tidy
    with_litany_in_hand
    say 'Breathe.'
    notate 'What have you just completed?', 'done'
    make_sure 'Have you cleared your space of your previous work?'
    notate 'What comes next?', 'next'
    incant
  end

  desc 'review', 'reflecting at the end of the day, or after a period of one kind of work'
  def review
    with_litany_in_hand
    say "Here's how today went."
    declaim
    notate 'How did that feel?', 'felt'
    notate 'What was left undone?', 'left'
    notate 'What do you want for the future?', 'want'
    archive
    incant
  end

  no_tasks do
    def archive
      run("mv #{options[:litany]} #{DateTime.now}-#{options[:litany]}", verbose: false) if File.exist? options[:litany]
    end

    def declaim
      with_litany_in_hand
      run("cat #{options[:litany]} | sed 's/^/  /'", verbose: false)
    end

    def incant
      say 'Great work.'
    end

    def make_sure(prompt)
      it_is_done = false
      it_is_done = yes? prompt until it_is_done
    end

    def notate(prompt, prefix)
      with_litany_in_hand
      append_to_file options[:litany], verbose: false do
        result = ask prompt
        "#{prefix}: #{result}\n"
      end
    end

    def with_litany_in_hand
      create_file(options[:litany], verbose: false) unless File.exist? options[:litany]
    end
  end
end
