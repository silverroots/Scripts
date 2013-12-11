#!/usr/bin/perl
# Copyright (c) Laszlo Simon.
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or ( at your option) any later version.
#             
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#                            
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA)

$date = sprintf("%02d",0+int(rand(8)))
        .sprintf("%02d",1+int(rand(12)))
        .sprintf("%02d",1+int(rand(28)));

system("wget -O /tmp/apxxxxxx.html 'http://antwrp.gsfc.nasa.gov/apod/ap$date.html'");

open HTML, "/tmp/apxxxxxx.html";
$content = join('',(<HTML>));
close HTML;

$content =~ /\<a\s+href\=\"((?:\w+\/)*)(\w+)(\.\w+)\"\s*\>\s*\n*\s*\<img/ims;

$path = $1;
$img = $2;
$ext = $3;

`mkdir -p ~/wallpapers`;
print ">>>>http://antwrp.gsfc.nasa.gov/$path$img$ext\n";
system("wget -O ~/wallpapers/$img$ext 'http://antwrp.gsfc.nasa.gov/$path$img$ext'");

system("gconftool -t string -s /desktop/gnome/background/picture_filename ~/wallpapers/$img$ext");

