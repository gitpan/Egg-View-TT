
use Test::More qw/no_plan/;
use Egg::Helper;

BEGIN { use_ok('Egg::View::TT') };

my $t= Egg::Helper->run('O:Test');

my $run_modes= <<END_OF_RUN;
  _default=> sub {},
END_OF_RUN

my @creates= $t->yaml_load( join '', <DATA> );

$t->create_project_root;
$t->prepare(
  dispatch=> { run_modes=> $run_modes },
  create_files=> \@creates,
  config=> { VIEW=> [ [ TT => {
    INCLUDE_PATH=> [$t->project_root. '/root'],
    TEMPLATE_EXTENSION=> '.tt',
    } ] ] },
  );

ok( my $e= $t->egg_virtual );
ok( $e->stash->{test1}= 'test1 ok' );
ok( $e->view->param( test2=> 'test2 ok' ) );
ok( my $body= $e->view->render( 'index.tt' ) );
like $$body, qr{<h1>View\-TT\-Test</h1>}s;
like $$body, qr{<h2>test1\s+ok</h2>}s;
like $$body, qr{<h3>test2\s+ok</h3>}s;


__DATA__
---
filename: root/index.tt
value: |
  <html>
  <head>
  <title><% $p->{page_title} %></title>
  </head>
  <body>
  <h1>View-TT-Test</h1>
  <h2>[% e.stash('test1') %]</h2>
  <h3>[% test2 %]</h3>
  </body>
  </html>
