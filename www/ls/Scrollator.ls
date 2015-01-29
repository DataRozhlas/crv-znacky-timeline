ig.makeScrollable = (container) ->
  listItems = container.node!querySelectorAll \li
  list = container.select \ul
  maxHeight = 650
  container.style \height "#{maxHeight}px"
  currentGroup = []
  currentHeight = 0
  allGroups = []
  for item, index in listItems
    currentStart = item if currentStart is null
    height = item.clientHeight
    currentHeight += height
    if currentHeight > maxHeight
      padGroup do
        currentGroup
        maxHeight - (currentHeight - height)
      currentHeight = height
      allGroups.push currentGroup
      currentGroup = [item]
    else
      currentGroup.push item
  padGroup currentGroup, maxHeight - currentHeight
  allGroups.push currentGroup
  selector = container.append \div .attr \class \selector
  currentIndex = 0
  selectorItems = selector.selectAll \a.item .data allGroups .enter!append \a
    ..attr \href \#
    ..append \span
      ..attr \class \znacka
      ..html ->
        it.map (.querySelector ".name" .innerHTML) .join ", "

    ..attr \class \item
    ..on \click (d, index) ~>
      d3.event.preventDefault!
      list.style \transform "translate(0, -#{index * maxHeight}px)"
      selectorItems.classed \active (d, i) -> i is index
      currentIndex := index

  selectorItems
    .classed \active (d, i) -> i is currentIndex
  selector.append \a
    ..attr \class 'arrow arrow-top'
    ..html "›"
    ..attr \href \#
    ..on \click ~>
      currentIndex--
      currentIndex %%= allGroups.length
      list.style \transform "translate(0, -#{currentIndex * maxHeight}px)"
      selectorItems.classed \active (d, i) -> i is currentIndex


  selector.append \a
    ..attr \class 'arrow arrow-bottom'
    ..html "›"
    ..attr \href \#
    ..on \click ~>
      currentIndex++
      currentIndex %%= allGroups.length
      list.style \transform "translate(0, -#{currentIndex * maxHeight}px)"
      selectorItems.classed \active (d, i) -> i is currentIndex





padGroup = (group, heightSurplus) ->
  padding = Math.floor heightSurplus / (group.length + 1)
  for item in group
    item.style.marginTop = "#{padding}px"
  group[*-1].style.marginBottom = "#{padding}px"
