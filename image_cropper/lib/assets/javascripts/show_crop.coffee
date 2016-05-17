# Declare Variables
url = $('#canvas-1').attr('data-project-url')
myPath = new Path

# Get data from database and draw on image
redraw = () ->
  $.ajax
    type: 'GET'
    url: url
    dataType: 'json'
    contentType: 'application/json'
    success: (data) ->
      i = 0
      while i < data.length
        myPath = new Path
        ii = 0
        while ii < data[i]['cords'].length
          myPath.fillColor = 'red'
          myPath.opacity = 0.5
          myPath.strokeColor = 'black'
          myPath.add new Point(data[i]['cords'][ii].x, data[i]['cords'][ii].y)
          ii++
        myPath.closed = true
        i++
      myPath = new Path
      return
  return


# Load image
raster = null

load_image = () ->
    if raster
        raster.remove()
    raster = new Raster $("#canvas-1").attr("data-project-image")
    raster.on 'load', () ->
        canvas = $("#canvas-1")
        canvas.width(raster.width)
        canvas.height(raster.height)
        raster.position = [raster.width/2, raster.height/2]
        view.setViewSize(canvas.width(), canvas.height())
        redraw()

load_image()
