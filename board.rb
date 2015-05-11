require 'rack'

class Board
  attr_accessor :array

  def initialize(board=Array.new(3) { Array.new(3) { " " }})
    @array = board
  end

  def print_board(params, message)
"<h1>#{message}</h1><table>
  <tr>
    <td>
        #{spot_open?(Coordinates.new('1,1')) ? query_string('1,1', params) : @array[0][0] }
    </td>
    <td>
        #{spot_open?(Coordinates.new('1,2')) ? query_string('1,2', params) : @array[0][1] }
    </td>
    <td>
      #{spot_open?(Coordinates.new('1,3')) ? query_string('1,3', params) : @array[0][2] }
    </td>
  </tr>
  <tr>
    <td>
        #{spot_open?(Coordinates.new('2,1')) ? query_string('2,1', params) : @array[1][0] }
    </td>
    <td>
        #{spot_open?(Coordinates.new('2,2')) ? query_string('2,2', params) : @array[1][1] }
    </td>
    <td>
      #{spot_open?(Coordinates.new('2,3')) ? query_string('2,3', params) : @array[1][2] }
    </td>
  </tr>
  <tr>
    <td>
        #{spot_open?(Coordinates.new('3,1')) ? query_string('3,1', params) : @array[2][0] }
    </td>
    <td>
        #{spot_open?(Coordinates.new('3,2')) ? query_string('3,2', params) : @array[2][1] }
    </td>
    <td>
      #{spot_open?(Coordinates.new('3,3')) ? query_string('3,3', params) : @array[2][2] }
    </td>
  </tr>
</table>
"
  end

  def spot_open?(spot)
    @array[spot.x][spot.y] == " "
  end

  def modify_params(coordinates, params)
    coordinate = Coordinates.new(coordinates)
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

  def query_string(coordinates, params)
    modified_params = modify_params(coordinates, params)
    "<a href=\"/tic_tac_toe/?#{Rack::Utils.build_nested_query(modified_params)}\">X</a>"
  end
end