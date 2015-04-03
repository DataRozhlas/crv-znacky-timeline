

yearsOld = [1945 to 2003]
dataOld = ig.data.znacky_2004

yearsNew = [1945 to 2013]
  ..unshift "stare"
dataNew = ig.data.znacky
{yearWidth, rectSize, rectFullSize, znackaHeight, rectCapacity} = ig
znacky_assoc = {}
getData = (row, years) ->
  data = name: row.znacka
  data.sum = 0
  data.yearMax = -Infinity
  data.years = for year in years
    cars = parseInt row[year], 10
    if row.znacka == "VŠE" then cars /= 2
    data.sum += cars
    if data.yearMax < cars
      data.yearMax = cars
    cars
  medianSum = 0
  halfOfCars = data.sum / 2
  data.medianAge = 0
  for index in [data.years.length - 1 to 0 by -1]
    cars = data.years[index]
    medianSum += cars
    if medianSum > halfOfCars
      partOfYear = (medianSum - halfOfCars) / cars
      data.medianAge += partOfYear
      break
    data.medianAge++

  data.height = Math.ceil data.yearMax / rectCapacity * rectFullSize
  data.height++ if data.height % 2
  data.height = 40 if data.height < 40
  data.correctSum = if row.znacka == "VŠE" then data.sum * 2 else data.sum
  data

znacky = d3.tsv.parse dataNew, (row) ->
  data = getData row, yearsNew
  znacky_assoc[data.name] = data
  data

d3.tsv.parse dataOld, (row) ->
  data = getData row, yearsOld
  if znacky_assoc[data.name]
    znacky_assoc[data.name].old = data
  data

znacky.sort (a, b) -> b.sum - a.sum
znacky .= filter ->
  it.name not in <[VOZIDLO OLTCIT GM MINI SMART LADA MICRO AERO POLARIS]>
if ig.containers['znacky-all']
  container = d3.select ig.containers['znacky-all']
  ig.drawHistogram container, [znacky.0]

if ig.containers['znacky-details']
  container = d3.select ig.containers['znacky-details']
  ig.drawHistogram container, znacky.slice 1
  ig.makeScrollable container

if ig.containers['ojetiny']
  container = d3.select that
  ig.ojetiny container

if ig.containers['firemni']
  container = d3.select that
  ig.firemni container

