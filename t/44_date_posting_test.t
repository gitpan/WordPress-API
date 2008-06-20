use Test::Simple 'no_plan';
use strict;
use lib './lib';
require './t/test.pl';
use WordPress::API::Post;
use Smart::Comments '###';

ok(1,'starting test.');

my $conf;
unless ( $conf = tconf() ){
   ok(1,'To test fully, you need to set up a ./t/wppost YAML file as per instructions in README');
   exit;
}





my $w = WordPress::API::Post->new($conf);
ok($w,'object initiated');

$w->proxy or die('check your conf');
$w->password or die;
$w->username or die;

$w->title('This is ok'.time());
$w->description('this is test content');


ok(1,'setting date.. ');
my $d = $w->dateCreated('20080731');
### $d
### saving.....
ok($w->save, 'posted') or die;


ok($w->id,'got id()'.$w->id);


ok( $w->load, 'loaded after saving.. hmmm');

my $datefromserver = $w->dateCreated;
### $datefromserver

my $struct = $w->structure_data;
### $struct



sleep 1;

ok( $w->delete,'deleted' ) or die;


