require 'rack'

class Board
  attr_accessor :array

  def initialize(board=Array.new(3) { Array.new(3) { " " }})
    @array = board
  end

  def print_board(params, message)
"<h1>#{message}</h1><table>
  <tr>
    #{generate_link("0,0", params) }
    #{generate_link("0,1", params)}
    #{generate_link("0,2", params)}
  </tr>
  <tr>
    #{generate_link("1,0", params)}
    #{generate_link("1,1", params) }
    #{generate_link("1,2", params)}
  </tr>
  <tr>
    #{generate_link("2,0", params)}
    #{generate_link("2,1", params)}
    #{generate_link("2,2", params)}
  </tr>
</table>

</br>

<a href=\"/tic_tac_toe/\">
  <button>Reset</button>
</a>
"
  end

  def spot_open?(spot)
    @array[spot.x][spot.y] == " "
  end

  def modify_params(coordinate, params)
    cloned_array = []
    @array.each_with_index do |a,i|
      cloned_array[i] = a.clone
    end
    cloned_array[coordinate.x][coordinate.y] = "X"
    json_params = JSON.parse(params["json"])
    json_params["board"] = cloned_array
    params["json"] = json_params.to_s.gsub("=>", ":")
    params
  end

  def generate_link(coordinates, params)
    coordinates = Coordinates.new(coordinates)
    return @array[coordinates.x][coordinates.y] unless spot_open?(coordinates)
    modified_params = modify_params(coordinates, params)
    "<td><a href=\"/tic_tac_toe/?#{Rack::Utils.build_nested_query(modified_params)}\">X</a></td>"
  end
end