#!/usr/bin/env perl6
# Makes a ruler SVG with inch marks and NUMBERING.
# TODO Parameterize text attributes such as size and color and left-margin
# TODO Parameterize text on top of ruler/vs. below
# TODO Allow for a top and bottom rule
# TODO Document appropriate SVG sizes for various $SEPARATIONS
use v6;

my $HEADER = q:to/END/;
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/
Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="%d" height="%d" version="1.1"
xmlns="http://www.w3.org/2000/svg">
END
my $RULER-RECT = '<rect y="%d" width="%d" height="%d" style="fill:none;stroke-width:1;stroke:%s;stroke-width:3"/>';
my $NUMBERING = '<text x="%d" y="%d" font-size="%d">%d</text>';
my $VLINE = '<line x1="%d" x2="%d" y1="%d" y2="%d" style="stroke:%s"/>';
my $END = '</svg>';

# CONFIG GLOBALS
my $HEIGHT = 100;
my $WIDTH = 500;
my $INCHES = 6;

my $BORDER-STROKE = 6; # Ruler's outside border
my $MARGIN-SIZE = 8; # measured in ticks.
my $SEPARATIONS = 16; # 10 for cm, 16 or 32 for inches
my $TEXT-SPACE = 0; # Allows for room above the SVG for numbers to live

# TODO @HIGHLIGHTS entries can either be numbers, or a pair. If it's a pair, the first entry is where the mark is made, the second is a number/letter below that mark.
my @HIGHLIGHTS = <11/32 .5 2>; # Say your ruler has "6" inches. A marking at `.5` would create a mark between the first and second major units of measure.

my $RECT-COLOR= 'black';
my $MARK-COLOR= 'gray';
my $HIGHLIGHT-COLOR = 'red';

# COMPUTED GLOBALS
my $half-margin = $MARGIN-SIZE / 2; # measured in ticks.
my $dx = ($WIDTH) / (($SEPARATIONS * $INCHES) + $MARGIN-SIZE);

my $stroke-height;
my $stroke-width;
my $offset;

# MAIN
my $svg = "";
$svg ~= sprintf($HEADER, $WIDTH, $HEIGHT);
loop (my $i = $half-margin;
         $i <= (($SEPARATIONS * $INCHES) + $half-margin);
         $i++)
{
  $stroke-height = ($HEIGHT - $TEXT-SPACE) / 8;
  $stroke-width = 1;
  loop (my $j = $SEPARATIONS; $j > 1; $j /= 2) { # Place tick marks
    if (($i - $half-margin) %% $j) {
      $stroke-height = ($HEIGHT - $TEXT-SPACE) / (($SEPARATIONS / $j) * 1.5);
      last;
    }
  }
  $svg ~= sprintf($VLINE, $i * $dx, $i * $dx,
  $TEXT-SPACE, $TEXT-SPACE + $stroke-height, $MARK-COLOR);
  if ($i - $half-margin) %% $SEPARATIONS  { # number the ruler.
    # $HEIGHT/2 is where the numbers go (vertically)
    # $HEIGHT/6 seems to be a good font size
    $svg ~= sprintf($NUMBERING, ($i+1) * $dx, $HEIGHT / 2, $HEIGHT / 6, floor($i / $SEPARATIONS));
  }
}

my $x-pos;
for @HIGHLIGHTS {
  $x-pos = $_ * $SEPARATIONS * $dx + $half-margin * $dx;
  $svg ~= sprintf($VLINE, $x-pos, $x-pos, $TEXT-SPACE, $TEXT-SPACE + $stroke-height, $HIGHLIGHT-COLOR);
}
$svg ~= sprintf($RULER-RECT, $TEXT-SPACE, $WIDTH, $HEIGHT - $TEXT-SPACE, $RECT-COLOR);
$svg ~= $END;
say $svg;

