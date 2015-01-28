require! {
  fs
  csv: 'csv-parse'
}

str = fs.createReadStream "#__dirname/../data/OA_hlavni-u.csv"
parser = csv!
str.pipe parser
currentZnacka = null
currentRoky = null
roky = [1945 to 2014]
out = "znacka\tstare\t" + roky.join "\t"
parser.on \readable ->
  while data = parser.read!
    [typ, znacka, druh, kat, celkem, bull, ...roky] = data
    return if typ == "typ"
    if znacka != currentZnacka
      if currentRoky
        out += "\n#currentZnacka\t#{currentRoky.join "\t"}"
      currentRoky := roky.map -> parseInt it, 10
      currentZnacka := znacka
    else
      for rok, index in roky
        currentRoky[index] += parseInt rok, 10
<~ parser.on \end
out += "\n#currentZnacka\t#{currentRoky.join "\t"}"
fs.writeFile "#__dirname/../data/znacka-rok.tsv", out
