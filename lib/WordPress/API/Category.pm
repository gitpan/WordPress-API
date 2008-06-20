package WordPress::API::Category;
use base 'WordPress::Base::Data::Category';
use base 'WordPress::Base::Object';
use strict;
no strict 'refs';
use Carp;

# must happen before make xmlrpc aliases
*WordPress::XMLRPC::getCategory  = \&xmlrpc_get;

__PACKAGE__->make_xmlrpc_aliases();

# there is no getCategory, need one
# should be in WordPress::XMLRPC



# overiddes from WordPress::Base::Object::make_xmlrpc_aliases()
# # this is a hack
*WordPress::XMLRPC::getCategory  = \&xmlrpc_get;
sub xmlrpc_get {
   my $self = shift;
   my $arg = shift; # takes id or category name

   defined $arg 
      or ($arg = $self->categoryId)
      or ($arg = $self->categoryName)
      or croak('missing argument, id or categoryName not set either, as alternative.');

   # should return struct
   
   # get all categories   
   for my $struct ( @{ $self->getCategories } ){
      if ( $arg=~/^\d+$/ ){
         $struct->{categoryId} == $arg or next;
      }
      else {
         $struct->{categoryName} eq $arg or next;
      }
      return $struct;
   }

   $self->errstr("Sorry, category '$arg' seems not to exist.");
   return;
}

sub xmlrpc_edit {
   croak("Sorry, you cannot edit categories.");
}

sub xmlrpc_delete {
   croak("Sorry, you cannot delete categories.");
}

# need this alias
*id = \&WordPress::Base::Data::Category::categoryId;
# WordPress php coders su<k balls. Why do they have post_id, page_id, categoryId.. WTF!!! why not
# idPost idPage idCategory 
# or page_id  post_id category_id
# or id() !!!!!!!!!!!!!!!!!!!!!!!!! RETARDS, what kind of coding standard is this!!!!!!!!!!!!!! GRRRRR
# i've spent countless hours just putting in/debugging hacks to work around these issues.. grrr



sub save {
   my $self = shift;
   $self->username or die('missing username');
   $self->password or die('missing password');   
   
   if( $self->id ) {
      croak("Sorry, you cannot edit categories.");      
      #return $self->xmlrpc_edit( $self->id, $self->structure_data );
   }
   
   #print STDERR "\t--had no id\n";
   my $cn = $self->categoryName or die('missing categoryName');

   my $id  = $self->newCategory( $cn )  # from WordPress::XMLRPC
      or confess("cant get id on saving cat '$cn'".$self->errstr);
   #print STDERR "\t--have id $id\n";
   

   # $self->id($id); # TODO may need to reload, to see what defaults sever set
   # should load, otherwise url() would not return
   $self->load($id);
   
   return $self->id;
}




1;

__END__

=pod

=head1 NAME

WordPress::API::Category

=head1 CAVEATS

I am having problems with WordPress::XMLRPC::newCategory(), until I resolve that, this module is on hold.

=head1 How to id the category

To fetch a category and its attributes, you can provide an id or a categoryName.
This is required before you call load() to fetch the data from the server.

   $cat->categoryName('Super Stuff');
   $cat->id(34);

=head1 METHODS

=head2 category setget methods

=head3 categoryId()

setget perl method
argument is number

=head3 categoryName()

setget perl method
argument is string

=head3 rssUrl()

setget perl method
argument is url

=head3 parentId()

setget perl method
argument is number

=head3 htmlUrl()

setget perl method
argument is url

=head3 description()

setget perl method
argument is string

=head2 object_type()

returns string 'Category' 

=head2 load()

Optional argument is an id or categoryName string.
Returns hashref, (but loads data into object)..

   my $cat = new WordPress::API::Category({
      proxy => 'http://site.com/xmlrpc.php',
      username => 'jimmy',
      password => 'jimmyspass',
   });

         $cat->id(5);
         $cat->load or die( $cat->errstr );
   print $cat->rssUrl;

=head2 save()

Unfortunately wordpress' xmlrpc command can't edit categories.


=head1 MAKING NEW CATEGORY

You cannot save changes to a category, you can only view existing categories and create new ones.
If you load() a category you cannot save() it. You can save() and then view its url, etc, though.

   $cat->categoryName('House Inspections');
   my $id = $cat->save;

   # or
   $cat->save;
   my $id = $cat->id;

   # now you can make a new post and set the parent to that category..
   #
   new WordPress::API::Post ....



