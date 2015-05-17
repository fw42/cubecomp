wca_event_definitions = [
  {
    name: "Rubik's Cube",
    handle: "3",
    wca_handle: "333",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "4x4 Cube",
    handle: "4",
    wca_handle: "444",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "5x5 Cube",
    handle: "5",
    wca_handle: "555",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "2x2 Cube",
    handle: "2",
    wca_handle: "222",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "3x3 blindfolded",
    handle: "3b",
    wca_handle: "333bf",
    formats: [ "Best of x" ]
  },
  {
    name: "3x3 one-handed",
    handle: "oh",
    wca_handle: "333oh",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "3x3 fewest moves",
    handle: "fm",
    wca_handle: "333fm",
    formats: [ "Best of x" ]
  },
  {
    name: "3x3 with feet",
    handle: "ft",
    wca_handle: "333ft",
    formats: [ "Best of x", "Mean of 3" ]
  },
  {
    name: "Megaminx",
    handle: "mx",
    wca_handle: "minx",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "Pyraminx",
    handle: "py",
    wca_handle: "pyram",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "Square-1",
    handle: "s1",
    wca_handle: "sq1",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "Rubik's Clock",
    handle: "cl",
    wca_handle: "clock",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "Skewb",
    handle: "sk",
    wca_handle: "skewb",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "6x6 Cube",
    handle: "6",
    wca_handle: "666",
    formats: [ "Mean of 3", "Best of x" ]
  },
  {
    name: "7x7 Cube",
    handle: "7",
    wca_handle: "777",
    formats: [ "Mean of 3", "Best of x" ]
  },
  {
    name: "4x4 blindfolded",
    handle: "4b",
    wca_handle: "444bf",
    formats: [ "Best of x" ]
  },
  {
    name: "5x5 blindfolded",
    handle: "5b",
    wca_handle: "555bf",
    formats: [ "Best of x" ]
  },
  {
    name: "3x3 multi blind",
    handle: "mbf",
    wca_handle: "333mbf",
    formats: [ "Best of x" ]
  },

  {
    name: "Rubik's Magic",
    handle: "m",
    formats: [ "Average of 5", "Best of x" ]
  },
  {
    name: "Rubik's Master Magic",
    handle: "mm",
    formats: [ "Average of 5", "Best of x" ]
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
