ig.yearWidth    = yearWidth    = 11
ig.rectSize     = rectSize     = 9
ig.rectFullSize = rectFullSize = rectSize + 1
ig.znackaHeight = znackaHeight = 200
ig.rectCapacity = rectCapacity = 5000
ig.drawHistogram = (container, znacky) ->
  age = [0 to 6].map -> -5 + ((it + 1) * 10)
  list = container.append \ul .attr \class \list
    ..selectAll \li.item .data znacky
      ..enter!append \li
        ..attr \class \item
        ..classed \no-new -> it.old is void
        ..append \div
          ..attr \class \text
          ..append \span
            ..attr \class \name
            ..html (.name)
          ..append \span
            ..attr \class "count new"
            ..html -> "Počet aut v roce 2014: <b>#{ig.utils.formatNumber it.sum}</b>"
          ..append \span
            ..attr \class "age new"
            ..html -> "Střední věk v roce 2014: <b>#{ig.utils.formatNumber it.medianAge, 1} let</b>"

        ..append \div
          ..attr \class "canvas-container new"
          ..style \height -> "#{it.height + 10}px"
          ..append \span
            ..attr \class \year-label
            ..html "2014"
            ..style \font-size -> "#{Math.max it.height * 0.4, 26}px"
            ..style \line-height -> "#{it.height + 30}px"
          ..append \div
            ..attr \class \ticks
            ..selectAll \.tick .data age .enter!append \div
              ..attr \class \tick
              ..append \div
                ..attr \class \value
                ..html -> it + if it == 65 then " let stará auta" else ""
              ..append \div
                ..attr \class \age-up
                ..html -> (if it == 65 then "rok výroby " else "") + (2014 - it)
              ..append \div
                ..attr \class \age-down
                ..html -> (if it == 65 then "rok výroby " else "") + (2004 - it)
              ..append \div .attr \class \border-top
              ..append \div .attr \class \border-bottom
          ..append \canvas
            ..attr \class \new
            ..attr \height -> it.height
            ..attr \width 768
      ..filter (-> it.old)
        ..select \div.text
          ..append \span
            ..attr \class "count old"
            ..html -> "Počet aut v roce 2004: <b>#{ig.utils.formatNumber it.old.sum}</b>"
          ..append \span
            ..attr \class "age old"
            ..html -> "Střední věk v roce 2004: <b>#{ig.utils.formatNumber it.old.medianAge, 1} let</b>"
        ..append \div
          ..attr \class "canvas-container old"
          ..style \height -> "#{it.old.height}px"
          ..append \span
            ..attr \class \year-label
            ..html "2004"
            ..style \font-size -> "#{Math.max it.height * 0.4, 26}px"
            ..style \line-height -> "#{it.old.height + 30}px"
          ..append \canvas
            ..attr \class \old
            ..attr \height -> it.old.height
            ..attr \width 768


  canvases = list.selectAll \canvas
    ..each (znacka) ->
      isOld = @className == \old
      color = isOld && '#acb5be' || '#003366'
      ctx = @getContext \2d
        ..strokeStyle = color
        ..fillStyle = color
      {years, height:canvasHeight} = isOld && znacka.old || znacka
      leftOffsetFromOld = isOld && 11 || 0
      for year, yearIndex in years
        rects = Math.floor year / 5000
        remainder = year % 5000
        lines = 0
        twinLines = 0
        if rects
          twinLines = Math.floor remainder / 2000
        else
          lines = Math.floor remainder / 1000
        remainder = remainder % 2000
        height = rects * rectFullSize
        leftOffset = yearWidth * (yearIndex + leftOffsetFromOld)
        topOffset = (canvasHeight - height) / 2
        for i in [0 til rects]
          ctx.fillRect do
            leftOffset
            topOffset + i * rectFullSize
            rectSize
            rectSize
        if lines == 1 or lines == 3
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
        for i in [0 til twinLines]
          topTop = topOffset - (i * 2)
          topBottom = topOffset + height + (i * 2)

          ctx.moveTo leftOffset, topTop - 1.5
          ctx.lineTo leftOffset + rectSize, topTop - 1.5

          ctx.moveTo leftOffset, topBottom + + 0.5
          ctx.lineTo leftOffset + rectSize, topBottom + + 0.5

        if rects == lines == 0
          width = Math.round year / 1000 * rectSize
          if width
            ctx.moveTo leftOffset + rectSize / 2 - width / 2, topOffset - 0.5
            ctx.lineTo leftOffset + rectSize / 2 + width / 2, topOffset - 0.5


      ctx.stroke!
