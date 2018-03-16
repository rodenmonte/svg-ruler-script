#!/usr/bin/env perl6
# Makes a ruler SVG with inch marks and numbering.
# TODO Paramaterize colors, such as ruler background
# TODO Parameterize tick length & population
# TODO Parameterize text attributes such as size and color and left-margin
# TODO Parameterize text on top of ruler/vs. below
# TODO Allow for a top and bottom rule
# TODO Document appropriate SVG sizes for various $SEPARATIONS
use v6;

my $header = q:to/END/;
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/
Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="%d" height="%d" version="1.1"
xmlns="http://www.w3.org/2000/svg">
END
my $ruler_rect = '<rect y="%d" width="%d" height="%d" style="fill:none;stroke-width:1;stroke:black;stroke-width:3"/>';
my $numbering = '<text x="%d" y="%d" font-size="%d">%d</text>';
my $vline = '<line x1="%d" x2="%d" y1="%d" y2="%d" style="stroke:grey"/>';
my $end = '</svg>';

# CONFIG GLOBALS
my $BORDER_STROKE = 6; # Ruler's outside border
my $MARGIN_SIZE = 8; # measured in ticks.
my $SEPARATIONS = 16; # 10 for cm, 16 or 32 for inches
my $TEXT_SPACE= 0; # Allows for room above the SVG for numbers to live

# COMPUTED GLOBALS
my $HALF_MARGIN = $MARGIN_SIZE / 2; # measured in ticks.

sub MAIN($height=100, $width=600, $inches=6) {
  my $dx = ($width) / (($SEPARATIONS * $inches) + $MARGIN_SIZE);
  my $svg = "";
  $svg ~= sprintf($header, $width, $height);
  $svg ~= sprintf($ruler_rect, $TEXT_SPACE, $width, $height - $TEXT_SPACE);

  my $stroke_height;
  my $stroke_width;
  my $offset;
  loop (my $i = $HALF_MARGIN;
           $i <= (($SEPARATIONS * $inches) + $HALF_MARGIN);
           $i++)
  {
    $stroke_height = ($height - $TEXT_SPACE) / 8;
    $stroke_width = 1;
    loop (my $j = $SEPARATIONS; $j > 1; $j /= 2) {
      if (($i - $HALF_MARGIN) %% $j) {
        $stroke_height = ($height - $TEXT_SPACE) / (($SEPARATIONS / $j) * 1.5);
        last;
      }
    }
    $svg ~= sprintf($vline, $i * $dx, $i * $dx,
    $TEXT_SPACE, $TEXT_SPACE + $stroke_height);
    if ($i - $HALF_MARGIN) %% $SEPARATIONS  { # Write numbers on the ruler.
      # $height/2 is where the numbers go (vertically)
      # $height/6 seems to be a good font size
      $svg ~= sprintf($numbering, ($i+1) * $dx, $height / 2, $height / 6, floor($i / $SEPARATIONS));
    }
  }
  $svg ~= $end;
  say $svg;
}

