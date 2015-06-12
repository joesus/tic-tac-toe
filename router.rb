require 'pry-nav'
require 'addressable/uri'
require_relative 'tic_tac_toe'
require_relative 'game_controller'

class Router
  attr_accessor :get_map

  def initialize
    self.get_map = {}
    setup_routes
  end

  def get(path, controller_action, param_keys=nil)
    self.get_map[path] = controller_action
  end

  def setup_routes
    get '/', 'game_controller#load_saved_game'
    get '/tic_tac_toe/', 'game_controller#load_saved_game'
  end

  def route(method, path, params)
    params = default_params if params.nil?
    self.send("#{method}_map").each do |key, value|
      if path.match(/^#{key}/)
        return parse_controller_action(value, params)
      end
    end
  end

  def parse_controller_action(value, params=nil)
    parts = value.split('#')
    create_controller(parts.first).new(params).send(parts[1])
  end

  def create_controller(name)
    class_name = name.split(/_/).map!(&:capitalize).join
    eval(class_name)
  end

  def default_params
    {
      "json" => "{\"board\":[[\" \", \" \", \" \"], [\" \", \" \", \" \"], [\" \", \" \", \" \"]], \"turn\":\"player_one\", \"player_one\":\"X\", \"player_two\":\"O\"}"
    }
  end

end