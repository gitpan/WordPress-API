use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'WordPress::API',
   VERSION_FROM => 'lib/WordPress/API.pm',


   # gen /usr/bin/pmused by Fri Jun 20 10:19:45 EDT 2008 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Date::Manip'                       => '5',
      'Exporter'                          => '0',
      'File::Type'                        => '0',
      'MIME::Base64'                      => '3',
      'Smart::Comments'                   => '1',
      'Test::Simple'                      => '0',
      'Time::Format'                      => '1',
      'Time::Local'                       => '1',
      'WordPress::XMLRPC'                 => '1',
      'YAML'                              => '0',
   },


   EXE_FILES => [],
);


