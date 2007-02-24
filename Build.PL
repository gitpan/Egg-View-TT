use Module::Build;

my $builder = Module::Build->new(
  module_name => 'Egg::View::TT',
  license => 'perl',
  dist_author => 'Masatoshi Mizuno E<lt>mizunoE<64>bomcity.comE<gt>',
  dist_version_from=> 'lib/Egg/View/TT.pm',
  requires => {
    'Egg::Release'=> 1.09,
    'Cache::Cache'=> 1.05,
    'File::Find'  => 5.80,
    'Test::More'  => 0,
    'Test::Pod'   => 0,
    },
  );

$builder->create_build_script();
