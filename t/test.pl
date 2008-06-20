use strict;


sub tconf {
   -f './t/wppost' or return;
   require YAML;
   my $c = YAML::LoadFile('./t/wppost');
   return $c;
}




1;
