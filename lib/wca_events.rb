wca_event_definitions = [
  {
    name_short: "Rubik's Cube",
    name: "Rubik's Cube (3x3x3)",
    handle: "3",
    wca_handle: "333",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "2x2x2",
    name: "Rubik's Pocket Cube (2x2x2)",
    handle: "2",
    wca_handle: "222",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "4x4x4",
    name: "Rubik's Revenge (4x4x4)",
    handle: "4",
    wca_handle: "444",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "5x5x5",
    name: "Rubik's Professor (5x5x5)",
    handle: "5",
    wca_handle: "555",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "6x6x6",
    name: "6x6x6 Cube",
    handle: "6",
    wca_handle: "666",
    formats: [ "Mean of 3", "Best of x" ]
  },
  {
    name_short: "7x7x7",
    name: "7x7x7 Cube",
    handle: "7",
    wca_handle: "777",
    formats: [ "Mean of 3", "Best of x" ]
  },
  {
    name_short: "Clock",
    name: "Rubik's Clock",
    handle: "cl",
    wca_handle: "clock",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "Magic",
    name: "Rubik's Magic",
    handle: "m",
    wca_handle: "magic",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "Master Magic",
    name: "Rubik's Master Magic",
    handle: "mm",
    wca_handle: "mmagic",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "Megaminx",
    name: "Megaminx",
    handle: "mx",
    wca_handle: "minx",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "Pyraminx",
    name: "Pyraminx",
    handle: "py",
    wca_handle: "pyram",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "Skewb",
    name: "Skewb",
    handle: "sk",
    wca_handle: "skewb",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "Square-1",
    name: "Square-1",
    handle: "s1",
    wca_handle: "sq1",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "3x3x3 OH",
    name: "Rubik's Cube (3x3x3) One-Handed",
    handle: "oh",
    wca_handle: "333oh",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name_short: "3x3x3 Feet",
    name: "Rubik's Cube (3x3x3) With Feet",
    handle: "ft",
    wca_handle: "333ft",
    formats: [ "Best of x", "Mean of 3" ]
  },
  {
    name_short: "Fewest Moves",
    name: "Rubik's Cube (3x3x3) Fewest Moves",
    handle: "fm",
    wca_handle: "333fm",
    formats: [ "Best of x" ]
  },
  {
    name_short: "3x3x3 BLD",
    name: "Rubik's Cube (3x3x3) Blindfolded",
    handle: "3b",
    wca_handle: "333bf",
    formats: [ "Best of x" ]
  },
  {
    name_short: "4x4x4 BLD",
    name: "Rubik's Revenge (4x4x4) Blindfolded",
    handle: "4b",
    wca_handle: "444bf",
    formats: [ "Best of x" ]
  },
  {
    name_short: "5x5x5 BLD",
    name: "Rubik's Professor (5x5x5) Blindfolded",
    handle: "5b",
    wca_handle: "555bf",
    formats: [ "Best of x" ]
  },
  {
    name_short: "3x3x3 MBF",
    name: "Rubik's Cube (3x3x3) Multiple Blindfolded",
    handle: "mbf",
    wca_handle: "333mbf",
    formats: [ "Best of x" ]
  }
]

WCA_EVENTS = wca_event_definitions.map do |event|
  event[:formats].map do |format|
    event_with_format = event.dup
    event_with_format[:format] = format
    event_with_format.delete(:formats)
    event_with_format
  end
end.flatten
