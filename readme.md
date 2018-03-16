# ruler.pl6

Generate an svg ruler with perl6. The ruler can be metric, 'Merican, or some made up form of measurement.

Usage: ./ruler.pl6 <width> <height> <inches>
        All parameters are optional.
        "inches" describes the number of major ticks.

Width and height are optional.
It's recommended to redirect output to an svg file, e.g.
`$ perl6 sudoku.pl6 > image.svg`

