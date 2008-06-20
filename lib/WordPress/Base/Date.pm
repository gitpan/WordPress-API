package WordPress::Base::Date;
use strict;
use Exporter;
use vars qw(@ISA @EXPORT);
@EXPORT = ('dateCreated');
@ISA = qw/Exporter/;

#use Smart::Comments '###';
no warnings 'redefine';

sub dateCreated {
   my($self,$val) = @_;
   ### DATE
   if(defined $val){
      ### $val

      # is it a valid date?
      require Date::Manip;  
      my $date = Date::Manip::ParseDate($val) 
            or croak("dateCreated value $val is not a valid date");
      
      ### $date

      my $wpdate = 
         Date::Manip::UnixDate($date,"%Y%m%dT%H:%M:%S");
      
      ### $wpdate

      $self->structure_data->{dateCreated} = $wpdate;

      # TODO maybe we should clear date_created_gmt, since server will set that for us?
      $self->structure_data->{date_created_gmt} = undef;
   }

   return $self->structure_data->{dateCreated};
}

1;


__END__


use Exporter;
use vars qw(@ISA $VERSION @EXPORT_OK %EXPORT_TAGS);
@ISA = qw/Exporter/;
@EXPORT_OK = qw(datestring2time
datestring_ok
datestring_parse
time2datestring);
%EXPORT_TAGS = ( all => \@EXPORT_OK );

use constant DEBUG => 0;

# TODO should override dateCreated









sub debug {
   DEBUG or return 1;
   my $msg = shift;
   print STDERR "# - $msg\n";
   return 1;
}

my $year = qr/[12]\d{3}/;
my $month= qr/[01][0-9]/;
my $day  = qr/[0123][0-9]/; 
my $time_T = 'T';
my $time_S = ':';
my $hms   = qr/\d{2}/;
   
sub datestring_parse {
   my $val = shift;
   
   $val=~/^($year)($month)($day)$time_T($hms)$time_S($hms)$time_S($hms)$/
      or debug("string $val cannot parse")
      and return;

   my $hash = {
      year   => $1,
      month  => $2,
      day    => $3,
      hour   => $4,
      minute => $5,
      second => $6,
   };
   return $hash;   
}



sub datestring_ok {
   my $val = shift;

   datestring_parse($val) 
      or debug("cant parse $val")
      and return 0;
      
   return 1;
   
}

sub datestring2time { # arg can also be hashref
   my $val = shift;
   $val or confess('missing string arg');

   my @elements = _sixelement($val)
      or debug("cant turn to elements")
      and return;

   require Time::Local;
   my $timestamp = Time::Local::timelocal(@elements)     
      or debug("cant make elements [@elements] to timestamp")
      and return;

   return $timestamp;   
}




#sub datehash2time {
#   my $hash = shift;

 #  for(

#}

# for timelocal
sub _sixelement {
   my $val = shift;
   defined $val or die;
   
   # see Time::Local   
   my @elements; 
   my @keys = qw(second minute hour day month year);



   # get the elements
   
   my $parse;     
   
   if (ref $val eq 'HASH'){
      debug("is hash");
      $parse = $val;
   }

   elsif (my $h = datestring_parse($val) ){
      debug("parsed");
      $parse = $h;
   }

   else {
      die("dunno what to do with '$val'");
   }


   # arrange the elements

   for my $key (@keys){
      my $val = $parse->{$key};
      $val ||= '00';

      # month  is -1 , only 0-11, makes sense.
      if($key eq 'month' and $val){
         $val--;
      }

      push @elements, $val;
   }

   
   return @elements;
}


sub time2datestring {
   my $time = shift;
   $time or confess('missing time arg');
   
   require Time::Format;
   my $datestring = Time::Format::time_format('yyyymmdd\Thh:mm:ss',$time)
      or debug("cant turn time [$time] to datestring")
      and return;
      
   return $datestring;

}

#sub time2datestring_gm {
   
#}


1;



__END__

=pod

=head1 NAME

WordPress::Base::Date

=head1 DESCRIPTION

Wordpress dates are tricky.


=head1 SYNOPSIS

   use WordPress::Base::Date ':all';

   my $datestring = '19791205T00:06:40';

   datestring_ok($datestring) or die;

   my $timestamp  = datestring2time($datestring);

   my $datestring_now = time2datestring(time());

   my $hash = datestring_parse($datestring);
   
ls t
=head2 datestring_ok()

arg is date strink, returns boolean

=head2 datestring2time()

arg is some sort of date string, attempts to turn to unix timestamp
optionally you can provide as arg a hash ref such as:

   {
      year => '1975',
      month => '07',
      day => '31',

   }

=head2 time2datestring()

arg is unix timestamp, returns formatted for wordpress

=head2 datestring_parse()

arg is datestring
if not valid datestring, returns undef
returns hash ref with keys year, month, day, hour, minute, second

=head1 SEE ALSO

WordPress::API

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=cut
