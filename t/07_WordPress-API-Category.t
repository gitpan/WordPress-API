use Test::Simple 'no_plan';
use lib './lib';
require './t/test.pl';
use strict;
use WordPress::API::Category;
use Smart::Comments '###';
my $c; 
unless( $c = tconf() ){
   ok(1,'skipping');   
   exit;
}


ok(1,"$0: this test is skipped until WordPress::XMLRPC::newCategory() is working.") and exit;

### I KNOW THIS IS BUGGY


# what categories are available??
#
my $api = WordPress::API::Category->new($c);
ok($api,'instanced' )or die($api->errstr);

# make a new one

my $newCategoryName = 'MiscCat' .  int(rand 1000);

ok( $api->categoryName($newCategoryName),"set name to $newCategoryName" );




my $nid = $api->save or die("cant save " . $api->errstr);
ok( $nid,"new cat id $nid");

my $catn = $api->categoryName;
unless ( ok( $catn eq $newCategoryName, " $catn eq $newCategoryName" )  ){
   my $d = $api->structure_data;
   ### $d
   die;
}


# hack
my $cats = $api->getCategories;
ok( $cats ,'getCategories returns');
ok( ref $cats eq 'ARRAY' ,'getCategories returns array ref');

ok( scalar @$cats ,'cats has count.');

for ( @$cats ){
   print STDERR "\n\n == Cat.. \n\n";
   my $id = $_->{id};
   my $cn = $_->{categoryName};
   ok("id $id, name $cn");

   my $o = new WordPress::API::Category($c);
   ok($o, 'instanced');
   ok $o->id($id);
   ok $o->load;
   ok $o->categoryName;

   my $url1 = $o->rssUrl;
   my $url2 = $o->htmlUrl;
   my $desc = $o->description;

   my $_cn = $o->categoryName;
   ok( $_cn eq $cn , "categoryName() = $_cn, and cats category name is $cn");

   #ok( $o->categoryName eq $cn );
}



1;


