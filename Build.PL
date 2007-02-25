use Module::Build;

my $builder = Module::Build->new(

  module_name       => 'Egg::View::TT',
  dist_version_from => 'lib/Egg/View/TT.pm',
  dist_author       => 'Masatoshi Mizuno E<lt>lusheE<64>cpan.orgE<gt>',
  license           => 'perl',

  requires => {
    'Egg::Release' => 1.09,
    'Cache::Cache' => 1.05,
    'File::Find'   => 5.80,
    'Test::More'   => 0,
    'Test::Pod'    => 0,
    },

  );

$builder->create_build_script();
