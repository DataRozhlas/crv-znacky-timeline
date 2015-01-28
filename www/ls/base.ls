years = [1945 to 2013]
years.unshift "stare"
yearWidth = 11
rectSize = 9
rectFullSize = rectSize + 1
znackaHeight = 200
rectCapacity = 5000

znacky = d3.tsv.parse ig.data.znacky, (row) ->
  data = name: row.znacka
  data.sum = 0
  data.yearMax = -Infinity
  data.years = for year in years
    cars = parseInt row[year], 10
    data.sum += cars
    if data.yearMax < cars
      data.yearMax = cars
    cars
  data.height = Math.ceil data.yearMax / rectCapacity * rectFullSize
  data.height++ if data.height % 2
  data.height = 40 if data.height < 40

  data
znacky.sort (a, b) -> b.sum - a.sum

# znacky.length = 5

container = d3.select ig.containers.base
list = container.append \ul .attr \class \list
  ..selectAll \li.item .data znacky .enter!append \li
    ..append \span
      ..attr \class \name
      ..html (.name)
      ..style \line-height -> "#{it.height}px"
    ..append \canvas
      ..attr \height (.height)
      ..attr \width 880

canvases = list.selectAll \canvas
  ..each ({years}:znacka) ->
    ctx = @getContext \2d
    for year, yearIndex in years
      rects = Math.floor year / 5000
      remainder = year % 5000
      lines = Math.floor remainder / 1000
      remainder = remainder % 1000
      height = rects * rectFullSize
      leftOffset = yearWidth * yearIndex
      topOffset = (znacka.height - height) / 2
      for i in [0 til rects]
        ctx.fillRect do
          leftOffset
          topOffset + i * rectFullSize
          rectSize
          rectSize
      # ctx.stroke!
      # ctx.strokeStyle = 'red'
      if rects == 0 and (lines == 1 or lines == 3)
        topOffset += 1
      for i in [0 til lines]
        ii = Math.floor i / 2
        if i % 2 == 0
          d = -1.5
          top = topOffset - (ii) * 2
        else
          d = 0.5
          top = topOffset + height + (ii) * 2
        ctx.moveTo leftOffset, top + d
        ctx.lineTo leftOffset + rectSize, top + d
      if rects == lines == 0
        width = Math.round year / 2000 * rectSize
        if width
          ctx.moveTo leftOffset + rectSize / 2 - width / 2, topOffset - 0.5
          ctx.lineTo leftOffset + rectSize / 2 + width / 2, topOffset - 0.5


    ctx.stroke!
