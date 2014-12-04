require 'pathname'
require 'json'

require 'daybreak'
require 'sinatra/base'

require_relative 'helpers'
require_relative 'metadata'


module KitchenHooks
  class App < Sinatra::Application
    set :root, File.join(KitchenHooks::ROOT, 'web')

    enable :sessions

    include KitchenHooks::Helpers

    def self.db! db_path
      @@db = Daybreak::DB.new db_path
    end

    def db &block
      if block_given?
        @@db.synchronize do
          yield
        end
      else
        return @@db
      end
    end

    def database
      db_entries = {}
      db.each do |k, v|
        db_entries[k] = v
      end
      return db_entries.sort_by { |stamp, _| stamp }
    end

    def self.config! config
      @@knives = config['servers'].map do |s|
        Pathname.new(s['knife']).expand_path.realpath.to_s
      end
    end

    def knives ; @@knives ||= [] end


    get '/' do
      erb :app, locals: {
        database: database
      }
    end

    get '/favicon.ico' do
      send_file File.join(settings.root, 'favicon.ico'), \
        :disposition => 'inline'
    end

    get %r|/app/(.*)| do |fn|
      send_file File.join(settings.root, 'app', fn), \
        :disposition => 'inline'
    end


    post '/' do
      request.body.rewind
      event = JSON::parse request.body.read

      if commit_to_kitchen?(event)
        perform_kitchen_upload(event, knives)
        save_event \
          type: 'kitchen upload',
          author: author(event),
          repo: repo_name(event),
          raw: event
      end

      if tagged_commit_to_cookbook?(event) &&
         tag_name(event) =~ /^v\d+/ # Tagged with version we're releasing
        perform_cookbook_upload(event, knives)
        save_event \
          type: 'cookbook upload',
          author: author(event),
          repo: repo_name(event),
          cookbook: cookbook_name(event),
          raw: event
      end

      if tagged_commit_to_realm?(event) &&
         tag_name(event) =~ /^bjn_/ # Tagged with environment we're pinning
        perform_constraint_application(event, knives)
        save_event \
          type: 'constraint application',
          author: author(event),
          repo: repo_name(event),
          cookbook: cookbook_name(event),
          raw: event
      end

      db.flush
    end

  private
    def save_event e
      db do
        db[Time.now.to_f] = e
      end
    end
  end
end