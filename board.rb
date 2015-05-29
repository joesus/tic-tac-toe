require 'rack'

class Board
  attr_accessor :array

  def initialize(board=Array.new(3) { Array.new(3) { " " }})
    @array = board
  end

  def print_board(params, message)
"
<html>
<head>
<style type=\"text/css\">
#gameBoard {
  cell-padding: 0px;
  cell-spacing: 0px;
}
#gameBoard td {
  border: 1px solid black;
  text-align: center;
  width: 30px;
  height: 30px;
  padding: 0px;
  spacing: 0px;
}
#gameBoard td a{
  display: none;
}#gameBoard td:HOVER a{
  display: inline;
}


</style>
</head>
<body>
<h1>#{message}</h1>
<table id='gameBoard'>
  <tr>
    <td>#{generate_link("0,0", params) }</td>
    <td>#{generate_link("0,1", params)}</td>
    <td>#{generate_link("0,2", params)}</td>
  </tr>
  <tr>
    <td>#{generate_link("1,0", params)}</td>
    <td>#{generate_link("1,1", params) }</td>
    <td>#{generate_link("1,2", params)}</td>
  </tr>
  <tr>
    <td>#{generate_link("2,0", params)}</td>
    <td>#{generate_link("2,1", params)}</td>
    <td>#{generate_link("2,2", params)}</td>
  </tr>
</table>

</br>

<a href=\"/tic_tac_toe/\">
  <button>Reset</button>
</a>
</body>
</html>
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
    "<a href=\"/tic_tac_toe/?#{Rack::Utils.build_nested_query(modified_params)}\">X</a>"
  end
end